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

class HomeViewController: UIViewController {
    
    var categories = [Category]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.FlatColor.lightBlue
        retrieveProducts()
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



