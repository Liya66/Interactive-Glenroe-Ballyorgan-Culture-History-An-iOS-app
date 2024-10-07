//
//  AudioTourViewController.swift
//  Glenroe-Ballyorgan
//
//  Created by Liya Wang on 2024/9/3.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation
import FirebaseStorage

struct LocationData {
    let name: String
    let latitude: Double
    let longitude: Double
    let audioFileName: String
}


class AudioTourViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, AVAudioPlayerDelegate {

    // UI Components
    var mapView: MKMapView!
    var gpsSwitch: UISwitch!
    var playPauseButton: UIButton!
    var progressSlider: UISlider!
    var downloadButton: UIButton!
    var downloadProgressView: UIProgressView!
    var durationLabel: UILabel!
    var  gpsLabel: UILabel!
    var audioControlsView: UIView!
    var audioTitleLabel: UILabel!

    
    // Audio and GPS related properties
    var locationManager: CLLocationManager!
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    var isGPSEnabled: Bool = true
    var currentRegion: String?
    
//    var locations: [LocationData] = []  *enable ONLY when TESTING the TEST TARGET!!!

  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup UI
        setupUI()
        
        // Setup MapView
        setupMapView()
        
        // Setup CLLocationManager for GPS
        setupLocationManager()
        
        // Initialize the GPS switch state
      
        
        gpsSwitch.isOn = false
        isGPSEnabled = false  // Disable GPS features by default

        // Setup Geofences for triggering audio by location
        setupGeofences()
        
        //
        self.view.backgroundColor = .white
        
        // Configure the audio session
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Failed to set audio session category: \(error)")
            }
    }

    // MARK: - Setup MapView

    
        func setupMapView() {
       
            mapView.showsUserLocation = true // show current user location
            // Add annotations for locations
            setupAnnotations()
        }
    
    func setupAnnotations() {
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.title = location.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            mapView.addAnnotation(annotation)
        }
    }

    // MARK: - Setup Location Manager

    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        
        
        // Move the map to the user's location
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        //  print the location for debugging purposes
        print("Updated location: \(location.coordinate), accuracy: \(location.horizontalAccuracy)")
    }

    internal func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if isGPSEnabled, region is CLCircularRegion {
            // Check if already triggered this region
            guard currentRegion != region.identifier else {
                return
            }

            // Trigger the new region and update the current region
            handleRegionEvent(for: region)
            currentRegion = region.identifier
        }
    }

    internal func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if isGPSEnabled, region is CLCircularRegion {
            if currentRegion == region.identifier {
                currentRegion = nil  // Only reset if we leave the current region
            }
        }
    }

    // MARK: - Setup Geofences

    func setupGeofences() {
        for location in locations {
            let identifier = location.name
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), radius: 50, identifier: identifier)
            region.notifyOnEntry = true
            region.notifyOnExit = true
            locationManager.startMonitoring(for: region)
            print("Geofence added for location: \(identifier)")
        }
       
    }



    // MARK: - GPS Toggle

   
    @objc func toggleGPS() {
        isGPSEnabled = gpsSwitch.isOn
        if isGPSEnabled {
            locationManager.startUpdatingLocation()
            setupGeofences() // Ensure geofences are re-registered
            print("GPS-triggered audio is ON")
        } else {
            locationManager.stopUpdatingLocation()
            locationManager.monitoredRegions.forEach { locationManager.stopMonitoring(for: $0) }
            print("GPS-triggered audio is OFF")
        }
    }

    @objc func playPauseAudio() {
        guard let player = audioPlayer else { return }

        if player.isPlaying {
               player.pause()
               playPauseButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
           } else {
               player.play()
               playPauseButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
               startProgressTimer()
           }
    }

    @objc func sliderValueChanged() {
        guard let player = audioPlayer else { return }
        player.currentTime = TimeInterval(progressSlider.value) * player.duration
    }

    // MARK: - Progress Timer

    func startProgressTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateProgress()
        }
    }

    func updateProgress() {
        guard let player = audioPlayer else { return }
        
        // Update slider progress
        progressSlider.value = Float(player.currentTime / player.duration)
        
        // Update the duration label with current time and total duration
        updateDurationLabel()
    }
    
    func updateDurationLabel() {
        guard let player = audioPlayer else { return }

        let currentTime = player.currentTime
        let totalDuration = player.duration

        durationLabel.text = "\(formatTime(currentTime)) / \(formatTime(totalDuration))"
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }


    func handleRegionEvent(for region: CLRegion) {
        print("Entered region: \(region.identifier)")
        playAudio(for: region.identifier)
    }

    // MARK: - MapView Annotation Selection

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            
            if let annotationTitle = annotation.title {
                print("Annotation \(annotationTitle ?? "No Title") selected")
                playAudio(for: annotationTitle ?? "")
            }
        }

    }

    // MARK: - Audio Playback

    func playAudio(for identifier: String) {
        // Find the location data that matches the identifier
        guard let location = locations.first(where: { $0.name == identifier }) else {
            print("No matching audio for the identifier \(identifier)")
            return
        }
        
        let audioFileName = location.audioFileName
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioURL = documentsURL.appendingPathComponent("\(audioFileName).mp3")

        guard FileManager.default.fileExists(atPath: audioURL.path) else {
            showAlertForDownload()
            print("Audio file not found at path: \(audioURL.path)")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.play()
            playPauseButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal) //update UI
            audioTitleLabel.text = identifier  // Set to the name or identifier of the audio being played
            startProgressTimer()
        } catch {
            print("Failed to play audio: \(error.localizedDescription)")
        }
    }


    // MARK: - Firebase Download

    @objc func downloadButtonTapped() {
        showDownloadProgressAlert()
        listAllFiles { fileNames in
            self.downloadAllFiles(fileNames: fileNames)
        }
    }

    func showDownloadProgressAlert() {
        downloadProgressView.progress = 0.0
        downloadProgressView.isHidden = false
    }

    func listAllFiles(completion: @escaping ([String]) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://glenroe-ballyorgan.appspot.com")
        
        var fileNames: [String] = []
        
        // List all items under the root folder
        storageRef.listAll { (result, error) in
            if let error = error {
                print("Error listing files: \(error.localizedDescription)")
                completion([])
                return
            }
            
            for item in result!.items {
                fileNames.append(item.name)
            }
            
            completion(fileNames)
        }
    }
    
    func downloadAllFiles(fileNames: [String]) {
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://glenroe-ballyorgan.appspot.com")
        
        for (index, fileName) in fileNames.enumerated() {
            let fileRef = storageRef.child(fileName)
            let localURL = getLocalFileURL(fileName: fileName)
            
            let downloadTask = fileRef.write(toFile: localURL) { url, error in
                if let error = error {
                    print("Failed to download \(fileName): \(error.localizedDescription)")
                    return
                }
                print("\(fileName) downloaded to: \(url!.path)")
                
                if index == fileNames.count - 1 {
                    self.downloadProgressView.isHidden = true // Hide the progress bar after the download completes
                }
            }
            
            downloadTask.observe(.progress) { snapshot in
                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                    / Double(snapshot.progress!.totalUnitCount)
                self.updateProgress(percent: percentComplete)
            }
        }
    }
    
    func getLocalFileURL(fileName: String) -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL.appendingPathComponent(fileName)
    }
    
    func updateProgress(percent: Double) {
        DispatchQueue.main.async {
            self.downloadProgressView.progress = Float(percent / 100.0)
        }
    }
    // Function to show alert if the file is missing
    func showAlertForDownload() {
        let alert = UIAlertController(title: "Download Needed",
                                      message: "Please press download",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Download", style: .default, handler: { _ in
            self.downloadButtonTapped()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

