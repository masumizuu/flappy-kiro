/// RenderComponent.swift
/// Flappy Kiro
///
/// Factory for all programmatic visuals in the game.
/// Every SKNode (Ghosty, walls, ground, backgrounds, HUD, screens) is created here.
///
/// Design principles:
///   - No external image assets — everything is drawn with SKShapeNode / SKLabelNode.
///   - All colours come from ColorPalette (Catppuccin Mocha).
///   - All fonts are Sora (headings) or JetBrains Mono (body), with system font fallback.
///   - This class has no game-logic dependencies — it is a pure visual factory.

import SpriteKit

final class RenderComponent {

    // MARK: - Font Loading

    /// Returns a named font, falling back to the system font if unavailable.
    func font(named name: String, size: CGFloat) -> NSFont {
        if let f = NSFont(name: name, size: size) { return f }
        Logger.error("RenderComponent: font '\(name)' not found, using system font")
        return NSFont.systemFont(ofSize: size)
    }

    // MARK: - Background

    /// Creates a full-scene background node filled with Catppuccin Mocha `base`.
    func makeBackground(size: CGSize) -> SKShapeNode {
        let node = SKShapeNode(rectOf: size)
        node.position  = CGPoint(x: size.width / 2, y: size.height / 2)
        node.fillColor = ColorPalette.base
        node.strokeColor = .clear
        node.zPosition = -10
        return node
    }

    // MARK: - Ground

    /// Creates the ground bar at the bottom of the scene.
    /// Also sets up its physics body so CollisionHandler can detect Ghosty landing.
    func makeGround(sceneSize: CGSize) -> SKShapeNode {
        let h    = LayoutConstants.groundHeight
        let rect = CGRect(x: 0, y: 0, width: sceneSize.width, height: h)
        let node = SKShapeNode(rect: rect)
        node.fillColor   = ColorPalette.surface1
        node.strokeColor = ColorPalette.surface0
        node.lineWidth   = 2
        node.zPosition   = 1

        // Static physics body — Ghosty bounces off this.
        let body = SKPhysicsBody(rectangleOf: CGSize(width: sceneSize.width, height: h),
                                 center: CGPoint(x: sceneSize.width / 2, y: h / 2))
        body.isDynamic        = false
        body.categoryBitMask  = PhysicsCategory.ground
        body.contactTestBitMask = PhysicsCategory.ghosty
        body.collisionBitMask = PhysicsCategory.none
        node.physicsBody = body
        return node
    }

    // MARK: - Ghosty

    /// Creates Ghosty's node: a cutesy ghost with a wavy tail, outstretched hands, and an OwO face.
    func makeGhosty() -> SKNode {
        let container = SKNode()
        container.zPosition = 5

        let w = LayoutConstants.ghostySize.width
        let h = LayoutConstants.ghostySize.height

        // --- Body: rounded oval ---
        let bodyPath = CGMutablePath()
        // Top arc (head)
        bodyPath.addArc(center: CGPoint(x: 0, y: h * 0.15),
                        radius: w * 0.5,
                        startAngle: 0, endAngle: .pi,
                        clockwise: false)
        // Left side down to tail start
        bodyPath.addLine(to: CGPoint(x: -w * 0.5, y: -h * 0.25))
        // Wavy tail: 3 bumps using quadratic curves
        let bumpW = w / 3
        bodyPath.addQuadCurve(to: CGPoint(x: -w * 0.5 + bumpW, y: -h * 0.5),
                              control: CGPoint(x: -w * 0.5 + bumpW * 0.5, y: -h * 0.42))
        bodyPath.addQuadCurve(to: CGPoint(x: -w * 0.5 + bumpW * 2, y: -h * 0.25),
                              control: CGPoint(x: -w * 0.5 + bumpW * 1.5, y: -h * 0.42))
        bodyPath.addQuadCurve(to: CGPoint(x: w * 0.5, y: -h * 0.5),
                              control: CGPoint(x: -w * 0.5 + bumpW * 2.5, y: -h * 0.42))
        bodyPath.addQuadCurve(to: CGPoint(x: w * 0.5, y: -h * 0.25),
                              control: CGPoint(x: w * 0.5 + bumpW * 0.3, y: -h * 0.38))
        bodyPath.closeSubpath()

        let body = SKShapeNode(path: bodyPath)
        body.fillColor   = ColorPalette.text
        body.strokeColor = ColorPalette.lavender
        body.lineWidth   = 2
        container.addChild(body)

        // --- Hands: two small ovals ---
        for side in [-1.0, 1.0] {
            let hand = SKShapeNode(ellipseOf: CGSize(width: 12, height: 8))
            hand.position    = CGPoint(x: CGFloat(side) * (w * 0.5 + 5), y: h * 0.05)
            hand.fillColor   = ColorPalette.peach
            hand.strokeColor = .clear
            container.addChild(hand)
        }

        // --- Eyes: two filled circles (OwO wide eyes) ---
        for xOffset in [-w * 0.18, w * 0.18] {
            let eye = SKShapeNode(circleOfRadius: 4.5)
            eye.position  = CGPoint(x: xOffset, y: h * 0.18)
            eye.fillColor = ColorPalette.base
            eye.strokeColor = .clear
            container.addChild(eye)
        }

        // --- Mouth: "w" shape (three short line segments) ---
        let mouthPath = CGMutablePath()
        mouthPath.move(to:    CGPoint(x: -w * 0.14, y: h * 0.04))
        mouthPath.addLine(to: CGPoint(x: -w * 0.07, y: h * 0.00))
        mouthPath.addLine(to: CGPoint(x:  0,         y: h * 0.04))
        mouthPath.addLine(to: CGPoint(x:  w * 0.07, y: h * 0.00))
        mouthPath.addLine(to: CGPoint(x:  w * 0.14, y: h * 0.04))

        let mouth = SKShapeNode(path: mouthPath)
        mouth.strokeColor = ColorPalette.base
        mouth.lineWidth   = 1.5
        mouth.fillColor   = .clear
        container.addChild(mouth)

        // --- Physics body: circle approximating Ghosty's head ---
        let physBody = SKPhysicsBody(circleOfRadius: w * 0.42)
        physBody.isDynamic          = true
        physBody.affectedByGravity  = false   // we handle gravity manually
        physBody.allowsRotation     = false
        physBody.categoryBitMask    = PhysicsCategory.ghosty
        physBody.contactTestBitMask = PhysicsCategory.wall | PhysicsCategory.ground
        physBody.collisionBitMask   = PhysicsCategory.none
        container.physicsBody = physBody

        return container
    }

    // MARK: - Walls

    /// Configures an existing WallPair's nodes with the correct size, position, colour, and physics.
    /// Called by WallSpawner when spawning or recycling a pair.
    func configureWallPair(
        _ pair: WallPair,
        gapCentreY: CGFloat,
        gapHeight: CGFloat,
        sceneSize: CGSize
    ) {
        let wallW  = LayoutConstants.wallWidth
        let radius = LayoutConstants.wallCornerRadius

        // Top wall: from gap top to scene ceiling.
        let topWallBottom = gapCentreY + gapHeight / 2
        let topWallHeight = sceneSize.height - topWallBottom
        configureWallNode(pair.topWall,
                          size: CGSize(width: wallW, height: topWallHeight),
                          centreY: topWallBottom + topWallHeight / 2,
                          cornerRadius: radius)

        // Bottom wall: from ground top to gap bottom.
        let bottomWallTop    = gapCentreY - gapHeight / 2
        let bottomWallHeight = bottomWallTop - LayoutConstants.groundHeight
        configureWallNode(pair.bottomWall,
                          size: CGSize(width: wallW, height: max(bottomWallHeight, 0)),
                          centreY: LayoutConstants.groundHeight + bottomWallHeight / 2,
                          cornerRadius: radius)
    }

    private func configureWallNode(
        _ node: SKShapeNode,
        size: CGSize,
        centreY: CGFloat,
        cornerRadius: CGFloat
    ) {
        let rect = CGRect(x: -size.width / 2, y: -size.height / 2,
                          width: size.width, height: size.height)
        node.path        = CGPath(roundedRect: rect, cornerWidth: cornerRadius,
                                  cornerHeight: cornerRadius, transform: nil)
        node.fillColor   = ColorPalette.green
        node.strokeColor = ColorPalette.surface0
        node.lineWidth   = 2
        node.position.y  = centreY
        node.zPosition   = 2

        let body = SKPhysicsBody(rectangleOf: size)
        body.isDynamic          = false
        body.categoryBitMask    = PhysicsCategory.wall
        body.contactTestBitMask = PhysicsCategory.ghosty
        body.collisionBitMask   = PhysicsCategory.none
        node.physicsBody = body
    }

    // MARK: - HUD

    /// Creates the score label shown in the top-left corner during gameplay.
    func makeScoreLabel() -> SKLabelNode {
        let label = SKLabelNode()
        label.fontName              = "Sora Regular"
        label.fontSize              = 32
        label.fontColor             = ColorPalette.mauve
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode   = .top
        label.position  = CGPoint(x: 20, y: LayoutConstants.sceneSize.height - 20)
        label.zPosition = 10
        label.text      = "0"
        return label
    }

    /// Updates the score label text.
    func updateScoreLabel(_ label: SKLabelNode, score: Int) {
        label.text = "\(score)"
    }

    // MARK: - Start Screen

    /// Creates the full start-screen overlay node.
    func makeStartScreen(size: CGSize) -> SKNode {
        let container = SKNode()
        container.zPosition = 20

        // Title
        let title = SKLabelNode(text: "Flappy Kiro")
        title.fontName    = "Sora Regular"
        title.fontSize    = 42
        title.fontColor   = ColorPalette.mauve
        title.position    = CGPoint(x: size.width / 2, y: size.height * 0.70)
        title.verticalAlignmentMode = .center
        container.addChild(title)

        // Subtitle
        let sub = SKLabelNode(text: "A Ghosty Adventure")
        sub.fontName  = "JetBrains Mono Regular"
        sub.fontSize  = 16
        sub.fontColor = ColorPalette.subtext1
        sub.position  = CGPoint(x: size.width / 2, y: size.height * 0.63)
        sub.verticalAlignmentMode = .center
        container.addChild(sub)

        // Prompt with pulsing alpha
        let prompt = SKLabelNode(text: "Press SPACE to start")
        prompt.fontName  = "JetBrains Mono Regular"
        prompt.fontSize  = 14
        prompt.fontColor = ColorPalette.subtext1
        prompt.position  = CGPoint(x: size.width / 2, y: size.height * 0.27)
        prompt.verticalAlignmentMode = .center
        prompt.run(pulseAction())
        container.addChild(prompt)

        return container
    }

    // MARK: - Game Over Screen

    /// Creates the game-over overlay node showing the final score.
    func makeGameOverScreen(score: Int, size: CGSize) -> SKNode {
        let container = SKNode()
        container.zPosition = 20

        // Dim overlay
        let dim = SKShapeNode(rectOf: size)
        dim.position     = CGPoint(x: size.width / 2, y: size.height / 2)
        dim.fillColor    = ColorPalette.base.withAlphaComponent(0.75)
        dim.strokeColor  = .clear
        dim.zPosition    = -1
        container.addChild(dim)

        // "Game Over" title
        let title = SKLabelNode(text: "Game Over")
        title.fontName   = "Sora Regular"
        title.fontSize   = 40
        title.fontColor  = ColorPalette.red
        title.position   = CGPoint(x: size.width / 2, y: size.height * 0.60)
        title.verticalAlignmentMode = .center
        container.addChild(title)

        // Score
        let scoreLbl = SKLabelNode(text: "Score: \(score)")
        scoreLbl.fontName  = "Sora Regular"
        scoreLbl.fontSize  = 28
        scoreLbl.fontColor = ColorPalette.mauve
        scoreLbl.position  = CGPoint(x: size.width / 2, y: size.height * 0.50)
        scoreLbl.verticalAlignmentMode = .center
        container.addChild(scoreLbl)

        // Restart prompt
        let restart = SKLabelNode(text: "Press SPACE to restart")
        restart.fontName  = "JetBrains Mono Regular"
        restart.fontSize  = 14
        restart.fontColor = ColorPalette.subtext1
        restart.position  = CGPoint(x: size.width / 2, y: size.height * 0.37)
        restart.verticalAlignmentMode = .center
        restart.run(pulseAction())
        container.addChild(restart)

        return container
    }

    // MARK: - Animations

    /// A repeating fade-in/out action used for "Press SPACE" prompts.
    func pulseAction() -> SKAction {
        let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.5)
        let fadeIn  = SKAction.fadeAlpha(to: 1.0, duration: 0.5)
        return SKAction.repeatForever(SKAction.sequence([fadeOut, fadeIn]))
    }

    /// Idle bob action for Ghosty on the start screen.
    func idleBobAction() -> SKAction {
        let up   = SKAction.moveBy(x: 0, y: 8,  duration: 0.6)
        let down = SKAction.moveBy(x: 0, y: -8, duration: 0.6)
        up.timingMode   = .easeInEaseOut
        down.timingMode = .easeInEaseOut
        return SKAction.repeatForever(SKAction.sequence([up, down]))
    }

    // MARK: - Letterbox Scale

    /// Computes the uniform scale factor to fit the scene inside the window (letterbox strategy).
    ///
    /// - Parameters:
    ///   - sceneSize: The fixed internal scene size (400 × 600).
    ///   - windowSize: The current window size.
    /// - Returns: A scale factor ≤ 1 (or > 1 if window is larger than scene).
    func letterboxScale(sceneSize: CGSize, windowSize: CGSize) -> CGFloat {
        let scaleX = windowSize.width  / sceneSize.width
        let scaleY = windowSize.height / sceneSize.height
        return min(scaleX, scaleY)
    }
}
