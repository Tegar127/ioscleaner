import SwiftUI

/// The main Dashboard screen for SmartCleanerAI.
///
/// Displays a storage usage ring, quick action cards, top AI recommendations,
/// and historical savings summary. All data is loaded via `DashboardViewModel`.
struct DashboardView: View {

    // MARK: - Dependencies

    @State var viewModel: DashboardViewModel
    let coordinator: any CoordinatorProtocol

    // MARK: - Body

    var body: some View {
        ScrollView {
            LazyVStack(spacing: UIConstants.Spacing.large) {
                headerSection
                storageRingSection
                quickActionsSection
                if let summary = viewModel.summary, !summary.topRecommendations.isEmpty {
                    recommendationsSection(summary.topRecommendations)
                }
                historySummarySection
            }
            .padding(.horizontal, UIConstants.Spacing.medium)
            .padding(.bottom, UIConstants.Spacing.section)
        }
        .screenBackground()
        .navigationBarHidden(true)
        .task { viewModel.loadDashboard() }
        .refreshable { viewModel.loadDashboard() }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: UIConstants.Spacing.extraSmall) {
                Text("dashboard.greeting".localized)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
                Text("dashboard.title".localized)
                    .font(AppTypography.largeTitle)
                    .foregroundStyle(AppColors.textPrimary)
            }
            Spacer()
            Button { coordinator.presentModal(.premium) } label: {
                Image(systemName: "crown.fill")
                    .foregroundStyle(AppColors.premium)
                    .font(.system(size: UIConstants.IconSize.medium))
            }
        }
        .padding(.top, UIConstants.Spacing.medium)
    }

    // MARK: - Storage Ring

    private var storageRingSection: some View {
        VStack(spacing: UIConstants.Spacing.large) {
            StorageRingChart(
                usedBytes: viewModel.summary?.totalMediaSizeBytes ?? 0,
                totalBytes: 128_000_000_000
            )
            .shimmer(isActive: viewModel.isLoading)
            statsRow
        }
        .padding(UIConstants.Spacing.large)
        .cardStyle()
    }

    private var statsRow: some View {
        HStack(spacing: UIConstants.Spacing.small) {
            StatCard(title: "Photos", value: "\(viewModel.summary?.photoCount ?? 0)",
                     subtitle: "in library", icon: "photo.stack", isLoading: viewModel.isLoading)
            StatCard(title: "Videos", value: "\(viewModel.summary?.videoCount ?? 0)",
                     subtitle: "in library", icon: "video.stack",
                     accentColor: AppColors.accentSecondary, isLoading: viewModel.isLoading)
            StatCard(title: "Contacts", value: "\(viewModel.summary?.contactCount ?? 0)",
                     subtitle: "saved", icon: "person.2",
                     accentColor: AppColors.success, isLoading: viewModel.isLoading)
        }
    }

    // MARK: - Quick Actions

    private var quickActionsSection: some View {
        VStack(spacing: UIConstants.Spacing.medium) {
            SectionHeader(title: "dashboard.quickActions.title".localized)
            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: UIConstants.Spacing.medium
            ) {
                QuickActionCard(icon: "photo.on.rectangle.angled",
                                title: "feature.duplicatePhotos".localized,
                                subtitle: "quickAction.findDuplicates".localized, action: {})
                QuickActionCard(icon: "camera.filters",
                                title: "feature.blurDetection".localized,
                                subtitle: "quickAction.findBlurry".localized,
                                accentColor: AppColors.warning, isNew: true, action: {})
                QuickActionCard(icon: "video.badge.ellipsis",
                                title: "feature.largeVideos".localized,
                                subtitle: "quickAction.findLargeVideos".localized,
                                accentColor: AppColors.accentSecondary, action: {})
                QuickActionCard(icon: "person.2.badge.gearshape",
                                title: "feature.duplicateContacts".localized,
                                subtitle: "quickAction.findContacts".localized,
                                accentColor: AppColors.success, action: {})
            }
        }
    }

    // MARK: - Recommendations

    private func recommendationsSection(_ recs: [RecommendationEntity]) -> some View {
        VStack(spacing: UIConstants.Spacing.medium) {
            SectionHeader(
                title: "dashboard.recommendations.title".localized,
                actionTitle: "action.seeAll".localized,
                action: { coordinator.navigate(to: .aiRecommendations) }
            )
            ForEach(recs) { rec in
                HStack(spacing: UIConstants.Spacing.medium) {
                    Image(systemName: rec.type.systemIcon)
                        .font(.system(size: UIConstants.IconSize.medium))
                        .foregroundStyle(AppColors.accent)
                        .frame(width: 40, height: 40)
                        .background(AppColors.accent.opacity(UIConstants.Opacity.subtle))
                        .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.small))
                    VStack(alignment: .leading, spacing: UIConstants.Spacing.extraSmall) {
                        Text(rec.title).font(AppTypography.bodyMedium).foregroundStyle(AppColors.textPrimary)
                        Text(rec.formattedSpaceSaved + " recoverable")
                            .font(AppTypography.caption).foregroundStyle(AppColors.success)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: UIConstants.IconSize.small))
                        .foregroundStyle(AppColors.textTertiary)
                }
                .padding(UIConstants.Spacing.medium).cardStyle()
            }
        }
    }

    // MARK: - History Summary

    private var historySummarySection: some View {
        VStack(spacing: UIConstants.Spacing.medium) {
            SectionHeader(title: "dashboard.history.title".localized,
                          actionTitle: "action.seeAll".localized,
                          action: { coordinator.navigate(to: .history) })
            HStack {
                VStack(alignment: .leading, spacing: UIConstants.Spacing.extraSmall) {
                    Text(viewModel.summary?.formattedTotalSaved ?? "—")
                        .font(AppTypography.title).foregroundStyle(AppColors.success)
                    Text("dashboard.history.totalSaved".localized)
                        .font(AppTypography.caption).foregroundStyle(AppColors.textSecondary)
                }
                Spacer()
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: UIConstants.IconSize.large)).foregroundStyle(AppColors.success)
            }
            .padding(UIConstants.Spacing.medium).cardStyle()
        }
    }
}
