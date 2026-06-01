import Foundation

// MARK: - Supporting Types

/// Progress state emitted during a storage scan.
public struct ScanProgress: Sendable {
    public enum Phase { case photos, videos, contacts }
    public let phase: Phase
    public let percentComplete: Double
    public var result: ScanResult? = nil
}

/// Aggregated scan result containing all fetched media and contacts.
public struct ScanResult: Sendable {
    public let photos: [PhotoEntity]
    public let videos: [VideoEntity]
    public let contacts: [ContactEntity]
}

// MARK: - StorageScannerService

/// Orchestrates a comprehensive multi-source device storage scan.
///
/// Coordinates concurrent fetching of photos, videos, and contacts,
/// reporting real-time progress updates via an `AsyncStream`.
///
/// Usage:
/// ```swift
/// for await progress in storageScannerService.scan() {
///     updateProgressUI(progress)
/// }
/// ```
public final class StorageScannerService: ServiceProtocol, Sendable {

    // MARK: - Dependencies

    private let photoRepository: PhotoRepositoryProtocol
    private let videoRepository: VideoRepositoryProtocol
    private let contactRepository: ContactRepositoryProtocol

    // MARK: - Init

    public init(
        photoRepository: PhotoRepositoryProtocol,
        videoRepository: VideoRepositoryProtocol,
        contactRepository: ContactRepositoryProtocol
    ) {
        self.photoRepository = photoRepository
        self.videoRepository = videoRepository
        self.contactRepository = contactRepository
    }

    // MARK: - Scanning

    /// Performs a full scan and reports progress via an `AsyncStream`.
    public func scan() -> AsyncStream<ScanProgress> {
        AsyncStream { continuation in
            Task { await self.performScan(continuation: continuation) }
        }
    }

    // MARK: - Private

    private func performScan(continuation: AsyncStream<ScanProgress>.Continuation) async {
        continuation.yield(ScanProgress(phase: .photos, percentComplete: 0.1))
        let photos  = await tryFetch { try await self.photoRepository.fetchAll() }
        let videos  = await tryFetch { try await self.videoRepository.fetchAll() }
        continuation.yield(ScanProgress(phase: .videos, percentComplete: 0.7))
        let contacts = await tryFetch { try await self.contactRepository.fetchAll() }
        continuation.yield(ScanProgress(
            phase: .contacts,
            percentComplete: 1.0,
            result: ScanResult(photos: photos, videos: videos, contacts: contacts)
        ))
        continuation.finish()
    }

    private func tryFetch<T>(_ op: @escaping () async throws -> [T]) async -> [T] {
        do { return try await op() }
        catch { AppLogger.data.error("Scan fetch error: \(error)"); return [] }
    }
}
