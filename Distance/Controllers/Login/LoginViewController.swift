//
//  LoginViewController.swift
//  Distance
//
//  Created by Tanuj Girish on 9/27/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

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
        usernameTextField.delegate = self
        
        loginButton.addTarget(self, action: #selector(LoginViewController.login), for: .touchUpInside)
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        loginButton.backgroundColor = UIColor.FlatColor.red
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 17)
        
        self.navigationController?.makeNavigationBarTransparent(self.navigationController!)
        self.addConstraints()
        
    }
    
    @IBAction func forgotPasswordAction(_ sender: UIBarButtonItem) {
    }
    
    func addConstraints() {
        let parent = self.view!
        
        loginTitle.snp.makeConstraints { (make) in
            make.width.equalTo(parent.snp.width).multipliedBy(0.9)
            make.height.equalTo(50)
            make.top.equalTo(parent.snp.top).offset(150)
            make.centerX.equalTo(parent.snp.centerX)
        }
        
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(loginTitle.snp.left)
            make.width.equalTo(parent.snp.width).multipliedBy(0.9)
            make.height.equalTo(21)
            make.top.equalTo(loginTitle.snp.bottom).offset(20)
        }
        
        usernameTextField.snp.makeConstraints { (make) in
            make.left.equalTo(loginTitle.snp.left)
            make.width.equalTo(parent.snp.width).multipliedBy(0.9)
            make.height.equalTo(30)
            make.top.equalTo(usernameLabel.snp.bottom)
        }
        
        usernameIndi.snp.makeConstraints { (make) in
            make.left.equalTo(loginTitle.snp.left)
            make.width.equalTo(usernameTextField.snp.width)
            make.height.equalTo(1)
            make.top.equalTo(usernameTextField.snp.bottom).offset(5)
        }
        
        passwordLabel.snp.makeConstraints { (make) in
            make.left.equalTo(loginTitle.snp.left)
            make.width.equalTo(parent.snp.width).multipliedBy(0.9)
            make.height.equalTo(21)
            make.top.equalTo(usernameIndi.snp.bottom).offset(20)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.left.equalTo(loginTitle.snp.left)
            make.width.equalTo(parent.snp.width).multipliedBy(0.9)
            make.height.equalTo(30)
            make.top.equalTo(passwordLabel.snp.bottom)
        }
        
        passwordIndi.snp.makeConstraints { (make) in
            make.left.equalTo(loginTitle.snp.left)
            make.width.equalTo(passwordTextField.snp.width)
            make.height.equalTo(1)
            make.top.equalTo(passwordTextField.snp.bottom).offset(5)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.width.equalTo(parent.snp.width).multipliedBy(0.9)
            make.height.equalTo(45)
            make.centerX.equalTo(parent.snp.centerX)
            make.top.equalTo(parent.snp.centerY)
        }
    }
    
    @objc func login() {
        
        guard let username = usernameTextField.text, let password = passwordTextField.text else { return }
        var usernameText = username.replacingOccurrences(of: " ", with: "")
        usernameText = "\(usernameText)@distance.com"
        Auth.auth().signIn(withEmail: usernameText, password: password) { (user, error) in
            if error != nil {
                print(error)
                return
            }
            CurrentUser.sharedInstance.updateUserObj()
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == usernameTextField {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = (newString as NSString).components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne {
                formattedString.append("1 ")
                index += 1
            }
            if (length - index) > 3 {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@ ", areaCode)
                index += 3
            }
            if length - index > 3 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@ ", prefix)
                index += 3
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
        }
        return true
    }
}

