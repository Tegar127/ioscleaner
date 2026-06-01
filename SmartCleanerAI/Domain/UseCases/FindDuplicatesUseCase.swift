import Foundation

// MARK: - DuplicatePhotoGroup Model

/// A group of photos identified as duplicates or near-duplicates.
public struct DuplicatePhotoGroup: Identifiable, Sendable {
    public let id: UUID
    public let photos: [PhotoEntity]
    public let totalSizeBytes: Int64
    /// Index within `photos` of the recommended photo to keep.
    public let recommendedKeepIndex: Int

    public init(id: UUID = UUID(), photos: [PhotoEntity], recommendedKeepIndex: Int = 0) {
        self.id = id
        self.photos = photos
        self.totalSizeBytes = photos.reduce(0) { $0 + $1.fileSize }
        self.recommendedKeepIndex = recommendedKeepIndex
    }

    /// Number of photos to delete (total minus the one to keep).
    public var duplicateCount: Int { max(0, photos.count - 1) }

    /// Total reclaimable bytes if all duplicates are deleted.
    public var reclaimableBytes: Int64 {
        photos.enumerated()
            .filter { $0.offset != recommendedKeepIndex }
            .reduce(0) { $0 + $1.element.fileSize }
    }

    public var formattedReclaimable: String {
        AppFormatter.byteCount.string(fromByteCount: reclaimableBytes)
    }
}

// MARK: - Use Case Protocol

/// Finds groups of duplicate photos using the AI similarity engine.
///
/// Usage:
/// ```swift
/// let groups = try await findDuplicatesUseCase.execute()
/// ```
public protocol FindDuplicatesUseCaseProtocol: Sendable {
    func execute() async throws -> [DuplicatePhotoGroup]
}

// MARK: - Implementation

public final class FindDuplicatesUseCase: FindDuplicatesUseCaseProtocol {

    private let photoRepository: PhotoRepositoryProtocol
    private let similarityEngine: PhotoSimilarityEngineProtocol

    public init(
        photoRepository: PhotoRepositoryProtocol,
        similarityEngine: PhotoSimilarityEngineProtocol
    ) {
        self.photoRepository = photoRepository
        self.similarityEngine = similarityEngine
    }

    public func execute() async throws -> [DuplicatePhotoGroup] {
        AppLogger.domain.info("Finding duplicate photos")
        let candidates = try await photoRepository.fetchDuplicateCandidates()
        let groups = try await similarityEngine.findDuplicates(among: candidates)
        AppLogger.domain.info("Found \(groups.count) duplicate groups")
        return groups
    }
}
