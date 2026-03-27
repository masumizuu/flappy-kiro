/// FlappyKiroApp.swift
/// Flappy Kiro
///
/// The SwiftUI application entry point.
///
/// Responsibilities:
///   - Declares the app and its main window.
///   - Sets the window title and enforces the minimum window size (400×600 pt).
///   - Hosts GameWindowView as the root content.

import SwiftUI

@main
struct FlappyKiroApp: App {
    var body: some Scene {
        WindowGroup {
            GameWindowView()
                .onAppear {
                    // Set minimum window size so the game is always playable.
                    NSApp.windows.first?.minSize = NSSize(
                        width:  LayoutConstants.minimumWindowSize.width,
                        height: LayoutConstants.minimumWindowSize.height
                    )
                    NSApp.windows.first?.title = "Flappy Kiro"
                }
        }
        .windowResizability(.contentMinSize)
    }
}
