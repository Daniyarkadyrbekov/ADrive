//
//  ViewController.swift
//  ADrive
//
//  Created by Данияр Кадырбеков on 04.10.17.
//  Copyright © 2017 Данияр Кадырбеков. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(hendleLogout))
    }
    
    func hendleLogout(){
        let loginViewController = LoginController()
        present(loginViewController, animated: true, completion: nil)
    }


}

