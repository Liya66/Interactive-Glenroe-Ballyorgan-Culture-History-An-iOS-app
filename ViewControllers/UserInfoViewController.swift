//
//  UserInfoViewController.swift
//  Glenroe-Ballyorgan
//
//  Created by Liya Wang on 2024/9/12.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class UserInfoViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var signUpDateLabel: UILabel!
    @IBOutlet weak var lastLoginLabel: UILabel!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            refreshUserInfo()
        }
    
    @IBAction func logoutClicked(_ sender: UIButton) {
          do {
              try Auth.auth().signOut()
              usernameLabel.text = "No user signed in"
              signUpDateLabel.text = ""
              lastLoginLabel.text = ""
              // Optionally navigate back to login screen or update UI
              self.performSegue(withIdentifier: "jumpBack2Login", sender: self)
              print("User signed out successfully.")
              // Example: Navigate to login screen
              // self.performSegue(withIdentifier: "logoutSegue", sender: self)
          } catch let signOutError as NSError {
              print("Error signing out: %@", signOutError)
          }
      }
    
    func fetchLastLoginTime(userId: String, completion: @escaping (Date?) -> Void) {
           let db = Firestore.firestore()
           db.collection("users").document(userId).getDocument { document, error in
               if let document = document, document.exists {
                   let lastLogin = document.get("lastLogin") as? Timestamp
                   completion(lastLogin?.dateValue())
               } else {
                   print("Document does not exist")
                   completion(nil)
               }
           }
       }
    
    func refreshUserInfo() {
        // Retrieve the currently signed-in user
        if let user = Auth.auth().currentUser {
            // Get the user's email or Google display name
            let username = user.displayName ?? user.email ?? "Unknown"
            
            // Get the sign-up date from Firebase user metadata
            if let creationDate = user.metadata.creationDate {
                // Format the date to a readable format
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                let formattedDate = dateFormatter.string(from: creationDate)
                
                // Display the user info on the screen
                usernameLabel.text = "Username: \(username)"
                signUpDateLabel.text = "Signed up on: \(formattedDate)"
                
                // Fetch and display the last login time
                fetchLastLoginTime(userId: user.uid) { [weak self] lastLoginDate in
                    guard let self = self else { return }
                    if let lastLoginDate = lastLoginDate {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .medium
                        dateFormatter.timeStyle = .short
                        self.lastLoginLabel.text = "Last Login: \(dateFormatter.string(from: lastLoginDate))"
                    } else {
                        self.lastLoginLabel.text = "No login record found."
                    }
                }
            }
        } else {
            // Handle case where no user is signed in
            usernameLabel.text = "No user signed in"
            signUpDateLabel.text = ""
            lastLoginLabel.text = ""
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Refresh user info whenever the view appears
        refreshUserInfo()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
