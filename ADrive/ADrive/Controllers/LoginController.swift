//
//  TestViewController.swift
//  ADrive
//
//  Created by Данияр Кадырбеков on 11.10.17.
//  Copyright © 2017 Данияр Кадырбеков. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire


class LoginController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var userStateModelController: UserStateModelController!

    
    let headers: HTTPHeaders = [
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjU5ZWRmYTZlOGM4YmQwNGNhZmJmZDU1ZSIsImVtYWlsIjoidGVzdEB0ZXN0LmNvbSIsImlhdCI6MTUxMDMzNTk2MX0.daBpomFXXEWWURJPVzBz2KzhR_atjN0k9EuQTvWHGCk"
    ]
    
    struct JsonObj: Decodable {
        let res : String?
        let err: Int?
    }
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        guard let login = loginTextField.text, login != "" else {
            errorAlert()
            return
        }
        guard let password = passwordTextField.text, password != "" else {
            errorAlert()
            return
        }
        let parameters: [String: String] = [
            "email": login,
            "password": password
        ]
        Alamofire.request("https://warm-castle-66534.herokuapp.com/auth",method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let courses = try JSONDecoder().decode(JsonObj.self, from: json)
                        guard courses.err == nil else {
                            self.errorAlert()
                            return
                        }
                       self.performSegue(withIdentifier: "ShowMainController", sender: courses)
                    }catch let jsonErr {
                        print("Error serializing json:", jsonErr)
                    }
                }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMainController" {
            if let nvc = segue.destination as? UINavigationController{
                if let dvc = nvc.viewControllers.first as? UserMainController{
                    if let courses = sender as? JsonObj {
                        if let token = courses.res{
                            var newState = UserStateModel()
                            newState.token = token
                            userStateModelController.userState = newState
                            dvc.userStateModelController = userStateModelController
                        }
                    }
                }
            }
        }
        
        if segue.identifier == "RegistrationView" {
            if let dvc = segue.destination as? CreateAccountController {
                dvc.userStateModelController = userStateModelController
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func errorAlert() {
        // create the alert
        let alert = UIAlertController(title: "Error", message: "Что то пошло не так(", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
