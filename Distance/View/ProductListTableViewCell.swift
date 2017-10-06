//
//  ProductListTableViewCell.swift
//  Distance
//
//  Created by Tanuj Girish on 10/5/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {

    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
