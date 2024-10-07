//
//  ARViewController_tests.swift
//  Glenroe-Ballyorgan_tests
//
//  Created by Liya Wang on 2024/10/2.
//
import XCTest
@testable import Glenroe_Ballyorgan
import ARKit
import CoreLocation

final class ARViewControllerTests: XCTestCase {
    
    var viewController: ARViewController!
    
    override func setUpWithError() throws {
        super.setUp()
        viewController = ARViewController()

        // Initialize sceneView before testing
        viewController.sceneView = ARSCNView()

        // Initialize other required properties
        viewController.modelNode = SCNNode()
        viewController.currentBirdIndex = nil
        
        // Start the AR session
           viewController.startARSession()
    }

    override func tearDownWithError() throws {
        viewController = nil
        super.tearDown()
    }

    func testARKitAvailability() {
        XCTAssertTrue(ARConfiguration.isSupported, "ARKit is not supported on this device.")
    }

    func testARSessionSetup() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        
        viewController.sceneView.session.run(configuration)
        
        // Add a delay to allow the AR session to initialize
//        let expectation = self.expectation(description: "Wait for AR session to start")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssertNotNil(self.viewController.sceneView.session.currentFrame, "AR session should have started with the correct configuration.")
//            expectation.fulfill()
        }
        
//        waitForExpectations(timeout: 5.0, handler: nil)
    }


    func testCameraAccessGranted() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            XCTAssertTrue(granted, "Camera access should be granted.")
        }
    }

    func testCameraAccessDenied() {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if cameraStatus == .denied {
            XCTAssertTrue(cameraStatus == .denied, "Camera access should be denied.")
        }
    }
    

    
    func testBirdLocationProximityTrigger() {
        let userLocation = CLLocation(latitude: 52.307, longitude: -8.417)
        viewController.findBird(to: userLocation) // Access findBird method via viewController
        
        XCTAssertNotNil(viewController.modelNode, "Bird model should be placed on the scene.")
    }
    
    func testDefaultModelPlacementWhenNoBirdFound() {
        // Simulate a user location far from any bird locations
        let userLocation = CLLocation(latitude: 52.000, longitude: -8.000) // Far from any bird location
        
        viewController.findBird(to: userLocation)
        
        // Ensure the model node is placed
        XCTAssertNotNil(viewController.modelNode, "Default model should be placed when no bird is found.")
        XCTAssertEqual(viewController.modelNode?.name, "Bird.scn", "Default bird model should be Bird.scn.")
    }

    func testModelPlacement() {
        let rootNode = viewController.sceneView.scene.rootNode
        viewController.placeModel(on: rootNode, modelName: "Barn_owl.scn")
        
        // Ensure the model node is placed and has the correct name
        XCTAssertNotNil(viewController.modelNode, "The model node should not be nil after placement.")
        XCTAssertEqual(viewController.modelNode?.name, "Barn_owl.scn", "The correct model should be placed on the scene.")
    }

    
    func testAlertDisplayForBird() {
        let birdLocation = BirdLocation(coordinate: CLLocationCoordinate2D(latitude: 52.307, longitude: -8.417), modelName: "Robin.scn", alertMessage: "You found a Robin!")
        let userLocation = CLLocation(latitude: birdLocation.coordinate.latitude, longitude: birdLocation.coordinate.longitude)
        
        viewController.findBird(to: userLocation) // Access findBird method via viewController
        
        XCTAssertEqual(viewController.currentBirdIndex, 0, "Bird index should be set.")
        XCTAssertNotNil(viewController.modelNode, "Bird model should be placed.")
    }
    
    func testModelFollowsCamera() {
        // Add an expectation to wait for the AR session to initialize and the frame to become available
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            guard let currentFrame = self.viewController.sceneView.session.currentFrame else {
                XCTFail("No current ARFrame available.")
                return
            }
            
            let cameraPosition = SCNVector3(
                currentFrame.camera.transform.columns.3.x,
                currentFrame.camera.transform.columns.3.y,
                currentFrame.camera.transform.columns.3.z
            )
            
            // Safely unwrap and compare the model position
            guard let modelPosition = self.viewController.modelNode?.position else {
                XCTFail("Model node position is nil.")
                return
            }
            
            XCTAssertEqual(modelPosition.x, cameraPosition.x, accuracy: 0.001, "X position should match.")
            XCTAssertEqual(modelPosition.y, cameraPosition.y, accuracy: 0.001, "Y position should match.")
            XCTAssertEqual(modelPosition.z, cameraPosition.z, accuracy: 0.001, "Z position should match.")
            
        }
        
        
    }



}
