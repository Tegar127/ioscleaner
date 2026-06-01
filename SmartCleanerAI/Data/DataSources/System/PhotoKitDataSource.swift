import Photos
import UIKit
import Foundation

/// Low-level PhotoKit wrapper for fetching photo and video assets.
///
/// Abstracts `PHFetchResult` and `PHAsset` APIs behind a clean async interface.
/// Used exclusively by `PhotoRepository` and `VideoRepository`.
///
/// Usage:
/// ```swift
/// let photos = try await photoKitDataSource.fetchAllPhotos()
/// try await photoKitDataSource.deleteAssets(withIdentifiers: ["ABC-123"])
/// ```
public final class PhotoKitDataSource: Sendable {

    // MARK: - Photo Fetching

    /// Fetches all image assets from the device library.
    ///
    /// - Returns: An array of `PhotoEntity` values.
    func fetchAllPhotos() async throws -> [PhotoEntity] {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let options = PHFetchOptions()
                options.sortDescriptors = [
                    NSSortDescriptor(key: "creationDate", ascending: false)
                ]
                let result = PHAsset.fetchAssets(with: .image, options: options)
                let photos = (0..<result.count).map { self.mapToPhoto(result.object(at: $0)) }
                continuation.resume(returning: photos)
            }
        }
    }

    /// Fetches all video assets from the device library.
    ///
    /// - Returns: An array of `VideoEntity` values.
    func fetchAllVideos() async throws -> [VideoEntity] {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let options = PHFetchOptions()
                options.sortDescriptors = [
                    NSSortDescriptor(key: "duration", ascending: false)
                ]
                let result = PHAsset.fetchAssets(with: .video, options: options)
                let videos = (0..<result.count).map { self.mapToVideo(result.object(at: $0)) }
                continuation.resume(returning: videos)
            }
        }
    }

    // MARK: - Deletion

    /// Permanently deletes assets identified by their local identifiers.
    ///
    /// - Parameter identifiers: An array of `PHAsset.localIdentifier` strings.
    /// - Throws: `StorageError.deletionFailed` if PhotoKit rejects the request.
    func deleteAssets(withIdentifiers identifiers: [String]) async throws {
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.deleteAssets(assets)
            }) { success, error in
                if success {
                    cont.resume()
                } else {
                    cont.resume(throwing: StorageError.deletionFailed(
                        reason: error?.localizedDescription ?? "Unknown"
                    ))
                }
            }
        }
    }

    // MARK: - Private Mappers

    private func mapToPhoto(_ asset: PHAsset) -> PhotoEntity {
        PhotoEntity(
            localIdentifier: asset.localIdentifier,
            creationDate: asset.creationDate,
            modificationDate: asset.modificationDate,
            pixelWidth: asset.pixelWidth,
            pixelHeight: asset.pixelHeight,
            isFavorite: asset.isFavorite,
            isScreenshot: asset.mediaSubtypes.contains(.photoScreenshot)
        )
    }

    private func mapToVideo(_ asset: PHAsset) -> VideoEntity {
        VideoEntity(
            localIdentifier: asset.localIdentifier,
            creationDate: asset.creationDate,
            duration: asset.duration,
            pixelWidth: asset.pixelWidth,
            pixelHeight: asset.pixelHeight,
            isFavorite: asset.isFavorite
        )
    }
}
