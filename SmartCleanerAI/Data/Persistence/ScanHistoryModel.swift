import SwiftData
import Foundation

/// SwiftData persistent model for scan history records.
///
/// Maps bidirectionally with `ScanHistoryEntity` in the Domain layer.
/// Each instance represents one completed cleanup session.
@Model
public final class ScanHistoryModel {

    // MARK: - Stored Properties

    @Attribute(.unique) public var id: UUID
    public var scanDate: Date
    public var spaceSavedBytes: Int64
    public var itemsDeleted: Int
    public var scanDurationSeconds: Double

    // Breakdown stored as individual fields for SwiftData query efficiency
    public var duplicatePhotosDeleted: Int
    public var blurryPhotosDeleted: Int
    public var screenshotsDeleted: Int
    public var largeVideosDeleted: Int
    public var duplicateContactsMerged: Int

    // MARK: - Init

    public init(from entity: ScanHistoryEntity) {
        self.id                       = entity.id
        self.scanDate                 = entity.scanDate
        self.spaceSavedBytes          = entity.spaceSavedBytes
        self.itemsDeleted             = entity.itemsDeleted
        self.scanDurationSeconds      = entity.scanDurationSeconds
        self.duplicatePhotosDeleted   = entity.breakdown.duplicatePhotosDeleted
        self.blurryPhotosDeleted      = entity.breakdown.blurryPhotosDeleted
        self.screenshotsDeleted       = entity.breakdown.screenshotsDeleted
        self.largeVideosDeleted       = entity.breakdown.largeVideosDeleted
        self.duplicateContactsMerged  = entity.breakdown.duplicateContactsMerged
    }

    // MARK: - Domain Mapping

    /// Converts this persistent model back to a domain `ScanHistoryEntity`.
    func toDomainEntity() -> ScanHistoryEntity {
        var breakdown = ScanBreakdown()
        breakdown.duplicatePhotosDeleted  = duplicatePhotosDeleted
        breakdown.blurryPhotosDeleted     = blurryPhotosDeleted
        breakdown.screenshotsDeleted      = screenshotsDeleted
        breakdown.largeVideosDeleted      = largeVideosDeleted
        breakdown.duplicateContactsMerged = duplicateContactsMerged

        return ScanHistoryEntity(
            id: id,
            scanDate: scanDate,
            spaceSavedBytes: spaceSavedBytes,
            itemsDeleted: itemsDeleted,
            scanDurationSeconds: scanDurationSeconds,
            breakdown: breakdown
        )
    }
}
