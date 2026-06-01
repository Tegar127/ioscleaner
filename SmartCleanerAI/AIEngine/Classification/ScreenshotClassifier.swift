import Foundation

/// Classifies photos as screenshots using PhotoKit metadata.
///
/// Uses `PHAsset.mediaSubtypes.contains(.photoScreenshot)` for instant,
/// battery-efficient classification — no ML model required.
public final class ScreenshotClassifier: Sendable {

    public init() {}

    // MARK: - Classification

    /// Filters a list of photos and returns only screenshots.
    ///
    /// - Parameter photos: All photos from the library.
    /// - Returns: Photos identified as screenshots by PhotoKit metadata.
    public func classifyScreenshots(from photos: [PhotoEntity]) -> [PhotoEntity] {
        photos.filter { $0.isScreenshot }
    }

    /// Calculates the total byte size of a collection of screenshots.
    ///
    /// - Parameter screenshots: The screenshot photos to size.
    /// - Returns: Total byte count.
    public func totalSize(of screenshots: [PhotoEntity]) -> Int64 {
        screenshots.reduce(0) { $0 + $1.fileSize }
    }

    /// Groups screenshots by creation month for display in timeline views.
    ///
    /// - Parameter screenshots: The screenshots to group.
    /// - Returns: A dictionary keyed by "MMMM yyyy" strings.
    public func groupByMonth(_ screenshots: [PhotoEntity]) -> [String: [PhotoEntity]] {
        Dictionary(grouping: screenshots) { photo in
            photo.creationDate?.monthYearLabel ?? "Unknown"
        }
    }
}
