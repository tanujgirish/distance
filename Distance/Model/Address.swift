//
//  Address.swift
//  Distance
//
//  Created by Tanuj Girish on 10/10/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit

class Address: NSObject {
    
    var address: String!
    var building: String!
    var number: String!
    
    init(dictionary: [String: Any]) {
        super.init()
        self.address = dictionary["address"] as! String
        self.building = dictionary["building"] as! String
        self.number = dictionary["number"] as! String
    }
}
