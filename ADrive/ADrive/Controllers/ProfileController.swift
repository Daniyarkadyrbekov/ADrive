//
//  ProfileController.swift
//  ADrive
//
//  Created by Данияр Кадырбеков on 19.11.17.
//  Copyright © 2017 Данияр Кадырбеков. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    var userStateModelController: UserStateModelController!

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileNumber: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var profileSurname: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    

}
