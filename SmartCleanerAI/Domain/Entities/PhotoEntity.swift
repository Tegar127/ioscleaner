import Foundation

/// Represents a photo asset in the SmartCleanerAI domain layer.
///
/// A pure Swift value type with zero framework dependencies.
/// PhotoKit details are encapsulated in the Data layer only.
///
/// Usage:
/// ```swift
/// let photo = PhotoEntity(
///     localIdentifier: "ABC-123",
///     creationDate: Date(),
///     fileSize: 4_200_000,
///     isFavorite: false
/// )
/// ```
public struct PhotoEntity: Identifiable, Hashable, Sendable {

    // MARK: - Identity

    public let id: UUID
    /// The PHAsset local identifier used to fetch the asset from PhotoKit.
    public let localIdentifier: String

    // MARK: - Metadata

    public let creationDate: Date?
    public let modificationDate: Date?
    public let fileSize: Int64
    public let pixelWidth: Int
    public let pixelHeight: Int

    // MARK: - Status Flags

    public var isFavorite: Bool
    public var isBlurry: Bool
    public var blurScore: Float
    public var isDuplicate: Bool
    public var isScreenshot: Bool

    // MARK: - Init

    public init(
        id: UUID = UUID(),
        localIdentifier: String,
        creationDate: Date? = nil,
        modificationDate: Date? = nil,
        fileSize: Int64 = 0,
        pixelWidth: Int = 0,
        pixelHeight: Int = 0,
        isFavorite: Bool = false,
        isBlurry: Bool = false,
        blurScore: Float = 0,
        isDuplicate: Bool = false,
        isScreenshot: Bool = false
    ) {
        self.id = id
        self.localIdentifier = localIdentifier
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.fileSize = fileSize
        self.pixelWidth = pixelWidth
        self.pixelHeight = pixelHeight
        self.isFavorite = isFavorite
        self.isBlurry = isBlurry
        self.blurScore = blurScore
        self.isDuplicate = isDuplicate
        self.isScreenshot = isScreenshot
    }

    // MARK: - Computed

    /// Human-readable file size (e.g., "4.2 MB").
    var formattedFileSize: String {
        AppFormatter.byteCount.string(fromByteCount: fileSize)
    }

    /// Resolution label (e.g., "4032 × 3024").
    var resolutionLabel: String { "\(pixelWidth) × \(pixelHeight)" }
}
