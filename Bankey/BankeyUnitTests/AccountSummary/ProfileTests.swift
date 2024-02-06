//
//  ProfileTests.swift
//  BankeyUnitTests
//
//  Created by Hamit Tırpan on 31.01.2024.
//

import Foundation

import Foundation
import XCTest

@testable import Bankey

class ProfileTests: XCTestCase{
    
    override class func setUp() {
        super.setUp()
    }
    
    func testCanParse(){
        let json = """
        {
        "id": "1",
        "first_name": "Hamit",
        "last_name": "Tırpan",
        }
        """
    
        let data = json.data(using: .utf8)!
        let result = try! JSONDecoder().decode(Profile.self, from: data)
        
        XCTAssertEqual(result.id, "1")
        XCTAssertEqual(result.firstName, "Hamit")
        XCTAssertEqual(result.lastName, "Tırpan")
    
    }
}
