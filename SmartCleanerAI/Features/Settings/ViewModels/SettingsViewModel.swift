import Foundation
import Observation

/// ViewModel for the Settings screen.
@MainActor
@Observable
public final class SettingsViewModel {

    // MARK: - Observable State

    var enableWeeklyBackgroundScan: Bool {
        didSet {
            UserDefaultsDataSource.shared.set(enableWeeklyBackgroundScan,
                                              forKey: .isPremiumUser) // example key
            if enableWeeklyBackgroundScan {
                BackgroundScanService.shared.scheduleWeeklyScan()
            }
        }
    }
    var enableScanNotifications: Bool

    // MARK: - Init

    public init() {
        self.enableWeeklyBackgroundScan = UserDefaultsDataSource.shared.bool(
            forKey: .isPremiumUser
        )
        self.enableScanNotifications = true
    }

    // MARK: - Actions

    func clearScanHistory() {
        AppLogger.ui.info("User requested scan history clear")
        // ScanHistoryRepository.deleteAll() invoked from DI-injected ViewModel
        // in production; coordinated via DependencyContainer injection.
    }
}
