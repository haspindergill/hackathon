//
//  LoginViewController.swift
//  Expense
//
//  Created by Haspinder on 06/07/18.
//  Copyright © 2018 Haspinder Singh. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import FirebaseDatabase


class LoginViewController: UIViewController {
    @IBOutlet var txts: [TextField]!
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
    

    @IBAction func actionLogin(_ sender: Any) {
        
        switch User().validateLogin(user: txts[0].text ?? "", password: txts[1].text ?? "") {
        case .Failure(let error):
            self.addAlert("Error", message: error)
        default:
            
            ref.child("users").child(txts[0].text!).observeSingleEvent(of: .value, with: { snapshot in
                
                if !snapshot.exists() {
                    self.addAlert("Error", message: "User Not Exist")
                    print("user not exist")
                    return
                }
                
                
                print(snapshot)
                
                let value = snapshot.value as? NSDictionary
                let pass = value?["password"] as? String ?? ""
                
                
                if (self.txts[1].text ?? "" == pass) {
                    
                    let user = User(user:snapshot.key,email: value?["email"] as? String ?? "", password: value?["password"] as? String ?? "", name: value?["name"] as? String ?? "", credit: 0.0, debit: 0.0)
                    
                    UserDataSingleton.sharedInstance.loggedInUser = user
                    let mainVC : UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC") as! UINavigationController
                    
                    let leftVC:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "leftView") as UIViewController
                    
                    let slideMenuController = SlideMenuController(mainViewController: mainVC, leftMenuViewController: leftVC)
                    self.present(slideMenuController, animated: true, completion: {
                        
                    })
                }else{
                  self.addAlert("error", message: "password not match")
                }
//                if let userName = snapshot.value["email"] {
//                    print(userName)
//                }
//                if let email = snapshot.value!["password"] as? String {
//                    print(email)
//                }
                
                // can also use
                // snapshot.childSnapshotForPath("full_name").value as! String
            })
        }
        
      
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
