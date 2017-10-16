//
//  Payment.swift
//  Distance
//
//  Created by Tanuj Girish on 10/14/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit
import Stripe

class Payment: NSObject {
    var cardId: String?
    var brand: STPCardBrand?
    var last4: String?
    
    init(data: [String: Any]) {
        super.init()
        guard let id = data["id"] as? String, let cardBrand = data["brand"] as? String, let last4Digits = data["last4"] as? String else { return }
        cardId = id
        brand = STPCard.brand(from: cardBrand)
        last4 = last4Digits
    }
}
