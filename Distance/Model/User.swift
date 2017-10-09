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
    
    override init() {
        super.init()
    }
    
    init(dictionary: [String: Any], id: String) {
        super.init()
        name = dictionary["name"] as? String
        email = dictionary["email"] as? String
        self.id = id
        phone = dictionary["phone"] as? String
    }
}
