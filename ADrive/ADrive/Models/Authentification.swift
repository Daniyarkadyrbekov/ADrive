//
//  File.swift
//  ADrive
//
//  Created by Данияр Кадырбеков on 25.11.17.
//  Copyright © 2017 Данияр Кадырбеков. All rights reserved.
//

import Foundation
import Alamofire

class Authentification{
    
    private let email:String?
    private let password:String?
    private let first_name:String?
    private let last_name:String?
    private let deviceToken:String?
    private var requestIsSuccessful: Bool?
    var token: String?

    
    
    init(authorizationEmail email: String, authorizationPassword password: String){
        self.email = email
        self.password = password
        first_name = nil
        last_name = nil
        deviceToken = nil
        requestIsSuccessful = nil
        token = nil
    }
    
    func authorization() -> Bool {
        guard let email = self.email, let password = self.password else {
            return false
        }
        
        let parameters: [String: String] = [
        "email": email,
        "password": password
        ]
        
        struct JsonObj: Decodable {
            let res : String?
            let err: Int?
        }
        
        Alamofire.request("https://warm-castle-66534.herokuapp.com/auth",method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                if let json = response.data {
                    do {
                        let courses = try JSONDecoder().decode(JsonObj.self, from: json)
                        guard courses.err == nil else {
                            print("Authorization Error")
                            self.requestIsSuccessful = false
                            return
                        }
                        self.token = courses.res
                        self.requestIsSuccessful = true
                        
                    }catch let jsonErr {
                        print("Error serializing json:", jsonErr)
                        self.requestIsSuccessful = false
                    }
                }
        }
        guard let requestIsSuccessful = requestIsSuccessful else {
            return false
        }
        return requestIsSuccessful
    }
}
