import SwiftUI

/// SmartCleanerAI application entry point.
///
/// Initializes `DependencyContainer`, `AppCoordinator`, and
/// `PremiumStatusManager`. Registers background tasks before first render.
@main
struct SmartCleanerAIApp: App {

    // MARK: - App State

    @State private var coordinator: AppCoordinator

    // MARK: - Init

    init() {
        do {
            let container = try DependencyContainer()
            _coordinator  = State(initialValue: AppCoordinator(container: container))
            BackgroundScanService.shared.registerTasks()
        } catch {
            fatalError("DependencyContainer initialization failed: \(error)")
        }
    }

    // MARK: - Scene

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(coordinator)
                .task {
                    await PremiumStatusManager.shared.refreshStatus()
                    PremiumStatusManager.shared.startObservingTransactions()
                    AnalyticsService.shared.track(.appOpened)
                }
        }
    }
}

// MARK: - Root Tab View

/// Root tab bar connecting all features to the coordinator.
struct RootTabView: View {

    @Environment(AppCoordinator.self) private var coordinator

    var body: some View {
        @Bindable var coordinator = coordinator

        TabView(selection: $coordinator.selectedTab) {
            DashboardView(
                viewModel: coordinator.container.makeDashboardViewModel(),
                coordinator: coordinator
            )
            .tabItem { Label(AppTab.dashboard.title, systemImage: AppTab.dashboard.systemImage) }
            .tag(AppTab.dashboard)

            CleanerMenuView(coordinator: coordinator)
                .tabItem { Label(AppTab.cleaner.title, systemImage: AppTab.cleaner.systemImage) }
                .tag(AppTab.cleaner)

            AIRecommendationsView(viewModel: coordinator.container.makeAIRecommendationsViewModel())
                .tabItem { Label(AppTab.aiRecommendations.title, systemImage: AppTab.aiRecommendations.systemImage) }
                .tag(AppTab.aiRecommendations)

            ScanHistoryView(viewModel: coordinator.container.makeScanHistoryViewModel())
                .tabItem { Label(AppTab.history.title, systemImage: AppTab.history.systemImage) }
                .tag(AppTab.history)

            SettingsView(viewModel: SettingsViewModel())
                .tabItem { Label(AppTab.settings.title, systemImage: AppTab.settings.systemImage) }
                .tag(AppTab.settings)
        }
        .tint(AppColors.accent)
        .sheet(item: $coordinator.presentedModal) { modal in
            switch modal {
            case .premium:
                PremiumPaywallView(viewModel: coordinator.container.makePremiumViewModel())
            default:
                EmptyView()
            }
        }
    }
}
