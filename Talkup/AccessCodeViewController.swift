//
//  AccessCodeViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 7/27/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class AccessCodeViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Properties 
    
    var accessCodes: [String] = ["test1234"]
    
    @IBOutlet weak var accessCodeTextField: UITextField!
    @IBOutlet weak var requestCodeButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    
    //MARK: - UI Actions 
    
    
    
    
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        requestCodeButton.layer.borderColor = UIColor.white.cgColor
        requestCodeButton.layer.borderWidth = 1
        requestCodeButton.layer.cornerRadius = 6.0
        requestCodeButton.layer.masksToBounds = true
        continueButton.layer.cornerRadius = 8.0
        continueButton.layer.masksToBounds = true
        accessCodeTextField.delegate = self
    }
    
    
    //MARK: - text field delegate 
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard let accessCode = accessCodeTextField.text else { return true }
        
        if accessCodes.contains(accessCode) {
            performSegue(withIdentifier: "accessCodeSuccess", sender: self)
        } else {
            print("show alert problem")
        }
        
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let accessCode = accessCodeTextField.text else { return }
        
        if accessCodes.contains(accessCode) {
            
            print("haz code")
            
        } else {
            print("show alert")
        }
    }
}
