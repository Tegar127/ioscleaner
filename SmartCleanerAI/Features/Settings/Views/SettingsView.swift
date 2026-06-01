import SwiftUI

/// App Settings screen.
struct SettingsView: View {

    @State var viewModel: SettingsViewModel
    @State private var showClearHistoryConfirmation = false

    var body: some View {
        NavigationStack {
            List {
                preferencesSection
                storageSection
                aboutSection
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .screenBackground()
            .navigationTitle("tab.settings".localized)
            .confirmationDialog(
                "settings.clearHistory.confirm.title".localized,
                isPresented: $showClearHistoryConfirmation,
                titleVisibility: .visible
            ) {
                Button("action.clearAll".localized, role: .destructive) {
                    viewModel.clearScanHistory()
                }
            }
        }
    }

    // MARK: - Sections

    private var preferencesSection: some View {
        Section("settings.section.preferences".localized) {
            Toggle("settings.weeklyBackgroundScan".localized, isOn: $viewModel.enableWeeklyBackgroundScan)
                .tint(AppColors.accent)
            Toggle("settings.scanNotifications".localized, isOn: $viewModel.enableScanNotifications)
                .tint(AppColors.accent)
        }
        .listRowBackground(AppColors.card)
    }

    private var storageSection: some View {
        Section("settings.section.storage".localized) {
            Button(role: .destructive) { showClearHistoryConfirmation = true } label: {
                HStack {
                    Image(systemName: "trash").foregroundStyle(AppColors.error)
                    Text("settings.clearHistory".localized).foregroundStyle(AppColors.error)
                }
            }
        }
        .listRowBackground(AppColors.card)
    }

    private var aboutSection: some View {
        Section("settings.section.about".localized) {
            Link(destination: URL(string: APIConstants.privacyPolicyURL)!) {
                Label("settings.privacyPolicy".localized, systemImage: "hand.raised")
                    .foregroundStyle(AppColors.textPrimary)
            }
            Link(destination: URL(string: APIConstants.termsOfServiceURL)!) {
                Label("settings.termsOfService".localized, systemImage: "doc.text")
                    .foregroundStyle(AppColors.textPrimary)
            }
            HStack {
                Text("settings.version".localized)
                    .foregroundStyle(AppColors.textSecondary)
                Spacer()
                Text("\(AppConstants.appVersion) (\(AppConstants.buildNumber))")
                    .foregroundStyle(AppColors.textTertiary)
            }
        }
        .listRowBackground(AppColors.card)
    }
}
