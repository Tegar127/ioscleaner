import Foundation

/// Centralized background task identifier constants for `BGTaskScheduler`.
///
/// - Important: These identifiers must also be registered in `Info.plist`
///   under `BGTaskSchedulerPermittedIdentifiers`.
public enum BackgroundTaskIdentifiers {
    /// Weekly lightweight storage scan (free tier).
    static let weeklyScan     = "com.smartcleanerai.task.weeklyscan"
    /// Monthly deep scan (Premium only).
    static let monthlyScan    = "com.smartcleanerai.task.monthlyscan"
    /// Storage reminder notification task.
    static let storageReminder = "com.smartcleanerai.task.storagereminder"
}
