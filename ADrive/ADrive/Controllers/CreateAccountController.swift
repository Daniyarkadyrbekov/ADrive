//
//  CreateAccountController.swift
//  ADrive
//
//  Created by Данияр Кадырбеков on 12.10.17.
//  Copyright © 2017 Данияр Кадырбеков. All rights reserved.
//

import UIKit
import Alamofire

class CreateAccountController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    
    let parameters: [String: String] = [
        "email": "test111117@test.com",
        "password": "123456"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
//                Alamofire.request("https://warm-castle-66534.herokuapp.com/register",method: .post, parameters: parameters, encoding: JSONEncoding.default)
//                    .responseJSON { response in
//                        print(response)
//                }
        
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
