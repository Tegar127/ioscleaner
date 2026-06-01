import Foundation

// MARK: - Use Case Protocol

/// Scores photos by predicted usefulness and returns the least-used assets.
///
/// Usage:
/// ```swift
/// let unusedPhotos = try await predictUnusedFilesUseCase.execute()
/// ```
public protocol PredictUnusedFilesUseCaseProtocol: Sendable {
    func execute() async throws -> [PhotoEntity]
}

// MARK: - Implementation

public final class PredictUnusedFilesUseCase: PredictUnusedFilesUseCaseProtocol {

    private let photoRepository: PhotoRepositoryProtocol
    private let predictionEngine: UsagePredictionEngineProtocol
    private let unusedScoreThreshold: Float

    public init(
        photoRepository: PhotoRepositoryProtocol,
        predictionEngine: UsagePredictionEngineProtocol,
        unusedScoreThreshold: Float = 0.3
    ) {
        self.photoRepository = photoRepository
        self.predictionEngine = predictionEngine
        self.unusedScoreThreshold = unusedScoreThreshold
    }

    public func execute() async throws -> [PhotoEntity] {
        AppLogger.domain.info("Predicting unused files")
        let photos = try await photoRepository.fetchAll()
        let scored = await predictionEngine.scoreAssets(photos)
        let unused = scored
            .filter { $0.score <= unusedScoreThreshold }
            .map { $0.photo }
        AppLogger.domain.info("Predicted \(unused.count) unused files")
        return unused
    }
}
