//
//  Cart.swift
//  Distance
//
//  Created by Tanuj Girish on 10/6/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit

class CartManager {
    
    static let sharedInstance = CartManager()
    private init() {}
    var products = [Product: Int]()
    
    func addProduct(_ product: Product, _ quantity: Int) {
        products[product] = quantity
        print(products)
    }
    
}
