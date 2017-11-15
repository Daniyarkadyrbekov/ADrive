//
//  UserStateModel.swift
//  ADrive
//
//  Created by Данияр Кадырбеков on 12.11.17.
//  Copyright © 2017 Данияр Кадырбеков. All rights reserved.
//

import Foundation

struct UserStateModel {
    var token: String?{
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "token")
        }
        get {
            let defaults = UserDefaults.standard
            let token = defaults.object(forKey: "token") as? String
            return token
        }
    }
}
