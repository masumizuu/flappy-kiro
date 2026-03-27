/// ColorPalette.swift
/// Flappy Kiro
///
/// Catppuccin Mocha colour palette as SKColor constants.
/// Reference: https://catppuccin.com/palette — Mocha flavour.
///
/// Usage: ColorPalette.mauve, ColorPalette.green, etc.

import SpriteKit

enum ColorPalette {

    // MARK: - Base / Backgrounds
    /// #1E1E2E — Main background, letterbox bars
    static let base      = SKColor(hex: 0x1E1E2E)
    /// #181825 — Darker background layer
    static let mantle    = SKColor(hex: 0x181825)
    /// #11111B — Darkest background
    static let crust     = SKColor(hex: 0x11111B)

    // MARK: - Surfaces
    /// #313244 — Wall borders, ground stroke
    static let surface0  = SKColor(hex: 0x313244)
    /// #45475A — Ground fill
    static let surface1  = SKColor(hex: 0x45475A)
    /// #585B70 — Subtle UI elements
    static let surface2  = SKColor(hex: 0x585B70)

    // MARK: - Text
    /// #CDD6F4 — Primary text, Ghosty body
    static let text      = SKColor(hex: 0xCDD6F4)
    /// #BAC2DE — Secondary text, prompts
    static let subtext1  = SKColor(hex: 0xBAC2DE)
    /// #A6ADC8 — Tertiary text
    static let subtext0  = SKColor(hex: 0xA6ADC8)

    // MARK: - Accent Colours
    /// #B4BEFE — Ghosty tint, accents
    static let lavender  = SKColor(hex: 0xB4BEFE)
    /// #CBA6F7 — Score label, title
    static let mauve     = SKColor(hex: 0xCBA6F7)
    /// #F38BA8 — Game Over title
    static let red       = SKColor(hex: 0xF38BA8)
    /// #FAB387 — Ghosty hands
    static let peach     = SKColor(hex: 0xFAB387)
    /// #A6E3A1 — Wall fill
    static let green     = SKColor(hex: 0xA6E3A1)
    /// #89DCEB — Decorative accents
    static let sky       = SKColor(hex: 0x89DCEB)
    /// #89B4FA — Decorative accents
    static let blue      = SKColor(hex: 0x89B4FA)
}

// MARK: - SKColor hex initialiser

extension SKColor {
    /// Initialise an SKColor from a 24-bit hex integer (e.g. 0x1E1E2E).
    convenience init(hex: UInt32) {
        let r = CGFloat((hex >> 16) & 0xFF) / 255
        let g = CGFloat((hex >> 8)  & 0xFF) / 255
        let b = CGFloat( hex        & 0xFF) / 255
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}
