

//
//  LeftViewController.swift
//  ParkingApp
//
//  Created by Haspinder on 04/03/18.
//  Copyright © 2018 Haspinder Singh. All rights reserved.
//

import UIKit
import MessageUI
import SlideMenuControllerSwift

class LeftViewController: UIViewController,MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var lblEmail: UILabel!
    
    var menuItems = ["Home","Friends","Expense","Share","Logout"]
    @IBOutlet weak var tableView: UITableView!
    
    
    var homeView : UINavigationController?
    var friendView : UINavigationController?
    var expenseView : UINavigationController?


    var dataSource : TableDataSource?{
        didSet{
            tableView.delegate = dataSource
            tableView.dataSource = dataSource
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        dataSource?.items = menuItems as Array<AnyObject>
        tableView.reloadData()
//        lblEmail.text = UserDataSingleton.sharedInstance.loggedInUser?.email ?? ""
        homeView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC") as! UINavigationController
        friendView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "friendVC") as! UINavigationController
        expenseView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "yourexpense") as! UINavigationController

//        addTicketView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addTicket") as! UINavigationController
//        locationView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "map") as! UINavigationController
//        profileView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileView") as! UINavigationController
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

}


//MARK: TableView
extension LeftViewController{
    
    func setupTableView() {
        dataSource = TableDataSource(items:menuItems as Array<AnyObject>, height: 44, tableView: tableView, cellIdentifier: "cell", configureCellBlock: { (cell, item, index) in
            self.configureTableCell(cell: cell, item: item,index: index)
        }, aRowSelectedListener: { (indexPath) in
            self.clickHandler(indexPath: indexPath)
        })
    }
    
    func clickHandler(indexPath : NSIndexPath) {
        switch indexPath.row {
        case 0:
            self.slideMenuController()?.changeMainViewController(homeView!, close: true)
        case 1:
            self.slideMenuController()?.changeMainViewController(friendView!, close: true)
        case 2:
            self.slideMenuController()?.changeMainViewController(expenseView!, close: true)
      
        case 3:
            let text = "Hey Friend, add me on expense app. my username is \(UserDataSingleton.sharedInstance.loggedInUser?.username ?? "")"
            
            // set up activity view controller
            let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        case 4:
            self.addAlertWithButton(title: "Alert", message: "Are you sure?", buttons: ["Logout"]) { (complete) in
                
            
                self.dismiss(animated: true, completion: {})}
        default:
            self.slideMenuController()?.changeMainViewController(friendView!, close: true)

        }
    }
    func configureTableCell(cell : AnyObject?,item : AnyObject?,index : NSIndexPath?) {
        let  cell = cell as? UITableViewCell
        cell?.textLabel?.text = item as? String
        //guard let itemData = item as? [String : String] else{return}
//        let cell = cell as? MonthlyFeeDetailTableViewCell
//        cell?.lblmonth.text = ¿itemData.keys.first
//        cell?.lblFeeStatus.text = ¿itemData.values.first
//        if ¿itemData.values.first == L10n.feesDone.string {cell?.lblFeeStatus.textColor = .green}else {
//            cell?.lblFeeStatus.textColor = .red
//        }
    }
    
    
    func makePhoneCall()
    {
        if let url = URL(string: "tel://+1123777777)"), UIApplication.shared.canOpenURL(url){
            if #available(iOS 10, *)
            {
                UIApplication.shared.open(url)
            }
            else
            {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func sendMessage() {
        
        if MFMessageComposeViewController.canSendText() {
            
            
            let messageVC = MFMessageComposeViewController()
            
            messageVC.body = "Subject dem0"
            messageVC.recipients = ["+11234567890"]
            messageVC.messageComposeDelegate = self
            
            self.present(messageVC, animated: false, completion: nil)
        }
        else{
            self.addAlert("Failed", message: "NO SIM available")
            print("NO SIM available")
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult)
    {
        
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
            self.addAlert("Failed", message: "Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case .failed:
            self.addAlert("Failed", message: "Message failed")
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case .sent:
            self.addAlert("Failed", message: "Message was sent")
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        }
    }
}
