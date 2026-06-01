import Foundation

/// API and remote service constants for SmartCleanerAI.
///
/// Reserved for future remote endpoints. Currently all AI features
/// run entirely on-device using Apple's Vision framework — no API keys required.
///
/// Usage:
/// ```swift
/// let privacyURL = URL(string: APIConstants.privacyPolicyURL)
/// ```
public enum APIConstants {

    // MARK: - Remote Configuration

    /// Base URL for remote configuration fetching (future use).
    static let remoteConfigURL = "https://config.smartcleanerai.com/v1"

    /// Privacy policy URL shown in Settings.
    static let privacyPolicyURL = "https://smartcleanerai.com/privacy"

    /// Terms of service URL shown in Settings.
    static let termsOfServiceURL = "https://smartcleanerai.com/terms"

    /// Support contact URL.
    static let supportURL = "https://smartcleanerai.com/support"

    // MARK: - Request Configuration

    /// Default network request timeout interval in seconds.
    static let requestTimeoutSeconds: Double = 15.0
}
