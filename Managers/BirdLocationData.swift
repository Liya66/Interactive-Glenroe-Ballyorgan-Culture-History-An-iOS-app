//
//  BirdLocationData.swift
//  Glenroe-Ballyorgan
//
//  Created by Liya Wang on 2024/9/28.
//

import Foundation
import CoreLocation

let birdLocations = [
    BirdLocation(coordinate: CLLocationCoordinate2D(latitude: 52.307, longitude: -8.417), modelName: "Barn_owl.scn", alertMessage: "You found a Barn Owl!"),
    BirdLocation(coordinate: CLLocationCoordinate2D(latitude: 52.309, longitude: -8.440), modelName: "Robin.scn", alertMessage: "You found a Robin!"),
    BirdLocation(coordinate: CLLocationCoordinate2D(latitude: 52.307, longitude: -8.458), modelName: "Bird.scn", alertMessage: "You found a ???")
]
