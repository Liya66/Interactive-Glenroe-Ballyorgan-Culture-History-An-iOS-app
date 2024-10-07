//  TestARViewController.swift
//  Glenroe-Ballyorgan
// Ballyhoura
//  Created by Liya Wang on 2024/8/3.
//

import UIKit
import ARKit
import SceneKit
import Speech
import CoreImage

struct BirdLocation {
    let coordinate: CLLocationCoordinate2D
    let modelName: String
    let alertMessage: String
}

class ARViewController: UIViewController, SFSpeechRecognizerDelegate, CLLocationManagerDelegate {
    
    var sceneView: ARSCNView!
    var modelNode: SCNNode?
    var locationManager = CLLocationManager()
    var userLocation: CLLocation?
    var voiceControlManager: VoiceControlManager?
    var currentBirdIndex: Int? = nil // To keep track of which bird is currently displayed

    
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private let audioEngine = AVAudioEngine()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize and configure the ARSCNView
        sceneView = ARSCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
       
        // Allow camera control for testing purposes
        sceneView.allowsCameraControl = true
        
        // Check and request camera access, then start the AR session
        checkCameraPermission()
        
        // Request location authorization
               locationManager.delegate = self
               locationManager.requestWhenInUseAuthorization()

               // Start tracking the user's location
               locationManager.startUpdatingLocation()
        
        voiceControlManager = VoiceControlManager()

                voiceControlManager?.onRecognizedText = { [weak self] text in
                    let response = self?.voiceControlManager?.handleRecognizedText(text) ?? ""
                    self?.showAlert(message: response)
                }

                voiceControlManager?.startListening()
    }
        
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bird Message",
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Start listening again after the user dismisses the alert
            self.voiceControlManager?.startListening()
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    
    func checkCameraPermission() {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if cameraStatus == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.startARSession()
                    }
                } else {
                    print("Camera access denied")
                    self.showCameraAccessAlert()
                }
            }
        } else if cameraStatus == .authorized {
            startARSession()
        } else {
            print("Camera access denied or restricted")
            showCameraAccessAlert()
        }
    }
    
    func startARSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        sceneView.session.run(configuration)
        
        addLighting()
    }
    
    func addLighting() {

    }
    
    func showCameraAccessAlert() {
        let alert = UIAlertController(title: "Camera Access Needed",
                                      message: "This app requires camera access to display AR content. Please enable it in Settings.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    

        // Location update handler
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                userLocation = location
                findBird(to: location)  // Check proximity each time location updates
            }
        }

        // Handle authorization status change (optional, but useful)
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                locationManager.startUpdatingLocation()
            }
        }
        
        
    // Check proximity to each bird location
    func findBird(to userLocation: CLLocation) {
        var birdFound = false
        for (index, birdLocation) in birdLocations.enumerated() {
            let birdCLLocation = CLLocation(latitude: birdLocation.coordinate.latitude, longitude: birdLocation.coordinate.longitude)
            let distance = userLocation.distance(from: birdCLLocation)
            
            if distance < 30 {
                if currentBirdIndex != index {
                    currentBirdIndex = index
                    placeModel(on: sceneView.scene.rootNode, modelName: birdLocation.modelName)
                    showAlert(message: birdLocation.alertMessage)
                }
                birdFound = true
                break
            }
        }
        
        // If no bird found within range, load default model
        if !birdFound {
            placeModel(on: sceneView.scene.rootNode, modelName: "Bird.scn") // Change "DefaultModel.scn" accordingly
            currentBirdIndex = nil // Reset the index
        }
    }

    
    func placeModel(on node: SCNNode, modelName: String) {
        // Load the 3D model from the provided modelName
        if let scene = SCNScene(named: modelName) {
            if let model = scene.rootNode.childNodes.first {
                // Safely remove the existing model if it exists
                modelNode?.removeFromParentNode()
                
                // Assign the new model
                modelNode = model
                
                // Set the modelNode's name (if it's not already set in the .scn file)
                modelNode?.name = modelName
                
                // Add the new model to the scene
                node.addChildNode(modelNode!)
            } else {
                print("Failed to find a model in the scene file: \(modelName)")
            }
        } else {
            print("Failed to load the SCN file: \(modelName)")
        }
    }


}

extension ARViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

        if modelNode == nil {
            let width = CGFloat(planeAnchor.extent.x)
            let height = CGFloat(planeAnchor.extent.z)

            let plane = SCNPlane(width: width, height: height)
            plane.materials.first?.diffuse.contents = UIColor(white: 1.0, alpha: 0.3)

            let planeNode = SCNNode(geometry: plane)
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            planeNode.eulerAngles.x = -.pi / 2

            node.addChildNode(planeNode)

            // Ensure userLocation is available before calling checkProximity
                    if let location = userLocation {
                        findBird(to: location)
                    }

        }
    }

        func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
            guard let currentFrame = sceneView.session.currentFrame else { return }
            
            // Get the camera's transform matrix
            let cameraTransform = currentFrame.camera.transform
            
            // Extract the position from the camera's transform matrix
            let cameraPosition = SCNVector3(
                cameraTransform.columns.3.x, // m41
                cameraTransform.columns.3.y, // m42
                cameraTransform.columns.3.z  // m43
            )
            
            // Update the model node's position to follow the camera
            modelNode?.position = cameraPosition
        }
    }
    

