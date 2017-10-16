//
//  NavigationExtension.swift
//  Distance
//
//  Created by Tanuj Girish on 10/14/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    func makeNavigationBarTransparent(_ navigationController: UINavigationController) {
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        navigationController.view.backgroundColor = .clear
    }
}
