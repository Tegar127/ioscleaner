import SwiftUI

/// Displays the complete cleanup history timeline grouped by month.
struct ScanHistoryView: View {

    @State var viewModel: ScanHistoryViewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    loadingView
                } else if viewModel.groupedHistory.isEmpty {
                    EmptyStateView(
                        icon: "clock.arrow.circlepath",
                        title: "history.empty.title".localized,
                        message: "history.empty.message".localized
                    )
                } else {
                    historyList
                }
            }
            .screenBackground()
            .navigationTitle("tab.history".localized)
            .toolbar { clearToolbarItem }
        }
        .task { viewModel.loadHistory() }
    }

    // MARK: - History List

    private var historyList: some View {
        List {
            ForEach(viewModel.sortedMonthKeys, id: \.self) { key in
                Section(header: monthHeader(key)) {
                    ForEach(viewModel.groupedHistory[key] ?? []) { entry in
                        ScanHistoryRowView(entry: entry)
                            .listRowBackground(AppColors.card)
                            .listRowSeparatorTint(AppColors.divider)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }

    // MARK: - Loading View

    private var loadingView: some View {
        VStack(spacing: UIConstants.Spacing.medium) {
            ForEach(0..<4, id: \.self) { _ in
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.card)
                    .fill(AppColors.card)
                    .frame(height: 70)
                    .shimmer(isActive: true)
            }
        }
        .padding(UIConstants.Spacing.medium)
    }

    // MARK: - Helper Views

    private func monthHeader(_ key: String) -> some View {
        Text(key)
            .font(AppTypography.labelBold)
            .foregroundStyle(AppColors.textSecondary)
            .padding(.vertical, UIConstants.Spacing.extraSmall)
    }

    private var clearToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(role: .destructive) { viewModel.clearAllHistory() } label: {
                Text("action.clearAll".localized)
                    .font(AppTypography.bodySmall)
                    .foregroundStyle(AppColors.error)
            }
        }
    }
}

// MARK: - Scan History Row

private struct ScanHistoryRowView: View {
    let entry: ScanHistoryEntity

    var body: some View {
        HStack(spacing: UIConstants.Spacing.medium) {
            scanIcon
            VStack(alignment: .leading, spacing: UIConstants.Spacing.extraSmall) {
                Text(entry.formattedDate)
                    .font(AppTypography.bodyMedium)
                    .foregroundStyle(AppColors.textPrimary)
                Text("\(entry.itemsDeleted) items removed")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
            Spacer()
            Text(entry.formattedSpaceSaved)
                .font(AppTypography.labelBold)
                .foregroundStyle(AppColors.success)
        }
        .padding(.vertical, UIConstants.Spacing.small)
    }

    private var scanIcon: some View {
        Image(systemName: "checkmark.seal.fill")
            .font(.system(size: UIConstants.IconSize.medium))
            .foregroundStyle(AppColors.success)
            .frame(width: 36, height: 36)
            .background(AppColors.success.opacity(UIConstants.Opacity.subtle))
            .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.small))
    }
}
