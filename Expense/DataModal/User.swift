
//
//  User.swift
//  ParkingApp
//
//  Created by Haspinder on 26/02/18.
//  Copyright © 2018 Haspinder Singh. All rights reserved.
//

import Foundation

class User : NSObject{

    internal struct RegexExpresssions {
        static let EmailRegex = "[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        static let PasswordRegex = "[A-Za-z0-9]{6,20}"
        static let PhoneRegex = "[0-9]{6,14}"
    }
    
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.email = aDecoder.decodeObject(forKey: "email") as? String
        self.password = aDecoder.decodeObject(forKey: "password") as? String
        self.phoneNumber = aDecoder.decodeObject(forKey: "phone") as? String
    }
    
    override init() {
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.password, forKey: "password")
        aCoder.encode(self.phoneNumber, forKey: "phone")
    
    }
    
    var name : String?
    var email : String?
    var password: String?
    var phoneNumber: String?
    var expenseCredit: Float?
    var expenseDebit : Float?
    var username : String?

    init(user:String?,email:String?,password:String?,name:String?,credit:Float?,debit:Float?) {
        self.name = name
        self.password = password
        self.email = email
        self.expenseCredit = credit
        self.expenseDebit = debit
        self.username = user
    }
}


enum ValidationResponse {
    case Success
    case Failure(String)
}



extension User{
    
//        func validateChangePassword(old:String?,new:String?,confirm:String?) -> ValidationResponse {
//            guard let oldPass = old, oldPass.trimmed().characters.count >= 6 && self.isValidPassword(oldPass) else {
//                return .Failure(L10n.pleaseEnterValidOldPassword.string)
//            }
//            guard let newPass = new, newPass.trimmed().characters.count >= 6 && self.isValidPassword(newPass)    else {
//                return .Failure(L10n.pleaseEnterValidNewPassword.string)
//            }
//            guard let confirmPass = confirm, confirmPass.trimmed().characters.count >= 6 && self.isValidPassword(confirmPass) && ((new?.elementsEqual(confirmPass)) ?? false)
//                else {
//                    return .Failure(L10n.confirmPasswordDoesnTMatch.string)
//            }
//            return .Success
//        }

    func validateLogin(user:String?,password:String?) -> ValidationResponse {
        //&& self.isValidEmail(mail)
        
        guard let username = user, username.trimmed().count != 0   else {
            return .Failure("please enter username")
        }
        
        
//        guard let pass = password, pass.trimmed().count >= 6 && self.isValidPassword(pass)   else {
//            return .Failure("please enter valid pass")
//        }
        return .Success
    }
    
    func validateSignup(user:String?,email:String?,password:String?,name:String?,phone:String?) -> ValidationResponse {
            //&& self.isValidEmail(mail)
        
        guard let username = user, username.trimmed().count != 0   else {
            return .Failure("please enter username")
        }
        
            guard let mail = email, mail.trimmed().count != 0   else {
                return .Failure("please enter email")
            }
        
        guard let nm = name, nm.trimmed().count != 0   else {
            return .Failure("please enter name")
        }
        
        guard let ph = phone, ph.trimmed().count != 0   else {
            return .Failure("please enter phone")
        }

        
            guard let pass = password, pass.trimmed().count >= 6 && self.isValidPassword(pass)   else {
                return .Failure("please enter valid pass")
            }
            return .Success
        }
        
        
//        func isForgotPassValid(_ userId:String?) -> ValidationResponse {
//            guard let mail = userId, mail.trimmed().characters.count != 0   else {
//                return .Failure(L10n.pleaseEnterEmailAddress.string)
//            }
//            return .Success
//        }
    
        func isValidEmail(_ email:String) -> Bool {
            return NSPredicate(format:"SELF MATCHES %@", RegexExpresssions.EmailRegex).evaluate(with: email)
        }
        
        func isValidPhone(_ phone:String) -> Bool {
            if phone.trimmed().characters.count != 0 {
                return true
            }
            return NSPredicate(format:"SELF MATCHES %@", RegexExpresssions.PasswordRegex).evaluate(with: phone)
        }
        
        func isValidPassword(_ password:String) -> Bool {
            return NSPredicate(format:"SELF MATCHES %@", RegexExpresssions.PasswordRegex).evaluate(with: password)
        }
        
    
}
