import BackgroundTasks
import Foundation

/// Manages background scan scheduling and execution via `BGTaskScheduler`.
///
/// Registers and handles background app refresh tasks for weekly storage scans.
/// Schedule is renewed automatically each time the handler fires.
///
/// Setup: Call `registerTasks()` in `SmartCleanerAIApp.init()` before `.body`.
///
/// Usage:
/// ```swift
/// BackgroundScanService.shared.registerTasks()
/// BackgroundScanService.shared.scheduleWeeklyScan()
/// ```
public final class BackgroundScanService: ServiceProtocol {

    // MARK: - Shared Instance

    public static let shared = BackgroundScanService()
    private var scanUseCase: AnalyzeStorageUseCaseProtocol?

    private init() {}

    // MARK: - Setup

    /// Registers all background task handlers.
    /// Must be called before the app finishes launching (in `App.init()`).
    public func registerTasks() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: BackgroundTaskIdentifiers.weeklyScan,
            using: nil
        ) { task in
            self.handleWeeklyScan(task: task as! BGAppRefreshTask)
        }
        AppLogger.infrastructure.info("Background tasks registered")
    }

    /// Injects the storage analysis use case required for background scanning.
    public func configure(with scanUseCase: AnalyzeStorageUseCaseProtocol) {
        self.scanUseCase = scanUseCase
    }

    // MARK: - Scheduling

    /// Schedules the next weekly background scan for 7 days from now.
    public func scheduleWeeklyScan() {
        let request = BGAppRefreshTaskRequest(
            identifier: BackgroundTaskIdentifiers.weeklyScan
        )
        let oneWeekSeconds: TimeInterval = 7 * 24 * 60 * 60
        request.earliestBeginDate = Date(timeIntervalSinceNow: oneWeekSeconds)
        do {
            try BGTaskScheduler.shared.submit(request)
            AppLogger.infrastructure.info("Weekly background scan scheduled")
        } catch {
            AppLogger.infrastructure.error("Failed to schedule: \(error)")
        }
    }

    // MARK: - Task Handling

    private func handleWeeklyScan(task: BGAppRefreshTask) {
        scheduleWeeklyScan()

        let scanTask = Task {
            do {
                let _ = try await scanUseCase?.execute()
                task.setTaskCompleted(success: true)
                AppLogger.infrastructure.info("Background scan completed successfully")
            } catch {
                task.setTaskCompleted(success: false)
                AppLogger.infrastructure.error("Background scan failed: \(error)")
            }
        }

        task.expirationHandler = {
            scanTask.cancel()
            AppLogger.infrastructure.warning("Background scan task expired")
        }
    }
}
