import SwiftUI

struct PiPContentView: View {
    @ObservedObject var monitor: NetworkMonitor
    
    var body: some View {
        ZStack {
            // Semi-transparent background for better contrast
            Color.black.opacity(0.1).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 8) {
                HStack {
                    Label {
                        Text(monitor.formattedSpeed(monitor.downloadSpeed))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            
                    } icon: {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    Label {
                        Text(monitor.formattedSpeed(monitor.uploadSpeed))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    } icon: {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                .font(.system(size: 18, weight: .semibold, design: .monospaced))
                
                // Add a small divider or indicator if needed, 
                // but keep it clean for small sizes
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
