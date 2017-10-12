//
//  CreateAccountController.swift
//  ADrive
//
//  Created by Данияр Кадырбеков on 12.10.17.
//  Copyright © 2017 Данияр Кадырбеков. All rights reserved.
//

import UIKit

class CreateAccountController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
