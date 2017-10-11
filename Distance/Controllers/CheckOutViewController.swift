//
//  CheckOutViewController.swift
//  Distance
//
//  Created by Tanuj Girish on 10/10/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit
import MapKit

class CheckOutViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }

}

extension CheckOutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 78
        } else if indexPath.row == 1 {
            return 70
        } else if indexPath.row == 2 {
            return 118
        } else {
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            let cell: DeliveryInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "deliverycell", for: indexPath) as! DeliveryInfoTableViewCell
            return cell
            
        } else if indexPath.row == 1 {
            
            let cell: PaymentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "paymentinfocell", for: indexPath) as! PaymentTableViewCell
            return cell
            
        } else if indexPath.row == 2 {
            
            let cell: OrderSummaryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ordersummarycell", for: indexPath) as! OrderSummaryTableViewCell
            return cell
            
        } else {
            
            let cell: TotalTableViewCell = tableView.dequeueReusableCell(withIdentifier: "totalcell", for: indexPath) as! TotalTableViewCell
            return cell
            
        }
    }
}
