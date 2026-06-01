import Foundation

/// Contract for contacts data access in SmartCleanerAI.
///
/// Implemented by `ContactRepository` in the Data layer (Contacts.framework).
/// Consumed by use cases in the Domain layer.
///
/// Usage:
/// ```swift
/// let contacts = try await contactRepository.fetchAll()
/// try await contactRepository.merge(duplicates, into: primaryContact)
/// ```
public protocol ContactRepositoryProtocol: Sendable {

    /// Fetches all contacts from the device address book.
    ///
    /// - Returns: An array of `ContactEntity` values.
    /// - Throws: `StorageError.permissionDenied` if authorization is denied.
    func fetchAll() async throws -> [ContactEntity]

    /// Groups contacts that appear to be duplicates.
    ///
    /// - Returns: An array of groups, each group containing duplicate `ContactEntity` values.
    func fetchDuplicateCandidates() async throws -> [[ContactEntity]]

    /// Merges a list of duplicate contacts into a single primary contact.
    ///
    /// - Parameters:
    ///   - duplicates: Contacts to merge (will be removed).
    ///   - primary: The contact that retains the merged record.
    /// - Throws: `StorageError.mergeFailed` if the operation fails.
    func merge(_ duplicates: [ContactEntity], into primary: ContactEntity) async throws

    /// Permanently deletes a contact from the address book.
    ///
    /// - Parameter contact: The contact to delete.
    func delete(_ contact: ContactEntity) async throws
}
