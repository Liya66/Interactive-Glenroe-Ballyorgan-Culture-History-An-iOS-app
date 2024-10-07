//
//  File.swift
//  Glenroe-Ballyorgan
//
//  Created by Liya Wang on 2024/9/28.
//

import Foundation
import MapboxMaps
import CoreLocation

class RouteManager {
private var allCoordinates = [CLLocationCoordinate2D]()
    private var currentIndex = 0
    private var currentCoordinates = [CLLocationCoordinate2D]()
    
    // Function to set coordinates from the parsed GeoJSON
    func setCoordinates(_ coordinates: [CLLocationCoordinate2D]) {
        allCoordinates = coordinates
        currentIndex = 0 // Reset index when new coordinates are set
    }
    
    // Function to get the next coordinate or part of the route
    func getNextCoordinate() -> [CLLocationCoordinate2D]? {
        guard currentIndex < allCoordinates.count else {
            return nil // No more coordinates
        }
        currentIndex += 1
        currentCoordinates = Array(allCoordinates[0..<currentIndex])
        return currentCoordinates
    }
}

