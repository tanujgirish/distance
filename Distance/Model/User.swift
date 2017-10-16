//
//  User.swift
//  Distance
//
//  Created by Tanuj Girish on 9/27/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit
import Firebase

class User: NSObject {
    
    var name: String!
    var email: String!
    var phone: String!
    var password: String!
    var id: String!
    var address: Address!
    var stripeCustomerId: String!
    
    override init() {
        super.init()
    }
    
    init(dictionary: [String: Any], id: String) {
        super.init()
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.id = id
        self.phone = dictionary["phone"] as? String
        self.stripeCustomerId = dictionary["stripeCustomerId"] as? String
    }
}

class CurrentUser {
    static let sharedInstance = CurrentUser()
    private init() {}
    var currentUser: User!
    
    func updateUserObj() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                self.currentUser = User(dictionary: dictionary, id: uid)
            }
        }, withCancel: nil)
    }
}
