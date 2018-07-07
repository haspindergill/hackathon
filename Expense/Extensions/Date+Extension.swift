
//
//  Date+Extension.swift
//  ParkingApp
//
//  Created by Haspinder on 05/03/18.
//  Copyright © 2018 Haspinder Singh. All rights reserved.
//

import Foundation
extension Date{
    func getDateFormatted(format : String) -> String?{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        return dateformatter.string(from: self as Date)
    }
    
}
