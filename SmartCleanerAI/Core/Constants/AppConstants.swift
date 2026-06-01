import Foundation

/// Application-wide constants for SmartCleanerAI.
///
/// Contains non-UI constants: app metadata, scan thresholds,
/// persistence configuration, and notification identifiers.
///
/// Usage:
/// ```swift
/// let id = AppConstants.bundleIdentifier
/// let timeout = AppConstants.Scan.defaultTimeoutSeconds
/// ```
public enum AppConstants {

    // MARK: - App Metadata

    /// The app's bundle identifier, resolved at runtime.
    static let bundleIdentifier: String =
        Bundle.main.bundleIdentifier ?? "com.smartcleanerai.app"

    /// Marketing version string (e.g., "1.0.0").
    static let appVersion: String =
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"

    /// Build number string (e.g., "42").
    static let buildNumber: String =
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"

    // MARK: - Scan Configuration

    /// Constants governing storage scanning behavior.
    enum Scan {
        /// Default per-asset processing timeout in seconds.
        static let defaultTimeoutSeconds: Double = 30.0

        /// Maximum concurrent assets processed during a scan.
        static let maxConcurrentAssets: Int = 10

        /// Minimum cosine similarity (0.0–1.0) to classify two photos as similar.
        static let similarityThreshold: Float = 0.92

        /// Blur score threshold (0.0–1.0) above which a photo is flagged as blurry.
        static let blurThreshold: Float = 0.65

        /// Minimum file size (bytes) for a video to appear in Large Videos. (100 MB)
        static let largeVideoThresholdBytes: Int64 = 100 * 1_024 * 1_024
    }

    // MARK: - SwiftData Persistence

    /// Constants for SwiftData store configuration.
    enum Persistence {
        /// Name of the SwiftData model store file.
        static let storeName: String = "SmartCleanerAI"

        /// Time-to-live for cached AI recommendations in seconds. (24 hours)
        static let recommendationCacheTTL: TimeInterval = 86_400
    }

    // MARK: - Notifications

    /// Local notification identifiers.
    enum Notifications {
        static let weeklyReminderID = "com.smartcleanerai.notification.weekly"
        static let scanCompleteID   = "com.smartcleanerai.notification.scanComplete"
    }
}
