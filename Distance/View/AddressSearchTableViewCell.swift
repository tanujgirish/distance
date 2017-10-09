//
//  AddressSearchTableViewCell.swift
//  Distance
//
//  Created by Tanuj Girish on 10/9/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit

class AddressSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
