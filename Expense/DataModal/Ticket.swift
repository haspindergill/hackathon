
//
//  Ticket.swift
//  ParkingApp
//
//  Created by Haspinder on 06/03/18.
//  Copyright © 2018 Haspinder Singh. All rights reserved.
//

import Foundation
class Ticket {
    var vehicleNumber : String?
    var vehicleBrand : String?
    var userId: String?
    var color: String?
    var time: String?
    var place: String?
    var lane: String?
    var method: String?
    var date:Date?

    init(userId:String?,vehileNumber:String?,vehicleBrand:String?,color:String?,time:String?,place:String?,lane :String?,method:String?,date:Date?) {
        self.vehicleBrand = vehicleBrand
        self.vehicleNumber = vehileNumber
        self.userId = userId
        self.color = color
        self.time = time
        self.place = place
        self.lane = lane
        self.method = method
        self.date = date
    }
    
    
}
