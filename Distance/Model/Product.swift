//
//  Product.swift
//  Distance
//
//  Created by Tanuj Girish on 10/5/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit

class Product: NSObject {
    var productName: String!
    var price: Double!
    var productKey: String!
    
    init(productName: String, price: Double, productKey: String) {
        self.productName = productName
        self.price = price
        self.productKey = productKey
    }
}
