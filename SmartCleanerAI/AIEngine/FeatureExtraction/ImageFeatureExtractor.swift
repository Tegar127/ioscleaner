import Vision
import UIKit
import Foundation

/// Shared image feature extractor using Apple's Vision framework.
///
/// Uses `VNGenerateImageFeaturePrintRequest` to generate on-device embedding
/// vectors from images. Shared by `PhotoSimilarityEngine` and `FindDuplicatesUseCase`
/// to avoid duplicating Vision request setup code.
///
/// Usage:
/// ```swift
/// let featurePrint = try await extractor.extractFeaturePrint(from: imageData)
/// let distance = try extractor.computeDistance(between: printA, and: printB)
/// ```
public final class ImageFeatureExtractor: Sendable {

    public init() {}

    // MARK: - Feature Print Extraction

    /// Extracts a `VNFeaturePrintObservation` from raw image data.
    ///
    /// - Parameter imageData: Raw JPEG or PNG image data.
    /// - Returns: A Vision feature print for similarity comparison.
    /// - Throws: `StorageError.featureExtractionFailed` if Vision request fails.
    public func extractFeaturePrint(from imageData: Data) async throws -> VNFeaturePrintObservation {
        try await withCheckedThrowingContinuation { continuation in
            guard let cgImage = UIImage(data: imageData)?.cgImage else {
                continuation.resume(throwing: StorageError.featureExtractionFailed)
                return
            }

            let request = VNGenerateImageFeaturePrintRequest { req, error in
                if let error {
                    AppLogger.ai.error("Feature extraction: \(error.localizedDescription)")
                    continuation.resume(throwing: StorageError.featureExtractionFailed)
                    return
                }
                guard let obs = req.results?.first as? VNFeaturePrintObservation else {
                    continuation.resume(throwing: StorageError.featureExtractionFailed)
                    return
                }
                continuation.resume(returning: obs)
            }

            do {
                try VNImageRequestHandler(cgImage: cgImage, options: [:]).perform([request])
            } catch {
                continuation.resume(throwing: StorageError.featureExtractionFailed)
            }
        }
    }

    // MARK: - Distance Computation

    /// Computes the normalized distance between two Vision feature prints.
    ///
    /// - Parameters:
    ///   - printA: First feature print observation.
    ///   - printB: Second feature print observation.
    /// - Returns: A distance in [0.0, ∞); lower values indicate greater similarity.
    public func computeDistance(
        between printA: VNFeaturePrintObservation,
        and printB: VNFeaturePrintObservation
    ) throws -> Float {
        var distance: Float = 0
        try printA.computeDistance(&distance, to: printB)
        return distance
    }
}
