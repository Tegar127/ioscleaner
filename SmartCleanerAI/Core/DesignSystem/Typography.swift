import SwiftUI

/// Typography scale for SmartCleanerAI's design system.
///
/// Defines the complete font hierarchy using SF Pro (system font) for
/// consistency with iOS platform conventions and Dynamic Type support.
///
/// Usage:
/// ```swift
/// Text("Storage Analysis").font(AppTypography.title)
/// Text("4.2 GB freed").font(AppTypography.displayBold)
/// ```
public enum AppTypography {

    // MARK: - Display

    /// Large hero numbers (e.g., ring center value). Bold, 48pt, rounded.
    static let displayBold: Font = .system(size: 48, weight: .bold, design: .rounded)

    /// Secondary hero display. Semibold, 36pt, rounded.
    static let displaySemibold: Font = .system(size: 36, weight: .semibold, design: .rounded)

    // MARK: - Titles

    /// Screen / page title. Bold, 28pt.
    static let largeTitle: Font = .system(size: 28, weight: .bold, design: .default)

    /// Section-level title. Semibold, 22pt.
    static let title: Font = .system(size: 22, weight: .semibold, design: .default)

    /// Card / modal title. Semibold, 18pt.
    static let titleSmall: Font = .system(size: 18, weight: .semibold, design: .default)

    // MARK: - Body

    /// Standard body text. Regular, 16pt.
    static let body: Font = .system(size: 16, weight: .regular, design: .default)

    /// Emphasized body text. Medium, 16pt.
    static let bodyMedium: Font = .system(size: 16, weight: .medium, design: .default)

    /// Secondary body / descriptor. Regular, 14pt.
    static let bodySmall: Font = .system(size: 14, weight: .regular, design: .default)

    // MARK: - Labels and Captions

    /// Metric / stat label. Bold, 14pt.
    static let labelBold: Font = .system(size: 14, weight: .bold, design: .default)

    /// Secondary descriptor. Regular, 12pt.
    static let caption: Font = .system(size: 12, weight: .regular, design: .default)

    /// Small badge / chip text. Medium, 11pt, rounded.
    static let badge: Font = .system(size: 11, weight: .medium, design: .rounded)
}
