import Foundation

/// UI layout constants for SmartCleanerAI's design system.
///
/// Centralizes all spacing, sizing, corner radius, animation duration,
/// and opacity values to ensure visual consistency across the app.
///
/// Usage:
/// ```swift
/// .padding(UIConstants.Spacing.medium)
/// .cornerRadius(UIConstants.CornerRadius.card)
/// withAnimation(.easeOut(duration: UIConstants.Animation.standard)) { ... }
/// ```
public enum UIConstants {

    // MARK: - Spacing (8pt grid)

    enum Spacing {
        /// 4pt — minimum tight spacing.
        static let extraSmall: CGFloat = 4
        /// 8pt — standard small spacing.
        static let small: CGFloat = 8
        /// 12pt — medium-small spacing.
        static let mediumSmall: CGFloat = 12
        /// 16pt — standard medium spacing.
        static let medium: CGFloat = 16
        /// 24pt — large spacing.
        static let large: CGFloat = 24
        /// 32pt — extra large spacing.
        static let extraLarge: CGFloat = 32
        /// 48pt — section-level spacing.
        static let section: CGFloat = 48
    }

    // MARK: - Corner Radius

    enum CornerRadius {
        /// 8pt — badges and chips.
        static let small: CGFloat = 8
        /// 12pt — buttons and text fields.
        static let button: CGFloat = 12
        /// 16pt — cards and list items.
        static let card: CGFloat = 16
        /// 24pt — modals and sheets.
        static let modal: CGFloat = 24
        /// 999pt — pill / fully-rounded.
        static let pill: CGFloat = 999
    }

    // MARK: - Icon Sizes

    enum IconSize {
        /// 16pt — inline icons.
        static let small: CGFloat = 16
        /// 24pt — standard action icons.
        static let medium: CGFloat = 24
        /// 32pt — feature header icons.
        static let large: CGFloat = 32
        /// 56pt — hero / illustration icons.
        static let hero: CGFloat = 56
    }

    // MARK: - Grid Layout

    enum Grid {
        /// Number of columns in the photo grid.
        static let photoColumns: Int = 3
        /// Spacing between grid items.
        static let itemSpacing: CGFloat = 2
    }

    // MARK: - Animation Durations

    enum Animation {
        /// 0.2s — fast micro-animations.
        static let fast: Double = 0.2
        /// 0.35s — standard transitions.
        static let standard: Double = 0.35
        /// 0.6s — emphasis animations.
        static let slow: Double = 0.6
        /// 1.5s — shimmer loop duration.
        static let shimmer: Double = 1.5
    }

    // MARK: - Opacity

    enum Opacity {
        /// 0.6 — overlay backgrounds.
        static let overlay: Double = 0.6
        /// 0.4 — disabled interactive elements.
        static let disabled: Double = 0.4
        /// 0.12 — subtle tint backgrounds.
        static let subtle: Double = 0.12
    }
}
