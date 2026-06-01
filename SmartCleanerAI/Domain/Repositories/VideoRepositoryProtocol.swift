import Foundation

/// Contract for video data access in SmartCleanerAI.
///
/// Implemented by `VideoRepository` in the Data layer (PhotoKit + AVFoundation).
/// Consumed by use cases in the Domain layer.
///
/// Usage:
/// ```swift
/// let large = try await videoRepository.fetchLarge(threshold: AppConstants.Scan.largeVideoThresholdBytes)
/// try await videoRepository.deleteBatch(selectedVideos)
/// ```
public protocol VideoRepositoryProtocol: Sendable {

    /// Fetches all video assets from the device library.
    ///
    /// - Returns: An array of `VideoEntity` values.
    /// - Throws: `StorageError.permissionDenied` if authorization is denied.
    func fetchAll() async throws -> [VideoEntity]

    /// Fetches videos exceeding a given file size threshold.
    ///
    /// - Parameter threshold: Minimum byte size. Default: `AppConstants.Scan.largeVideoThresholdBytes`.
    /// - Returns: An array of `VideoEntity` sorted by file size descending.
    func fetchLarge(threshold: Int64) async throws -> [VideoEntity]

    /// Permanently deletes a single video asset from the library.
    ///
    /// - Parameter video: The video to delete.
    /// - Throws: `StorageError.deletionFailed` if the operation fails.
    func delete(_ video: VideoEntity) async throws

    /// Permanently deletes multiple video assets in a single batch operation.
    ///
    /// - Parameter videos: The videos to delete.
    func deleteBatch(_ videos: [VideoEntity]) async throws
}
