/// GameScene.swift
/// Flappy Kiro
///
/// The central game orchestrator. This is the heart of the game.
///
/// Responsibilities:
///   - Owns and coordinates all sub-components (physics, walls, score, etc.)
///   - Drives the game loop via CVDisplayLink (60 FPS, frame-synced, macOS native)
///   - Manages the state machine: idle → playing → gameOver
///   - Handles keyboard input by delegating to InputHandler
///   - Applies Ghosty's velocity-based tilt animation each frame
///
/// How CVDisplayLink works (macOS):
///   CVDisplayLink is the macOS equivalent of iOS's CADisplayLink.
///   It fires a C callback in sync with the display refresh rate (~16.7 ms at 60 Hz).
///   We dispatch from that callback to the main thread to safely update the scene.
///
/// How the state machine works:
///   idle      — start screen shown, loop paused
///   playing   — loop running, all components updating
///   gameOver  — loop paused, game-over screen shown

import SpriteKit
import CoreVideo   // for CVDisplayLink

final class GameScene: SKScene {

    // MARK: - Sub-components

    private let renderComponent  = RenderComponent()
    private var wallSpawner:       WallSpawner!
    private let scoreComponent   = ScoreComponent()
    private let difficultyComp   = DifficultyComponent()
    private var collisionHandler:  CollisionHandler!
    private let inputHandler     = InputHandler()
    private let audioManager     = AudioManager()

    // MARK: - Scene Nodes

    private var ghostyNode:      SKNode!
    private var scoreLabel:      SKLabelNode!
    private var startScreenNode: SKNode?
    private var gameOverNode:    SKNode?

    // MARK: - Game Loop (CVDisplayLink — macOS native)

    private var displayLink:     CVDisplayLink?
    private var lastUpdateTime:  CFTimeInterval = 0

    // MARK: - State

    private(set) var gameState: GameState = .idle

    // MARK: - Physics Component

    private var physics: PhysicsComponent!

    // MARK: - SKScene Lifecycle

    override func didMove(to view: SKView) {
        setupScene()
        audioManager.setup()
    }

    override func willMove(from view: SKView) {
        stopGameLoop()
        audioManager.teardown()
    }

    // MARK: - Scene Setup

    /// Builds the initial scene: background, ground, Ghosty, HUD, and start screen.
    /// Called once when the scene first appears.
    private func setupScene() {
        // Remove any existing content (called on restart too via reset path).
        removeAllChildren()

        physicsWorld.gravity    = .zero   // we handle gravity manually
        physicsWorld.contactDelegate = setupCollisionHandler()

        // Background
        addChild(renderComponent.makeBackground(size: size))

        // Ground
        addChild(renderComponent.makeGround(sceneSize: size))

        // Ghosty
        ghostyNode = renderComponent.makeGhosty()
        ghostyNode.position = CGPoint(
            x: LayoutConstants.ghostyStartX,
            y: LayoutConstants.ghostyStartY
        )
        addChild(ghostyNode)

        // Physics component — now wired to the real ghosty node.
        physics = PhysicsComponent(ghostyNode: ghostyNode as! SKShapeNode)

        // Wall spawner
        wallSpawner = WallSpawner(scene: self, renderComponent: renderComponent)

        // HUD score label
        scoreLabel = renderComponent.makeScoreLabel()
        addChild(scoreLabel)

        // Input handler wiring
        inputHandler.onJump  = { [weak self] in self?.handleJump() }
        inputHandler.onStart = { [weak self] in self?.handleStart() }

        // Show start screen
        showStartScreen()
    }

    private func setupCollisionHandler() -> CollisionHandler {
        let handler = CollisionHandler(gameScene: self)
        collisionHandler = handler
        return handler
    }

    // MARK: - Game Loop

    private func startGameLoop() {
        lastUpdateTime = CACurrentMediaTime()

        // CVDisplayLink fires a C callback synced to the display refresh rate.
        // We create it, set a callback that dispatches to the main thread, then start it.
        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)

        guard let link = displayLink else {
            Logger.error("GameScene: failed to create CVDisplayLink")
            return
        }

        // The callback is a C closure — it cannot capture `self` directly,
        // so we pass `self` as an unmanaged pointer via the userInfo parameter.
        let userInfo = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())

        CVDisplayLinkSetOutputCallback(link, { _, _, _, _, _, userInfo -> CVReturn in
            // Retrieve `self` from the raw pointer.
            guard let ptr = userInfo else { return kCVReturnSuccess }
            let scene = Unmanaged<GameScene>.fromOpaque(ptr).takeUnretainedValue()
            // Dispatch to main thread — SpriteKit scene mutations must happen on main.
            DispatchQueue.main.async { scene.gameLoopTick() }
            return kCVReturnSuccess
        }, userInfo)

        CVDisplayLinkStart(link)
    }

    private func stopGameLoop() {
        if let link = displayLink {
            CVDisplayLinkStop(link)
            displayLink = nil
        }
    }

    @objc private func gameLoopTick() {
        guard gameState == .playing else { return }

        let now       = CACurrentMediaTime()
        let deltaTime = min(now - lastUpdateTime, Double(PhysicsConstants.maxDeltaTime))
        lastUpdateTime = now

        do {
            try updateGame(deltaTime: deltaTime)
        } catch {
            Logger.error("GameScene: unhandled error in game loop: \(error)")
        }
    }

    private func updateGame(deltaTime: TimeInterval) throws {
        let speed = difficultyComp.currentSpeed(for: scoreComponent.currentScore)

        // 1. Update Ghosty physics.
        physics.update(deltaTime: CGFloat(deltaTime))

        // 2. Scroll and spawn walls.
        wallSpawner.update(deltaTime: deltaTime, speed: speed)

        // 3. Check score passthrough.
        scoreComponent.checkPassthrough(
            ghostyX: ghostyNode.position.x,
            walls:   wallSpawner.walls()
        )

        // 4. Update HUD.
        renderComponent.updateScoreLabel(scoreLabel, score: scoreComponent.currentScore)

        // 5. Tilt Ghosty based on vertical velocity.
        applyGhostyTilt()
    }

    // MARK: - Ghosty Tilt

    /// Rotates Ghosty to face the direction of travel — up when jumping, down when falling.
    private func applyGhostyTilt() {
        let velocity = physics.currentVelocity
        // Map velocity to rotation: +jumpVelocity → +15°, terminalVelocity → -25°
        let maxUp:   CGFloat =  PhysicsConstants.jumpVelocity
        let maxDown: CGFloat =  PhysicsConstants.terminalVelocity   // negative
        let t = (velocity - maxDown) / (maxUp - maxDown)   // 0…1
        let angle = (-25 + t * 40) * (.pi / 180)           // -25° to +15° in radians
        ghostyNode.zRotation = angle
    }

    // MARK: - State Transitions

    /// Transitions from idle or gameOver → playing.
    func startGame() {
        gameState = .playing
        scoreComponent.reset()
        difficultyComp.reset()
        wallSpawner.reset()
        physics.reset()
        ghostyNode.zRotation = 0

        renderComponent.updateScoreLabel(scoreLabel, score: 0)

        startScreenNode?.removeFromParent()
        startScreenNode = nil
        gameOverNode?.removeFromParent()
        gameOverNode = nil

        startGameLoop()
    }

    /// Called by CollisionHandler when Ghosty hits a wall or the ground.
    func triggerGameOver() {
        guard gameState == .playing else { return }
        gameState = .gameOver
        stopGameLoop()
        audioManager.playGameOver()
        showGameOverScreen()
    }

    // MARK: - Input Routing

    private func handleJump() {
        physics.applyJump()
        audioManager.playJump()
    }

    private func handleStart() {
        startGame()
    }

    // MARK: - Screen Overlays

    private func showStartScreen() {
        gameState = .idle
        let screen = renderComponent.makeStartScreen(size: size)

        // Add idle bob to Ghosty on start screen.
        ghostyNode.run(renderComponent.idleBobAction(), withKey: "idleBob")

        addChild(screen)
        startScreenNode = screen
    }

    private func showGameOverScreen() {
        ghostyNode.removeAction(forKey: "idleBob")
        let screen = renderComponent.makeGameOverScreen(
            score: scoreComponent.currentScore,
            size:  size
        )
        addChild(screen)
        gameOverNode = screen
    }

    // MARK: - Keyboard Input (macOS)

    override func keyDown(with event: NSEvent) {
        // Guard against key repeat events (held-down key fires repeatedly).
        guard !event.isARepeat else { return }
        inputHandler.handleKeyDown(keyCode: event.keyCode, gameState: gameState)
    }
}
