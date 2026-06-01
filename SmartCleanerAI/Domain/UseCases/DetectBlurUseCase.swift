import Foundation

// MARK: - Use Case Protocol

/// Scans all photos and returns those detected as blurry.
///
/// Uses `BlurDetectionEngine` concurrently via `TaskGroup` for performance.
///
/// Usage:
/// ```swift
/// let blurryPhotos = try await detectBlurUseCase.execute()
/// ```
public protocol DetectBlurUseCaseProtocol: Sendable {
    func execute() async throws -> [PhotoEntity]
}

// MARK: - Implementation

public final class DetectBlurUseCase: DetectBlurUseCaseProtocol {

    // MARK: - Dependencies

    private let photoRepository: PhotoRepositoryProtocol
    private let blurEngine: BlurDetectionEngineProtocol

    // MARK: - Init

    public init(
        photoRepository: PhotoRepositoryProtocol,
        blurEngine: BlurDetectionEngineProtocol
    ) {
        self.photoRepository = photoRepository
        self.blurEngine = blurEngine
    }

    // MARK: - Execute

    public func execute() async throws -> [PhotoEntity] {
        AppLogger.domain.info("Starting blur detection scan")
        let photos = try await photoRepository.fetchAll()
        let blurryPhotos = try await scanConcurrently(photos: photos)
        AppLogger.domain.info("Blur detection found \(blurryPhotos.count) blurry photos")
        return blurryPhotos.sorted { $0.blurScore > $1.blurScore }
    }

    // MARK: - Private Helpers

    private func scanConcurrently(photos: [PhotoEntity]) async throws -> [PhotoEntity] {
        var results: [PhotoEntity] = []

        try await withThrowingTaskGroup(of: PhotoEntity?.self) { group in
            for photo in photos {
                group.addTask {
                    var mutablePhoto = photo
                    let score = try await self.blurEngine.calculateBlurScore(
                        for: photo.localIdentifier
                    )
                    mutablePhoto.blurScore = score
                    mutablePhoto.isBlurry  = score >= AppConstants.Scan.blurThreshold
                    return mutablePhoto.isBlurry ? mutablePhoto : nil
                }
            }
            for try await result in group {
                if let photo = result { results.append(photo) }
            }
        }

        return results
    }
}
