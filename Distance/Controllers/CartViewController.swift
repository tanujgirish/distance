//
//  CartViewController.swift
//  Distance
//
//  Created by Tanuj Girish on 10/6/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var cartObj = CartManager.sharedInstance.products
    var keys = [Product]()
    
    var cartView: AddToCartView!
    var dimView: UIView!
    @IBOutlet weak var checkoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        checkoutButton.addTarget(self, action: #selector(presentCheckout(_:)), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cartObj = CartManager.sharedInstance.products
        keys = Array(cartObj.keys)
        self.tableView.reloadData()
    }
    
    @objc func presentCheckout(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "checkoutvc") as! CheckOutViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func calculateSubTotal() -> Double {
        var subtotal = Double()
        for product in keys {
            subtotal += product.price
        }
        return subtotal
    }
    
    private func calculateTotal() -> Double {
        var total = Double()
        total = calculateSubTotal() + 2.00
        return total
    }
    
    @objc func dismissAddCartView(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.cartView.frame.origin.y = self.view.frame.height + 185
            self.dimView.backgroundColor = UIColor.clear
        }) { (result) in
            self.cartView.removeFromSuperview()
            self.dimView.removeFromSuperview()
            self.tableView.reloadData()
        }
    }

}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row + 1 != keys.count + 1 {
            return 60
        }
        return 85
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < keys.count {
            
            let cell: CartTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cartcell", for: indexPath) as! CartTableViewCell
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.productLabel.frame.origin.x, bottom: 0, right: 0)
            
            let currentProduct = keys[indexPath.row]
            cell.priceLabel.text = "$\(currentProduct.price!)"
            cell.productLabel.text = currentProduct.productName
            cell.quantityLabel.text = "\(cartObj[currentProduct]!)"
            
            cell.quantityLabel.layer.cornerRadius = cell.quantityLabel.frame.width / 2
            cell.quantityLabel.layer.masksToBounds = false
            cell.quantityLabel.clipsToBounds = true
            
            cell.selectionStyle = .none
            
            return cell
            
        } else {
            
            let cell: CartTotalTableViewCell = tableView.dequeueReusableCell(withIdentifier: "carttotalcell", for: indexPath) as! CartTotalTableViewCell
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            cell.subtotalPriceLabel.text = String(format: "%.02f", calculateSubTotal())
            cell.deliveryPriceLabel.text = "$2.00"
            cell.totalPriceLabel.text = String(format: "%.02f", calculateTotal())
            
            cell.selectionStyle = .none
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = self.keys[indexPath.row]
        if cartView == nil && dimView == nil {
            let frame = CGRect(x: 0, y: self.view.frame.height + 185, width: self.view.frame.width, height: 185)
            cartView = AddToCartView(frame: frame)
            dimView = UIView(frame: self.view.frame)
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissAddCartView(_:)))
            dimView.isUserInteractionEnabled = true
            dimView.addGestureRecognizer(gestureRecognizer)
        }
        
        cartView.delegate = self
        cartView.product = selectedProduct
        
        
        self.tabBarController?.view.addSubview(self.cartView)
        self.navigationController?.view.addSubview(self.dimView)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.cartView.frame.origin.y = self.view.frame.height - 185
            self.dimView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        }, completion: nil)
    }
}

extension CartViewController: QuantityDelegate {
    func addToCart(_ product: Product, _ quantity: Int) {
        CartManager.sharedInstance.addProduct(product, quantity)
        self.dismissAddCartView(UITapGestureRecognizer())
    }
}
