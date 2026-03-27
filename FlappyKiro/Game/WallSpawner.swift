/// WallSpawner.swift
/// Flappy Kiro
///
/// Spawns, scrolls, and recycles wall pairs.
///
/// Object pool:
///   WallPair nodes are expensive to create (SKShapeNode allocation + physics body setup).
///   Instead of creating and destroying them every spawn cycle, we maintain a small pool
///   of pre-configured pairs and reset + reuse them when they scroll off-screen.
///
/// Gap randomisation:
///   Each wall pair gets a random gap height (within safe bounds) AND a random gap
///   centre Y position. This means some gaps are tighter, some are wider, and they
///   appear at different heights — keeping the game unpredictable.

import SpriteKit

final class WallSpawner {

    // MARK: - Dependencies

    private weak var scene: SKScene?
    private let renderComponent: RenderComponent

    // MARK: - State

    /// Active wall pairs currently in the scene.
    private var activePairs: [WallPair] = []

    /// Recycled wall pairs waiting to be reused.
    private var pool: [WallPair] = []

    /// Time elapsed since the last wall pair was spawned.
    private var timeSinceLastSpawn: TimeInterval = 0

    // MARK: - Init

    /// - Parameters:
    ///   - scene: The SKScene to add wall nodes to.
    ///   - renderComponent: Used to configure wall node visuals.
    init(scene: SKScene, renderComponent: RenderComponent) {
        self.scene           = scene
        self.renderComponent = renderComponent
        // Pre-fill the pool with 6 pairs — enough for any scroll speed.
        for _ in 0..<6 { pool.append(WallPair()) }
    }

    // MARK: - Public API

    /// Removes all active walls from the scene and resets spawn timing.
    /// Called at the start of each new game.
    func reset() {
        for pair in activePairs { pair.removeFromParent() }
        pool.append(contentsOf: activePairs)
        activePairs.removeAll()
        timeSinceLastSpawn = 0
    }

    /// Returns the currently active wall pairs (read by ScoreComponent and CollisionHandler).
    func walls() -> [WallPair] { activePairs }

    /// Updates wall positions and spawns new pairs on the correct interval.
    ///
    /// - Parameters:
    ///   - deltaTime: Seconds since the last frame.
    ///   - speed: Current scroll speed in pt/s (from DifficultyComponent).
    func update(deltaTime: TimeInterval, speed: CGFloat) {
        scrollWalls(deltaTime: deltaTime, speed: speed)
        removeOffScreenWalls()

        timeSinceLastSpawn += deltaTime
        let interval = spawnInterval(for: speed)
        if timeSinceLastSpawn >= interval {
            spawnWallPair()
            timeSinceLastSpawn = 0
        }
    }

    // MARK: - Private

    /// Moves all active walls to the left by `speed × deltaTime` points.
    private func scrollWalls(deltaTime: TimeInterval, speed: CGFloat) {
        let dx = speed * CGFloat(deltaTime)
        for pair in activePairs {
            pair.xPosition -= dx
        }
    }

    /// Removes wall pairs whose right edge has scrolled past the left edge of the scene.
    private func removeOffScreenWalls() {
        let removeThreshold: CGFloat = -(LayoutConstants.wallWidth / 2 + 10)
        activePairs = activePairs.filter { pair in
            if pair.xPosition < removeThreshold {
                pair.removeFromParent()
                pair.reset()
                pool.append(pair)   // return to pool for reuse
                return false
            }
            return true
        }
    }

    /// Spawns a new wall pair with a randomised gap.
    private func spawnWallPair() {
        guard let scene = scene else { return }

        // Dequeue from pool or allocate a fresh pair.
        let pair = pool.isEmpty ? WallPair() : pool.removeFirst()

        // Randomise gap height within the safe range.
        let ghostyH = LayoutConstants.ghostySize.height
        let minGap  = ghostyH * LayoutConstants.minGapMultiplier
        let maxGap  = ghostyH * LayoutConstants.maxGapMultiplier
        let gapH    = CGFloat.random(in: minGap...maxGap)

        // Randomise gap centre Y within safe vertical bounds.
        let minCentreY = LayoutConstants.groundHeight + gapH / 2 + LayoutConstants.gapEdgePadding
        let maxCentreY = LayoutConstants.sceneSize.height - gapH / 2 - LayoutConstants.gapEdgePadding
        let gapCentreY = CGFloat.random(in: minCentreY...maxCentreY)

        pair.gapCentreY = gapCentreY
        pair.gapHeight  = gapH

        // Configure visuals and physics via RenderComponent.
        renderComponent.configureWallPair(
            pair,
            gapCentreY: gapCentreY,
            gapHeight:  gapH,
            sceneSize:  LayoutConstants.sceneSize
        )

        // Position at the right spawn edge.
        pair.xPosition = LayoutConstants.wallSpawnX

        scene.addChild(pair.topWall)
        scene.addChild(pair.bottomWall)
        activePairs.append(pair)
    }

    /// Computes the spawn interval for the current speed.
    /// Faster speed → shorter interval → more walls.
    private func spawnInterval(for speed: CGFloat) -> TimeInterval {
        // Scale interval inversely with speed relative to base speed.
        let ratio    = DifficultyConstants.baseSpeed / speed
        let interval = LayoutConstants.baseSpawnInterval * Double(ratio)
        return max(interval, LayoutConstants.minSpawnInterval)
    }
}
