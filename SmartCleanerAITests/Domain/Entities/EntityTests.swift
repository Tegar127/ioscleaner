import XCTest
@testable import SmartCleanerAI

// MARK: - PhotoEntity Tests

final class PhotoEntityTests: XCTestCase {

    func testFormattedFileSizeOutput() {
        let photo = PhotoEntity(localIdentifier: "test-1", fileSize: 4_200_000)
        XCTAssertFalse(photo.formattedFileSize.isEmpty)
        XCTAssertTrue(photo.formattedFileSize.contains("MB") || photo.formattedFileSize.contains("GB"))
    }

    func testResolutionLabel() {
        let photo = PhotoEntity(localIdentifier: "test-2", pixelWidth: 4032, pixelHeight: 3024)
        XCTAssertEqual(photo.resolutionLabel, "4032 × 3024")
    }

    func testDefaultsAreCorrect() {
        let photo = PhotoEntity(localIdentifier: "test-3")
        XCTAssertFalse(photo.isBlurry)
        XCTAssertFalse(photo.isDuplicate)
        XCTAssertEqual(photo.blurScore, 0)
        XCTAssertFalse(photo.isFavorite)
    }
}

// MARK: - VideoEntity Tests

final class VideoEntityTests: XCTestCase {

    func testFormattedDuration() {
        let video = VideoEntity(localIdentifier: "vid-1", duration: 222)
        XCTAssertEqual(video.formattedDuration, "3:42")
    }

    func testResolutionLabel4K() {
        let video = VideoEntity(localIdentifier: "vid-2", pixelHeight: 2160)
        XCTAssertEqual(video.resolutionLabel, "4K")
    }

    func testResolutionLabel1080p() {
        let video = VideoEntity(localIdentifier: "vid-3", pixelHeight: 1080)
        XCTAssertEqual(video.resolutionLabel, "1080p")
    }
}

// MARK: - ContactEntity Tests

final class ContactEntityTests: XCTestCase {

    func testFullNameCombinesNames() {
        let c = ContactEntity(cnIdentifier: "c1", givenName: "John", familyName: "Doe")
        XCTAssertEqual(c.fullName, "John Doe")
    }

    func testInitialsAreTwoUppercaseChars() {
        let c = ContactEntity(cnIdentifier: "c2", givenName: "Alice", familyName: "Smith")
        XCTAssertEqual(c.initials, "AS")
    }

    func testInitialsWithEmptyFamilyName() {
        let c = ContactEntity(cnIdentifier: "c3", givenName: "Bono", familyName: "")
        XCTAssertEqual(c.initials, "B")
    }

    func testPrimaryPhoneReturnsFirstNumber() {
        let c = ContactEntity(cnIdentifier: "c4", givenName: "X", familyName: "Y",
                              phoneNumbers: ["+62812", "+62899"])
        XCTAssertEqual(c.primaryPhone, "+62812")
    }
}
