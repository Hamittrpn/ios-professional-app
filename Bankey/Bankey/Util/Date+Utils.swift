//
//  Date+Utils.swift
//  Bankey
//
//  Created by Hamit Tırpan on 31.01.2024.
//

import Foundation

extension Date{
    static var bankeyDateFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "MDT")
        
        return formatter
    }
    
    var monthDateYearString: String{
        let dateFormatter = Date.bankeyDateFormatter
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        return dateFormatter.string(from: self)
    }
}
