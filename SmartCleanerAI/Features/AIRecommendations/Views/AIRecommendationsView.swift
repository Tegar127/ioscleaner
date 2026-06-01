import SwiftUI

/// AI Recommendations screen showing ranked cleanup suggestions.
struct AIRecommendationsView: View {

    @State var viewModel: AIRecommendationsViewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    loadingView
                } else if viewModel.recommendations.isEmpty {
                    EmptyStateView(
                        icon: "brain",
                        title: "recommendations.empty.title".localized,
                        message: "recommendations.empty.message".localized,
                        actionTitle: "action.refresh".localized,
                        action: { viewModel.refresh() }
                    )
                } else {
                    recommendationList
                }
            }
            .screenBackground()
            .navigationTitle("tab.ai".localized)
            .toolbar { refreshToolbarItem }
        }
        .task { viewModel.load() }
    }

    // MARK: - List

    private var recommendationList: some View {
        ScrollView {
            LazyVStack(spacing: UIConstants.Spacing.medium) {
                summaryBanner
                ForEach(viewModel.recommendations) { rec in
                    RecommendationCard(recommendation: rec, action: {})
                }
            }
            .padding(.horizontal, UIConstants.Spacing.medium)
            .padding(.bottom, UIConstants.Spacing.section)
        }
    }

    // MARK: - Summary Banner

    private var summaryBanner: some View {
        HStack {
            VStack(alignment: .leading, spacing: UIConstants.Spacing.extraSmall) {
                Text("recommendations.banner.title".localized)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
                Text(viewModel.totalReclaimable)
                    .font(AppTypography.title)
                    .foregroundStyle(AppColors.success)
                Text("recommendations.banner.subtitle".localized)
                    .font(AppTypography.bodySmall)
                    .foregroundStyle(AppColors.textSecondary)
            }
            Spacer()
            Image(systemName: "brain")
                .font(.system(size: UIConstants.IconSize.hero))
                .foregroundStyle(AppColors.accentGradient)
        }
        .padding(UIConstants.Spacing.large)
        .cardStyle()
        .accentBorder()
    }

    // MARK: - Loading

    private var loadingView: some View {
        VStack(spacing: UIConstants.Spacing.medium) {
            ForEach(0..<3, id: \.self) { _ in
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.card)
                    .fill(AppColors.card).frame(height: 88).shimmer(isActive: true)
            }
        }
        .padding(UIConstants.Spacing.medium)
    }

    // MARK: - Toolbar

    private var refreshToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button { viewModel.refresh() } label: {
                Image(systemName: "arrow.clockwise")
                    .foregroundStyle(AppColors.accentSecondary)
            }
        }
    }
}

// MARK: - Recommendation Card

private struct RecommendationCard: View {
    let recommendation: RecommendationEntity
    let action: () -> Void

    var body: some View {
        HStack(spacing: UIConstants.Spacing.medium) {
            iconView
            textStack
            Spacer()
            spaceLabel
        }
        .padding(UIConstants.Spacing.medium)
        .cardStyle()
    }

    private var iconView: some View {
        Image(systemName: recommendation.type.systemIcon)
            .font(.system(size: UIConstants.IconSize.medium))
            .foregroundStyle(AppColors.accent)
            .frame(width: 44, height: 44)
            .background(AppColors.accent.opacity(UIConstants.Opacity.subtle))
            .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.small))
    }

    private var textStack: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.extraSmall) {
            Text(recommendation.title)
                .font(AppTypography.bodyMedium).foregroundStyle(AppColors.textPrimary)
            Text(recommendation.description)
                .font(AppTypography.caption).foregroundStyle(AppColors.textSecondary).lineLimit(2)
        }
    }

    private var spaceLabel: some View {
        VStack(alignment: .trailing, spacing: UIConstants.Spacing.extraSmall) {
            Text(recommendation.formattedSpaceSaved)
                .font(AppTypography.labelBold).foregroundStyle(AppColors.success)
            Text(recommendation.confidenceLabel)
                .font(AppTypography.badge).foregroundStyle(AppColors.textTertiary)
        }
    }
}
