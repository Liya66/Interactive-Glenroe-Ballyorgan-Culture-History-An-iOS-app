//
//  InteractiveExperienceViewController.swift
//  Glenroe-Ballyorgan
//
//  Created by Liya Wang on 2024/9/21.
//
import UIKit
import WebKit
import UIKit
import WebKit

class InteractiveExperienceViewController: UIViewController {

    // UI Elements
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let screenTitleLabel = UILabel()
    
    let birdTourTitleLabel = UILabel()
    let audioTourTitleLabel = UILabel()
    
    let birdTourWebView = WKWebView()
    let audioTourWebView = WKWebView()
    
    let birdTourStartButton = UIButton(type: .system)
    let birdTourViewButton = UIButton(type: .system)
    
    let audioTourStartButton = UIButton(type: .system)
    let audioTourViewButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View background color
        view.backgroundColor = .white
        
        // Setup ScrollView and ContentView
        setupScrollView()
        setupUI()
        setupConstraints()
        
        // Load URLs in WebViews
        loadTourURLs()
    }
    
    func setupScrollView() {
        // Add ScrollView and ContentView to the main view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Enable auto layout
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set scrollView constraints to fill the whole screen
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView constraints inside the scrollView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Set content height as 1.2 times the screen height
        let screenHeight = UIScreen.main.bounds.height
        contentView.heightAnchor.constraint(equalToConstant: screenHeight * 1.2).isActive = true
    }

    func setupUI() {
        // Screen title label
        screenTitleLabel.text = "Interactive Tours"
        screenTitleLabel.font = UIFont(name: "AvenirNext-Bold", size: 24)
        screenTitleLabel.textColor = UIColor(red: 2/255, green: 48/255, blue: 71/255, alpha: 1.0)
        screenTitleLabel.textAlignment = .left // Left aligned
        contentView.addSubview(screenTitleLabel)
        
        // Bird Tour title
        birdTourTitleLabel.text = "AR Bird Finding Tour Along Keale River"
        birdTourTitleLabel.font = UIFont(name: "AvenirNext-Medium", size: 20)
        birdTourTitleLabel.textColor = UIColor(red: 2/255, green: 48/255, blue: 71/255, alpha: 1.0)
        birdTourTitleLabel.numberOfLines = 0
        birdTourTitleLabel.textAlignment = .left // Left aligned
        contentView.addSubview(birdTourTitleLabel)
        
        // Audio Tour title
        audioTourTitleLabel.text = "Audio Stories of Ballyhoura Region"
        audioTourTitleLabel.font = UIFont(name: "AvenirNext-Medium", size: 20)
        audioTourTitleLabel.textColor = UIColor(red: 2/255, green: 48/255, blue: 71/255, alpha: 1.0)
        audioTourTitleLabel.numberOfLines = 0
        audioTourTitleLabel.textAlignment = .left // Left aligned
        contentView.addSubview(audioTourTitleLabel)
        
        // Bird Tour WebView
        birdTourWebView.layer.borderWidth = 0.5
        birdTourWebView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.addSubview(birdTourWebView)
        
        // Audio Tour WebView
        audioTourWebView.layer.borderWidth = 1
        audioTourWebView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.addSubview(audioTourWebView)
        
        // Bird Tour Start Button (Filled button)
        birdTourStartButton.setTitle("Start AR Riverwalk", for: .normal)
        birdTourStartButton.backgroundColor = UIColor(red: 33/255, green: 158/255, blue: 188/255, alpha: 1.0) //a lighter blue
        birdTourStartButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        birdTourStartButton.setTitleColor(.white, for: .normal)
        birdTourStartButton.addTarget(self, action: #selector(navigateToARTour), for: .touchUpInside) // Add action
        contentView.addSubview(birdTourStartButton)
        
        // Bird Tour View Button with system image
        birdTourViewButton.setTitle("View Map ", for: .normal)
        birdTourViewButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        birdTourViewButton.setImage(UIImage(systemName: "location.circle"), for: .normal) // Add system image
        birdTourViewButton.setTitleColor(.gray, for: .normal)
        birdTourViewButton.addTarget(self, action: #selector(navigateToRiverMap), for: .touchUpInside) // Add action
        contentView.addSubview(birdTourViewButton)
        
        // Audio Tour Start Button (Filled button)
        audioTourStartButton.setTitle("Start Audio Story Tour", for: .normal)
        audioTourStartButton.backgroundColor = UIColor(red: 251/255, green: 133/255, blue: 0/255, alpha: 1.0) //orange
        audioTourStartButton.setTitleColor(.white, for: .normal)
        audioTourStartButton.addTarget(self, action: #selector(navigateToAudioTour), for: .touchUpInside) // Add action
        contentView.addSubview(audioTourStartButton)
        
        // Audio Tour View Button with system image
        audioTourViewButton.setTitle("View Map", for: .normal)
        audioTourViewButton.setImage(UIImage(systemName: "location.circle"), for: .normal) // Add system image
        audioTourViewButton.setTitleColor(.gray, for: .normal)
        audioTourViewButton.addTarget(self, action: #selector(navigateToAudioTourMap), for: .touchUpInside) // Add action
        contentView.addSubview(audioTourViewButton)
    }
    
    func setupConstraints() {
        // Disable autoresizing masks for Auto Layout
        screenTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        birdTourTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        audioTourTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        birdTourWebView.translatesAutoresizingMaskIntoConstraints = false
        audioTourWebView.translatesAutoresizingMaskIntoConstraints = false
        birdTourStartButton.translatesAutoresizingMaskIntoConstraints = false
        birdTourStartButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        birdTourStartButton.layer.cornerRadius = 10  // Adjust this value as needed
        birdTourStartButton.clipsToBounds = true     // Ensures the corners are clipped

        
        birdTourViewButton.translatesAutoresizingMaskIntoConstraints = false
        audioTourStartButton.translatesAutoresizingMaskIntoConstraints = false
        audioTourStartButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        audioTourStartButton.layer.cornerRadius = 10 //corner
        birdTourStartButton.clipsToBounds = true
        audioTourViewButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Define Constraints
        NSLayoutConstraint.activate([
            // Screen Title Label
            screenTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            screenTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            screenTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Bird Tour Title Label
            birdTourTitleLabel.topAnchor.constraint(equalTo: screenTitleLabel.bottomAnchor, constant: 20), // Increased space
            birdTourTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            birdTourTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Bird Tour WebView
            birdTourWebView.topAnchor.constraint(equalTo: birdTourTitleLabel.bottomAnchor, constant: 15), // Increased space
            birdTourWebView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            birdTourWebView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            birdTourWebView.heightAnchor.constraint(equalToConstant: 200),
            
            // Bird Tour Start Button
            birdTourStartButton.topAnchor.constraint(equalTo: birdTourWebView.bottomAnchor, constant: 20), // Increased space
            birdTourStartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            
            // Bird Tour View Button
            birdTourViewButton.centerYAnchor.constraint(equalTo: birdTourStartButton.centerYAnchor),
            birdTourViewButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Audio Tour Title Label
            audioTourTitleLabel.topAnchor.constraint(equalTo: birdTourStartButton.bottomAnchor, constant: 40), //  space
            audioTourTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            audioTourTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Audio Tour WebView
            audioTourWebView.topAnchor.constraint(equalTo: audioTourTitleLabel.bottomAnchor, constant: 15), // Increased space
            audioTourWebView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            audioTourWebView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            audioTourWebView.heightAnchor.constraint(equalToConstant: 250),
            
            // Audio Tour Start Button
            audioTourStartButton.topAnchor.constraint(equalTo: audioTourWebView.bottomAnchor, constant: 20), // Increased space
            audioTourStartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            // Audio Tour View Button
            audioTourViewButton.centerYAnchor.constraint(equalTo: audioTourStartButton.centerYAnchor),
            audioTourViewButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    func loadTourURLs() {
        // Load the Vimeo video in birdTourWebView
        if let birdTourURL = URL(string: "https://player.vimeo.com/video/311870112?h=4032a46fe8&title=0&byline=0&portrait=0") {
            birdTourWebView.load(URLRequest(url: birdTourURL))
        }
        
        // Load the YouTube video in audioTourWebView
        if let audioTourURL = URL(string: "https://www.youtube.com/watch?v=DLA9RRFM8oE") {
            audioTourWebView.load(URLRequest(url: audioTourURL))
        }
    }
    
    // Navigation actions for the buttons
    @objc func navigateToRiverMap() {
        let vc = MapViewController() // Assuming ViewController1 exists
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func navigateToAudioTourMap() {
        let vc = BallyhourAudioTourMapViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func navigateToARTour() {
        let vc = ARViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func navigateToAudioTour() {
        let vc = AudioTourViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
