

//
//  String+Extension.swift
//  FinalProject
//
//  Created by Haspinder on 06/02/18.
//  Copyright © 2018 Haspinder Singh. All rights reserved.
//

import Foundation

extension String{
    
    func toInt() -> Int {
        return Int(self) ?? 0
    }
    
    func toFloat() -> Float {
        return Float(self) ?? 0.0
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func trimmed() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
   

}
