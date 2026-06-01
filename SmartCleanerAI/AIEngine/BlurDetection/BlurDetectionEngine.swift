import Vision
import UIKit
import CoreImage
import Foundation

// MARK: - Protocol

/// Contract for blur detection capabilities.
public protocol BlurDetectionEngineProtocol: Sendable {
    func calculateBlurScore(for assetIdentifier: String) async throws -> Float
}

// MARK: - Implementation

/// On-device blur detection using Laplacian variance via CoreImage.
///
/// Computes a blur score in [0.0, 1.0] where higher values indicate more blur.
/// Laplacian variance measures sharpness by analyzing edge gradient intensity.
///
/// - Note: In production, image data is loaded via `PHCachingImageManager`
///   at thumbnail resolution (faster, lower memory than full resolution).
public final class BlurDetectionEngine: BlurDetectionEngineProtocol {

    private let ciContext = CIContext()

    // MARK: - BlurDetectionEngineProtocol

    /// Calculates a blur score for the photo with the given local identifier.
    ///
    /// - Parameter assetIdentifier: The `PHAsset.localIdentifier` of the photo.
    /// - Returns: A blur score in [0.0, 1.0]. Higher = more blurry.
    public func calculateBlurScore(for assetIdentifier: String) async throws -> Float {
        guard let imageData = await loadThumbnailData(for: assetIdentifier) else {
            throw StorageError.assetNotFound
        }
        return computeLaplacianVarianceScore(from: imageData)
    }

    // MARK: - Private Helpers

    private func loadThumbnailData(for identifier: String) async -> Data? {
        // Production: inject PHCachingImageManager and request thumbnail (200×200)
        // Return nil in scaffold — will be wired up in Xcode project with real manager.
        AppLogger.ai.debug("Blur: loading thumbnail for \(identifier)")
        return nil
    }

    private func computeLaplacianVarianceScore(from imageData: Data) -> Float {
        guard let uiImage = UIImage(data: imageData),
              let ciImage = CIImage(image: uiImage) else { return 0 }

        guard let filter = CIFilter(name: "CIConvolution3X3") else { return 0 }
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        let laplacianKernel: [CGFloat] = [0, 1, 0, 1, -4, 1, 0, 1, 0]
        filter.setValue(CIVector(values: laplacianKernel, count: 9), forKey: "inputWeights")

        guard let output = filter.outputImage,
              let cgImage = ciContext.createCGImage(output, from: output.extent) else {
            return 0
        }

        return normalizeVariance(computeVariance(from: cgImage))
    }

    private func computeVariance(from image: CGImage) -> Double {
        // Simplified placeholder — real implementation samples pixel brightness
        // and computes variance across the edge-filtered image.
        return Double.random(in: 0...200)
    }

    private func normalizeVariance(_ variance: Double) -> Float {
        let maxExpectedVariance: Double = 400
        return Float(max(0, min(1, 1.0 - (variance / maxExpectedVariance))))
    }
}
