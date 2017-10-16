//
//  PaymentOptionsViewController.swift
//  Distance
//
//  Created by Tanuj Girish on 10/14/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit
import Alamofire
import Stripe

class PaymentOptionsViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var payments = [Payment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrievePaymentMethods()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func deviceSupportsApplePay() -> Bool {
        return Stripe.deviceSupportsApplePay()
    }

    func retrievePaymentMethods() {
        let url = "https://us-central1-distance-c3c4a.cloudfunctions.net/RetrieveCustomerCards"
        let parameters: [String: Any] = ["stripeCustomerId": CurrentUser.sharedInstance.currentUser.stripeCustomerId]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            switch response.response?.statusCode {
            case 200?:
                if let data = response.data {
                    do {
                        if let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let dataArr = dictionary["data"] as? [[String: Any]] {
                                for data in dataArr {
                                    let payment = Payment(data: data)
                                    self.payments.append(payment)
                                }
                            }
                            DispatchQueue.main.async {
                                //reload table view
                                self.tableView.reloadData()
                            }
                        }
                    } catch {
                        print("error parsing data")
                    }
                }
            case 400?:
                print(response.data)
            default:
                print(response.data)
            }
        }
    }
    
    private func totalRowCount() -> Int {
        if deviceSupportsApplePay() {
            return payments.count + 2
        } else {
            return payments.count + 1
        }
    }


}

extension PaymentOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalRowCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PaymentOptionsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "paymentoptioncell", for: indexPath) as! PaymentOptionsTableViewCell
        
        if deviceSupportsApplePay() {
            //add apple pay to row 0
            if indexPath.row == 0 {
                cell.paymentImage.image = #imageLiteral(resourceName: "apple-pay")
                cell.paymentBrand.text = "Apple Pay"
            }
            //add rest of payments
            if indexPath.row < payments.count {
                
            } else if indexPath.row != 0 {
                cell.paymentImage.image = #imageLiteral(resourceName: "add-card")
                cell.paymentBrand.text = "Add Payment Card"
            }
            //add add card to last row
        } else {
            if indexPath.row < payments.count {
                
            } else {
                cell.paymentImage.image = #imageLiteral(resourceName: "add-card")
                cell.paymentBrand.text = "Add Payment Card"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == totalRowCount() {
            print(indexPath.row + 1, totalRowCount())
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "addpaymentvc") as! AddPayementViewController
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
}




