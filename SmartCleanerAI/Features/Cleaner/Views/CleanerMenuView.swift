import SwiftUI

/// Cleaner feature menu — entry point to all individual cleaning tools.
struct CleanerMenuView: View {

    let coordinator: any CoordinatorProtocol

    private let features: [CleanerFeature] = CleanerFeature.allCases

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: UIConstants.Spacing.medium) {
                    ForEach(features) { feature in
                        CleanerFeatureRow(feature: feature, onTap: {})
                    }
                }
                .padding(.horizontal, UIConstants.Spacing.medium)
                .padding(.bottom, UIConstants.Spacing.section)
            }
            .screenBackground()
            .navigationTitle("tab.cleaner".localized)
        }
    }
}

// MARK: - Feature Row

private struct CleanerFeatureRow: View {
    let feature: CleanerFeature
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: UIConstants.Spacing.medium) {
                iconView
                textStack
                Spacer()
                if feature.isPremium { premiumBadge }
                Image(systemName: "chevron.right")
                    .foregroundStyle(AppColors.textTertiary)
                    .font(.system(size: UIConstants.IconSize.small))
            }
            .padding(UIConstants.Spacing.medium)
            .cardStyle()
        }
        .buttonStyle(.plain)
    }

    private var iconView: some View {
        Image(systemName: feature.icon)
            .font(.system(size: UIConstants.IconSize.medium))
            .foregroundStyle(feature.accentColor)
            .frame(width: 44, height: 44)
            .background(feature.accentColor.opacity(UIConstants.Opacity.subtle))
            .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.small))
    }

    private var textStack: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.extraSmall) {
            Text(feature.title)
                .font(AppTypography.bodyMedium)
                .foregroundStyle(AppColors.textPrimary)
            Text(feature.subtitle)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
        }
    }

    private var premiumBadge: some View {
        Text("badge.premium".localized)
            .font(AppTypography.badge)
            .foregroundStyle(AppColors.premium)
            .padding(.horizontal, UIConstants.Spacing.small)
            .padding(.vertical, UIConstants.Spacing.extraSmall)
            .background(AppColors.premium.opacity(UIConstants.Opacity.subtle))
            .clipShape(Capsule())
    }
}

// MARK: - CleanerFeature Model

private struct CleanerFeature: Identifiable, CaseIterable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let accentColor: Color
    var isPremium: Bool = false

    static var allCases: [CleanerFeature] = [
        .init(id: "duplicates",  title: "feature.duplicatePhotos".localized,  subtitle: "cleaner.duplicates.subtitle".localized,  icon: "photo.on.rectangle.angled", accentColor: AppColors.accent),
        .init(id: "blurry",      title: "feature.blurDetection".localized,    subtitle: "cleaner.blurry.subtitle".localized,      icon: "camera.filters",           accentColor: AppColors.warning, isPremium: true),
        .init(id: "similar",     title: "feature.similarPhotos".localized,    subtitle: "cleaner.similar.subtitle".localized,     icon: "rectangle.stack",          accentColor: AppColors.accentSecondary, isPremium: true),
        .init(id: "screenshots", title: "feature.screenshots".localized,      subtitle: "cleaner.screenshots.subtitle".localized, icon: "camera.viewfinder",        accentColor: AppColors.success),
        .init(id: "videos",      title: "feature.largeVideos".localized,      subtitle: "cleaner.largeVideos.subtitle".localized, icon: "video.badge.ellipsis",     accentColor: AppColors.accentSecondary),
        .init(id: "contacts",    title: "feature.duplicateContacts".localized, subtitle: "cleaner.contacts.subtitle".localized,   icon: "person.2.badge.gearshape", accentColor: AppColors.premium)
    ]
}
