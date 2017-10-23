//
//  UserMainController.swift
//  ADrive
//
//  Created by Данияр Кадырбеков on 22.10.17.
//  Copyright © 2017 Данияр Кадырбеков. All rights reserved.
//

import UIKit
import GoogleMaps

class UserMainController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey("AIzaSyAPx222p1RMhFO7PSf-r3Aiiyj1nhgILsY")
        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withLatitude: 55.751244, longitude: 37.618423, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }

}
