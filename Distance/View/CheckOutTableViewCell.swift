//
//  CheckOutTableViewCell.swift
//  Distance
//
//  Created by Tanuj Girish on 10/10/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit

class DeliveryInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    
}

class PaymentTableViewCell: UITableViewCell {
    @IBOutlet weak var lastFourLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var paymentImage: UIImageView!
    @IBOutlet weak var changeButton: UIButton!
}

class OrderSummaryTableViewCell: UITableViewCell {
    @IBOutlet weak var orderSummaryLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    
    @IBOutlet weak var subtotalPriceLabel: UILabel!
    @IBOutlet weak var taxPriceLabel: UILabel!
    @IBOutlet weak var deliveryPriceLabel: UILabel!
}

class TotalTableViewCell: UITableViewCell {
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
}
