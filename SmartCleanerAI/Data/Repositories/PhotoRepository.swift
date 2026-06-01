import Foundation
import Photos

/// PhotoKit-backed implementation of `PhotoRepositoryProtocol`.
///
/// Fetches and deletes photos using PhotoKit, mapping between
/// `PHAsset` and `PhotoEntity` domain objects via `PhotoKitDataSource`.
public final class PhotoRepository: PhotoRepositoryProtocol {

    // MARK: - Dependencies

    private let dataSource: PhotoKitDataSource

    // MARK: - Init

    public init(dataSource: PhotoKitDataSource = PhotoKitDataSource()) {
        self.dataSource = dataSource
    }

    // MARK: - PhotoRepositoryProtocol

    public func fetchAll() async throws -> [PhotoEntity] {
        guard PHPhotoLibrary.authorizationStatus(for: .readWrite) != .denied else {
            throw StorageError.permissionDenied
        }
        AppLogger.data.info("Fetching all photos from PhotoKit")
        return try await dataSource.fetchAllPhotos()
    }

    public func fetchDuplicateCandidates() async throws -> [PhotoEntity] {
        let all = try await fetchAll()
        // Pre-filter: exclude favorites; heavy analysis done in AIEngine
        return all.filter { !$0.isFavorite }
    }

    public func fetchScreenshots() async throws -> [PhotoEntity] {
        let all = try await fetchAll()
        return all.filter { $0.isScreenshot }
    }

    public func delete(_ photo: PhotoEntity) async throws {
        AppLogger.data.info("Deleting photo: \(photo.localIdentifier)")
        try await dataSource.deleteAssets(withIdentifiers: [photo.localIdentifier])
    }

    public func deleteBatch(_ photos: [PhotoEntity]) async throws {
        guard !photos.isEmpty else { return }
        AppLogger.data.info("Batch deleting \(photos.count) photos")
        try await dataSource.deleteAssets(withIdentifiers: photos.map { $0.localIdentifier })
    }
}
