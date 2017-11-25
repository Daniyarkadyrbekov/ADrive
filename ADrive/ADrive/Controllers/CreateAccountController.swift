//
//  CreateAccountController.swift
//  ADrive
//
//  Created by Данияр Кадырбеков on 12.10.17.
//  Copyright © 2017 Данияр Кадырбеков. All rights reserved.
//

import UIKit
import Alamofire

class CreateAccountController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    var localPath:String?;
    
    var userStateModelController: UserStateModelController!
    
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
        
        imagePicker.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateAccountController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)

    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        // We use document directory to place our cloned image
        let documentDirectory: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        
        // Set static name, so everytime image is cloned, it will be named "temp", thus rewrite the last "temp" image.
        // *Don't worry it won't be shown in Photos app.
        let imageName = "temp"
        let imagePath = documentDirectory.appendingPathComponent(imageName)
        
        // Encode this image into JPEG. *You can add conditional based on filetype, to encode into JPEG or PNG
        if let data = UIImageJPEGRepresentation(image, 80) {
            // Save cloned image into document directory
            try! data.write(to: URL(fileURLWithPath: imagePath))
        }
        
        // Save it's path
        localPath = imagePath
        
        Alamofire.upload(
            multipartFormData: { formData in
                let filePath = NSURL(fileURLWithPath: self.localPath!)
                let imageData = try? Data.init(contentsOf: filePath as URL)
                formData.append(imageData!, withName: "file")
                
        },
            to: "https://warm-castle-66534.herokuapp.com/upload",
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
        
        dismiss(animated: true, completion: {
            
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
        
        Alamofire.request("https://warm-castle-66534.herokuapp.com/register",method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                if let json = response.data {
                    do {
                        let jsonErr = try JSONSerialization.jsonObject(with: json, options: .mutableContainers) as! Dictionary<String, Any>
                        if let _ = jsonErr["err"] as? Dictionary<String, Any> {
                            self.errorAlert(withMessage: "Ошибка Регистрации. Попробуйте использовать другой email")
                        }else{
                            self.makeAuthorisation(with: parameters)
                        }
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
