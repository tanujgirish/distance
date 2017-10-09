//
//  AddressChangeViewController.swift
//  Distance
//
//  Created by Tanuj Girish on 10/7/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit
import Firebase

class AddressChangeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var exitButton: UIBarButtonItem!
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        retrieveSavedContacts()
    }
    
    func retrieveSavedContacts() {
        //self.users.removeAll()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("saved-contacts").child(uid)
        ref.observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            self.retrieveExistingUser(uid)
        }
    }
    
    func retrieveExistingUser(_ uid: String) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary, id: uid)
                self.users.append(user)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func exitAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AddressChangeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < users.count {
            let cell: NewAddressTableViewCell = tableView.dequeueReusableCell(withIdentifier: "addresscell", for: indexPath) as! NewAddressTableViewCell
            cell.contactLabel.text = self.users[indexPath.row].name
            return cell
        } else {
            let cell: AddAddressTableViewCell = tableView.dequeueReusableCell(withIdentifier: "newaddresscell", for: indexPath) as! AddAddressTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "addcontactvc") as! AddContactViewController
            self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
