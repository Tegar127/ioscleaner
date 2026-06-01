import XCTest
@testable import SmartCleanerAI

// MARK: - AnalyzeStorageUseCase Tests

final class AnalyzeStorageUseCaseTests: XCTestCase {

    private var photoRepository: MockPhotoRepository!
    private var videoRepository: MockVideoRepository!
    private var contactRepository: MockContactRepository!
    private var sut: AnalyzeStorageUseCase!

    override func setUp() {
        super.setUp()
        photoRepository   = MockPhotoRepository()
        videoRepository   = MockVideoRepository()
        contactRepository = MockContactRepository()
        sut = AnalyzeStorageUseCase(
            photoRepository: photoRepository,
            videoRepository: videoRepository,
            contactRepository: contactRepository
        )
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testExecuteReturnsCombinedCounts() async throws {
        photoRepository.stubbedPhotos = [
            PhotoEntity(localIdentifier: "p1", fileSize: 1_000_000),
            PhotoEntity(localIdentifier: "p2", fileSize: 2_000_000)
        ]
        videoRepository.stubbedVideos = [
            VideoEntity(localIdentifier: "v1", fileSize: 100_000_000)
        ]
        contactRepository.stubbedContacts = [
            ContactEntity(cnIdentifier: "c1", givenName: "John", familyName: "Doe"),
            ContactEntity(cnIdentifier: "c2", givenName: "Jane", familyName: "Doe")
        ]

        let result = try await sut.execute()

        XCTAssertEqual(result.photoCount,   2)
        XCTAssertEqual(result.videoCount,   1)
        XCTAssertEqual(result.contactCount, 2)
        XCTAssertEqual(result.totalPhotoSizeBytes, 3_000_000)
        XCTAssertEqual(result.totalVideoSizeBytes, 100_000_000)
    }

    func testExecuteWithEmptyRepositories() async throws {
        let result = try await sut.execute()
        XCTAssertEqual(result.photoCount,   0)
        XCTAssertEqual(result.videoCount,   0)
        XCTAssertEqual(result.contactCount, 0)
        XCTAssertEqual(result.totalMediaSizeBytes, 0)
    }
}

// MARK: - SaveScanHistoryUseCase Tests

final class SaveScanHistoryUseCaseTests: XCTestCase {

    func testExecuteSavesEntityToRepository() async throws {
        let repo = MockScanHistoryRepository()
        let sut  = SaveScanHistoryUseCase(scanHistoryRepository: repo)

        let sessionResult = ScanSessionResult(
            totalSpaceSavedBytes: 5_000_000_000,
            totalItemsDeleted: 100,
            durationSeconds: 12.5
        )

        let entity = try await sut.execute(with: sessionResult)

        XCTAssertEqual(repo.savedEntries.count, 1)
        XCTAssertEqual(entity.spaceSavedBytes, 5_000_000_000)
        XCTAssertEqual(entity.itemsDeleted, 100)
        XCTAssertEqual(entity.scanDurationSeconds, 12.5, accuracy: 0.01)
    }
}

// MARK: - GenerateRecommendationUseCase Tests

final class GenerateRecommendationUseCaseTests: XCTestCase {

    func testReturnsCachedResultsWhenAvailable() async throws {
        let mockRepo   = MockRecommendationRepository()
        let mockEngine = MockRecommendationEngine()
        let mockPhotos = MockPhotoRepository()
        let mockVideos = MockVideoRepository()

        let cached = [RecommendationEntity(
            type: .screenshots, title: "Cached", description: "desc",
            estimatedSpaceSavedBytes: 1_000_000, confidenceScore: 0.9
        )]
        mockRepo.cache = cached

        let sut = GenerateRecommendationUseCase(
            recommendationRepository: mockRepo,
            recommendationEngine: mockEngine,
            photoRepository: mockPhotos,
            videoRepository: mockVideos
        )

        let result = try await sut.execute()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.title, "Cached")
    }

    func testGeneratesFreshWhenCacheIsEmpty() async throws {
        let mockRepo   = MockRecommendationRepository()
        let mockEngine = MockRecommendationEngine()
        let mockPhotos = MockPhotoRepository()
        let mockVideos = MockVideoRepository()

        let fresh = [RecommendationEntity(
            type: .largeVideos, title: "Fresh", description: "desc",
            estimatedSpaceSavedBytes: 200_000_000, confidenceScore: 0.88
        )]
        mockEngine.stubbedRecommendations = fresh

        let sut = GenerateRecommendationUseCase(
            recommendationRepository: mockRepo,
            recommendationEngine: mockEngine,
            photoRepository: mockPhotos,
            videoRepository: mockVideos
        )

        let result = try await sut.execute()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.title, "Fresh")
        XCTAssertEqual(mockRepo.cache?.count, 1, "Fresh results should be saved to cache")
    }
}
