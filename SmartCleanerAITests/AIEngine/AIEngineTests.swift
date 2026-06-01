import XCTest
@testable import SmartCleanerAI

// MARK: - UsagePredictionEngine Tests

final class UsagePredictionEngineTests: XCTestCase {

    private var sut: UsagePredictionEngine!

    override func setUp() {
        super.setUp()
        sut = UsagePredictionEngine()
    }

    func testFavoritesScoreHigher() async {
        let favoritePhoto = PhotoEntity(localIdentifier: "fav", creationDate: .now, isFavorite: true)
        let normalPhoto   = PhotoEntity(localIdentifier: "nrm", creationDate: .now)

        let scored = await sut.scoreAssets([favoritePhoto, normalPhoto])
        let favoriteScore = scored.first { $0.photo.localIdentifier == "fav" }?.score ?? 0
        let normalScore   = scored.first { $0.photo.localIdentifier == "nrm" }?.score ?? 0

        XCTAssertGreaterThan(favoriteScore, normalScore)
    }

    func testBlurryPhotosScoreLower() async {
        let sharp  = PhotoEntity(localIdentifier: "sharp", isBlurry: false)
        let blurry = PhotoEntity(localIdentifier: "blur",  isBlurry: true)

        let scored = await sut.scoreAssets([sharp, blurry])
        let sharpScore  = scored.first { $0.photo.localIdentifier == "sharp" }?.score ?? 0
        let blurryScore = scored.first { $0.photo.localIdentifier == "blur"  }?.score ?? 0

        XCTAssertGreaterThan(sharpScore, blurryScore)
    }

    func testScoresAreBoundedBetween0And1() async {
        let photos = (0..<20).map { i in
            PhotoEntity(
                localIdentifier: "p\(i)",
                creationDate: Calendar.current.date(byAdding: .day, value: -i * 50, to: .now),
                isFavorite: i % 3 == 0,
                isBlurry: i % 4 == 0,
                isScreenshot: i % 5 == 0
            )
        }
        let scored = await sut.scoreAssets(photos)
        for item in scored {
            XCTAssertGreaterThanOrEqual(item.score, 0.0)
            XCTAssertLessThanOrEqual(item.score, 1.0)
        }
    }
}

// MARK: - RecommendationEngine Tests

final class RecommendationEngineTests: XCTestCase {

    func testGeneratesScreenshotRecommendation() async {
        let sut = RecommendationEngine()
        let screenshots = (0..<10).map { i in
            PhotoEntity(localIdentifier: "s\(i)", fileSize: 1_000_000, isScreenshot: true)
        }
        let recs = await sut.generateRecommendations(photos: screenshots, videos: [])
        XCTAssertTrue(recs.contains { $0.type == .screenshots })
    }

    func testGeneratesLargeVideoRecommendation() async {
        let sut = RecommendationEngine()
        let largeVideo = VideoEntity(
            localIdentifier: "v1",
            fileSize: 200 * 1_024 * 1_024
        )
        let recs = await sut.generateRecommendations(photos: [], videos: [largeVideo])
        XCTAssertTrue(recs.contains { $0.type == .largeVideos })
    }

    func testRecommendationsAreSortedBySpaceSavedDescending() async {
        let sut = RecommendationEngine()
        let smallScreenshots = [PhotoEntity(localIdentifier: "s1", fileSize: 100_000, isScreenshot: true)]
        let largeVideo = VideoEntity(localIdentifier: "v1", fileSize: 500 * 1_024 * 1_024)

        let recs = await sut.generateRecommendations(photos: smallScreenshots, videos: [largeVideo])
        guard recs.count >= 2 else { return }
        XCTAssertGreaterThanOrEqual(
            recs[0].estimatedSpaceSavedBytes,
            recs[1].estimatedSpaceSavedBytes
        )
    }
}
