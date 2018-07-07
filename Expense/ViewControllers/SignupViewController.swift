
//
//  SignupViewController.swift
//  Expense
//
//  Created by Haspinder on 06/07/18.
//  Copyright © 2018 Haspinder Singh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase

class SignupViewController: UIViewController {
   
    
    @IBOutlet var txts: [TextField]!
    
    @IBAction func actionHaveAccount(_ sender: Any) {
        self.dismiss(animated: true) {}
    }
    
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func actionSignup(_ sender: Any) {
        switch User().validateSignup(user: txts[0].text ?? "", email: txts[1].text ?? "", password: txts[2].text ?? "", name: txts[3].text ?? "", phone: txts[4].text ?? "") {
        case .Failure(let error):
            self.addAlert("Error", message: error)
        default:
            ref.child("users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                if snapshot.hasChild(self.txts[0].text!){
                    self.addAlert("Sorry", message: "Username already exists")
                }else{
                    self.ref.child("users").child(self.txts[0].text ?? "").setValue(["email": self.txts[1].text ?? "","password": self.txts[2].text ?? "","name":self.txts[3].text ?? "","phone":self.txts[4].text ?? ""])
                    self.addAlert("Success", message: "Register done,Please login now")
                }
            })
            self.dismiss(animated: true, completion: {})
            
        }
        
        
    }
}
