import Foundation

/// Orchestrates batch deletion of media assets and contacts.
///
/// Provides atomic batch deletion with analytics tracking and
/// structured logging for each operation type.
///
/// Usage:
/// ```swift
/// let bytesFreed = try await deletionService.deletePhotos(selectedPhotos)
/// ```
public final class DeletionService: ServiceProtocol, Sendable {

    // MARK: - Dependencies

    private let photoRepository: PhotoRepositoryProtocol
    private let videoRepository: VideoRepositoryProtocol
    private let contactRepository: ContactRepositoryProtocol
    private let analytics: AnalyticsService

    // MARK: - Init

    public init(
        photoRepository: PhotoRepositoryProtocol,
        videoRepository: VideoRepositoryProtocol,
        contactRepository: ContactRepositoryProtocol,
        analytics: AnalyticsService = .shared
    ) {
        self.photoRepository = photoRepository
        self.videoRepository = videoRepository
        self.contactRepository = contactRepository
        self.analytics = analytics
    }

    // MARK: - Photo Deletion

    /// Deletes a batch of photos and returns the total space freed in bytes.
    ///
    /// - Parameter photos: Photos to permanently delete.
    /// - Returns: Total bytes freed by the operation.
    @discardableResult
    public func deletePhotos(_ photos: [PhotoEntity]) async throws -> Int64 {
        guard !photos.isEmpty else { return 0 }
        let totalBytes = photos.reduce(0) { $0 + $1.fileSize }
        try await photoRepository.deleteBatch(photos)
        analytics.track(.itemDeleted, count: photos.count)
        AppLogger.data.info("Deleted \(photos.count) photos — \(totalBytes) bytes freed")
        return totalBytes
    }

    // MARK: - Video Deletion

    /// Deletes a batch of videos and returns the total space freed in bytes.
    ///
    /// - Parameter videos: Videos to permanently delete.
    /// - Returns: Total bytes freed by the operation.
    @discardableResult
    public func deleteVideos(_ videos: [VideoEntity]) async throws -> Int64 {
        guard !videos.isEmpty else { return 0 }
        let totalBytes = videos.reduce(0) { $0 + $1.fileSize }
        try await videoRepository.deleteBatch(videos)
        analytics.track(.itemDeleted, count: videos.count)
        AppLogger.data.info("Deleted \(videos.count) videos — \(totalBytes) bytes freed")
        return totalBytes
    }

    // MARK: - Contact Deletion

    /// Deletes a batch of contacts from the address book.
    ///
    /// - Parameter contacts: Contacts to permanently delete.
    public func deleteContacts(_ contacts: [ContactEntity]) async throws {
        for contact in contacts {
            try await contactRepository.delete(contact)
        }
        analytics.track(.itemDeleted, count: contacts.count)
        AppLogger.data.info("Deleted \(contacts.count) contacts")
    }
}
