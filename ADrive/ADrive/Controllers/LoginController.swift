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
        
        if segue.identifier == "ShowAdminController" {
            if let nvc = segue.destination as? UINavigationController{
                if let dvc = nvc.viewControllers.first as?  AdminController{
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
