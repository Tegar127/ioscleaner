import SwiftUI
import StoreKit

/// Full-screen premium paywall with subscription plans and feature grid.
struct PremiumPaywallView: View {

    @State var viewModel: PremiumViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: UIConstants.Spacing.extraLarge) {
                    heroSection
                    featuresGrid
                    plansSection
                    footerLinks
                }
                .padding(.horizontal, UIConstants.Spacing.medium)
                .padding(.bottom, UIConstants.Spacing.section)
            }
            .screenBackground()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { dismissToolbarItem }
        }
    }

    // MARK: - Hero

    private var heroSection: some View {
        VStack(spacing: UIConstants.Spacing.medium) {
            ZStack {
                Circle()
                    .fill(AppColors.accentGradient)
                    .frame(width: 80, height: 80)
                Image(systemName: "crown.fill")
                    .font(.system(size: UIConstants.IconSize.large))
                    .foregroundStyle(.white)
            }
            Text("premium.hero.title".localized)
                .font(AppTypography.largeTitle)
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)
            Text("premium.hero.subtitle".localized)
                .font(AppTypography.bodySmall)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, UIConstants.Spacing.large)
    }

    // MARK: - Features Grid

    private let premiumFeatures: [(icon: String, title: String)] = [
        ("brain",                        "premium.feature.aiAnalysis"),
        ("photo.on.rectangle.angled",    "premium.feature.deepDuplicateScan"),
        ("camera.filters",               "premium.feature.blurDetection"),
        ("arrow.clockwise",              "premium.feature.autoScan"),
        ("chart.bar.xaxis",              "premium.feature.detailedStats"),
        ("icloud.and.arrow.down",        "premium.feature.cloudExport")
    ]

    private var featuresGrid: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: UIConstants.Spacing.medium
        ) {
            ForEach(premiumFeatures, id: \.title) { feature in
                HStack(spacing: UIConstants.Spacing.small) {
                    Image(systemName: feature.icon)
                        .font(.system(size: UIConstants.IconSize.small))
                        .foregroundStyle(AppColors.accentSecondary)
                    Text(feature.title.localized)
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textPrimary)
                }
                .padding(UIConstants.Spacing.small)
                .frame(maxWidth: .infinity, alignment: .leading)
                .cardStyle()
            }
        }
    }

    // MARK: - Plans

    private var plansSection: some View {
        VStack(spacing: UIConstants.Spacing.medium) {
            if viewModel.isLoadingProducts {
                ProgressView().tint(AppColors.accent)
            } else {
                ForEach(viewModel.products, id: \.id) { product in
                    PlanCard(product: product, isSelected: viewModel.selectedProductID == product.id) {
                        viewModel.selectedProductID = product.id
                    }
                }
            }
            if let error = viewModel.errorMessage {
                Text(error).font(AppTypography.caption).foregroundStyle(AppColors.error)
            }
            PrimaryButton(
                title: "premium.cta.subscribe".localized,
                isLoading: viewModel.isPurchasing
            ) { viewModel.purchaseSelected() }
            Button("premium.action.restore".localized) { viewModel.restorePurchases() }
                .font(AppTypography.caption).foregroundStyle(AppColors.textSecondary)
        }
    }

    // MARK: - Footer

    private var footerLinks: some View {
        HStack(spacing: UIConstants.Spacing.medium) {
            Link("premium.privacy".localized, destination: URL(string: APIConstants.privacyPolicyURL)!)
            Text("•").foregroundStyle(AppColors.textTertiary)
            Link("premium.terms".localized, destination: URL(string: APIConstants.termsOfServiceURL)!)
        }
        .font(AppTypography.caption)
        .foregroundStyle(AppColors.textSecondary)
    }

    private var dismissToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button { dismiss() } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
    }
}

// MARK: - Plan Card

private struct PlanCard: View {
    let product: Product
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack {
                VStack(alignment: .leading, spacing: UIConstants.Spacing.extraSmall) {
                    Text(product.displayName)
                        .font(AppTypography.bodyMedium).foregroundStyle(AppColors.textPrimary)
                    Text(product.localizedPriceString)
                        .font(AppTypography.caption).foregroundStyle(AppColors.textSecondary)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(AppColors.accent)
                }
            }
            .padding(UIConstants.Spacing.medium)
            .cardStyle()
            .if(isSelected) { $0.accentBorder() }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Product Extension

private extension Product {
    var localizedPriceString: String {
        priceFormatStyle.locale(.current).format(price)
    }
}
