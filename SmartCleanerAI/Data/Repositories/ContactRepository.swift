import Foundation
import Contacts

/// Contacts.framework-backed implementation of `ContactRepositoryProtocol`.
public final class ContactRepository: ContactRepositoryProtocol {

    // MARK: - Dependencies

    private let dataSource: ContactsDataSource

    // MARK: - Init

    public init(dataSource: ContactsDataSource = ContactsDataSource()) {
        self.dataSource = dataSource
    }

    // MARK: - ContactRepositoryProtocol

    public func fetchAll() async throws -> [ContactEntity] {
        AppLogger.data.info("Fetching all contacts from address book")
        return try await dataSource.fetchAll()
    }

    public func fetchDuplicateCandidates() async throws -> [[ContactEntity]] {
        let all = try await fetchAll()
        return groupByNormalizedName(all)
    }

    public func merge(_ duplicates: [ContactEntity], into primary: ContactEntity) async throws {
        AppLogger.data.info("Merging \(duplicates.count) contacts into: \(primary.fullName)")
        let toDelete = duplicates.filter { $0.cnIdentifier != primary.cnIdentifier }
        for contact in toDelete {
            try await dataSource.deleteContact(withIdentifier: contact.cnIdentifier)
        }
    }

    public func delete(_ contact: ContactEntity) async throws {
        AppLogger.data.info("Deleting contact: \(contact.fullName)")
        try await dataSource.deleteContact(withIdentifier: contact.cnIdentifier)
    }

    // MARK: - Private Helpers

    private func groupByNormalizedName(_ contacts: [ContactEntity]) -> [[ContactEntity]] {
        let grouped = Dictionary(grouping: contacts) { contact in
            contact.fullName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return grouped.values.filter { $0.count > 1 }.map { Array($0) }
    }
}
