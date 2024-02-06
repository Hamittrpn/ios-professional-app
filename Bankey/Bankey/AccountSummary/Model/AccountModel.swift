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
    
    static func makeSkeleton() -> Account{
        return Account(id: "1", type: .Banking, name: "Account Name", amount: 0.0, createdDateTime: Date())
    }
    
}
