//
//  ProfileController.swift
//  ADrive
//
//  Created by Данияр Кадырбеков on 19.11.17.
//  Copyright © 2017 Данияр Кадырбеков. All rights reserved.
//

import UIKit
import Alamofire
import ALCameraViewController

class ProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var userStateModelController: UserStateModelController!
    
    var userData: UserData?
    
    //let imagePicker = UIImagePickerController()
    
    
    //var localPath:String?;

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileNumber: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var profileSurname: UILabel!
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUserProfileData()
        
        //imagePicker.delegate = self
    }
    
    private func setUserProfileData(){
        profileName.text = userData?._id ?? ""
        profileNumber.text = userData?.deviceToken ?? ""
        profileEmail.text = userData?.email ?? ""
        profileSurname.text = userData?.createdAt ?? ""
        
    }
    
    func profileImageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        
        let cropping = CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: CGSize(width: 60, height: 60))
        
        let cameraViewController = CameraViewController(croppingParameters: cropping, allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: true){ [weak self] image, asset in
            // Do something with your image here.
            self?.profileImage.contentMode = .scaleAspectFit
            self?.profileImage.image = image
            self?.dismiss(animated: true, completion: nil)
        }
        present(cameraViewController, animated: true, completion: nil)
        
//        let imagePickerViewController = CameraViewController.imagePickerViewController(croppingParameters: cropping){
//            [weak self] image, asset in
//            //            // Do something with your image here.
//                        self?.profileImage.contentMode = .scaleAspectFit
//                        self?.profileImage.image = image
//                        self?.dismiss(animated: true, completion: nil)
//        }
        //present(imagePickerViewController, animated: true, completion: nil)
        
//        if let tappedImage = tapGestureRecognizer.view as? UIImageView {
//            imagePicker.allowsEditing = false
//            imagePicker.sourceType = .photoLibrary
//            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
//            present(imagePicker, animated: true, completion: nil)
//        }
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
//            return
//        }
//        profileImage.contentMode = .scaleAspectFit
//        profileImage.image = image
//
//        // We use document directory to place our cloned image
//        let documentDirectory: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
//
//        // Set static name, so everytime image is cloned, it will be named "temp", thus rewrite the last "temp" image.
//        // *Don't worry it won't be shown in Photos app.
//        let imageName = "temp"
//        let imagePath = documentDirectory.appendingPathComponent(imageName)
//
//        // Encode this image into JPEG. *You can add conditional based on filetype, to encode into JPEG or PNG
//        if let data = UIImageJPEGRepresentation(image, 80) {
//            // Save cloned image into document directory
//            try! data.write(to: URL(fileURLWithPath: imagePath))
//        }
//
//        // Save it's path
//        localPath = imagePath
//
//        Alamofire.upload(
//            multipartFormData: { formData in
//                let filePath = NSURL(fileURLWithPath: self.localPath!)
//                let imageData = try? Data.init(contentsOf: filePath as URL)
//                formData.append(imageData!, withName: "file")
//
//        },
//            to: "https://warm-castle-66534.herokuapp.com/upload",
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON { response in
//                        debugPrint(response)
//                    }
//                case .failure(let encodingError):
//                    print(encodingError)
//                }
//        })
//
//        dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
    

}
