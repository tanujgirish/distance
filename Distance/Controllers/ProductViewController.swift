//
//  ProductTableViewController.swift
//  Distance
//
//  Created by Tanuj Girish on 10/5/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit
import Firebase

class ProductViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var products = [Product]()
    var currentCategory: Category!
    
    var cartView: AddToCartView!
    var dimView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationTitle()
        retrieveProducts()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUpNavigationTitle() {
        
    }
    
    func retrieveProducts() {
        let ref = Database.database().reference().child("products").child(currentCategory.category.rawValue)
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                for(key, dic) in dictionary.enumerated() {
                    if let dicValue = dic.value as? [String: Any] {
                        let newProduct = Product(productName: dicValue["product"] as! String, price: 4.25, productKey: snapshot.key)
                        self.products.append(newProduct)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }, withCancel: nil)
    }
    
    @objc func dismissAddCartView(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.cartView.frame.origin.y = self.view.frame.height + 185
            self.dimView.backgroundColor = UIColor.clear
        }) { (result) in
            self.cartView.removeFromSuperview()
            self.dimView.removeFromSuperview()
        }
    }
    
    
}

extension ProductViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "productcell", for: indexPath) as! ProductListTableViewCell
        cell.productLabel.text = products[indexPath.row].productName
        cell.priceLabel.text = "$\(products[indexPath.row].price!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = self.products[indexPath.row]
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

extension ProductViewController: QuantityDelegate {
    func addToCart(_ product: Product, _ quantity: Int) {
        CartManager.sharedInstance.addProduct(product, quantity)
        self.dismissAddCartView(UITapGestureRecognizer())
    }
}


