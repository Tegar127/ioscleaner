import Foundation

/// Represents a video asset in the SmartCleanerAI domain layer.
///
/// A pure Swift value type with zero framework dependencies.
///
/// Usage:
/// ```swift
/// let video = VideoEntity(
///     localIdentifier: "XYZ-456",
///     duration: 222.5,
///     fileSize: 512_000_000
/// )
/// ```
public struct VideoEntity: Identifiable, Hashable, Sendable {

    // MARK: - Identity

    public let id: UUID
    public let localIdentifier: String

    // MARK: - Metadata

    public let creationDate: Date?
    public let duration: TimeInterval
    public let fileSize: Int64
    public let pixelWidth: Int
    public let pixelHeight: Int
    public var isFavorite: Bool

    // MARK: - Init

    public init(
        id: UUID = UUID(),
        localIdentifier: String,
        creationDate: Date? = nil,
        duration: TimeInterval = 0,
        fileSize: Int64 = 0,
        pixelWidth: Int = 0,
        pixelHeight: Int = 0,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.localIdentifier = localIdentifier
        self.creationDate = creationDate
        self.duration = duration
        self.fileSize = fileSize
        self.pixelWidth = pixelWidth
        self.pixelHeight = pixelHeight
        self.isFavorite = isFavorite
    }

    // MARK: - Computed

    /// Formatted duration string (e.g., "3:42").
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    /// Resolution label (e.g., "4K", "1080p", "720p").
    var resolutionLabel: String {
        switch pixelHeight {
        case 2160...: return "4K"
        case 1080...: return "1080p"
        case 720...:  return "720p"
        default:      return "SD"
        }
    }

    /// Human-readable file size (e.g., "512 MB").
    var formattedFileSize: String {
        AppFormatter.byteCount.string(fromByteCount: fileSize)
    }
}
