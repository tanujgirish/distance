//
//  AddContactViewController.swift
//  Distance
//
//  Created by Tanuj Girish on 10/8/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit
import Contacts
import Firebase

class AddContactViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var numberOfSections: Int = 2
    var contactStore = CNContactStore()
    
    
    
    var existingUsers = [User]()
    var nonUserContacts = [Contact]()
    
    lazy var contactsNumber: [Contact] = {
        let contactStore = CNContactStore()
        let keysToFetch = [CNContactPhoneNumbersKey,
                           CNContactFormatter.descriptorForRequiredKeys(for: .fullName)] as [Any]
        
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("error")
        }
        
        var results: [CNContact] = []
        
        for container in allContainers {
            
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("error")
            }
        }
        
        var phoneNumbers: [String] = []
        var contacts = [Contact]()
        
        for contact in results {
            if contact.phoneNumbers.count > 0 {
                if let digits = (contact.phoneNumbers[0].value).value(forKey: "digits") as? String, let name = CNContactFormatter.string(from: contact, style: .fullName) {
                    var newContact = Contact(phoneNumber: digits, name: name)
                    contacts.append(newContact)
                }
            } else {
                print("No Number")
            }
        }
        return contacts
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        requestForAccess { (success) in
            self.fetchUser()
        }
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //check contacts for friends IF phone number exists
                if let phone = dictionary["phone"] as? String {
                    
                    for contact in self.contactsNumber {
                        if (contact.phoneNumber.range(of: phone) != nil) {
                            
                            let user = User(dictionary: dictionary, id: snapshot.key)
                            
                            self.existingUsers.append(user)
                            
                        } else {
                            self.nonUserContacts.append(contact)
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            
        }, withCancel: nil)
    }
    
    
    func requestForAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: .contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                }
                else {
                    if authorizationStatus == .denied {
                        print("auth denied")
                    }
                }
            })
        default:
            completionHandler(false)
        }
    }
    
    func addExistingUserToList(_ user: User) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("saved-contacts").child(uid)
        let values = [user.id: 1]
        ref.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error)
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func presentSearchAddress(_ selectedContact: Contact) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "serachaddressvc") as! AddressSearchViewController
        vc.contact = selectedContact
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
}

extension AddContactViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if nonUserContacts.count > 0 && existingUsers.count > 0 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.numberOfSections == 1 && nonUserContacts.count > 0 {
            return nonUserContacts.count
        } else if tableView.numberOfSections == 1 && existingUsers.count > 0 {
            return existingUsers.count
        } else {
            if section == 0 {
                return existingUsers.count
            } else {
                return nonUserContacts.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AddContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: "addcontactcell", for: indexPath) as! AddContactTableViewCell
        
        
        
        if tableView.numberOfSections == 1 && nonUserContacts.count > 0 {
            
            cell.usernameLabel.text = self.nonUserContacts[indexPath.row].name
            cell.typeImageView.image = #imageLiteral(resourceName: "add-loc")
            
        } else if tableView.numberOfSections == 1 && existingUsers.count > 0 {
            
            cell.usernameLabel.text = self.existingUsers[indexPath.row].name
            cell.typeImageView.image = #imageLiteral(resourceName: "existing-user")
            
        } else {
            
            if indexPath.section == 0 {
                
                cell.usernameLabel.text = self.existingUsers[indexPath.row].name
                cell.typeImageView.image = #imageLiteral(resourceName: "existing-user")
                
            } else {
                
                cell.usernameLabel.text = self.nonUserContacts[indexPath.row].name
                cell.typeImageView.image = #imageLiteral(resourceName: "add-loc")
                
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.numberOfSections == 1 && nonUserContacts.count > 0 {
            
            var selectedContact = self.nonUserContacts[indexPath.row]
            presentSearchAddress(selectedContact)
            
        } else if tableView.numberOfSections == 1 && existingUsers.count > 0 {
            
            self.addExistingUserToList(existingUsers[indexPath.row])
            
        } else {
            
            if indexPath.section == 0 {
                
                self.addExistingUserToList(existingUsers[indexPath.row])
                
            } else {
                
                var selectedContact = self.nonUserContacts[indexPath.row]
                presentSearchAddress(selectedContact)
                
            }
            
        }
        
    }
    
}
