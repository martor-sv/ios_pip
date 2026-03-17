import Foundation

class NetworkMonitor: ObservableObject {
    @Published var downloadSpeed: Double = 0
    @Published var uploadSpeed: Double = 0
    
    private var lastReceivedBytes: UInt64 = 0
    private var lastSentBytes: UInt64 = 0
    private var timer: Timer?
    
    init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateUsage()
        }
    }
    
    private func updateUsage() {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return }
        defer { freeifaddrs(ifaddr) }
        
        var totalReceived: UInt64 = 0
        var totalSent: UInt64 = 0
        
        var ptr = ifaddr
        while ptr != nil {
            defer { ptr = ptr?.pointee.ifa_next }
            
            guard let interface = ptr?.pointee else { continue }
            let name = String(cString: interface.ifa_name)
            
            // Only monitor cellular and wifi
            if name == "en0" || name == "pdp_ip0" {
                if let data = interface.ifa_data?.assumingMemoryBound(to: if_data.self).pointee {
                    totalReceived += UInt64(data.ifi_ibytes)
                    totalSent += UInt64(data.ifi_obytes)
                }
            }
        }
        
        if lastReceivedBytes != 0 {
            downloadSpeed = Double(totalReceived - lastReceivedBytes) / 1024.0 // KB/s
        }
        if lastSentBytes != 0 {
            uploadSpeed = Double(totalSent - lastSentBytes) / 1024.0 // KB/s
        }
        
        lastReceivedBytes = totalReceived
        lastSentBytes = totalSent
    }
    
    func formattedSpeed(_ speed: Double) -> String {
        if speed > 1024 {
            return String(format: "%.1f MB/s", speed / 1024.0)
        } else {
            return String(format: "%.0f KB/s", speed)
        }
    }
}
