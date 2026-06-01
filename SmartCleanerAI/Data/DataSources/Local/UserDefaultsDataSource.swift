import Foundation

/// Type-safe UserDefaults wrapper for simple user preferences.
///
/// Provides strongly-typed access to `UserDefaults`, eliminating
/// raw string key usage throughout the codebase.
///
/// Usage:
/// ```swift
/// UserDefaultsDataSource.shared.set(true, forKey: .hasSeenOnboarding)
/// let seen = UserDefaultsDataSource.shared.bool(forKey: .hasSeenOnboarding)
/// ```
public final class UserDefaultsDataSource {

    // MARK: - Shared Instance

    public static let shared = UserDefaultsDataSource()

    private let defaults = UserDefaults.standard
    private init() {}

    // MARK: - Keys

    enum Key: String {
        case hasSeenOnboarding              = "has_seen_onboarding"
        case hasRequestedPhotoPermission    = "has_requested_photo_permission"
        case hasRequestedContactPermission  = "has_requested_contact_permission"
        case isPremiumUser                  = "is_premium_user"
        case lastBackgroundScanDate         = "last_background_scan_date"
        case appOpenCount                   = "app_open_count"
    }

    // MARK: - Bool

    func bool(forKey key: Key) -> Bool { defaults.bool(forKey: key.rawValue) }
    func set(_ value: Bool, forKey key: Key) { defaults.set(value, forKey: key.rawValue) }

    // MARK: - Date

    func date(forKey key: Key) -> Date? { defaults.object(forKey: key.rawValue) as? Date }
    func set(_ value: Date, forKey key: Key) { defaults.set(value, forKey: key.rawValue) }

    // MARK: - Integer

    func integer(forKey key: Key) -> Int { defaults.integer(forKey: key.rawValue) }

    /// Atomically increments an integer value by 1.
    func increment(forKey key: Key) {
        defaults.set(integer(forKey: key) + 1, forKey: key.rawValue)
    }
}
