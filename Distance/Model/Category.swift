//
//  Category.swift
//  Distance
//
//  Created by Tanuj Girish on 10/2/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import Foundation
import UIKit

enum CategoriesEnum: String {
    case drinks = "drinks"
    case sweets = "sweets"
    case snacks = "snacks"
    case health = "health"
}

class Category: NSObject {
    var category: CategoriesEnum!
    var imageURL = String()
    
    init(categroyType: CategoriesEnum, imageURL: String) {
        self.category = categroyType
        self.imageURL = imageURL
    }
}
