import Foundation

// MARK: - Use Case Protocol

/// Orchestrates a full device storage analysis scan.
///
/// Concurrently fetches photos, videos, and contacts, then aggregates
/// the results into a `StorageAnalysisResult`.
///
/// Usage:
/// ```swift
/// let result = try await analyzeStorageUseCase.execute()
/// print("Photos: \(result.photoCount), Videos: \(result.videoCount)")
/// ```
public protocol AnalyzeStorageUseCaseProtocol: Sendable {
    func execute() async throws -> StorageAnalysisResult
}

// MARK: - Implementation

public final class AnalyzeStorageUseCase: AnalyzeStorageUseCaseProtocol {

    // MARK: - Dependencies

    private let photoRepository: PhotoRepositoryProtocol
    private let videoRepository: VideoRepositoryProtocol
    private let contactRepository: ContactRepositoryProtocol

    // MARK: - Init

    public init(
        photoRepository: PhotoRepositoryProtocol,
        videoRepository: VideoRepositoryProtocol,
        contactRepository: ContactRepositoryProtocol
    ) {
        self.photoRepository = photoRepository
        self.videoRepository = videoRepository
        self.contactRepository = contactRepository
    }

    // MARK: - Execute

    public func execute() async throws -> StorageAnalysisResult {
        AppLogger.domain.info("Starting storage analysis")

        async let photos   = photoRepository.fetchAll()
        async let videos   = videoRepository.fetchAll()
        async let contacts = contactRepository.fetchAll()

        let (allPhotos, allVideos, allContacts) = try await (photos, videos, contacts)

        let totalPhotoSize = allPhotos.reduce(Int64(0))  { $0 + $1.fileSize }
        let totalVideoSize = allVideos.reduce(Int64(0))  { $0 + $1.fileSize }

        AppLogger.domain.info("Analysis done: \(allPhotos.count) photos, \(allVideos.count) videos, \(allContacts.count) contacts")

        return StorageAnalysisResult(
            photoCount: allPhotos.count,
            videoCount: allVideos.count,
            contactCount: allContacts.count,
            totalPhotoSizeBytes: totalPhotoSize,
            totalVideoSizeBytes: totalVideoSize,
            analysisDate: .now
        )
    }
}

// MARK: - Result Model

/// The aggregated result of a full storage analysis scan.
public struct StorageAnalysisResult: Sendable {
    public let photoCount: Int
    public let videoCount: Int
    public let contactCount: Int
    public let totalPhotoSizeBytes: Int64
    public let totalVideoSizeBytes: Int64
    public let analysisDate: Date

    public var totalMediaSizeBytes: Int64 { totalPhotoSizeBytes + totalVideoSizeBytes }
}
