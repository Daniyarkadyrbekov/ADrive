//
//  TestViewController.swift
//  ADrive
//
//  Created by Данияр Кадырбеков on 11.10.17.
//  Copyright © 2017 Данияр Кадырбеков. All rights reserved.
//

import UIKit
import GoogleMaps

class TestViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
        
        GMSServices.provideAPIKey("AIzaSyAPx222p1RMhFO7PSf-r3Aiiyj1nhgILsY")
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
