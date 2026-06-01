import SwiftData
import Foundation

/// Configures and provides the SwiftData `ModelContainer` for SmartCleanerAI.
///
/// Initializes a persistent store registering all `@Model` schemas.
/// Injected into the app via `DependencyContainer`.
///
/// Usage:
/// ```swift
/// let container = try SwiftDataContainer.makeContainer()
/// let context   = container.mainContext
/// ```
public final class SwiftDataContainer {

    // MARK: - Production Container

    /// Creates and returns the configured persistent `ModelContainer`.
    ///
    /// - Returns: A `ModelContainer` with all registered `@Model` schemas.
    /// - Throws: `StorageError.persistenceFailed` if container creation fails.
    public static func makeContainer() throws -> ModelContainer {
        let schema = Schema([
            ScanHistoryModel.self,
            RecommendationCacheModel.self,
            UserPreferencesModel.self
        ])
        let configuration = ModelConfiguration(
            AppConstants.Persistence.storeName,
            schema: schema,
            isStoredInMemoryOnly: false
        )
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            AppLogger.data.error("SwiftData container creation failed: \(error)")
            throw StorageError.persistenceFailed(reason: error.localizedDescription)
        }
    }

    // MARK: - In-Memory Container (Tests + Previews)

    /// Creates an in-memory `ModelContainer` that does not persist data.
    ///
    /// Use in unit tests and SwiftUI `#Preview` blocks.
    ///
    /// - Returns: A transient `ModelContainer`.
    public static func makeInMemoryContainer() throws -> ModelContainer {
        let schema = Schema([
            ScanHistoryModel.self,
            RecommendationCacheModel.self,
            UserPreferencesModel.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [configuration])
    }
}
