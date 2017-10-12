//
//  ViewController.swift
//  ADrive
//
//  Created by Данияр Кадырбеков on 04.10.17.
//  Copyright © 2017 Данияр Кадырбеков. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func hendleLogout(){
        let testViewController = TestViewController()
        present(testViewController, animated: true, completion: nil)
    }
}

