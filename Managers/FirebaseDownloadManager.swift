//
//  FirebaseDownloadManager.swift
//  Glenroe-Ballyorgan
//
//  Created by Liya Wang on 2024/9/28.
//

import Foundation
import FirebaseStorage

class FirebaseDownloadManager {
    let storage = Storage.storage()

    func listAllFiles(completion: @escaping ([String]) -> Void) {
        let storageRef = storage.reference(forURL: "gs://glenroe-ballyorgan.appspot.com")
        var fileNames: [String] = []
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
        let storageRef = storage.reference(forURL: "gs://glenroe-ballyorgan.appspot.com")
        for fileName in fileNames {
            let fileRef = storageRef.child(fileName)
            let localURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
            fileRef.write(toFile: localURL) { (url, error) in
                if let error = error {
                    print("Failed to download \(fileName): \(error.localizedDescription)")
                    return
                }
                print("Downloaded \(fileName) to \(url?.path ?? "")")
            }
        }
    }
}
