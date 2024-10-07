//
//  EventManager.swift
//  Glenroe-Ballyorgan
//
//  Created by Liya Wang on 2024/9/17.
//
import FirebaseStorage
import MapboxMaps
import Foundation
import UIKit
import CoreLocation

struct EventsResponse: Decodable {
    var version: String
    var events: [Event]
}

struct Event: Decodable {
    var title: String
    var description: String
    var imageURL: String
    var eventURL: String
    var date: String
}

class EventManager {
    var events = [Event]()
    
    func fetchEvents(completion: @escaping ([Event]) -> Void) {
        // Create a reference to your Firebase Storage
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://glenroe-ballyorgan.appspot.com/Events.json")
        
        
        // Download the JSON data
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading JSON: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data found")
                return
            }
            
            // Log the raw JSON string to check its structure
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Downloaded JSON: \(jsonString)")
            }

            do {
                let decodedResponse = try JSONDecoder().decode(EventsResponse.self, from: data)
                self.events = decodedResponse.events
                completion(self.events)
            } catch let jsonError {
                print("Failed to decode JSON: \(jsonError.localizedDescription)")
            }
        }

    }
}
