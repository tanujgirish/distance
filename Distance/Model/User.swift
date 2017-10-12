//
//  User.swift
//  Distance
//
//  Created by Tanuj Girish on 9/27/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit

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
    var currenUser: User!
    
    func updateUserObj() {
        
    }
}
