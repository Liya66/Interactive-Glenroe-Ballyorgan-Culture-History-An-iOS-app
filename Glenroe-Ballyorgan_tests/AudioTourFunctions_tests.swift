//
//  AudioTourFunctions_tests.swift
//  Glenroe-Ballyorgan_tests
//
//  Created by Liya Wang on 2024/10/3.
//
@testable import Glenroe_Ballyorgan
import XCTest
import MapKit
import CoreLocation
import AVFAudio

final class AudioTourFunctions_tests: XCTestCase {
    var viewController: AudioTourViewController!
    override func setUpWithError() throws {
        super.setUp()

        // Initialize the view controller
        viewController = AudioTourViewController()

        // Manually initialize the UI components, as viewDidLoad is not automatically called in unit tests
        viewController.mapView = MKMapView()  // Initialize the map view
        viewController.downloadProgressView = UIProgressView()  // Initialize the progress view
        viewController.playPauseButton = UIButton()  // Initialize the play/pause button
        viewController.gpsSwitch = UISwitch()  // Initialize the GPS switch
        viewController.durationLabel = UILabel()  // Initialize the duration label
        viewController.progressSlider = UISlider()  // Initialize the progress slider
        viewController.audioTitleLabel = UILabel()  // Initialize the audio title label

        // Trigger viewDidLoad lifecycle to ensure UI components are initialized
        viewController.loadViewIfNeeded()  // This will call viewDidLoad and setupUI if defined there

        // Set up any additional properties if needed
        viewController.setupUI()  // If setupUI() does additional UI setup
    }

    
    //test gps location updates
    
    func testLocationManagerSetup() {
        viewController.setupLocationManager()
        
        XCTAssertNotNil(viewController.locationManager, "Location Manager should be initialized.")
        XCTAssertEqual(viewController.locationManager.desiredAccuracy, kCLLocationAccuracyBest, "Location accuracy should be set to best.")
    }

    // test geofence setup
    func testGeofenceSetup() {
        viewController.setupGeofences()

        XCTAssertEqual(viewController.locationManager.monitoredRegions.count, locations.count, "All geofences should be set up.")
        
        // Check that a specific region is being monitored
        let firstLocation = locations.first!
        XCTAssertTrue(viewController.locationManager.monitoredRegions.contains(where: { $0.identifier == firstLocation.name }), "Geofence should be set for the first location.")
    }

    
  
    
    
    func testRegionEntryTriggersAudio() throws {
        throw XCTSkip("Skipping due to issues with simulating geofencing in a test environment.")
        // Given: Setup a mock GPS location and region
        let location = CLLocation(latitude: 52.307, longitude: -8.417)
        let region = CLCircularRegion(center: location.coordinate, radius: 50, identifier: "TestRegion")
        
        // Setup mock location data for downloading audio
        let mockLocationData = LocationData(name: "TestRegion", latitude: 52.307, longitude: -8.417, audioFileName: "TestAudio")
        viewController.locations = [mockLocationData]

        // Simulate download of the audio file
        viewController.downloadAllFiles(fileNames: ["TestAudio"])

        // Wait for the download to complete and then simulate region entry
        let expectation = self.expectation(description: "Audio should play after entering region")

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            // Simulate entering the geofenced region
            self.viewController.locationManager(self.viewController.locationManager, didEnterRegion: region)

            // Check if audio is playing
            XCTAssertNotNil(self.viewController.audioPlayer, "Audio should start playing when entering a geofenced region.")
            
            // Check if the correct audio title is set
            XCTAssertEqual(self.viewController.audioTitleLabel.text, "TestRegion", "The correct audio title should be displayed.")
            
            // Fulfill the expectation
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    

    }




    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            viewController.downloadAllFiles(fileNames: ["file1.mp3", "file2.mp3"])
        }
    }

}
