import Contacts
import Foundation

/// Low-level Contacts.framework wrapper for fetching and modifying contacts.
///
/// Abstracts `CNContactStore` behind a clean async interface.
/// Used exclusively by `ContactRepository`.
///
/// Usage:
/// ```swift
/// let contacts = try await contactsDataSource.fetchAll()
/// try await contactsDataSource.deleteContact(withIdentifier: "abc-123")
/// ```
public final class ContactsDataSource: Sendable {

    // MARK: - Properties

    private let store = CNContactStore()

    // MARK: - Fetching

    /// Fetches all contacts with keys required for deduplication analysis.
    ///
    /// - Returns: An array of `ContactEntity` values.
    /// - Throws: `StorageError.assetFetchFailed` on any Contacts framework error.
    func fetchAll() async throws -> [ContactEntity] {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let keys: [CNKeyDescriptor] = [
                        CNContactGivenNameKey as CNKeyDescriptor,
                        CNContactFamilyNameKey as CNKeyDescriptor,
                        CNContactPhoneNumbersKey as CNKeyDescriptor,
                        CNContactEmailAddressesKey as CNKeyDescriptor
                    ]
                    var contacts: [ContactEntity] = []
                    try self.store.enumerateContacts(
                        with: CNContactFetchRequest(keysToFetch: keys)
                    ) { cn, _ in
                        contacts.append(self.mapContact(cn))
                    }
                    continuation.resume(returning: contacts)
                } catch {
                    continuation.resume(throwing: StorageError.assetFetchFailed)
                }
            }
        }
    }

    // MARK: - Deletion

    /// Permanently deletes a contact by identifier.
    ///
    /// - Parameter identifier: The `CNContact.identifier` string.
    /// - Throws: `StorageError.deletionFailed` if the save request fails.
    func deleteContact(withIdentifier identifier: String) async throws {
        let contact = try store.unifiedContact(
            withIdentifier: identifier,
            keysToFetch: [CNContactIdentifierKey as CNKeyDescriptor]
        )
        guard let mutable = contact.mutableCopy() as? CNMutableContact else { return }
        let request = CNSaveRequest()
        request.delete(mutable)
        do {
            try store.execute(request)
        } catch {
            throw StorageError.deletionFailed(reason: error.localizedDescription)
        }
    }

    // MARK: - Private Mapper

    private func mapContact(_ cn: CNContact) -> ContactEntity {
        ContactEntity(
            cnIdentifier: cn.identifier,
            givenName: cn.givenName,
            familyName: cn.familyName,
            phoneNumbers: cn.phoneNumbers.map { $0.value.stringValue },
            emailAddresses: cn.emailAddresses.map { $0.value as String }
        )
    }
}
