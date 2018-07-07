//
//  SDataSingleton.swift
//
//
//  Created by cbl16 on 7/11/16.
//  Copyright © 2016 Haspinder. All rights reserved.
//

import UIKit
//import RMMapper

class UserDataSingleton {
    static let sharedInstance: UserDataSingleton = { UserDataSingleton() }()


        var loggedInUser : User?//{
//            get{
//                var user : User?
//                if let data = UserDefaults.standard.rm_customObject(forKey:"profile") as? User{
//                    user = data
//                }
//                return user
//            }
//            set{
//                let defaults = UserDefaults.standard
//
//                if let value = newValue{
//                    defaults.rm_setCustomObject(value, forKey: "profile")
//                }
//                else{
//                    defaults.removeObject(forKey: "profile")
//                }
//            }
//    }
}
