import OSLog

/// Centralized structured logging for SmartCleanerAI using Apple's unified logging system.
///
/// Provides categorized loggers per subsystem layer, enabling efficient
/// filtering in Console.app and crash reports.
///
/// Usage:
/// ```swift
/// AppLogger.ui.info("Dashboard loaded successfully")
/// AppLogger.ai.error("Feature extraction failed: \(error.localizedDescription)")
/// ```
public enum AppLogger {

    // MARK: - Subsystem

    private static let subsystem: String = {
        Bundle.main.bundleIdentifier ?? "com.smartcleanerai.app"
    }()

    // MARK: - Category Loggers

    /// Logs UI and SwiftUI view lifecycle events.
    static let ui = Logger(subsystem: subsystem, category: "UI")

    /// Logs domain use case and business logic events.
    static let domain = Logger(subsystem: subsystem, category: "Domain")

    /// Logs data layer, repository, and persistence events.
    static let data = Logger(subsystem: subsystem, category: "Data")

    /// Logs AI engine operations: blur detection, similarity, recommendations.
    static let ai = Logger(subsystem: subsystem, category: "AIEngine")

    /// Logs infrastructure events: StoreKit, background tasks, analytics.
    static let infrastructure = Logger(subsystem: subsystem, category: "Infrastructure")

    /// Logs permission request and authorization status changes.
    static let permissions = Logger(subsystem: subsystem, category: "Permissions")
}
