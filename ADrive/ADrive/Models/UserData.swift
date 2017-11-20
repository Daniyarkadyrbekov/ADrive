//
//  UserData.swift
//  ADrive
//
//  Created by Данияр Кадырбеков on 20.11.17.
//  Copyright © 2017 Данияр Кадырбеков. All rights reserved.
//

import Foundation


struct UserSocial: Decodable {
    let fb: String?
    let instagram: String?
    let vk: String?
}

struct UserData: Decodable {
    let __v: Int?
    let _id: String?
    let createdAt: String?
    let deviceToken: String?
    let email: String?
    let passwordHash: String?
    let salt: String?
    let social: UserSocial?
    let updatedAt: String?
}
