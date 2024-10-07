

import UIKit
import MapKit

// Extension for UI setup and constraints
extension AudioTourViewController {
    func setupUI() {
        // GPS Detechtion Label
        gpsLabel = UILabel()
        gpsLabel.translatesAutoresizingMaskIntoConstraints = false
        gpsLabel.text = "GPS Detection"
        gpsLabel.textColor = UIColor(red: 2/255, green: 48/255, blue: 71/255, alpha: 1.0)
        self.view.addSubview(gpsLabel)
        
        
        gpsSwitch = UISwitch()
        gpsSwitch.translatesAutoresizingMaskIntoConstraints = false
        gpsSwitch.addTarget(self, action: #selector(toggleGPS), for: .valueChanged)
        self.view.addSubview(gpsSwitch)
        
        // Audio Controls Container
        audioControlsView = UIView()
        audioControlsView.translatesAutoresizingMaskIntoConstraints = false
        audioControlsView.backgroundColor = UIColor(red: 142/255, green: 202/255, blue: 230/255, alpha: 0.5) // #8ecae6 color
        audioControlsView.layer.cornerRadius = 10
        self.view.addSubview(audioControlsView)
        
        // Play/Pause button with image
        playPauseButton = UIButton(type: .system)
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        playPauseButton.tintColor = UIColor(red: 2/255, green: 48/255, blue: 71/255, alpha: 0.8)
        playPauseButton.addTarget(self, action: #selector(playPauseAudio), for: .touchUpInside)
        audioControlsView.addSubview(playPauseButton)
        
        // Progress Slider
        progressSlider = UISlider()
        progressSlider.translatesAutoresizingMaskIntoConstraints = false
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = 1
        progressSlider.minimumTrackTintColor = UIColor(red: 33/255, green: 158/255, blue: 188/255, alpha: 1.0) //a lighter blue
        progressSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        audioControlsView.addSubview(progressSlider)
        
        // Duration Label
        durationLabel = UILabel()
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.text = "00:00 / 00:00"
        durationLabel.textColor = UIColor(red: 2/255, green: 48/255, blue: 71/255, alpha: 1.0)
        audioControlsView.addSubview(durationLabel)
        
        
        // Audio Title Label
        audioTitleLabel = UILabel()
        audioTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        audioTitleLabel.text = "-No Audio Being Played-"  // Default text when no audio is playing
        audioTitleLabel.textColor = UIColor(red: 2/255, green: 48/255, blue: 71/255, alpha: 0.9)
        audioControlsView.addSubview(audioTitleLabel)
        
        
        downloadButton = UIButton(type: .system)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.setTitle("Download", for: .normal)
        downloadButton.setTitleColor(UIColor(red: 2/255, green: 48/255, blue: 71/255, alpha: 0.6), for: .normal)
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        self.view.addSubview(downloadButton)
        
        downloadProgressView = UIProgressView(progressViewStyle: .default)
        downloadProgressView.translatesAutoresizingMaskIntoConstraints = false
        downloadProgressView.progress = 0
        downloadProgressView.isHidden = true
        self.view.addSubview(downloadProgressView)
        
        
        
        // Setup MapView
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        mapView.showsUserLocation = true
        //        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 52.64035, longitude: -8.58330), latitudinalMeters: 2000, longitudinalMeters: 2000) //the welcome location
        //        mapView.setRegion(region, animated: true)
        
        self.view.addSubview(mapView)
        
        setupConstraints() // Call the constraints setup here
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // GPS Label
            gpsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            gpsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // GPS Switch
            gpsSwitch.centerYAnchor.constraint(equalTo: gpsLabel.centerYAnchor),
            gpsSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Audio Controls Container
            audioControlsView.topAnchor.constraint(equalTo: gpsSwitch.bottomAnchor, constant: 20),
            audioControlsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            audioControlsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            audioControlsView.heightAnchor.constraint(equalToConstant: 130), // Adjust height as needed
            
            // Audio Title Label
            audioTitleLabel.topAnchor.constraint(equalTo: audioControlsView.topAnchor, constant: 15), // Swapped with playPauseButton
            audioTitleLabel.centerXAnchor.constraint(equalTo: audioControlsView.centerXAnchor),
            
            // Play/Pause Button
            playPauseButton.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 8), // Swapped with audioTitleLabel
            playPauseButton.leadingAnchor.constraint(equalTo: audioControlsView.leadingAnchor, constant: 20),
            
            
            
            // Progress Slider
            progressSlider.topAnchor.constraint(equalTo: audioTitleLabel.bottomAnchor, constant: 20),
            progressSlider.leadingAnchor.constraint(equalTo: audioControlsView.leadingAnchor, constant: 20),
            progressSlider.trailingAnchor.constraint(equalTo: audioControlsView.trailingAnchor, constant: -20),
            
            // Duration Label
            durationLabel.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 14),
            durationLabel.trailingAnchor.constraint(equalTo: audioControlsView.trailingAnchor, constant: -20),
            
            
            
            // Download button
            downloadButton.topAnchor.constraint(equalTo: audioControlsView.bottomAnchor, constant: 5),
            downloadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // Download progress view
            downloadProgressView.topAnchor.constraint(equalTo: downloadButton.bottomAnchor, constant: 5),
            downloadProgressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            downloadProgressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Map view
            mapView.topAnchor.constraint(equalTo: downloadProgressView.bottomAnchor, constant: 5),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
