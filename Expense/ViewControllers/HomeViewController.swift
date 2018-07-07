//
//  HomeViewController.swift
//  Expense
//
//  Created by Haspinder on 06/07/18.
//  Copyright © 2018 Haspinder Singh. All rights reserved.
//

import UIKit
import FirebaseDatabase
import UserNotifications

class HomeViewController: UIViewController,UNUserNotificationCenterDelegate {

    @IBOutlet weak var lblDebit: UILabel!
    @IBOutlet weak var lblCredit: UILabel!
    
    var totalCredit : Float? = 0
    var totalDedit : Float? = 0
    
    
    var ref: DatabaseReference!

    
    @IBAction func actionMenu(_ sender: Any) {
        if self.slideMenuController()?.isLeftOpen() ?? true{
            self.slideMenuController()?.closeLeft()
        }else{
            self.slideMenuController()?.openLeft()
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.setnotifications()


//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func setnotifications() {
        ref.child("friends").child(UserDataSingleton.sharedInstance.loggedInUser?.username ?? "").observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount) // I got the expected number of items
            
            
            for rest in (snapshot.children.allObjects as? [DataSnapshot])! {
                let value = rest.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                let username = rest.key
                var credit : Float = 0.0;
                var debit : Float = 0.0;
                
                self.ref.child("expense").observeSingleEvent(of: .value, with: { snapshot in
                    for rest in (snapshot.children.allObjects as? [DataSnapshot])! {
                        let key = rest.value as? NSDictionary
                        let u_email = key?["user"] as? String ?? ""
                        let f_email = key?["friend"] as? String ?? ""
                        
                        if (u_email == username && f_email == UserDataSingleton.sharedInstance.loggedInUser?.username ?? ""){
                            credit = credit + ((key?["me_owe"] as? Float) ?? 0.0)
                            debit = debit + ((key?["owed"] as? Float) ?? 0.0)
                        }else if(f_email == username && u_email == UserDataSingleton.sharedInstance.loggedInUser?.username ?? ""){
                            credit = credit + ((key?["owed"] as? Float) ?? 0.0)
                            debit = debit + ((key?["me_owe"] as? Float) ?? 0.0)
                        }
                    }
                    print(credit,debit);
                    let content = UNMutableNotificationContent()
                    var total : Float = 0.0
                    content.title = "Alert"

                    if debit > credit {
                        total = debit - credit
                        content.body = "\(name) has to pay you $\(total.description)"

                    }
                    else{
                        total = credit - debit
                        content.body = "you has to pay $\(total.description) to \(name)"


                    }
                    
                    content.sound = UNNotificationSound.default()
                    
                    // Deliver the notification in five seconds.
                    let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 20, repeats: false)
                    let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().delegate = self

                    // Schedule the notification.
                    let center = UNUserNotificationCenter.current()
                    center.add(request) { (error) in
                        print(error)
                    }
                    print("should have been added")
                })
                
            }
        })
        
        
        let cente = UNUserNotificationCenter.current()

        cente.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print("alert")
                print(request)
            }
        })
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        totalDedit  = 0.0
        totalCredit  = 0.0
        
        self.ref.child("expense").observeSingleEvent(of: .value, with: { snapshot in
            for rest in (snapshot.children.allObjects as? [DataSnapshot])! {
                let value = rest.value as? NSDictionary
                let user = value?["user"] as? String ?? ""
                let friend = value?["friend"] as? String ?? ""

                
                if (user == UserDataSingleton.sharedInstance.loggedInUser?.username){
                    self.totalCredit = self.totalCredit! + ((value?["me_owe"] as? Float) ?? 0.0)
                    self.totalDedit = self.totalDedit! + ((value?["owed"] as? Float) ?? 0.0)
                }else if(friend == UserDataSingleton.sharedInstance.loggedInUser?.username){
                    self.totalCredit = self.totalCredit! + ((value?["owed"] as? Float) ?? 0.0)
                    self.totalDedit = self.totalDedit! + ((value?["me_owe"] as? Float) ?? 0.0)
                }
                
                
//                let total = value?["owed"] as? Float ?? 0
//                let dtotal = value?["me_owe"] as? Float ?? 0
//                self.totalDedit = (self.totalDedit ?? 0.0) + dtotal
//                self.totalCredit = (self.totalCredit ?? 0.0) + total
                if (self.totalDedit ?? 0.0) > (self.totalCredit ?? 0.0){
                    self.totalDedit = (self.totalDedit ?? 0.0 ) - (self.totalCredit ?? 0.0)
                    self.totalCredit = 0.0
                }else{
                    self.totalCredit = (self.totalCredit ?? 0.0 ) - (self.totalDedit ?? 0.0)
                    self.totalDedit = 0.0
                }
            }
            self.lblCredit.text = "Total Debit  $\(self.totalCredit ?? 0.0)"
            self.lblDebit.text = "Total Credit  $\(self.totalDedit ?? 0.0)"
        })
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
