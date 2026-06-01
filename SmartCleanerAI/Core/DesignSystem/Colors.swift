import SwiftUI

/// Semantic design system color tokens for SmartCleanerAI.
///
/// Defines a dark-mode-first palette with a purple/cyan AI gradient theme.
/// All UI components must reference these tokens — never raw hex values.
///
/// Usage:
/// ```swift
/// Rectangle().fill(AppColors.background)
/// Text("Hello").foregroundStyle(AppColors.textPrimary)
/// LinearGradient — use AppColors.accentGradient
/// ```
public enum AppColors {

    // MARK: - Background Hierarchy

    /// Deepest app background — dark navy (#0A0A1A).
    static let background = Color(hex: "0A0A1A")

    /// Elevated surface for sheets and modals (#12122A).
    static let surface = Color(hex: "12122A")

    /// Card and list-item background (#1C1C3E).
    static let card = Color(hex: "1C1C3E")

    /// Subtle divider and border color.
    static let divider = Color.white.opacity(0.08)

    // MARK: - Accent Colors

    /// Primary brand accent — purple (#7C5CBF).
    static let accent = Color(hex: "7C5CBF")

    /// Secondary accent — AI cyan (#00D4FF).
    static let accentSecondary = Color(hex: "00D4FF")

    /// Gradient from accent (purple) → accentSecondary (cyan).
    static let accentGradient = LinearGradient(
        colors: [Color(hex: "7C5CBF"), Color(hex: "00D4FF")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Text Colors

    /// Primary text on dark backgrounds.
    static let textPrimary = Color.white

    /// Secondary / muted descriptive text (#B0B4CC).
    static let textSecondary = Color(hex: "B0B4CC")

    /// Tertiary / placeholder text.
    static let textTertiary = Color.white.opacity(0.35)

    // MARK: - Semantic Status Colors

    /// Success / space-recovered indicator (#00E676).
    static let success = Color(hex: "00E676")

    /// Warning / attention required (#FFD740).
    static let warning = Color(hex: "FFD740")

    /// Error / destructive action (#FF5252).
    static let error = Color(hex: "FF5252")

    /// Premium / gold feature indicator (#FFB347).
    static let premium = Color(hex: "FFB347")
}
