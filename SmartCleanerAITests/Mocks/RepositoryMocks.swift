import XCTest
@testable import SmartCleanerAI

// MARK: - Mock Photo Repository

final class MockPhotoRepository: PhotoRepositoryProtocol {
    var stubbedPhotos: [PhotoEntity] = []
    var deletedIdentifiers: [String] = []

    func fetchAll() async throws -> [PhotoEntity] { stubbedPhotos }
    func fetchDuplicateCandidates() async throws -> [PhotoEntity] {
        stubbedPhotos.filter { !$0.isFavorite }
    }
    func fetchScreenshots() async throws -> [PhotoEntity] {
        stubbedPhotos.filter { $0.isScreenshot }
    }
    func delete(_ photo: PhotoEntity) async throws {
        deletedIdentifiers.append(photo.localIdentifier)
    }
    func deleteBatch(_ photos: [PhotoEntity]) async throws {
        deletedIdentifiers.append(contentsOf: photos.map { $0.localIdentifier })
    }
}

// MARK: - Mock Video Repository

final class MockVideoRepository: VideoRepositoryProtocol {
    var stubbedVideos: [VideoEntity] = []
    func fetchAll() async throws -> [VideoEntity] { stubbedVideos }
    func fetchLarge(threshold: Int64) async throws -> [VideoEntity] {
        stubbedVideos.filter { $0.fileSize >= threshold }
    }
    func delete(_ video: VideoEntity) async throws {}
    func deleteBatch(_ videos: [VideoEntity]) async throws {}
}

// MARK: - Mock Contact Repository

final class MockContactRepository: ContactRepositoryProtocol {
    var stubbedContacts: [ContactEntity] = []
    func fetchAll() async throws -> [ContactEntity] { stubbedContacts }
    func fetchDuplicateCandidates() async throws -> [[ContactEntity]] { [[]] }
    func merge(_ duplicates: [ContactEntity], into primary: ContactEntity) async throws {}
    func delete(_ contact: ContactEntity) async throws {}
}

// MARK: - Mock Scan History Repository

final class MockScanHistoryRepository: ScanHistoryRepositoryProtocol {
    var savedEntries: [ScanHistoryEntity] = []
    func save(_ entry: ScanHistoryEntity) async throws { savedEntries.append(entry) }
    func fetchAll() async throws -> [ScanHistoryEntity] { savedEntries }
    func fetchRecent(days: Int) async throws -> [ScanHistoryEntity] {
        savedEntries.filter { !$0.scanDate.isOlderThan(days: days) }
    }
    func deleteAll() async throws { savedEntries.removeAll() }
}

// MARK: - Mock Recommendation Repository

final class MockRecommendationRepository: RecommendationRepositoryProtocol {
    var cache: [RecommendationEntity]? = nil
    func fetchCached() async throws -> [RecommendationEntity]? { cache }
    func save(_ recommendations: [RecommendationEntity]) async throws { cache = recommendations }
    func markActioned(id: UUID) async throws {}
    func clearCache() async throws { cache = nil }
}

// MARK: - Mock Recommendation Engine

final class MockRecommendationEngine: RecommendationEngineProtocol {
    var stubbedRecommendations: [RecommendationEntity] = []
    func generateRecommendations(photos: [PhotoEntity], videos: [VideoEntity]) async -> [RecommendationEntity] {
        stubbedRecommendations
    }
}
