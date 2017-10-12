//
//  AddressSearchViewController.swift
//  Distance
//
//  Created by Tanuj Girish on 10/9/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit
import MapKit

class AddressSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    
    var searching = false
    
    var currentLoc: String!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    var contact: Contact!
    var contactPage = AddContactViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "Search for an address"
        searchBar.showsCancelButton = true
        searchBar.autocapitalizationType = .words
        
        
        let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor : UIColor.FlatColor.red]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont(name: "Avenir-Book", size: 17.0)
        
        if let txfSearchField = searchBar.value(forKey: "_searchField") as? UITextField {
            //txfSearchField.borderStyle = .none
            txfSearchField.backgroundColor = UIColor.FlatColor.lightGray
        }
        
        
        self.navigationItem.titleView = searchBar
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        searchCompleter.delegate = self
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getCurrentLocation() {
        LocationManager.shared.getLocation { (location) in
            if location == nil {
                return
            }
            CLGeocoder().reverseGeocodeLocation(location!, completionHandler: { (placemarks, error) in
                if error != nil{
                    print(error)
                    return
                }
                let placemark = placemarks!.first!
                let address = "\(placemark.subThoroughfare!) \(placemark.thoroughfare!), \(placemark.postalCode!)"
                self.currentLoc = address
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.presentDetailedAddressVC(placemark)
                }
            })
        }
    }
    
    func generateLocationPlacemark(_ selectedLoc: MKLocalSearchCompletion) {
        CLGeocoder().geocodeAddressString("\(selectedLoc.title), \(selectedLoc.subtitle)") { (placemarks, error) in
            guard let placemark = placemarks?.first else { return }
            self.searchBar.resignFirstResponder()
            self.presentDetailedAddressVC(placemark)
        }
    }
    
    func presentDetailedAddressVC(_ locationPlacemark: CLPlacemark) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailedaddressvc") as! DetailedAddressViewController
        vc.placemark = locationPlacemark
        vc.contact = self.contact
        vc.contactPage = contactPage
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension AddressSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchResults.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AddressSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "addresssearchcell", for: indexPath) as! AddressSearchTableViewCell
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: cell.primaryLabel.frame.origin.x, bottom: 0, right: 0)
        cell.selectionStyle = .none
        
        if searching {
            
            var myMutableString = NSMutableAttributedString()
            
            
            let searchResult = searchResults[indexPath.row]
            
            
            myMutableString = NSMutableAttributedString(string: searchResult.title)
            //NSRange(location:12,length:8)
            if let range = (searchResult.title as NSString).range(of: searchBar.text!) as? NSRange {
                myMutableString.setAttributes([NSAttributedStringKey.foregroundColor: UIColor.FlatColor.red], range: range)
            }
            
            cell.primaryLabel.attributedText = myMutableString
            cell.secondaryLabel.text = searchResult.subtitle
            cell.typeImageView.image = #imageLiteral(resourceName: "general-loc")
            
        } else {
            
            if currentLoc == nil {
                
                cell.primaryLabel.text = "Get Current Location"
                cell.secondaryLabel.text = "We'll try to find the closest location"
                cell.typeImageView.image = #imageLiteral(resourceName: "current-loc")
                
            } else {
                
                cell.primaryLabel.text = "Current Location"
                cell.secondaryLabel.text = currentLoc
                
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! AddressSearchTableViewCell
        
        if searching {
            
            let selectedLoc = self.searchResults[indexPath.row]
            self.generateLocationPlacemark(selectedLoc)
            
        } else {
            
            cell.primaryLabel.text = "Getting Current Location"
            cell.secondaryLabel.text = "Positioning our satellite"
            self.getCurrentLocation()
            
        }
    }
}

extension AddressSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
}

extension AddressSearchViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searching = true
        searchResults = completer.results
        self.tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}
