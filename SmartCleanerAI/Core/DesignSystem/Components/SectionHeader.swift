import SwiftUI

/// A consistent section header with optional subtitle and action button.
///
/// Used throughout the app to introduce content sections with
/// a title, descriptive subtitle, and "See All" / action link.
///
/// Usage:
/// ```swift
/// SectionHeader(
///     title: "AI Recommendations",
///     subtitle: "Based on your usage",
///     actionTitle: "See All",
///     action: { coordinator.navigate(to: .aiRecommendations) }
/// )
/// ```
struct SectionHeader: View {

    // MARK: - Properties

    let title: String
    var subtitle: String? = nil
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    // MARK: - Body

    var body: some View {
        HStack(alignment: .bottom) {
            titleStack
            Spacer()
            if let actionTitle, let action {
                actionButton(title: actionTitle, handler: action)
            }
        }
    }

    // MARK: - Private Views

    private var titleStack: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.extraSmall) {
            Text(title)
                .font(AppTypography.titleSmall)
                .foregroundStyle(AppColors.textPrimary)
            if let subtitle {
                Text(subtitle)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
    }

    private func actionButton(title: String, handler: @escaping () -> Void) -> some View {
        Button(action: handler) {
            Text(title)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.accentSecondary)
        }
    }
}
