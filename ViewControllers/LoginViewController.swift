//
//  LoginViewController.swift
//  Glenroe-Ballyorgan
//
//  Created by Liya Wang on 2024/9/1.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import FirebaseFirestore

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordToggleIcon: UIButton!
    
    var isPasswordVisible = false //default invisible
    var isLoggedIn = false
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
           // Set the password field to be secure (hidden) initially
           passwordTextField.isSecureTextEntry = true
           passwordToggleIcon.setImage(UIImage(systemName: "eye.slash"), for: .normal) // Set the icon for hidden password
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
        
       }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)  // dismiss the keyboard
    }
       
       @IBAction func togglePasswordVisibility(_ sender: UIButton) {
           // Toggle password visibility
           isPasswordVisible.toggle()
           
           // Update the secure text entry state
           passwordTextField.isSecureTextEntry = !isPasswordVisible
           
           // Update the eye icon based on the current state
           let iconName = isPasswordVisible ? "eye" : "eye.slash"
           passwordToggleIcon.setImage(UIImage(systemName: iconName), for: .normal)
           
           // Refresh the text field to ensure the change is visible immediately
           passwordTextField.resignFirstResponder()  // Lose focus
           passwordTextField.becomeFirstResponder()  // Regain focus, triggers a refresh
       }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else { return }
           guard let password = passwordTextField.text, !password.isEmpty else { return }

           Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
               if let error = error {
                   print("Error during login: \(error.localizedDescription)")
                   self?.showLoginErrorAlert()
                   return
               }

               if let user = result?.user {
                   self?.updateLastLoginTime(userId: user.uid)
                                 // Navigate to another screen after successful login
                    self?.isLoggedIn = true
                    self?.performSegue(withIdentifier: "jump", sender: self)
               }
           }
    }
    
    func showLoginErrorAlert() {
        let alertController = UIAlertController(
            title: "Login Error",
            message: "The email or password you entered is incorrect. Please try again.",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func updateLastLoginTime(userId: String) {
        let db = Firestore.firestore()
        let currentTime = Date()
        db.collection("users").document(userId).setData([
            "lastLogin": Timestamp(date: currentTime)
        ], merge: true) { error in
            if let error = error {
                print("Error updating last login time: \(error.localizedDescription)")
            } else {
                print("Last login time updated successfully.")
            }
        }
    }

    
    @IBAction func googleSignInClicked(_ sender: UIButton) {
        // Step 1: Get the client ID from Firebase configuration
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            // Step 2: Create Google Sign-In configuration object
            let config = GIDConfiguration(clientID: clientID)
            
            // Step 3: Start the Google Sign-In flow
            GIDSignIn.sharedInstance.configuration = config
            GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
                // Step 4: Handle error if any
                if let error = error {
                    print("Error during Google sign-in: \(error.localizedDescription)")
                    return
                }
                
                // Step 5: Get user ID token and access token
                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString else {
                    print("Error: Missing Google authentication tokens.")
                    return
                }
                let accessToken = user.accessToken.tokenString
                
                // Step 6: Create Firebase credential with the tokens
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                
                // Step 7: Sign in to Firebase with the Google credential
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        print("Error during Firebase sign-in: \(error.localizedDescription)")
                        return
                    }
                    
                    // User is signed in successfully
                    print("Successfully signed in with Google and Firebase!")
                    
                    // Apply your logic here
                    if let user = authResult?.user {
                        // Step 8: Update the last login time and navigate to another screen
                        self.updateLastLoginTime(userId: user.uid)
                        // Navigate to the next screen after successful login
                        self.performSegue(withIdentifier: "jump", sender: self)
                    }
                }
            }
    }
    
    
    /*
    // MARK: - Navigation


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // the first account is test123@umail.ucc.ie 123456 ; test456@gmail.ucc.ie 123456

}
