/// Logger.swift
/// Flappy Kiro
///
/// Lightweight debug logger that writes exclusively to stderr.
///
/// Why stderr? So debug output never appears in the user-facing UI and is
/// easy to filter in Xcode's console. In a production build you can disable
/// logging by setting the DEBUG flag to false or stripping the calls.
///
/// Security note (SECURITY-03): This logger must NEVER receive passwords,
/// tokens, or personally identifiable information — none exist in this app,
/// but the rule is documented here for future maintainers.

import Foundation

enum Logger {

    // MARK: - Public API

    /// Log a debug-level message to stderr.
    /// Use for informational traces during development.
    static func debug(
        _ message: String,
        file: String = #fileID,
        line: Int = #line
    ) {
        write(level: "DEBUG", message: message, file: file, line: line)
    }

    /// Log an error-level message to stderr.
    /// Use when a recoverable failure occurs (e.g. audio synthesis failed, font not found).
    static func error(
        _ message: String,
        file: String = #fileID,
        line: Int = #line
    ) {
        write(level: "ERROR", message: message, file: file, line: line)
    }

    // MARK: - Private

    private static func write(level: String, message: String, file: String, line: Int) {
        // fputs writes directly to stderr — never to stdout or any UI surface.
        fputs("[\(level)] \(file):\(line) — \(message)\n", stderr)
    }
}
