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

    func authorization(email: String, password: String, completionHandler: @escaping (String?, String?) -> () ) {

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
                if let json = response.data {
                    do {
                        let courses = try JSONDecoder().decode(JsonObj.self, from: json)
                        guard courses.err == nil else {
                            completionHandler("wrong login or password error" , nil)
                            return
                        }
                        completionHandler(nil, courses.res)
                    }catch let jsonErr {
                        print("Error serializing json:", jsonErr)
                        completionHandler("error serializing json", nil)
                    }
                }
        }
    }
}

