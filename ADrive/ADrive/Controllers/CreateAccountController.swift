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
    
    var userStateModelController: UserStateModelController!
    
    struct JsonObj: Decodable {
        let res : String?
        let err: Int?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }

    @IBAction func registerButtonPresssed(_ sender: UIButton) {
        
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
        
        Alamofire.request("https://warm-castle-66534.herokuapp.com/register",method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                if let json = response.data {
                   // print(json)
                    do {
                        let courses = try JSONDecoder().decode(JsonObj.self, from: json)
                        guard courses.err == nil else {
                            self.errorAlert()
                            return
                        }
                        self.makeAuthorisation(with: parameters)
                    }catch let jsonErr {
                        print("Error serializing json:", jsonErr)
                    }
                }
        }
    }
    
    func makeAuthorisation(with parameters: [String: String]) {
        Alamofire.request("https://warm-castle-66534.herokuapp.com/auth",method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let courses = try JSONDecoder().decode(JsonObj.self, from: json)
                        guard courses.err == nil else {
                            print("User login error")
                            return
                        }
                        self.performSegue(withIdentifier: "ShowMainController", sender: courses)
                    }catch let jsonErr {
                        print("Error serializing json:", jsonErr)
                    }
                }
        }
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
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
