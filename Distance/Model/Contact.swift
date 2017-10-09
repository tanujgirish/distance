//
//  Contact.swift
//  Distance
//
//  Created by Tanuj Girish on 10/8/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit

class Contact: NSObject {
    
    var phoneNumber: String!
    var name: String!
    
    init(phoneNumber: String, name: String) {
        self.phoneNumber = phoneNumber
        self.name = name
    }
}
