import SwiftUI

/// A reusable empty state placeholder for lists and grids.
///
/// Displays a circular icon background, title, descriptive message,
/// and an optional CTA button when a feature has no content to show.
///
/// Usage:
/// ```swift
/// EmptyStateView(
///     icon: "checkmark.seal.fill",
///     title: "All Clean!",
///     message: "No duplicate photos found.",
///     actionTitle: "Scan Again",
///     action: { viewModel.startScan() }
/// )
/// ```
struct EmptyStateView: View {

    // MARK: - Properties

    let icon: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    // MARK: - Body

    var body: some View {
        VStack(spacing: UIConstants.Spacing.large) {
            iconView
            textStack
            if let actionTitle, let action {
                PrimaryButton(title: actionTitle, action: action)
                    .padding(.horizontal, UIConstants.Spacing.extraLarge)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(UIConstants.Spacing.extraLarge)
    }

    // MARK: - Private Views

    private var iconView: some View {
        ZStack {
            Circle()
                .fill(AppColors.accent.opacity(UIConstants.Opacity.subtle))
                .frame(width: 88, height: 88)
            Image(systemName: icon)
                .font(.system(size: UIConstants.IconSize.hero))
                .foregroundStyle(AppColors.accent)
        }
    }

    private var textStack: some View {
        VStack(spacing: UIConstants.Spacing.small) {
            Text(title)
                .font(AppTypography.titleSmall)
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)
            Text(message)
                .font(AppTypography.bodySmall)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
    }
}
