//
//  IntExtension.swift
//  Distance
//
//  Created by Tanuj Girish on 10/12/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    init(_ range: Range<Int> ) {
        let delta = range.lowerBound < 0 ? abs(range.lowerBound) : 0
        let min = UInt32(range.lowerBound + delta)
        let max = UInt32(range.upperBound   + delta)
        self.init(Int(min + arc4random_uniform(max - min)) - delta)
    }
}
