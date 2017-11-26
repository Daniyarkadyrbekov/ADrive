//
//  UserStandartController.swift
//  ADrive
//
//  Created by Данияр Кадырбеков on 15.11.17.
//  Copyright © 2017 Данияр Кадырбеков. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Alamofire

class AdminController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    //location and Map
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var marker = [GMSMarker]()
    
    //User State
    var userStateModelController: UserStateModelController!
    
    
    let userAcceptButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.setTitle("Пригласить всех", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // Here gonna check Headers of the user to login him
        let userState = userStateModelController.userState
        
        if let token = userState.token {
            print(token)
        }else {
            self.performSegue(withIdentifier: "LogoutSegue", sender: nil)
        }
    }
    
    override func loadView() {
        GMSServices.provideAPIKey("AIzaSyAPx222p1RMhFO7PSf-r3Aiiyj1nhgILsY")
        let camera = GMSCameraPosition.camera(withLatitude: 55.751244, longitude: 37.618423, zoom: 10.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Карта города"
        
        view.addSubview(userAcceptButton)
        setUpUserAcceptButton()
        
    }
    
    // Marker will be placed same way but with backend
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 13.0)
        
        self.mapView?.animate(to: camera)
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func setUpUserAcceptButton() {
        
        view.addConstraint(NSLayoutConstraint(item: userAcceptButton, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute:.top, multiplier: 1, constant: -10))
        view.addConstraint(NSLayoutConstraint(item: userAcceptButton, attribute: .leadingMargin, relatedBy: .equal, toItem: view, attribute: .leadingMargin, multiplier: 1, constant: 20))
        view.addConstraint(NSLayoutConstraint(item: userAcceptButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,multiplier: 1, constant: 60))
        view.addConstraint(NSLayoutConstraint(item: userAcceptButton, attribute: .trailingMargin, relatedBy: .equal, toItem: view, attribute: .trailingMargin, multiplier: 1, constant: -60))
        
    }
    
    
    func buttonAction(sender: UIButton!) {
        let userState = UserStateModel()
        if let token = userState.token {
            //Get to auth to check is token valid
            let headers: HTTPHeaders = [
                "token": token
            ]
            print(token)
            Alamofire.request("https://warm-castle-66534.herokuapp.com/push",method: .post, headers: headers)
                .responseJSON { response in
                    print(response)
            }
        }
    }
    
    // MARK: GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.performSegue(withIdentifier: "MarkerSegue", sender: marker)
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "LogoutSegue" == segue.identifier {
            if let nvc =  segue.destination as? UINavigationController {
                if let logoutViewController = nvc.viewControllers.first as? LoginController{
                    
                    var userState = userStateModelController.userState
                    if let _ = userState.token {
                        userState.token = nil
                    }
                    
                    logoutViewController.userStateModelController = userStateModelController
                }
            }
        }
    }
    
    
}
