import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var monitor = NetworkMonitor()
    @StateObject private var pipManager = PiPManager()
    
    var body: some View {
        VStack(spacing: 30) {
            Text("实时网络速度")
                .font(.largeTitle)
                .fontWeight(.black)
                .padding(.top)
            
            VStack(spacing: 20) {
                SpeedCard(title: "下载", speed: monitor.downloadSpeed, icon: "arrow.down.circle.fill", color: .blue)
                SpeedCard(title: "上传", speed: monitor.uploadSpeed, icon: "arrow.up.circle.fill", color: .green)
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                pipManager.togglePiP()
            }) {
                HStack {
                    Image(systemName: pipManager.isPiPActive ? "stop.fill" : "pip.enter")
                    Text(pipManager.isPiPActive ? "关闭画中画" : "开启画中画")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(15)
                .font(.headline)
            }
            .padding()
        }
        .onAppear {
            // Wait a bit for the layout to finish
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first,
                   let rootViewController = window.rootViewController {
                    pipManager.setupPiP(withView: PiPContentView(monitor: monitor), sourceView: rootViewController.view)
                }
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                if !pipManager.isPiPActive {
                    monitor.stopMonitoring()
                }
            } else if newPhase == .active {
                monitor.startMonitoring()
            }
        }
        .onChange(of: pipManager.isPiPActive) { isActive in
            if !isActive && scenePhase == .background {
                monitor.stopMonitoring()
            } else if isActive {
                monitor.startMonitoring()
            }
        }
    }
}

struct SpeedCard: View {
    let title: String
    let speed: Double
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(formattedSpeed(speed))
                    .font(.title2)
                    .fontWeight(.bold)
                    .italic()
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(15)
    }
    
    func formattedSpeed(_ speed: Double) -> String {
        if speed > 1024 {
            return String(format: "%.2f MB/s", speed / 1024.0)
        } else {
            return String(format: "%.0f KB/s", speed)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
