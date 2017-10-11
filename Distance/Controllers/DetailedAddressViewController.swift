//
//  DetailedAddressViewController.swift
//  Distance
//
//  Created by Tanuj Girish on 10/9/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class DetailedAddressViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var numberSeperator: UIView!
    
    @IBOutlet weak var buildingLabel: UILabel!
    @IBOutlet weak var buildingTextField: UITextField!
    @IBOutlet weak var buildingSeperator: UIView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var placemark: CLPlacemark!
    var contact: Contact!
    
    var contactPage = AddContactViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let address = "\(placemark.subThoroughfare!) \(placemark.thoroughfare!), \(placemark.postalCode!)"
        self.navigationItem.title = address
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font.rawValue: UIFont(name: "Avenir-Medium", size: 17)!]
        setUpMap()
    }
    
    func setUpMap() {
        
        let regionRadius: CLLocationDistance = 500
        
        let centerCoord = CLLocationCoordinate2D(latitude: (placemark.location?.coordinate.latitude)!, longitude: (placemark.location?.coordinate.longitude)!)
        mapView.setCenter(centerCoord, animated: false)
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance((placemark.location?.coordinate)!, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = centerCoord
        mapView.addAnnotation(annotation)
        
        mapView.isUserInteractionEnabled = false
        
    }
    
    func saveNonUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let address = "\(placemark.subThoroughfare!) \(placemark.thoroughfare!) \(placemark.locality!), \(placemark.administrativeArea!) \(placemark.postalCode!)"
        let ref = Database.database().reference().child("saved-contacts").child(uid).childByAutoId()
        let values: [String: Any] = ["name": contact.name, "address": address, "number": numberTextField.text, "building": buildingTextField.text, "phone": contact.phoneNumber]
        ref.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error)
                return
            }
            self.saveComplete()
        }
    }
    
    func saveComplete() {
        self.dismiss(animated: true) {
            self.contactPage.navigationController?.popToRootViewController(animated: true)
        }
    }

    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        saveNonUser()
    }

}
