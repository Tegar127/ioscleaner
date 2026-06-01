import Foundation

/// Generic wrapper for an AI engine result with confidence score and timing.
///
/// Usage:
/// ```swift
/// let result = AIResult(value: blurScore, confidence: 0.92, processingTimeMs: 45)
/// ```
public struct AIResult<T: Sendable>: Sendable {
    public let value: T
    public let confidence: Float
    public let processingTimeMs: Double

    public init(value: T, confidence: Float, processingTimeMs: Double = 0) {
        self.value = value
        self.confidence = confidence
        self.processingTimeMs = processingTimeMs
    }
}
