
//
//  UIView+Extension.swift
//  ParkingApp
//
//  Created by Haspinder on 06/03/18.
//  Copyright © 2018 Haspinder Singh. All rights reserved.
//

import Foundation
import UIKit

extension  UIView{
    public func addTapGesture(tapNumber: Int = 1, target: AnyObject, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    public func addTapGesture(tapNumber: Int = 1, action: ((UITapGestureRecognizer) -> ())?) {
        let tap = BlockTap(tapCount: tapNumber, fingerCount: 1, action: action)
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    
  
}
