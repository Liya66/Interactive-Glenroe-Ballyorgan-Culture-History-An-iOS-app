//
//  BallyhourAudioTourMapViewController.swift
//  Glenroe-Ballyorgan
//
//  Created by Liya Wang on 2024/9/13.

import Foundation
import UIKit
import MapboxMaps

class BallyhourAudioTourMapViewController: BaseMapViewController {
    override func getCenterCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 52.6, longitude: -8.5)
    }

    override func getZoomLevel() -> CGFloat {
        return 8.5
    }

    override func getGeoJSONFileName() -> String {
        return "AudioTourRoute"
    }
}





//
//class BallyhourAudioTourMapViewController: UIViewController {
//    private let sourceIdentifier = "route-source-identifier"
//     private var mapView: MapView!
//     private var routeLineSource: GeoJSONSource? // Changed to var to allow reassignment
//     private var currentIndex = 0
//     private var cancelable: Cancelable?
//
//     override func viewDidLoad() {
//         super.viewDidLoad()
//
//         let centerCoordinate = CLLocationCoordinate2D(latitude: 52.6, longitude: -8.5) //
//         let options = MapInitOptions(cameraOptions: CameraOptions(center: centerCoordinate, zoom: 8.5), styleURI: .light)
//
//         mapView = MapView(frame: view.bounds, mapInitOptions: options)
//         mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//         view.addSubview(mapView)
//         
//         
//
//         // Wait for the map to load its style before adding data.
//         cancelable = mapView.mapboxMap.onEvery(.mapLoaded) { _ in
//             self.addLine()
//             self.animatePolyline()
//         }
//     }
//    
//    func addLine() {
//        // Create an empty or single-point GeoJSON source
//        var routeLineSource = GeoJSONSource()
//        
//        // Initially, use an empty LineString or a single-point LineString
//        routeLineSource.data = .feature(Feature(geometry: LineString([]))) // Empty line
//        
//        self.routeLineSource = routeLineSource // Assign it to the instance variable
//
//        // Add the empty GeoJSON source to the map's style with the source identifier
//        try! mapView.mapboxMap.style.addSource(routeLineSource, id: sourceIdentifier)
//
//        // Create a line layer and set the source
//        var lineLayer = LineLayer(id: "line-layer")
//        lineLayer.source = sourceIdentifier // Set the source for the layer
//        lineLayer.lineColor = Value.constant(StyleColor(.tintColor)) // Set your preferred color
//
//        // Define line width at different zoom levels
//        let lowZoomWidth: Double = 5.0
//        let highZoomWidth: Double = 20.0
//
//        // Use an expression to define line width
//        lineLayer.lineWidth = Value.expression(
//            Exp(.interpolate) {
//                Exp(.linear)
//                Exp(.zoom)
//                14.0
//                lowZoomWidth
//                18.0
//                highZoomWidth
//            }
//        )
//        
//        lineLayer.lineCap = Value.constant(.round)
//        lineLayer.lineJoin = Value.constant(.round)
//
//        // Add the line layer to the map's style
//        try! mapView.mapboxMap.style.addLayer(lineLayer)
//    }
//
//
//    func animatePolyline() {
//        // Initialize an empty array to hold the coordinates
//        var currentCoordinates = [CLLocationCoordinate2D]()
//        
//        // Load the GeoJSON file from the app bundle
//        guard let geojsonURL = Bundle.main.url(forResource: "AudioTourRoute", withExtension: "geojson") else {
//            print("Error: Failed to locate GeoJSON file in bundle.")
//            return
//        }
//        
//        // Load the data from the GeoJSON file
//        guard let data = try? Data(contentsOf: geojsonURL) else {
//            print("Error: Failed to load data from GeoJSON file.")
//            return
//        }
//        
//        // Parse the GeoJSON data using JSONSerialization
//        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
//              let jsonDict = jsonObject as? [String: Any],
//              let features = jsonDict["features"] as? [[String: Any]] else {
//            print("Error: Failed to parse GeoJSON file.")
//            return
//        }
//        
//        // Extract the coordinates from the first feature's geometry
//        guard let geometry = features.first?["geometry"] as? [String: Any],
//              let coordinates = geometry["coordinates"] as? [[Double]] else {
//            print("Error: Failed to extract coordinates from GeoJSON.")
//            return
//        }
//        
//        // Convert coordinates into CLLocationCoordinate2D array
//        let parsedCoordinates: [CLLocationCoordinate2D] = coordinates.map { coordinate in
//            CLLocationCoordinate2D(latitude: coordinate[1], longitude: coordinate[0])
//        }
//
//        // Start animating through the coordinates with a timer
//        Timer.scheduledTimer(withTimeInterval: 0.10, repeats: true) { [weak self] timer in
//            guard let self = self else {
//                timer.invalidate()
//                return
//            }
//            
//            // Ensure there are coordinates to animate through
//            guard !parsedCoordinates.isEmpty else {
//                timer.invalidate()
//                print("No coordinates found in GeoJSON.")
//                return
//            }
//            
//            // Stop the timer if we've reached the end of the coordinates
//            if self.currentIndex >= parsedCoordinates.count {
//                timer.invalidate()
//                return
//            }
//            
//            self.currentIndex += 1
//            
//            // Create a subarray of locations up to the current index
//            currentCoordinates = Array(parsedCoordinates[0..<self.currentIndex])
//            
//            // Create a new LineString feature with the updated coordinates
//            let updatedLine = Feature(geometry: LineString(currentCoordinates))
//            
//            // Update the GeoJSON source with the updated line
//            try! self.mapView.mapboxMap.style.updateGeoJSONSource(withId: self.sourceIdentifier, geoJSON: .feature(updatedLine))
//        }
//    }
//
//
//
//}
