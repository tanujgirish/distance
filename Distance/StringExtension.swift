//
//  StringExtension.swift
//  Distance
//
//  Created by Tanuj Girish on 10/2/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
