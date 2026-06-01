import Foundation

// MARK: - Protocol

/// Contract for AI recommendation generation.
public protocol RecommendationEngineProtocol: Sendable {
    func generateRecommendations(
        photos: [PhotoEntity],
        videos: [VideoEntity]
    ) async -> [RecommendationEntity]
}

// MARK: - Implementation

/// Generates ranked cleanup recommendations from storage analysis results.
///
/// Scores cleanup actions by estimated space freed and confidence,
/// producing a descending-sorted `[RecommendationEntity]` list.
public final class RecommendationEngine: RecommendationEngineProtocol {

    public init() {}

    // MARK: - RecommendationEngineProtocol

    public func generateRecommendations(
        photos: [PhotoEntity],
        videos: [VideoEntity]
    ) async -> [RecommendationEntity] {
        AppLogger.ai.info("Generating recommendations for \(photos.count) photos, \(videos.count) videos")

        let candidates: [RecommendationEntity?] = [
            buildScreenshotRecommendation(from: photos),
            buildLargeVideoRecommendation(from: videos),
            buildBlurryPhotoRecommendation(from: photos),
            buildDuplicatePhotoRecommendation(from: photos)
        ]

        return candidates
            .compactMap { $0 }
            .sorted { $0.estimatedSpaceSavedBytes > $1.estimatedSpaceSavedBytes }
    }

    // MARK: - Private Builders

    private func buildScreenshotRecommendation(from photos: [PhotoEntity]) -> RecommendationEntity? {
        let screenshots = photos.filter { $0.isScreenshot }
        guard !screenshots.isEmpty else { return nil }
        return RecommendationEntity(
            type: .screenshots,
            title: "recommendation.screenshots.title".localized,
            description: "recommendation.screenshots.description".localizedFormat(screenshots.count),
            estimatedSpaceSavedBytes: screenshots.reduce(0) { $0 + $1.fileSize },
            confidenceScore: 0.95,
            affectedAssetIdentifiers: screenshots.map { $0.localIdentifier }
        )
    }

    private func buildLargeVideoRecommendation(from videos: [VideoEntity]) -> RecommendationEntity? {
        let large = videos.filter { $0.fileSize >= AppConstants.Scan.largeVideoThresholdBytes }
        guard !large.isEmpty else { return nil }
        return RecommendationEntity(
            type: .largeVideos,
            title: "recommendation.largeVideos.title".localized,
            description: "recommendation.largeVideos.description".localizedFormat(large.count),
            estimatedSpaceSavedBytes: large.reduce(0) { $0 + $1.fileSize },
            confidenceScore: 0.90,
            affectedAssetIdentifiers: large.map { $0.localIdentifier }
        )
    }

    private func buildBlurryPhotoRecommendation(from photos: [PhotoEntity]) -> RecommendationEntity? {
        let blurry = photos.filter { $0.isBlurry }
        guard !blurry.isEmpty else { return nil }
        return RecommendationEntity(
            type: .blurryPhotos,
            title: "recommendation.blurry.title".localized,
            description: "recommendation.blurry.description".localizedFormat(blurry.count),
            estimatedSpaceSavedBytes: blurry.reduce(0) { $0 + $1.fileSize },
            confidenceScore: 0.80,
            affectedAssetIdentifiers: blurry.map { $0.localIdentifier }
        )
    }

    private func buildDuplicatePhotoRecommendation(from photos: [PhotoEntity]) -> RecommendationEntity? {
        let duplicates = photos.filter { $0.isDuplicate }
        guard !duplicates.isEmpty else { return nil }
        return RecommendationEntity(
            type: .duplicatePhotos,
            title: "recommendation.duplicates.title".localized,
            description: "recommendation.duplicates.description".localizedFormat(duplicates.count),
            estimatedSpaceSavedBytes: duplicates.reduce(0) { $0 + $1.fileSize } / 2,
            confidenceScore: 0.85,
            affectedAssetIdentifiers: duplicates.map { $0.localIdentifier }
        )
    }
}
