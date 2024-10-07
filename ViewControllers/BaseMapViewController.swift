//
//  BaseMapViewController.swift
//  Glenroe-Ballyorgan
//
//  Created by Liya Wang on 2024/9/28.
//

import Foundation
import UIKit
import MapboxMaps

class BaseMapViewController: UIViewController {
    private let sourceIdentifier = "route-source-identifier"
    private var mapView: MapView!
    private var routeLineSource: GeoJSONSource? // Changed to var to allow reassignment
    private var currentIndex = 0
    private var cancelable: Cancelable?

    override func viewDidLoad() {
        super.viewDidLoad()

        let centerCoordinate = getCenterCoordinate()
        let options = MapInitOptions(cameraOptions: CameraOptions(center: centerCoordinate, zoom: getZoomLevel()), styleURI: .light)

        mapView = MapView(frame: view.bounds, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)

        // Wait for the map to load its style before adding data.
        cancelable = mapView.mapboxMap.onEvery(.mapLoaded) { [weak self] _ in
            self?.addLine()
            self?.animatePolyline()
        }
    }

    func getCenterCoordinate() -> CLLocationCoordinate2D {
        fatalError("Must override in subclass")
    }

    func getZoomLevel() -> CGFloat {
        fatalError("Must override in subclass")
    }

    func getGeoJSONFileName() -> String {
        fatalError("Must override in subclass")
    }

    func addLine() {
        var routeLineSource = GeoJSONSource()
        routeLineSource.data = .feature(Feature(geometry: LineString([]))) // Empty line
        self.routeLineSource = routeLineSource
        try! mapView.mapboxMap.style.addSource(routeLineSource, id: sourceIdentifier)

        var lineLayer = LineLayer(id: "line-layer")
        lineLayer.source = sourceIdentifier
        lineLayer.lineColor = Value.constant(StyleColor(.tintColor))

        let lowZoomWidth: Double = 5.0
        let highZoomWidth: Double = 20.0
        lineLayer.lineWidth = Value.expression(
            Exp(.interpolate) {
                Exp(.linear)
                Exp(.zoom)
                14.0
                lowZoomWidth
                18.0
                highZoomWidth
            }
        )
        lineLayer.lineCap = Value.constant(.round)
        lineLayer.lineJoin = Value.constant(.round)
        try! mapView.mapboxMap.style.addLayer(lineLayer)
    }

    func animatePolyline() {
        var currentCoordinates = [CLLocationCoordinate2D]()
        guard let geojsonURL = Bundle.main.url(forResource: getGeoJSONFileName(), withExtension: "geojson") else {
            print("Error: Failed to locate GeoJSON file in bundle.")
            return
        }
        guard let data = try? Data(contentsOf: geojsonURL) else {
            print("Error: Failed to load data from GeoJSON file.")
            return
        }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let jsonDict = jsonObject as? [String: Any],
              let features = jsonDict["features"] as? [[String: Any]] else {
            print("Error: Failed to parse GeoJSON file.")
            return
        }
        guard let geometry = features.first?["geometry"] as? [String: Any],
              let coordinates = geometry["coordinates"] as? [[Double]] else {
            print("Error: Failed to extract coordinates from GeoJSON.")
            return
        }
        let parsedCoordinates = coordinates.map { CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0]) }
        Timer.scheduledTimer(withTimeInterval: 0.10, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            guard !parsedCoordinates.isEmpty else {
                timer.invalidate()
                print("No coordinates found in GeoJSON.")
                return
            }
            if self.currentIndex >= parsedCoordinates.count {
                timer.invalidate()
                return
            }
            self.currentIndex += 1
            currentCoordinates = Array(parsedCoordinates[0..<self.currentIndex])
            let updatedLine = Feature(geometry: LineString(currentCoordinates))
            try! self.mapView.mapboxMap.style.updateGeoJSONSource(withId: self.sourceIdentifier, geoJSON: .feature(updatedLine))
        }
    }
}
