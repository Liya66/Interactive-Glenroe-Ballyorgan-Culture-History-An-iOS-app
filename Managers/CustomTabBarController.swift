//
//  CustomTabBarController.swift
//  Glenroe-Ballyorgan
//
//  Created by Liya Wang on 2024/9/21.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    var isLoggedIn = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 4{
            if isLoggedIn {
                // Navigate to UserInfoViewController
                performSegue(withIdentifier: "showUserInfo", sender: self)
            } else {
                // Navigate to LoginViewController
                performSegue(withIdentifier: "showLogin", sender: self)
            }

        }
       
       
    }

    // Implement your tab bar button action and delegate methods here
    
    @IBAction func userAccountButtonTapped(_ sender: Any) {
        if isLoggedIn {
            // Navigate to UserInfoViewController
            performSegue(withIdentifier: "showUserInfo", sender: self)
        } else {
            // Navigate to LoginViewController
            performSegue(withIdentifier: "showLogin", sender: self)
        }
    }

}
