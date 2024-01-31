//
//  ProfileModel.swift
//  Bankey
//
//  Created by Hamit Tırpan on 31.01.2024.
//

import Foundation

struct Profile: Codable{
    let id: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey{
        case id
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
