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
import Alamofire

class UserMainController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    //location and Map
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var marker = [GMSMarker]()
    
    //User State
    var userStateModelController: UserStateModelController!
    
    struct JsonObj: Decodable {
        let err: Int?
        let res: UserData?
    }
    
    var profileData: JsonObj?
    
    let profileNames = ["Алексей","Сергей","Миша"]
    let profileNumbers = ["89009909099","89651110101","89997778877"]
    
    var locations = [Location]()
    func generateLocations() {
        var chage: Double
        for index in 1...10 {
            chage = Double(index) / 10
            locations.append(Location(token: "\(index)", long: 37.618423 + chage, lat: 55.751244 - chage))
        }
    }
    
    
    let userAcceptButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.setTitle("Принять предложение", for: .normal)
        button.setTitle("Алан пока не доступен", for: .disabled)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    let userTableDistanceButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.setTitle("Таблица", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.addTarget(self, action: #selector(tableButtonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // Here gonna check Headers of the user to login him
        let userState = userStateModelController.userState
        
        if let token = userState.token {
            //Get to auth to check is token valid
            let headers: HTTPHeaders = [
                "token": token
            ]
            
            Alamofire.request("https://warm-castle-66534.herokuapp.com/auth",method: .get, headers: headers)
                .responseJSON { response in
                    if let json = response.data {
                        do {
                            let userResultObject = try JSONDecoder().decode(JsonObj.self, from: json)
                            guard userResultObject.err == nil else {
                                self.performSegue(withIdentifier: "LogoutSegue", sender: nil)
                                return
                            }
                            self.profileData = userResultObject
                            print(userResultObject.res?.email ?? "nil")
                        }catch let jsonErr {
                            print("Error serializing json:", jsonErr)
                            self.performSegue(withIdentifier: "LogoutSegue", sender: nil)
                        }
                    }
                }
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
        
        putMarkers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Карта города"
        
        view.addSubview(userAcceptButton)
        view.addSubview(userTableDistanceButton)
        self.userAcceptButton.isEnabled = false
        self.userAcceptButton.backgroundColor = .gray
        setUpUserAcceptButton()
        setUpUserTableDistancetButton()
        
    }
    
    // Marker will be placed same way but with backend
    func putMarkers() {
        generateLocations()
        var i = 0
        for index in locations {
            marker.append(GMSMarker())
            marker[i].position = CLLocationCoordinate2D(latitude: index.lat, longitude: index.long)
            marker[i].title = "\(profileNames[Int(arc4random_uniform(3))]) \(profileNumbers[Int(arc4random_uniform(3))])"
            marker[i].snippet = index.token
            marker[i].map = mapView
            i += 1
        }
    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 13.0)
        
        self.mapView?.animate(to: camera)
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func setUpUserTableDistancetButton() {
        
        view.addConstraint(NSLayoutConstraint(item: userTableDistanceButton, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute:.bottom, multiplier: 1, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: userTableDistanceButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,multiplier: 1, constant: 40))
        view.addConstraint(NSLayoutConstraint(item: userTableDistanceButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,multiplier: 1, constant: 60))
        view.addConstraint(NSLayoutConstraint(item: userTableDistanceButton, attribute: .trailingMargin, relatedBy: .equal, toItem: view, attribute: .trailingMargin, multiplier: 1, constant: 0))
    }
    
    func setUpUserAcceptButton() {
        
        view.addConstraint(NSLayoutConstraint(item: userAcceptButton, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute:.top, multiplier: 1, constant: -10))
        view.addConstraint(NSLayoutConstraint(item: userAcceptButton, attribute: .leadingMargin, relatedBy: .equal, toItem: view, attribute: .leadingMargin, multiplier: 1, constant: 20))
        view.addConstraint(NSLayoutConstraint(item: userAcceptButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,multiplier: 1, constant: 60))
        view.addConstraint(NSLayoutConstraint(item: userAcceptButton, attribute: .trailingMargin, relatedBy: .equal, toItem: view, attribute: .trailingMargin, multiplier: 1, constant: -60))
        
    }
   
    
    func buttonAction(sender: UIButton!) {
        guard let userToken = userStateModelController.userState.token else {
            return
        }
        let location: [String : String] = [
            "lat" : "\(locationManager.location!.coordinate.latitude)",
            "lng" : "\(locationManager.location!.coordinate.longitude)"
        ]
        let parameters: [String: Any] = [
            "token": userToken,
            "location": location
        ]
        
        Alamofire.request("https://warm-castle-66534.herokuapp.com/accept-request",method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
        }
        
    }
    
    func tableButtonAction(sender: UIButton!){
        self.performSegue(withIdentifier: "TableDistanceSegue", sender: nil)
    }
    
    @IBAction func LogoutButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "LogoutSegue", sender: nil)
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
        if "MarkerSegue" == segue.identifier {
            print("MarkerSegue Works")
        }
        if "TableDistanceSegue" == segue.identifier {
            if let vc =  segue.destination as? DistanceTableControllerTableViewController {
                vc.marker = self.marker
            }
        }
        if "ProfileSegue" == segue.identifier {
            if let vc =  segue.destination as? ProfileController {
                if let userData = self.profileData?.res {
                    vc.userData = userData
                }
            }
        }
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

