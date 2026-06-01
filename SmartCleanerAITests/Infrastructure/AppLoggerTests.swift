import XCTest
@testable import SmartCleanerAI

// MARK: - AppLogger Tests

final class AppLoggerTests: XCTestCase {

    func testAppLoggerCategoriesExist() {
        // All category loggers should be accessible without crashing
        let ui            = AppLogger.ui
        let domain        = AppLogger.domain
        let data          = AppLogger.data
        let ai            = AppLogger.ai
        let infrastructure = AppLogger.infrastructure
        let permissions   = AppLogger.permissions

        XCTAssertNotNil(ui)
        XCTAssertNotNil(domain)
        XCTAssertNotNil(data)
        XCTAssertNotNil(ai)
        XCTAssertNotNil(infrastructure)
        XCTAssertNotNil(permissions)
    }
}

// MARK: - AppConstants Tests

final class AppConstantsTests: XCTestCase {

    func testScanThresholdsAreValid() {
        XCTAssertGreaterThan(AppConstants.Scan.similarityThreshold, 0)
        XCTAssertLessThanOrEqual(AppConstants.Scan.similarityThreshold, 1)

        XCTAssertGreaterThan(AppConstants.Scan.blurThreshold, 0)
        XCTAssertLessThanOrEqual(AppConstants.Scan.blurThreshold, 1)

        XCTAssertGreaterThan(AppConstants.Scan.largeVideoThresholdBytes, 0)
    }

    func testPersistenceCacheTTLIsPositive() {
        XCTAssertGreaterThan(AppConstants.Persistence.recommendationCacheTTL, 0)
    }

    func testBundleIdentifierNotEmpty() {
        XCTAssertFalse(AppConstants.bundleIdentifier.isEmpty)
    }
}

// MARK: - UIConstants Tests

final class UIConstantsTests: XCTestCase {

    func testSpacingValuesArePositive() {
        XCTAssertGreaterThan(UIConstants.Spacing.small, 0)
        XCTAssertGreaterThan(UIConstants.Spacing.medium, UIConstants.Spacing.small)
        XCTAssertGreaterThan(UIConstants.Spacing.large, UIConstants.Spacing.medium)
    }

    func testCornerRadiiArePositive() {
        XCTAssertGreaterThan(UIConstants.CornerRadius.card, 0)
        XCTAssertGreaterThan(UIConstants.CornerRadius.pill, UIConstants.CornerRadius.modal)
    }

    func testAnimationDurationsArePositive() {
        XCTAssertGreaterThan(UIConstants.Animation.fast, 0)
        XCTAssertLessThan(UIConstants.Animation.fast, UIConstants.Animation.standard)
    }
}
