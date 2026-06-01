import SwiftUI

/// An animated metric display card used in Dashboard and Summary screens.
///
/// Shows a value, title, icon, and optional accent color.
/// Animates value changes with `contentTransition(.numericText())`.
///
/// Usage:
/// ```swift
/// StatCard(
///     title: "Photos",
///     value: "4,281",
///     subtitle: "in library",
///     icon: "photo.stack",
///     accentColor: AppColors.accent,
///     isLoading: viewModel.isLoading
/// )
/// ```
struct StatCard: View {

    // MARK: - Properties

    let title: String
    let value: String
    let subtitle: String
    let icon: String
    var accentColor: Color = AppColors.accent
    var isLoading: Bool = false

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.small) {
            iconRow
            Spacer(minLength: 0)
            valueLabel
            subtitleLabel
        }
        .padding(UIConstants.Spacing.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
        .shimmer(isActive: isLoading)
    }

    // MARK: - Private Views

    private var iconRow: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: UIConstants.IconSize.small))
                .foregroundStyle(accentColor)
            Spacer()
        }
    }

    private var valueLabel: some View {
        Text(isLoading ? "—" : value)
            .font(AppTypography.titleSmall)
            .foregroundStyle(AppColors.textPrimary)
            .contentTransition(.numericText())
            .animation(.spring, value: value)
    }

    private var subtitleLabel: some View {
        Text(isLoading ? " " : title)
            .font(AppTypography.caption)
            .foregroundStyle(AppColors.textSecondary)
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: UIConstants.CornerRadius.card)
            .fill(AppColors.card)
            .overlay(
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.card)
                    .stroke(AppColors.divider, lineWidth: 1)
            )
    }
}
