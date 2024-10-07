//
//  SignUpViewController.swift
//  Glenroe-Ballyorgan
//
//  Created by Liya Wang on 2024/9/1.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn


class SignUpViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initially disable the login button
               signupButton.isEnabled = false
               
    //detect email and password input
        emailTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        
        passwordTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)

        // dissmiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
        
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)  // This will dismiss the keyboard
    }
    @objc func textFieldChanged(_ textField: UITextField) {
          // Validate both email and password
          if let email = emailTextField.text, isValidEmail(email),
             let password = passwordTextField.text, isValidPassword(password) {
              signupButton.isEnabled = true  // Enable the button if both email and password are valid
          } else {
              signupButton.isEnabled = false // Disable the button if either is invalid
          }
      }
    func isValidEmail(_ email: String) -> Bool {
           let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
           let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
           return emailPredicate.evaluate(with: email)
       }
    
    func isValidPassword(_ password: String) -> Bool {
           return password.count > 5 // Password must be more than 6 characters
       }
    
    @IBAction func singupClicked(_ sender: UIButton) {
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else{return} //make sure they are not empty
        Auth.auth().createUser(withEmail: email, password: password){ Result, error in
            if let e = error {
                self.showFailAlert()
                print ("Error!")
            }
            else{
                //show alert
                self.showSuccessAlert()
               
            }
        }
        
    }
    
    func showFailAlert(){
        let alertController = UIAlertController(
            title: "Sorry",
            message: "Please try again with a different email.",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    func showSuccessAlert() {
        let alertController = UIAlertController(
            title: "Create an account",
            message: "Success! Now log in with your new account.",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Perform the segue only after the user taps "OK"
            self.performSegue(withIdentifier: "jump2Login", sender: self)
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    /*
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // test account: test123@umail.ucc.ie 123456

}
