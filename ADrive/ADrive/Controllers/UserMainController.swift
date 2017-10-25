//
//  UserMainController.swift
//  ADrive
//
//  Created by Данияр Кадырбеков on 22.10.17.
//  Copyright © 2017 Данияр Кадырбеков. All rights reserved.
//

import UIKit
import GoogleMaps

class UserMainController: UIViewController {
    
    let userAcceptButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.setTitle("Принять предложение", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Карта города"
        
        GMSServices.provideAPIKey("AIzaSyAPx222p1RMhFO7PSf-r3Aiiyj1nhgILsY")
        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withLatitude: 55.751244, longitude: 37.618423, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        view = mapView
        
        view.addSubview(userAcceptButton)
        
        setUpUserAcceptButton()
        
    }
    
    func setUpUserAcceptButton() {
        
        view.addConstraint(NSLayoutConstraint(item: userAcceptButton, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute:.top, multiplier: 1, constant: -10))
        
        view.addConstraint(NSLayoutConstraint(item: userAcceptButton, attribute: .leadingMargin, relatedBy: .equal, toItem: view, attribute: .leadingMargin, multiplier: 1, constant: 10))
        view.addConstraint(NSLayoutConstraint(item: userAcceptButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,multiplier: 1, constant: 80))
        view.addConstraint(NSLayoutConstraint(item: userAcceptButton, attribute: .trailingMargin, relatedBy: .equal, toItem: view, attribute: .trailingMargin, multiplier: 1, constant: -10))
        
    }
   
    
    func buttonAction(sender: UIButton!) {
        print("Button tapped")
    }

}
