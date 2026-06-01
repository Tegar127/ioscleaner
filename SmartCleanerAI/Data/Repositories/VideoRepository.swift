import Foundation
import Photos

/// PhotoKit-backed implementation of `VideoRepositoryProtocol`.
public final class VideoRepository: VideoRepositoryProtocol {

    // MARK: - Dependencies

    private let dataSource: PhotoKitDataSource

    // MARK: - Init

    public init(dataSource: PhotoKitDataSource = PhotoKitDataSource()) {
        self.dataSource = dataSource
    }

    // MARK: - VideoRepositoryProtocol

    public func fetchAll() async throws -> [VideoEntity] {
        guard PHPhotoLibrary.authorizationStatus(for: .readWrite) != .denied else {
            throw StorageError.permissionDenied
        }
        AppLogger.data.info("Fetching all videos from PhotoKit")
        return try await dataSource.fetchAllVideos()
    }

    public func fetchLarge(
        threshold: Int64 = AppConstants.Scan.largeVideoThresholdBytes
    ) async throws -> [VideoEntity] {
        let all = try await fetchAll()
        return all
            .filter { $0.fileSize >= threshold }
            .sorted { $0.fileSize > $1.fileSize }
    }

    public func delete(_ video: VideoEntity) async throws {
        AppLogger.data.info("Deleting video: \(video.localIdentifier)")
        try await dataSource.deleteAssets(withIdentifiers: [video.localIdentifier])
    }

    public func deleteBatch(_ videos: [VideoEntity]) async throws {
        guard !videos.isEmpty else { return }
        AppLogger.data.info("Batch deleting \(videos.count) videos")
        try await dataSource.deleteAssets(withIdentifiers: videos.map { $0.localIdentifier })
    }
}
