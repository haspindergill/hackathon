//
//  UIViewController+Extension.swift
//  C0728467_MidTerm_MADF2018
//
//  Created by Haspinder on 28/02/18.
//  Copyright © 2018 Haspinder Singh. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    typealias DidComplete = (AnyObject) -> ()

    
    func addAlert(_ title : String , message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func addAlertWithButton(title:String?,message:String,buttons : [String],didClickButtonAtIndex : @escaping DidComplete ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))

        for (index,item) in buttons.enumerated(){
            alert.addAction(UIAlertAction(title: item, style: .default, handler: { (alert) in
                didClickButtonAtIndex(index as AnyObject)
            }))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
        func hideKeyboardWhenTappedAround() {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        
    @objc func dismissKeyboard() {
            view.endEditing(true)
        }
}
