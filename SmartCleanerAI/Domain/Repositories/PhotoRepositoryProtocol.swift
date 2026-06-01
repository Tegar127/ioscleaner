import Foundation

/// Contract for photo data access in SmartCleanerAI.
///
/// Implemented by `PhotoRepository` in the Data layer (PhotoKit).
/// Consumed by use cases in the Domain layer.
///
/// Usage:
/// ```swift
/// let photos = try await photoRepository.fetchAll()
/// try await photoRepository.deleteBatch(selectedPhotos)
/// ```
public protocol PhotoRepositoryProtocol: Sendable {

    /// Fetches all photo assets from the device library.
    ///
    /// - Returns: An array of `PhotoEntity` values sorted by creation date descending.
    /// - Throws: `StorageError.permissionDenied` if authorization is denied.
    func fetchAll() async throws -> [PhotoEntity]

    /// Fetches photos eligible for duplicate analysis (excludes favorites).
    ///
    /// - Returns: An array of non-favorited `PhotoEntity` values.
    func fetchDuplicateCandidates() async throws -> [PhotoEntity]

    /// Fetches photos classified as screenshots via PhotoKit metadata.
    ///
    /// - Returns: An array of screenshot `PhotoEntity` values.
    func fetchScreenshots() async throws -> [PhotoEntity]

    /// Permanently deletes a single photo asset from the library.
    ///
    /// - Parameter photo: The photo to delete.
    /// - Throws: `StorageError.deletionFailed` if the operation fails.
    func delete(_ photo: PhotoEntity) async throws

    /// Permanently deletes multiple photo assets in a single batch operation.
    ///
    /// - Parameter photos: The photos to delete.
    /// - Throws: `StorageError.deletionFailed` on partial or full failure.
    func deleteBatch(_ photos: [PhotoEntity]) async throws
}
