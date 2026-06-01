import Foundation

/// Represents the blur assessment score for a single image asset.
///
/// A score of 0.0 indicates a perfectly sharp image; 1.0 is maximally blurry.
/// The threshold for "blurry" classification is `AppConstants.Scan.blurThreshold` (0.65).
public struct BlurScore: Sendable {
    public let localIdentifier: String
    /// Normalized blur intensity in [0.0, 1.0].
    public let score: Float

    /// Returns `true` if the image is classified as blurry.
    public var isBlurry: Bool { score >= AppConstants.Scan.blurThreshold }

    /// A human-readable blur classification label.
    public var label: String {
        switch score {
        case 0..<0.3:                              return "blur.label.sharp".localized
        case 0.3..<AppConstants.Scan.blurThreshold: return "blur.label.slightly".localized
        default:                                   return "blur.label.blurry".localized
        }
    }

    public init(localIdentifier: String, score: Float) {
        self.localIdentifier = localIdentifier
        self.score = score
    }
}
