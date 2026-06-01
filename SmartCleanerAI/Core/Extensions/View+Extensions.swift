import SwiftUI

/// SwiftUI `View` extensions providing composite design-system modifiers.
///
/// Centralizes recurring styling to reduce duplication across feature views
/// and ensure consistent visual appearance.
///
/// Usage:
/// ```swift
/// VStack { ... }.cardStyle()
/// Color.clear.screenBackground()
/// ```
extension View {

    // MARK: - Card Style

    /// Applies the standard card appearance: dark fill, rounded corners, subtle border.
    func cardStyle() -> some View {
        self
            .background(AppColors.card)
            .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.card))
            .overlay(
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.card)
                    .stroke(AppColors.divider, lineWidth: 1)
            )
    }

    // MARK: - Screen Background

    /// Applies the standard full-screen dark background color.
    func screenBackground() -> some View {
        self.background(AppColors.background.ignoresSafeArea())
    }

    // MARK: - Gradient Accent Border

    /// Applies a gradient stroke border using the app's accent gradient.
    ///
    /// - Parameter width: Stroke width. Defaults to 1.5.
    func accentBorder(width: CGFloat = 1.5) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.card)
                .stroke(AppColors.accentGradient, lineWidth: width)
        )
    }

    // MARK: - Conditional Modifier

    /// Applies a transform closure conditionally.
    ///
    /// - Parameters:
    ///   - condition: When `true`, the transform is applied.
    ///   - transform: A closure that modifies the view.
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition { transform(self) } else { self }
    }

    // MARK: - Header Padding

    /// Applies consistent horizontal padding for screen-level headers.
    func headerPadding() -> some View {
        self.padding(.horizontal, UIConstants.Spacing.medium)
    }
}
