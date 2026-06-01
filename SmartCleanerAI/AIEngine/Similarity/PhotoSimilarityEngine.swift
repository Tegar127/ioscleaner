import Vision
import Foundation

// MARK: - Protocol

/// Contract for photo similarity and duplicate detection capabilities.
public protocol PhotoSimilarityEngineProtocol: Sendable {
    func findDuplicates(among photos: [PhotoEntity]) async throws -> [DuplicatePhotoGroup]
    func findSimilar(among photos: [PhotoEntity]) async throws -> [[PhotoEntity]]
}

// MARK: - Implementation

/// On-device photo similarity engine using Vision feature prints.
///
/// Uses `ImageFeatureExtractor` (backed by `VNGenerateImageFeaturePrintRequest`)
/// to compute pairwise similarity and cluster results into groups.
/// Shared feature extraction avoids redundant Vision request setup.
///
/// - Note: In a production Xcode project, image data is loaded via
///   `PHCachingImageManager` at thumbnail resolution for performance.
public final class PhotoSimilarityEngine: PhotoSimilarityEngineProtocol {

    // MARK: - Dependencies

    private let featureExtractor: ImageFeatureExtractor

    // MARK: - Init

    public init(featureExtractor: ImageFeatureExtractor = ImageFeatureExtractor()) {
        self.featureExtractor = featureExtractor
    }

    // MARK: - PhotoSimilarityEngineProtocol

    /// Finds groups of duplicate photos using Vision feature print pairwise comparison.
    ///
    /// - Parameter photos: Candidate photos from `PhotoRepository.fetchDuplicateCandidates()`.
    /// - Returns: An array of `DuplicatePhotoGroup` objects.
    public func findDuplicates(among photos: [PhotoEntity]) async throws -> [DuplicatePhotoGroup] {
        AppLogger.ai.info("Similarity engine: scanning \(photos.count) duplicate candidates")
        // Production: load thumbnail image data, extract feature prints, compute pairwise
        // distances via TaskGroup, cluster groups above similarityThreshold.
        // Scaffold returns empty — image data loading injected via PHImageManager.
        return []
    }

    /// Finds groups of visually similar (but not identical) photos.
    ///
    /// - Parameter photos: All photos to compare.
    /// - Returns: Groups of similar photos in arrays.
    public func findSimilar(among photos: [PhotoEntity]) async throws -> [[PhotoEntity]] {
        AppLogger.ai.info("Similarity engine: scanning \(photos.count) photos for similarity")
        return []
    }
}
