//
//  EmailViewController.swift
//  Distance
//
//  Created by Tanuj Girish on 9/27/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit

class EmailViewController: UIViewController {
    
    var signupPageVC: SignUpPageViewController!
    
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailIndi: UIView!
    
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

        // Do any additional setup after loading the view.
    }

    override var inputAccessoryView: UIView? {
        get {
            return nextButton
        }
    }
    
    @objc func nextPage() {
        if (emailField.text?.isEmpty)! {
            emailIndi.backgroundColor = UIColor.FlatColor.red
        } else if validateEmail(candidate: emailField.text!) {
            self.signupPageVC.nextPage()
            self.signupPageVC.newUser.email = emailField.text
            emailIndi.backgroundColor = UIColor.black
        } else {
            emailIndi.backgroundColor = UIColor.FlatColor.red
        }
    }
    
    fileprivate func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }

}
