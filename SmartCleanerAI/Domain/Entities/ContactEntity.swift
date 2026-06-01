import Foundation

/// Represents a contact in the SmartCleanerAI domain layer.
///
/// A pure Swift value type isolated from Contacts.framework details.
///
/// Usage:
/// ```swift
/// let contact = ContactEntity(
///     cnIdentifier: "ABC",
///     givenName: "John",
///     familyName: "Doe",
///     phoneNumbers: ["+62-812-3456-7890"]
/// )
/// ```
public struct ContactEntity: Identifiable, Hashable, Sendable {

    // MARK: - Identity

    public let id: UUID
    /// The CNContact identifier for fetching from the address book.
    public let cnIdentifier: String

    // MARK: - Name

    public let givenName: String
    public let familyName: String

    // MARK: - Contact Details

    public let phoneNumbers: [String]
    public let emailAddresses: [String]

    // MARK: - Status

    public var isDuplicate: Bool

    // MARK: - Init

    public init(
        id: UUID = UUID(),
        cnIdentifier: String,
        givenName: String,
        familyName: String,
        phoneNumbers: [String] = [],
        emailAddresses: [String] = [],
        isDuplicate: Bool = false
    ) {
        self.id = id
        self.cnIdentifier = cnIdentifier
        self.givenName = givenName
        self.familyName = familyName
        self.phoneNumbers = phoneNumbers
        self.emailAddresses = emailAddresses
        self.isDuplicate = isDuplicate
    }

    // MARK: - Computed

    /// Full display name composed of given and family name.
    var fullName: String {
        [givenName, familyName]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    /// Initials for avatar display (up to 2 characters).
    var initials: String {
        [givenName.prefix(1), familyName.prefix(1)]
            .filter { !$0.isEmpty }
            .joined()
            .uppercased()
    }

    /// Primary phone number, if available.
    var primaryPhone: String? { phoneNumbers.first }

    /// Primary email address, if available.
    var primaryEmail: String? { emailAddresses.first }
}
