//
//  RecipientInfoViewController.swift
//  Distance
//
//  Created by Tanuj Girish on 10/10/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit
import MapKit

class RecipientInfoViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationDetailsLabel: UILabel!
    
    var selectedUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedUser = Recipient.sharedInstance.selectedUser
        userCheck()
    }
    
    func userCheck() {
        if selectedUser == nil {
            //present view controller to select a user
            selectUser()
        } else {
            //add labels
            setUpView()
        }
    }
        
    func setUpView() {
        nameLabel.text = selectedUser.name
        phoneNumberLabel.text = selectedUser.phone
    }
    
    func selectUser() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "addresschangevc") as! AddressChangeViewController
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }

}
