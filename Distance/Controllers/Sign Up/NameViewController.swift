//
//  NameViewController.swift
//  Distance
//
//  Created by Tanuj Girish on 9/27/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit

class NameViewController: UIViewController {
    
    var signupPageVC: SignUpPageViewController!
    
    @IBOutlet weak var nameTitle: UILabel!
    
    
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var firstNameIndi: UIView!
    
    
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var lastNameIndi: UIView!
    
    
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
        if !(firstNameTextField.text?.isEmpty)! && !(lastNameTextField.text?.isEmpty)! {
            firstNameIndi.backgroundColor = UIColor.black
            lastNameIndi.backgroundColor = UIColor.black
            self.signupPageVC.nextPage()
            self.signupPageVC.newUser.name = "\(firstNameTextField.text!) \(lastNameTextField.text!)"
        } else {
            if (firstNameTextField.text?.isEmpty)! {
                firstNameIndi.backgroundColor = UIColor.FlatColor.red
            } else {
                firstNameIndi.backgroundColor = UIColor.black
            }
            if (lastNameTextField.text?.isEmpty)! {
                lastNameIndi.backgroundColor = UIColor.FlatColor.red
            } else {
                lastNameIndi.backgroundColor = UIColor.black
            }
        }
    }

}
