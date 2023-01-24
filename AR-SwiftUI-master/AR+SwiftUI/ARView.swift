import Foundation
import ARKit
import SwiftUI

// MARK: - ARViewIndicator
struct ARViewIndicator: UIViewControllerRepresentable {
   typealias UIViewControllerType = ARView
   
   func makeUIViewController(context: Context) -> ARView {
      return ARView()
   }
   func updateUIViewController(_ uiViewController:
   ARViewIndicator.UIViewControllerType, context:
   UIViewControllerRepresentableContext<ARViewIndicator>) { }
}


class ARView: UIViewController, ARSCNViewDelegate, ARCoachingOverlayViewDelegate{
   
   var arView: ARSCNView {
      return self.view as! ARSCNView
   }
   override func loadView() {
     self.view = ARSCNView(frame: .zero)
   }
   override func viewDidLoad() {
      super.viewDidLoad()
      arView.delegate = self
      arView.scene = SCNScene()
      addCoaching()
       
   }
   // MARK: - Functions for standard AR view handling
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
   }
   override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
   }
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      let configuration = ARWorldTrackingConfiguration()
      arView.session.run(configuration)
      arView.delegate = self
       
   }
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      arView.session.pause()
   }
    // MARK: - ARCoachingOverlayViewDelegate
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        #if !targetEnvironment(simulator)
        coachingOverlay.session = self.arView.session
        #endif
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.activatesAutomatically = true
        self.view.addSubview(coachingOverlay)
        
        self.arView.addSubview(coachingOverlay)
    }
    
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("did deactivate")
    }
    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {

        // Reset the session.
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        arView.session.run(configuration, options: [.resetTracking])

        // Custom actions to restart the AR experience.
        // ...
    }
    
    
   // MARK: - ARSCNViewDelegate
   func sessionWasInterrupted(_ session: ARSession) {}
   func sessionInterruptionEnded(_ session: ARSession) {}
   func session(_ session: ARSession, didFailWithError error: Error){}
   func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera){}
}

