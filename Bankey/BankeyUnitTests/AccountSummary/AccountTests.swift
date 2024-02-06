//
//  AccountTests.swift
//  BankeyUnitTests
//
//  Created by Hamit Tırpan on 6.02.2024.
//

import Foundation
import XCTest

@testable import Bankey

class AccountTests: XCTestCase{
    
    override class func setUp() {
        super.setUp()
    }
    
    func testCanParse(){
        let json = """
        [
            {
            "id": "1",
            "type": "Banking",
            "name": "Basic Savings",
            "amount": 929466.23,
            "createdDateTime": "2023-06-21T15:29:32Z"
            },
            {
            "id": "2",
            "type": "Banking",
            "name": "No-Fee All-In Chequing",
            "amount": 17562.44,
            "createdDateTime": "2011-06-21T15:29:32Z"
            },
        ]
        """
    
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        
        let result = try! decoder.decode([Account].self, from: data)
        
        XCTAssertEqual(result.count, 2)
        
        let account1 = result[0]
        XCTAssertEqual(account1.id, "1")
        XCTAssertEqual(account1.type, .Banking)
        XCTAssertEqual(account1.name, "Basic Savings")
        XCTAssertEqual(account1.amount, 929466.23)
        XCTAssertEqual(account1.createdDateTime.monthDateYearString, "Haz 21, 2023")
        
    
    }
}
