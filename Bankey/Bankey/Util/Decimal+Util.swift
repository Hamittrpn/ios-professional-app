//
//  DecimalUtil.swift
//  Bankey
//
//  Created by Hamit Tırpan on 30.01.2024.
//

import Foundation

extension Decimal{
    var doubleValue: Double{
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
