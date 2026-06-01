import SwiftUI

/// A tappable card linking to a specific cleaner feature.
///
/// Displays an SF Symbol icon, feature title, subtitle metric,
/// optional "New" badge, and a subtle scale-down tap animation.
///
/// Usage:
/// ```swift
/// QuickActionCard(
///     icon: "photo.on.rectangle.angled",
///     title: "Duplicate Photos",
///     subtitle: "312 found",
///     accentColor: AppColors.accent,
///     isNew: false,
///     action: { navigate() }
/// )
/// ```
struct QuickActionCard: View {

    // MARK: - Properties

    let icon: String
    let title: String
    let subtitle: String
    var accentColor: Color = AppColors.accent
    var isNew: Bool = false
    let action: () -> Void

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            cardContent
        }
        .buttonStyle(CardScaleButtonStyle())
    }

    // MARK: - Private Views

    private var cardContent: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.small) {
            iconRow
            Spacer()
            Text(title)
                .font(AppTypography.labelBold)
                .foregroundStyle(AppColors.textPrimary)
                .lineLimit(1)
            Text(subtitle)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
        }
        .padding(UIConstants.Spacing.medium)
        .frame(maxWidth: .infinity, minHeight: 110, alignment: .leading)
        .background(cardBackground)
    }

    private var iconRow: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: UIConstants.IconSize.medium))
                .foregroundStyle(accentColor)
            Spacer()
            if isNew { newBadge }
        }
    }

    private var newBadge: some View {
        Text("badge.new".localized)
            .font(AppTypography.badge)
            .foregroundStyle(.white)
            .padding(.horizontal, UIConstants.Spacing.small)
            .padding(.vertical, UIConstants.Spacing.extraSmall)
            .background(AppColors.accentSecondary)
            .clipShape(Capsule())
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: UIConstants.CornerRadius.card)
            .fill(AppColors.card)
            .overlay(
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.card)
                    .stroke(accentColor.opacity(UIConstants.Opacity.subtle), lineWidth: 1)
            )
    }
}

// MARK: - Card Button Style

private struct CardScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeInOut(duration: UIConstants.Animation.fast), value: configuration.isPressed)
    }
}
