//
//  NewAddressTableViewCell.swift
//  Distance
//
//  Created by Tanuj Girish on 10/7/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit

class NewAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var addressTypeImageView: UIImageView!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var otherInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class AddAddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addAddressImageView: UIImageView!
    @IBOutlet weak var addAddressLabel: UILabel!
    
}
