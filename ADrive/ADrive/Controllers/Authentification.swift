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
    
    func registration(email: String, password: String, firstName: String, lastName: String, deviceToken: String?, completionHandler: @escaping (String?, String?) -> () ) {
        
        let parameters: [String: String] = [
            "email": email,
            "password": password,
            "first_name": firstName,
            "last_name": lastName,
            "deviceToken": deviceToken ?? "nil"
        ]
        
        Alamofire.request("https://warm-castle-66534.herokuapp.com/register",method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                if let json = response.data {
                    do {
                        let jsonErr = try JSONSerialization.jsonObject(with: json, options: .mutableContainers) as! Dictionary<String, Any>
                        if let _ = jsonErr["err"] as? Dictionary<String, Any> {
                            completionHandler("Ошибка Регистрации. Попробуйте использовать другой email", nil)
                        }else{
                            self.authorization(email: parameters["email"]!, password: parameters["password"]!, completionHandler: { (error, result) in
                                guard error == nil else {
                                    completionHandler(error, nil)
                                    return
                                }
                                completionHandler(nil, result)
                            })
                        }
                    }catch let jsonErr {
                        print("Error serializing json:", jsonErr)
                        completionHandler("Error serializing json:", nil)
                    }
                }
        }
    }
}

