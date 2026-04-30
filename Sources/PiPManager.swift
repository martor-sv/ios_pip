import AVKit
import SwiftUI

class PiPManager: NSObject, ObservableObject {
    private var pipController: AVPictureInPictureController?
    private var pipVideoCallViewController: AVPictureInPictureVideoCallViewController?
    
    @Published var isPiPActive: Bool = false
    @Published var canStartPiP: Bool = false
    
    func setupPiP<Content: View>(withView content: Content, sourceView: UIView) {
        print("DEBUG: Setting up PiP...")
        
        let screenBounds = UIScreen.main.bounds
        let pipWidth = min(screenBounds.width * 0.8, 300)
        let pipHeight: CGFloat = 80
        let pipSize = CGSize(width: pipWidth, height: pipHeight)
        
        let hostingController = UIHostingController(rootView: content)
        hostingController.view.frame = CGRect(origin: .zero, size: pipSize)
        hostingController.view.backgroundColor = .clear
        
        pipVideoCallViewController = AVPictureInPictureVideoCallViewController()
        pipVideoCallViewController?.preferredContentSize = pipSize
        pipVideoCallViewController?.view.addSubview(hostingController.view)
        pipVideoCallViewController?.view.backgroundColor = .clear
        
        // Ensure constraints are set up
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: pipVideoCallViewController!.view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: pipVideoCallViewController!.view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: pipVideoCallViewController!.view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: pipVideoCallViewController!.view.trailingAnchor)
        ])
        
        let contentSource = AVPictureInPictureController.ContentSource(
            activeVideoCallSourceView: sourceView,
            contentViewController: pipVideoCallViewController!
        )
        
        pipController = AVPictureInPictureController(contentSource: contentSource)
        pipController?.delegate = self
        pipController?.canStartPictureInPictureAutomaticallyFromInline = true
        
        updatePiPStatus()
    }
    
    func updatePiPStatus() {
        self.canStartPiP = AVPictureInPictureController.isPictureInPictureSupported()
        print("DEBUG: PiP Supported: \(AVPictureInPictureController.isPictureInPictureSupported())")
        print("DEBUG: PiP Possible: \(pipController?.isPictureInPicturePossible ?? false)")
    }
    
    func togglePiP() {
        guard let controller = pipController else {
            print("DEBUG: PiP Controller is nil")
            return
        }
        
        updatePiPStatus()
        
        if controller.isPictureInPictureActive {
            print("DEBUG: Stopping PiP")
            controller.stopPictureInPicture()
        } else {
            if controller.isPictureInPicturePossible {
                print("DEBUG: Starting PiP")
                controller.startPictureInPicture()
            } else {
                print("DEBUG: PiP is currently not possible. Check Audio Session and Source View.")
            }
        }
    }
}

extension PiPManager: AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        isPiPActive = true
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        isPiPActive = false
    }
}
