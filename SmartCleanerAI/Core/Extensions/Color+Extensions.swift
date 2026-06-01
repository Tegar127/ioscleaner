import SwiftUI

/// SwiftUI `Color` extensions for hex initialization and brand color shortcuts.
///
/// Usage:
/// ```swift
/// let brandColor = Color(hex: "7C5CBF")
/// let surface = Color.appSurface
/// ```
extension Color {

    // MARK: - Hex Initializer

    /// Creates a `Color` from a 6-character hex string.
    ///
    /// - Parameter hex: A 6-character hex string with or without a leading `#`.
    init(hex: String) {
        let sanitized = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: sanitized).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >>  8) & 0xFF) / 255.0
        let b = Double( int        & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }

    // MARK: - Brand Color Shortcuts

    /// Primary app background color.
    static var appBackground: Color    { AppColors.background }
    /// Elevated surface color (cards, sheets).
    static var appSurface: Color       { AppColors.surface }
    /// Card / container background.
    static var appCard: Color          { AppColors.card }
    /// Primary accent color (purple).
    static var appAccent: Color        { AppColors.accent }
    /// Secondary accent color (cyan).
    static var appAccentSecondary: Color { AppColors.accentSecondary }
    /// Primary text color.
    static var appTextPrimary: Color   { AppColors.textPrimary }
    /// Secondary / muted text color.
    static var appTextSecondary: Color { AppColors.textSecondary }
    /// Success / reclaimable space color.
    static var appSuccess: Color       { AppColors.success }
    /// Warning / caution color.
    static var appWarning: Color       { AppColors.warning }
    /// Error / destructive color.
    static var appError: Color         { AppColors.error }
}
