//
//  AddPayementViewController.swift
//  Distance
//
//  Created by Tanuj Girish on 10/15/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit
import Alamofire
import Stripe

class AddPayementViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var cardBrandImage: UIImageView!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cardNumberIndi: UIView!
    
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var expTextField: UITextField!
    @IBOutlet weak var expIndi: UIView!
    
    @IBOutlet weak var cvvLabel: UILabel!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var cvvIndi: UIView!
    
    @IBOutlet weak var postalCodeLabel: UILabel!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var postalCodeIndi: UIView!

    let cardParams = STPCardParams()
    
    
    // MARK: - Variables
    
    lazy var addButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 45))
        button.setTitle("Add", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 18)
        button.backgroundColor = UIColor.FlatColor.red
        button.addTarget(self, action: #selector(addPayment), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardNumberTextField.keyboardType = .numberPad
        expTextField.keyboardType = .numberPad
        cvvTextField.keyboardType = .numberPad
        postalCodeTextField.keyboardType = .numberPad
        
        cardNumberTextField.delegate = self
        expTextField.delegate = self
        cvvTextField.delegate = self
        postalCodeTextField.delegate = self
        
    }

    override var inputAccessoryView: UIView? {
        get {
            return addButton
        }
    }
    
    private func brandForNumber(_ number: String) -> STPCardBrand {
        let cardNumber = STPCardValidator.sanitizedNumericString(for: number)
        return STPCardValidator.brand(forNumber: cardNumber)
    }
    
    private func validateCard() -> STPCardValidationState {
        return STPCardValidator.validationState(forCard: cardParams)
    }
    
    
    
    func generateToken() {
        guard let cardNumber = self.cardNumberTextField.text?.replacingOccurrences(of: " ", with: ""),
              let expMonth = self.expTextField.text?.split(separator: "/")[0],
              let expYear = self.expTextField.text?.split(separator: "/")[1],
              let cvv = self.cvvTextField.text else { return }

        cardParams.cvc = cvv
        cardParams.number = cardNumber
        cardParams.expMonth = UInt(expMonth)!
        cardParams.expYear = UInt(expYear)!
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            if error != nil {
                print(error)
                return
            }
            self.addPayment(token)
        }
    }
    
    @objc func addPayment(_ token: STPToken?) {
        let url = "https://us-central1-distance-c3c4a.cloudfunctions.net/AddCardToStripeCustomer"
        let parameters: [String: Any] = ["token": token, "stripeCustomerId": CurrentUser.sharedInstance.currentUser.stripeCustomerId]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                print(data)
                //completion(json as? [String: AnyObject], nil)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func changeCardImage(_ brand: STPCardBrand) {
        switch brand {
        case .amex:
            self.cardBrandImage.image = #imageLiteral(resourceName: "amex")
        case .dinersClub:
            self.cardBrandImage.image = #imageLiteral(resourceName: "diners-club")
        case .discover:
            self.cardBrandImage.image = #imageLiteral(resourceName: "discover")
        case .JCB:
            self.cardBrandImage.image = #imageLiteral(resourceName: "jcb")
        case .masterCard:
            self.cardBrandImage.image = #imageLiteral(resourceName: "mastercard")
        case .visa:
            self.cardBrandImage.image = #imageLiteral(resourceName: "visa")
        case .unknown:
            self.cardBrandImage.image = #imageLiteral(resourceName: "unknown")
        }
    }

}

extension AddPayementViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
        let newLength: Int = currentText.count
        
        if textField == cardNumberTextField {
            let brand = self.brandForNumber(currentText)
            self.changeCardImage(brand)
            if newLength == 19 {
                expTextField.becomeFirstResponder()
            }
            textField.text = currentText.grouping(every: 4, with: " ")
            return false
        } else if textField == expTextField {
            if newLength == 5 {
                cvvTextField.becomeFirstResponder()
            }
            textField.text = currentText.grouping(every: 2, with: "/")
            return false
        } else if textField == cvvTextField {
            if newLength == 3 {
                postalCodeTextField.becomeFirstResponder()
            }
            textField.text = currentText.grouping(every: 3, with: " ")
            return false
        } else {
            return true
        }
    }
}
