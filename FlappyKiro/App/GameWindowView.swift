/// GameWindowView.swift
/// Flappy Kiro
///
/// The SwiftUI view that hosts the SpriteKit game scene.
///
/// Responsibilities:
///   - Wraps GameScene in a SpriteView so SwiftUI can display it.
///   - Observes the window size via GeometryReader.
///   - Computes a uniform scale factor so the game canvas letterboxes/pillarboxes
///     proportionally inside the window — game logic always uses fixed 400×600 coords.
///   - Fills the letterbox bars with Catppuccin Mocha `base` colour.

import SwiftUI
import SpriteKit

struct GameWindowView: View {

    // MARK: - Scene

    /// The SpriteKit scene — created once and reused for the app's lifetime.
    @StateObject private var sceneHolder = SceneHolder()

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            let scale     = letterboxScale(windowSize: geo.size)
            let sceneSize = LayoutConstants.sceneSize
            let scaledW   = sceneSize.width  * scale
            let scaledH   = sceneSize.height * scale

            ZStack {
                // Letterbox background — fills the entire window.
                Color(nsColor: NSColor(
                    red: 0x1E / 255.0,
                    green: 0x1E / 255.0,
                    blue: 0x2E / 255.0,
                    alpha: 1
                ))
                .ignoresSafeArea()

                // The game canvas, centred and scaled.
                SpriteView(scene: sceneHolder.scene)
                    .frame(width: scaledW, height: scaledH)
                    .clipped()
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }

    // MARK: - Helpers

    /// Computes the uniform scale factor to fit the 400×600 scene into the window.
    private func letterboxScale(windowSize: CGSize) -> CGFloat {
        let sceneSize = LayoutConstants.sceneSize
        let scaleX = windowSize.width  / sceneSize.width
        let scaleY = windowSize.height / sceneSize.height
        return min(scaleX, scaleY)
    }
}

// MARK: - SceneHolder

/// Holds the GameScene instance as an ObservableObject so it persists across SwiftUI redraws.
final class SceneHolder: ObservableObject {
    let scene: GameScene

    init() {
        let s = GameScene(size: LayoutConstants.sceneSize)
        s.scaleMode = .aspectFit   // SpriteKit also respects aspect fit inside SpriteView
        scene = s
    }
}
