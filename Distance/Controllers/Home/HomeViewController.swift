//
//  HomeViewController.swift
//  Distance
//
//  Created by Tanuj Girish on 9/29/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit
import iCarousel
import Firebase
import SDWebImage
import CoreLocation

class HomeViewController: UIViewController {
    
    var categories = [Category]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let button = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.FlatColor.lightBlue
        retrieveProducts()
        setUpNavBar()
    }
    
    func retrieveProducts() {
        let ref = Database.database().reference().child("products")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                if let categoryType = CategoriesEnum(rawValue: snapshot.key as! String), let imageURL = dictionary["imageURL"] as? String {
                    let newCategory = Category(categroyType: categoryType, imageURL: imageURL)
                    self.categories.append(newCategory)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }, withCancel: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavBar()
    }
    
    func updateNavBar() {
        
        var string = String()
        
        if Recipient.sharedInstance.selectedUser != nil {
            string = "To \(Recipient.sharedInstance.selectedUser!.name!)"
        } else {
            string = "To ..."
        }
        
        
        let attributedString = NSMutableAttributedString(string: string, attributes: [NSAttributedStringKey.font: UIFont(name: "Avenir-Book", size: 17)])
        
        let boldFontAttribute = [NSAttributedStringKey.font: UIFont(name: "Avenir-Heavy", size: 17)]
        
        let range = (string as NSString).range(of: "To") as! NSRange
        
        attributedString.addAttributes(boldFontAttribute, range: range)
        
        button.setAttributedTitle(attributedString, for: .normal)
    }
    
    func setUpNavBar() {
        
        var string = String()
        
        if Recipient.sharedInstance.selectedUser != nil {
            string = "To \(Recipient.sharedInstance.selectedUser!.name!)"
        } else {
            string = "To ..."
        }
        
        let attributedString = NSMutableAttributedString(string: string, attributes: [NSAttributedStringKey.font: UIFont(name: "Avenir-Book", size: 17)])
        
        let boldFontAttribute = [NSAttributedStringKey.font: UIFont(name: "Avenir-Heavy", size: 17)]
        
        let range = (string as NSString).range(of: "To") as! NSRange
        
        attributedString.addAttributes(boldFontAttribute, range: range)
        
        button.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 17)
        
        button.addTarget(self, action: #selector(self.presentAddressVc(_:)), for: .touchUpInside)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setAttributedTitle(attributedString, for: .normal)
//        button.setImage(#imageLiteral(resourceName: "down"), for: .normal)
//        button.imageView?.frame.size = CGSize(width: 20, height: 36)
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: button.frame.width, bottom: 0, right: 0)
        
        self.navigationItem.titleView = button
        
    }
    
    @objc func presentAddressVc(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "addresschangevc") as! AddressChangeViewController
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
    
}
    
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "homecollection", for: indexPath) as! HomeCollectionViewCell
        cell.categoryTitle.text = categories[indexPath.row].category.rawValue.capitalizingFirstLetter()
        if let url = URL(string: self.categories[indexPath.row].imageURL) {
            cell.imageView.sd_setImage(with: url, completed: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "productvc") as! ProductViewController
        vc.currentCategory = selectedCategory
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



