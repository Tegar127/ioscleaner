import Network
import Foundation
import Combine

/// Monitors device network connectivity using NWPathMonitor.
///
/// Publishes `isConnected` and `connectionType` that update automatically
/// when network conditions change. Used for remote config fetching.
///
/// Usage:
/// ```swift
/// NetworkMonitor.shared.$isConnected
///     .sink { print("Connected: \($0)") }
///     .store(in: &cancellables)
/// ```
public final class NetworkMonitor: ObservableObject {

    // MARK: - Shared Instance

    public static let shared = NetworkMonitor()

    // MARK: - Published State

    @Published private(set) var isConnected: Bool = true
    @Published private(set) var connectionType: ConnectionType = .unknown

    // MARK: - Private Properties

    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "com.smartcleanerai.networkmonitor")

    // MARK: - Nested Types

    /// Represents the current network connection type.
    enum ConnectionType { case wifi, cellular, wired, unknown }

    // MARK: - Init

    private init() { startMonitoring() }

    // MARK: - Monitoring

    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async { self?.update(from: path) }
        }
        monitor.start(queue: monitorQueue)
    }

    private func update(from path: NWPath) {
        isConnected = path.status == .satisfied
        connectionType = resolveType(from: path)
        AppLogger.infrastructure.debug("Network connected: \(path.status == .satisfied)")
    }

    private func resolveType(from path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi)          { return .wifi }
        if path.usesInterfaceType(.cellular)      { return .cellular }
        if path.usesInterfaceType(.wiredEthernet) { return .wired }
        return .unknown
    }

    deinit { monitor.cancel() }
}
