//
//  StartViewController.swift
//  Distance
//
//  Created by Tanuj Girish on 10/13/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit
import SnapKit

class StartViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.cornerRadius = loginButton.frame.height / 2
        signUpButton.backgroundColor = UIColor.FlatColor.red
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 18)
        
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        loginButton.layer.borderColor = UIColor.FlatColor.red.cgColor
        loginButton.layer.borderWidth =  1.5
        loginButton.backgroundColor = UIColor.white
        loginButton.setTitleColor(UIColor.FlatColor.red, for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 18)
        
        self.addConstraints()
    }
    
    func addConstraints() {
        let parent = self.view!
        
        logoImageView.snp.makeConstraints { (make) in
            make.width.equalTo(parent.snp.width).multipliedBy(0.23)
            make.left.equalTo(22)
            make.height.equalTo(parent.snp.width).multipliedBy(0.1)
            make.bottom.equalTo(parent.snp.centerY).offset(-150)
        }
        
        distanceLabel.snp.makeConstraints { (make) in
            make.width.equalTo(parent.snp.width).multipliedBy(0.9)
            make.height.equalTo(parent.snp.width).multipliedBy(0.1)
            make.centerX.equalTo(parent.snp.centerX)
            make.top.equalTo(logoImageView.snp.bottom).offset(50)
        }
        
        signUpButton.snp.makeConstraints { (make) in
            make.width.equalTo(parent.snp.width).multipliedBy(0.9)
            make.height.equalTo(45)
            make.centerX.equalTo(parent.snp.centerX)
            make.top.equalTo(parent.snp.centerY)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.width.equalTo(parent.snp.width).multipliedBy(0.9)
            make.height.equalTo(45)
            make.centerX.equalTo(parent.snp.centerX)
            make.top.equalTo(signUpButton.snp.bottom).offset(20)
        }
    }

}
