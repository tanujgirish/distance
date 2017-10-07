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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cartObj = CartManager.sharedInstance.products
        keys = Array(cartObj.keys)
        
        self.tableView.reloadData()
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
            
            return cell
            
        } else {
            
            let cell: CartTotalTableViewCell = tableView.dequeueReusableCell(withIdentifier: "carttotalcell", for: indexPath) as! CartTotalTableViewCell
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            cell.subtotalPriceLabel.text = "$\(calculateSubTotal())"
            cell.deliveryPriceLabel.text = "$2.00"
            cell.totalPriceLabel.text = "$\(calculateTotal())"
            return cell
        }
        
    }
}
