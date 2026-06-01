import Foundation

/// Represents a completed scan/cleanup session in the SmartCleanerAI domain.
///
/// Stored via SwiftData (`ScanHistoryModel`) for historical tracking
/// and monetization insights ("You've freed 14.8 GB this month!").
///
/// Usage:
/// ```swift
/// let entry = ScanHistoryEntity(
///     spaceSavedBytes: 4_200_000_000,
///     itemsDeleted: 312,
///     scanDurationSeconds: 18.4
/// )
/// ```
public struct ScanHistoryEntity: Identifiable, Hashable, Sendable {

    public let id: UUID
    public let scanDate: Date
    public let spaceSavedBytes: Int64
    public let itemsDeleted: Int
    public let scanDurationSeconds: Double
    public let breakdown: ScanBreakdown

    // MARK: - Init

    public init(
        id: UUID = UUID(),
        scanDate: Date = .now,
        spaceSavedBytes: Int64,
        itemsDeleted: Int,
        scanDurationSeconds: Double,
        breakdown: ScanBreakdown = ScanBreakdown()
    ) {
        self.id = id
        self.scanDate = scanDate
        self.spaceSavedBytes = spaceSavedBytes
        self.itemsDeleted = itemsDeleted
        self.scanDurationSeconds = scanDurationSeconds
        self.breakdown = breakdown
    }

    // MARK: - Computed

    /// Human-readable space saved label (e.g., "4.2 GB").
    var formattedSpaceSaved: String {
        AppFormatter.byteCount.string(fromByteCount: spaceSavedBytes)
    }

    /// Formatted scan date label (e.g., "May 1, 2025").
    var formattedDate: String { scanDate.shortDateLabel }

    /// Month-year grouping label for the timeline UI (e.g., "May 2025").
    var monthYearKey: String { scanDate.monthYearLabel }
}

// MARK: - ScanBreakdown

/// Per-category item counts for a completed scan session.
public struct ScanBreakdown: Hashable, Codable, Sendable {
    public var duplicatePhotosDeleted: Int  = 0
    public var blurryPhotosDeleted: Int     = 0
    public var screenshotsDeleted: Int      = 0
    public var largeVideosDeleted: Int      = 0
    public var duplicateContactsMerged: Int = 0
    public init() {}
}
