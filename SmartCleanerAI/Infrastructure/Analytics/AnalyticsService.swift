import Foundation

/// Privacy-first local analytics service for SmartCleanerAI.
///
/// Tracks app usage events using local integer counters only — no data
/// is ever transmitted to any server. Complies with Apple App Privacy guidelines.
///
/// Usage:
/// ```swift
/// AnalyticsService.shared.track(.scanStarted)
/// AnalyticsService.shared.track(.itemDeleted, count: 5)
/// let opens = AnalyticsService.shared.count(for: .appOpened)
/// ```
public final class AnalyticsService: Sendable {

    // MARK: - Shared Instance

    public static let shared = AnalyticsService()
    private init() {}

    // MARK: - Event Types

    public enum Event: String {
        case appOpened             = "app_opened"
        case scanStarted           = "scan_started"
        case scanCompleted         = "scan_completed"
        case itemDeleted           = "item_deleted"
        case featureViewed         = "feature_viewed"
        case premiumUpgradeTapped  = "premium_upgrade_tapped"
        case permissionGranted     = "permission_granted"
        case permissionDenied      = "permission_denied"
    }

    // MARK: - Tracking

    /// Records an analytics event by incrementing a local counter.
    ///
    /// - Parameters:
    ///   - event: The event type to track.
    ///   - count: Optional quantity for batch events. Default: 1.
    public func track(_ event: Event, count: Int = 1) {
        let key = "analytics_\(event.rawValue)"
        let current = UserDefaults.standard.integer(forKey: key)
        UserDefaults.standard.set(current + count, forKey: key)
        AppLogger.infrastructure.debug("Analytics: \(event.rawValue) ×\(count)")
    }

    // MARK: - Querying

    /// Returns the total recorded count for an event.
    ///
    /// - Parameter event: The event type to query.
    /// - Returns: The cumulative count since first install.
    public func count(for event: Event) -> Int {
        UserDefaults.standard.integer(forKey: "analytics_\(event.rawValue)")
    }
}
