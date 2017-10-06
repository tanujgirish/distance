//
//  PasswordViewController.swift
//  Distance
//
//  Created by Tanuj Girish on 9/27/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {
    
    var signupPageVC: SignUpPageViewController!
    
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var passwordDescription: UITextView!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordIndi: UIView!
    @IBOutlet weak var showButton: UIButton!
    
    lazy var nextButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 45))
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 18)
        button.backgroundColor = UIColor.FlatColor.teal
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showButton.addTarget(self, action: #selector(togglePassword), for: .touchUpInside)
        passwordField.clearsOnBeginEditing = false
        // Do any additional setup after loading the view.
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return nextButton
        }
    }
    
    @objc func nextPage() {
        if (passwordField.text?.characters.count)! >= 6 && validatePassword(candidate: passwordField.text!) {
            self.signupPageVC.newUser.password = self.passwordField.text
            self.signupPageVC.completeSignUp()
            passwordIndi.backgroundColor = UIColor.black
        } else {
            passwordIndi.backgroundColor = UIColor.FlatColor.red
        }
    }
    
    fileprivate func validatePassword(candidate: String) -> Bool {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        if candidate.rangeOfCharacter(from: characterset.inverted) != nil {
            return true
        }
        return false
    }
    
    @objc func togglePassword() {
        passwordField.isSecureTextEntry = !passwordField.isSecureTextEntry
        if passwordField.isSecureTextEntry {
            self.showButton.setTitle("Show", for: .normal)
        } else {
            self.showButton.setTitle("Hide", for: .normal)
        }
    }

}
