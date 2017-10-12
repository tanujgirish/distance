//
//  PhoneVerificationViewController.swift
//  Distance
//
//  Created by Tanuj Girish on 10/11/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit
import SnapKit

class PhoneVerificationViewController: UIViewController {
    
    
    @IBOutlet weak var numberOne: UITextField!
    @IBOutlet weak var numberTwo: UITextField!
    @IBOutlet weak var numberThree: UITextField!
    @IBOutlet weak var numberFour: UITextField!
    
    var numberOneView = UIView()
    var numberTwoView = UIView()
    var numberThreeView = UIView()
    var numberFourView = UIView()
    
    @IBOutlet weak var confirmationCodeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var phoneNumber = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        numberOne.delegate = self
        numberTwo.delegate = self
        numberThree.delegate = self
        numberFour.delegate = self
        
        numberOne.tintColor = UIColor.clear
        numberTwo.tintColor = UIColor.clear
        numberThree.tintColor = UIColor.clear
        numberFour.tintColor = UIColor.clear
        
        numberOne.text?.removeAll()
        numberTwo.text?.removeAll()
        numberThree.text?.removeAll()
        numberFour.text?.removeAll()
        
        numberOne.keyboardType = .numberPad
        numberTwo.keyboardType = .numberPad
        numberThree.keyboardType = .numberPad
        numberFour.keyboardType = .numberPad
        
        numberOne.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        numberTwo.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        numberThree.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        numberFour.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        phoneNumber = "2818967762"
        phoneNumber = phoneNumber.format(phoneNumber: phoneNumber)!
        
        
        descriptionTextView.isEditable = false
        descriptionTextView.isSelectable = false
        
        
        let descriptionText = "We've sent a four-digit confirmation code to \(phoneNumber). Enter it here to confirm your phone number"
        
        
        var myMutableString = NSMutableAttributedString()
        
        
        myMutableString = NSMutableAttributedString(string: descriptionText, attributes: [NSAttributedStringKey.font: UIFont(name: "Avenir", size: 15), NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        
        
        
        if let range = (descriptionText as NSString).range(of: phoneNumber) as? NSRange {
            myMutableString.setAttributes([NSAttributedStringKey.font: UIFont(name: "Avenir-Heavy", size: 15),   NSAttributedStringKey.foregroundColor: UIColor.darkGray], range: range)
        }
        
        descriptionTextView.attributedText = myMutableString
        
        addTextFieldViews()
    }
    
    func addTextFieldViews() {
        self.numberOne.addSubview(numberOneView)
        self.numberTwo.addSubview(numberTwoView)
        self.numberThree.addSubview(numberThreeView)
        self.numberFour.addSubview(numberFourView)
        
        self.numberOneView.snp.makeConstraints { (make) in
            make.center.equalTo(numberOne.snp.center)
            make.size.equalTo(numberOne.snp.size)
        }
        self.numberTwoView.snp.makeConstraints { (make) in
            make.center.equalTo(numberTwo.snp.center)
            make.size.equalTo(numberTwo.snp.size)
        }
        self.numberThreeView.snp.makeConstraints { (make) in
            make.center.equalTo(numberThree.snp.center)
            make.size.equalTo(numberThree.snp.size)
        }
        self.numberFourView.snp.makeConstraints { (make) in
            make.center.equalTo(numberFour.snp.center)
            make.size.equalTo(numberFour.snp.size)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        numberOne.becomeFirstResponder()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case numberOne:
            numberTwo.becomeFirstResponder()
        case numberTwo:
            numberThree.becomeFirstResponder()
        case numberThree:
            numberFour.becomeFirstResponder()
        case numberFour:
            numberFour.resignFirstResponder()
        default:
            break
        }
    }
    
}

extension PhoneVerificationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            switch textField {
            case numberOne:
                numberOne.text?.removeAll()
                numberOne.becomeFirstResponder()
            case numberTwo:
                numberTwo.text?.removeAll()
                numberTwo.becomeFirstResponder()
            case numberThree:
                numberThree.text?.removeAll()
                numberThree.becomeFirstResponder()
            case numberFour:
                numberFour.text?.removeAll()
                numberFour.becomeFirstResponder()
            default:
                break
            }
        }
        
        return true
    }
}
