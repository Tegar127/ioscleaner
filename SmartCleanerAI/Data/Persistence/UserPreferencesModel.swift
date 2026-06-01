import SwiftData
import Foundation

/// SwiftData persistent model for user preferences and app settings.
///
/// Designed as a singleton record (one instance in the store).
/// Stores scan schedule, notifications, and aggregate usage stats.
@Model
public final class UserPreferencesModel {

    @Attribute(.unique) public var id: UUID
    public var enableWeeklyBackgroundScan: Bool
    public var enableScanNotifications: Bool
    public var totalScansCompleted: Int
    public var lastAppReviewPromptDate: Date?
    public var preferredLanguageCode: String

    // MARK: - Init

    public init() {
        self.id                       = UUID()
        self.enableWeeklyBackgroundScan = false
        self.enableScanNotifications  = true
        self.totalScansCompleted      = 0
        self.lastAppReviewPromptDate  = nil
        self.preferredLanguageCode    =
            Locale.current.language.languageCode?.identifier ?? "en"
    }
}
