//
//  UserMainController.swift
//  ADrive
//
//  Created by Данияр Кадырбеков on 22.10.17.
//  Copyright © 2017 Данияр Кадырбеков. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation


class UserMainController: UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var locations = [Location]()
    func generateLocations() {
        var chage: Double
        for index in 1...10 {
            chage = Double(index) / 10
            //print("\(index) change = \(chage)")
            locations.append(Location(token: "\(index)", long: 37.618423 + chage, lat: 55.751244 - chage))
        }
        //print(locations.count)
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //print(locations.count)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Карта города"
        
        GMSServices.provideAPIKey("AIzaSyAPx222p1RMhFO7PSf-r3Aiiyj1nhgILsY")
        let camera = GMSCameraPosition.camera(withLatitude: 55.751244, longitude: 37.618423, zoom: 10.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        view = mapView
        
        
        
        var marker = [GMSMarker]()
        generateLocations()
        var i = 0
        for index in locations {
            marker.append(GMSMarker())
            marker[i].position = CLLocationCoordinate2D(latitude: index.lat, longitude: index.long)
            marker[i].title = "Алексей 87779651170737"
            marker[i].snippet = index.token
            marker[i].map = mapView
            i += 1
        }
        
        
        
        //view.addSubview(userAcceptButton)
        //setUpUserAcceptButton()
        
    }
    
    //Location Manager delegates
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        
        self.mapView?.animate(to: camera)
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
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

