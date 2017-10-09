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
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "Search for an address"
        searchBar.showsCancelButton = true
        
        
        let attributes: [String: Any] = [NSAttributedStringKey.foregroundColor.rawValue : UIColor.FlatColor.red]
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
        
        if searching {
            
            let searchResult = searchResults[indexPath.row]
            cell.primaryLabel.text = searchResult.title
            cell.secondaryLabel.text = searchResult.subtitle
            cell.typeImageView.image = #imageLiteral(resourceName: "general-loc")
        } else {
            
            cell.primaryLabel.text = "Get Current Location"
            cell.secondaryLabel.text = "We'll try to find the closest location"
            cell.typeImageView.image = #imageLiteral(resourceName: "current-loc")
            
        }
        
        return cell
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
