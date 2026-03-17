import SwiftUI
import AVFoundation

@main
struct NetworkPiPApp: App {
    init() {
        configureAudioSession()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            print("DEBUG: Audio Session configured successfully")
        } catch {
            print("DEBUG: Failed to set audio session category: \(error)")
        }
    }
}
