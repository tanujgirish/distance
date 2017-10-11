//
//  Recipient.swift
//  Distance
//
//  Created by Tanuj Girish on 10/10/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit

class Recipient {
    
    static let sharedInstance = Recipient()
    private init() {}
    var selectedUser: User!
    
}
