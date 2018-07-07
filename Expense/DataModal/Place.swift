
//
//  Place.swift
//  Expense
//
//  Created by Haspinder on 07/07/18.
//  Copyright © 2018 Haspinder Singh. All rights reserved.
//

import Foundation
class Place : NSObject{
    
    
    override init() {
        
    }
    
 
    
    var name : String?
    var lat : String?
    var long: String?
 
    
    init(name:String?,lat:String?,long:String?) {
        self.name = name
        self.lat = lat
        self.long = long
    }
}
