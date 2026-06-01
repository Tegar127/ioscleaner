import Foundation

/// Base protocol for all application services in SmartCleanerAI.
///
/// Services encapsulate operations that span multiple repositories or system APIs.
/// They manage lifecycle events and support structured teardown.
///
/// Usage:
/// ```swift
/// final class MyService: ServiceProtocol {
///     func prepare() async throws { /* setup */ }
///     func tearDown() { /* cleanup */ }
/// }
/// ```
public protocol ServiceProtocol: AnyObject, Sendable {

    /// Prepares the service for use. Called once after dependency injection.
    ///
    /// - Throws: Any error that prevents the service from being ready.
    func prepare() async throws

    /// Tears down the service and releases held resources.
    func tearDown()
}

// MARK: - Default Implementation

public extension ServiceProtocol {

    /// Default no-op implementation of `prepare()`.
    func prepare() async throws {}

    /// Default no-op implementation of `tearDown()`.
    func tearDown() {}
}
