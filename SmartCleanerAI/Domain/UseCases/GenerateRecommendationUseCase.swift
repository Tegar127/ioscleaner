import Foundation

// MARK: - Use Case Protocol

/// Generates AI cleanup recommendations, using a cache when available.
///
/// Returns cached results within the 24-hour TTL; otherwise runs the
/// recommendation engine and saves the fresh results.
///
/// Usage:
/// ```swift
/// let recommendations = try await generateRecommendationUseCase.execute()
/// ```
public protocol GenerateRecommendationUseCaseProtocol: Sendable {
    func execute() async throws -> [RecommendationEntity]
}

// MARK: - Implementation

public final class GenerateRecommendationUseCase: GenerateRecommendationUseCaseProtocol {

    // MARK: - Dependencies

    private let recommendationRepository: RecommendationRepositoryProtocol
    private let recommendationEngine: RecommendationEngineProtocol
    private let photoRepository: PhotoRepositoryProtocol
    private let videoRepository: VideoRepositoryProtocol

    // MARK: - Init

    public init(
        recommendationRepository: RecommendationRepositoryProtocol,
        recommendationEngine: RecommendationEngineProtocol,
        photoRepository: PhotoRepositoryProtocol,
        videoRepository: VideoRepositoryProtocol
    ) {
        self.recommendationRepository = recommendationRepository
        self.recommendationEngine = recommendationEngine
        self.photoRepository = photoRepository
        self.videoRepository = videoRepository
    }

    // MARK: - Execute

    public func execute() async throws -> [RecommendationEntity] {
        if let cached = try await recommendationRepository.fetchCached() {
            AppLogger.domain.info("Returning \(cached.count) cached recommendations")
            return cached
        }
        return try await generateFresh()
    }

    // MARK: - Private

    private func generateFresh() async throws -> [RecommendationEntity] {
        async let photos = photoRepository.fetchAll()
        async let videos = videoRepository.fetchAll()
        let (allPhotos, allVideos) = try await (photos, videos)

        let recommendations = await recommendationEngine.generateRecommendations(
            photos: allPhotos,
            videos: allVideos
        )
        try await recommendationRepository.save(recommendations)
        AppLogger.domain.info("Generated \(recommendations.count) fresh recommendations")
        return recommendations
    }
}
