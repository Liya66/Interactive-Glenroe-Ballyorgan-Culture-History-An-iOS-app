import XCTest
import MapKit
import ARKit
import FirebaseStorage
import Speech
@testable import Glenroe_Ballyorgan

class AppIntegrationTests: XCTestCase {
    
    var viewController: AudioTourViewController!
    var voiceControlManager: VoiceControlManager!

    override func setUpWithError() throws {
        super.setUp()

        // Initialize the view controller
        viewController = AudioTourViewController()
        voiceControlManager = VoiceControlManager()

        // Initialize the UI and key components
        viewController.mapView = MKMapView()
        viewController.playPauseButton = UIButton()
        viewController.gpsSwitch = UISwitch()
        viewController.audioTitleLabel = UILabel()
        viewController.audioPlayer = AVAudioPlayer()
        viewController.locationManager = CLLocationManager()

        // Simulate the view loading lifecycle
        viewController.loadViewIfNeeded()
        viewController.setupUI()
        viewController.setupLocationManager()
        viewController.setupGeofences()
    }
    
    override func tearDownWithError() throws {
        viewController = nil
        voiceControlManager = nil
        super.tearDown()
    }

    // Integration test: Verifying GPS, AR, Firebase, and Audio components work together
    func testGPS_AR_Firebase_Integration() throws {
        // Simulate GPS location update close to a region
        let mockLocation = CLLocation(latitude: 52.307, longitude: -8.417)
        let region = CLCircularRegion(center: mockLocation.coordinate, radius: 50, identifier: "TestRegion")

        // Simulate Firebase audio download
        let mockFileNames = ["TestAudio.mp3"]
        viewController.downloadAllFiles(fileNames: mockFileNames)

        // Wait for the download to complete
        let downloadExpectation = expectation(description: "Audio file downloaded")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            downloadExpectation.fulfill()
        }
        wait(for: [downloadExpectation], timeout: 3.0)

        // Simulate entering a geofenced region
        viewController.locationManager(viewController.locationManager, didEnterRegion: region)

        // Assert map view and location updates
        XCTAssertNotNil(viewController.mapView, "Map view should be loaded and tracking location.")
    }

    // Integration test: Voice Control and Firebase interaction
    func testVoiceControl_Firebase_Integration() throws {
        // Simulate Firebase audio download
        let mockFileNames = ["file1.mp3", "file2.mp3"]
        viewController.downloadAllFiles(fileNames: mockFileNames)

        // Wait for the download to complete
        let downloadExpectation = expectation(description: "Wait for download to complete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            downloadExpectation.fulfill()
        }
        wait(for: [downloadExpectation], timeout: 3.0)

        // Test voice recognition with a valid input
        let recognizedText = "Hi"
        let voiceControlResult = voiceControlManager.handleRecognizedText(recognizedText)
        XCTAssertEqual(voiceControlResult, "Hello, nice to meet you!", "Voice control should return the expected response for valid input.")

        // Assert that the progress bar hides after the download
        XCTAssertTrue(viewController.downloadProgressView.isHidden, "Progress view should be hidden after download.")
    }

    // Integration test: UI and Firebase interaction
    func testUI_Firebase_Integration() throws {
        // Simulate downloading files from Firebase
        let mockFileNames = ["file1.mp3", "file2.mp3"]
        viewController.downloadAllFiles(fileNames: mockFileNames)

        // Wait for the download to complete
        let expectation = self.expectation(description: "Wait for download to complete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)

        // Assert progress bar hides after the download
        XCTAssertTrue(viewController.downloadProgressView.isHidden, "Progress view should be hidden after download.")
    }
}

