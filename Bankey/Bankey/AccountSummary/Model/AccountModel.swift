//
//  AccountModel.swift
//  Bankey
//
//  Created by Hamit Tırpan on 31.01.2024.
//

import Foundation

struct Account: Codable{
    let id: String
    let type: AccountType
    let name: String
    let amount: Decimal
    let createdDateTime: Date
    
}
