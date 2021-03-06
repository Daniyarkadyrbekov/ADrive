//
//  CreateAccountController.swift
//  ADrive
//
//  Created by Данияр Кадырбеков on 12.10.17.
//  Copyright © 2017 Данияр Кадырбеков. All rights reserved.
//

import UIKit
import Alamofire
import ALCameraViewController

class CreateAccountController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    var userStateModelController: UserStateModelController!
    
    let authentification = Authentification()
    
    struct JsonObj: Decodable {
        let res : String?
        let err: Int?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
        surnameTextField.delegate = self
        nameTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateAccountController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        let cropping = CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: CGSize(width: 60, height: 60))
        
        let cameraViewController = CameraViewController(croppingParameters: cropping, allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: true){ [weak self] image, asset in
            
            self?.dismiss(animated: true, completion: nil)
            
        }
        present(cameraViewController, animated: true, completion: nil)
    }
    
    
    
    
    private func fieldsAreCorrect() -> Bool {
        guard let login = loginTextField.text, login != "" else {
            errorAlert(withMessage: "поле email пустое")
            return false
        }
        guard let password = passwordTextField.text, password != "" else {
            errorAlert(withMessage: "поле пароля пустое")
            return false
        }
        guard let surname = surnameTextField.text, surname != "" else {
            errorAlert(withMessage: "поле фамилии пустое")
            return false
        }
        guard let name = nameTextField.text, name != "" else {
            errorAlert(withMessage: "поле имени пустое")
            return false
        }
        guard let repeatPassword = repeatPasswordTextField.text, password == repeatPassword  else {
            errorAlert(withMessage: "пароли не идентичны")
            return false
        }
        
        
        return true
    }

    @IBAction func registerButtonPresssed(_ sender: UIButton) {
        
        guard fieldsAreCorrect() else{
            return
        }
        
        let parameters: [String: String] = [
            "email": (loginTextField?.text)!,
            "password": (passwordTextField?.text)!,
            "first_name": (nameTextField?.text)!,
            "last_name": (surnameTextField?.text)!,
            "deviceToken": userStateModelController.userState.deviceToken ?? "nil"
        ]
        
        authentification.registration(email: parameters["email"]!, password: parameters["password"]!, firstName: parameters["first_name"]!, lastName: parameters["last_name"]!, deviceToken: parameters["deviceToken"]!, completionHandler: { (error, result) in
            guard error == nil else {
                self.errorAlert(withMessage: error ?? "Низвестная ошибка авторизациии")
                return
            }
            self.performSegue(withIdentifier: "ShowMainController", sender: result)
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMainController" {
            if let nvc = segue.destination as? UINavigationController{
                if let dvc = nvc.viewControllers.first as? UserMainController{
                    if let token = sender as? String {
                        var newState = UserStateModel()
                        newState.token = token
                        userStateModelController.userState = newState
                        dvc.userStateModelController = userStateModelController
                    }
                }
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func errorAlert(withMessage error: String) {
        // create the alert
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
}
