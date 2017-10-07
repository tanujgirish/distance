//
//  AddToCartView.swift
//  Distance
//
//  Created by Tanuj Girish on 10/5/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit
import SnapKit

protocol QuantityDelegate {
    func addToCart(_ product: Product, _ quantity: Int)
}

class AddToCartView: UIView {
    
    let productLabel = UILabel()
    let subtractButton = UIButton()
    let addButton = UIButton()
    let addToCartButton = UIButton()
    let quantity = UILabel()
    
    var product: Product? = nil {
        didSet {
            initalizeView()
        }
    }
    
    var delegate: QuantityDelegate!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    func initalizeView() {
        
        productLabel.text = product?.productName
        productLabel.font = UIFont(name: "Avenir-Book", size: 18)
        productLabel.textColor = UIColor.black
        productLabel.textAlignment = .center
        self.addSubview(productLabel)
        productLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(self.snp.width).multipliedBy(0.8)
            make.height.equalTo(24)
            make.top.equalTo(self.snp.top).offset(20)
        }
        
        quantity.text = "1"
        quantity.font = UIFont(name: "Avenir-Medium", size: 30)
        quantity.textAlignment = .center
        self.addSubview(quantity)
        quantity.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(-10)
            make.size.equalTo(58)
        }
        
        subtractButton.setImage(#imageLiteral(resourceName: "minus"), for: .normal)
        subtractButton.isEnabled = false
        subtractButton.addTarget(self, action: #selector(decreaeQuantity(_:)), for: .touchUpInside)
        self.addSubview(subtractButton)
        subtractButton.snp.makeConstraints { (make) in
            make.size.equalTo(40)
            make.centerY.equalTo(self.snp.centerY).offset(-10)
            make.right.equalTo(self.quantity.snp.left)
        }
        
        addButton.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        addButton.addTarget(self, action: #selector(increaseQuantity(_:)), for: .touchUpInside)
        self.addSubview(addButton)
        addButton.snp.makeConstraints { (make) in
            make.size.equalTo(40)
            make.centerY.equalTo(self.snp.centerY).offset(-10)
            make.left.equalTo(self.quantity.snp.right)
        }
        
        addToCartButton.setTitle("Add to cart", for: .normal)
        addToCartButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        addToCartButton.backgroundColor = UIColor.FlatColor.red
        addToCartButton.titleLabel?.textColor = UIColor.white
        addToCartButton.addTarget(self, action: #selector(addToCart(_:)), for: .touchUpInside)
        self.addSubview(addToCartButton)
        addToCartButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(self.snp.height).multipliedBy(0.3)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    @objc func increaseQuantity(_ sender: UIButton) {
        guard let quantityText = self.quantity.text else { return }
        if let currentQuantity = Int(quantityText) {
            let updatedQuantity = currentQuantity + 1
            self.quantity.text = "\(updatedQuantity)"
            if updatedQuantity > 1 {
                subtractButton.isEnabled = true
            } else {
                subtractButton.isEnabled = false
            }
        }
    }
    
    @objc func decreaeQuantity(_ sender: UIButton) {
        guard let quantityText = self.quantity.text else { return }
        if let currentQuantity = Int(quantityText) {
            let updatedQuantity = currentQuantity - 1
            self.quantity.text = "\(updatedQuantity)"
            if updatedQuantity == 1 {
                subtractButton.isEnabled = false
            } else {
                subtractButton.isEnabled = true
            }
        }
    }
    
    @objc func addToCart(_ sender: UIButton) {
        guard let quantityText = quantity.text, let product = self.product else { return }
        if let currentQuantity = Int(quantityText) {
            delegate.addToCart(product, currentQuantity)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
}
