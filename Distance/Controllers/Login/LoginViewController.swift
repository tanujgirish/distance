//
//  LoginViewController.swift
//  Distance
//
//  Created by Tanuj Girish on 9/27/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTitle: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameIndi: UIView!
    @IBOutlet weak var passwordIndi: UIView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.addTarget(self, action: #selector(LoginViewController.login), for: .touchUpInside)
    }
    
    @IBAction func forgotPasswordAction(_ sender: UIBarButtonItem) {
    }
    
    @objc func login() {
        guard let username = usernameTextField.text, let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: username, password: password) { (user, error) in
            if error != nil {
                print(error)
                return
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}

