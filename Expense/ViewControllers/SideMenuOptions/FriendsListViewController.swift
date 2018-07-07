//
//  FriendsListViewController.swift
//  Expense
//
//  Created by Haspinder on 06/07/18.
//  Copyright © 2018 Haspinder Singh. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FriendsListViewController: UIViewController {

   
    
    var ref: DatabaseReference!
    
    

    @IBOutlet weak var tableView: UITableView!
    var dataSource : TableDataSource?{
        didSet{
            tableView.delegate = dataSource
            tableView.dataSource = dataSource
        }
    }
    
    
    var friendList = [User](){didSet{
        dataSource?.items = friendList as Array<AnyObject>
        self.tableView?.reloadData()
        }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        
        self.setupTableView()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchFriends()
    }
    
    
    func fetchFriends() {
        friendList = [User](); ref.child("friends").child((UserDataSingleton.sharedInstance.loggedInUser?.username)!).observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount) // I got the expected number of items
            
            
            for rest in (snapshot.children.allObjects as? [DataSnapshot])! {
                let value = rest.value as? NSDictionary
                
                let user = User(user: rest.key, email: value?["email"] as? String ?? "", password: "", name: value?["name"] as? String ?? "", credit: 0.0, debit: 0.0)
                //                let email = value?["email"] as? String ?? ""
                self.friendList.append(user)
            }
        })
        print(friendList.count)
        self.tableView.reloadData()
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
extension FriendsListViewController{
    
    func setupTableView() {
        dataSource = TableDataSource(items:friendList as Array<AnyObject>, height: UITableViewAutomaticDimension, tableView: tableView, cellIdentifier: "cell", configureCellBlock: { (cell, item, index) in
            self.configureTableCell(cell: cell, item: item,index: index)
        }, aRowSelectedListener: { (indexPath) in
            self.clickHandler(indexPath: indexPath)
        })
    }
    
    func clickHandler(indexPath : NSIndexPath) {
        
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewExpenseViewController") as! NewExpenseViewController
        let user = friendList[indexPath.row]
        vc.friendUsername = user.username
        self.navigationController?.pushViewController(vc, animated: true)

      
    }
    func configureTableCell(cell : AnyObject?,item : AnyObject?,index : NSIndexPath?) {
        let  cell = cell as? UserTableViewCell
        let user = friendList[index?.row ?? 0]
        cell?.user = user
    }
    
    
    
    @IBAction func actionMenu(_ sender: Any) {
        if self.slideMenuController()?.isLeftOpen() ?? true{
            self.slideMenuController()?.closeLeft()
        }else{
            self.slideMenuController()?.openLeft()
        }
    }
    
    @IBAction func actionAdd(_ sender: Any) {
        let alert = UIAlertController(title: "Add Friend", message: "Enter a his/her username", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Username (case insensitive)"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if (textField?.text?.trimmed().count ?? 0) == 0{
                return
            }
            self.ref.child("users").child((textField?.text!)!).observeSingleEvent(of: .value, with: { snapshot in
                
                if !snapshot.exists() {
                    self.addAlert("", message: "user not exist")
                    print("user not exist")
                    return
                }
                
                let value = snapshot.value as? NSDictionary
                let email = value?["email"] as? String ?? ""
                let name = value?["name"] as? String ?? ""
            self.ref.child("friends").child((UserDataSingleton.sharedInstance.loggedInUser?.username)!).child((textField?.text!)!).setValue(["email": email,"name":name])
                    self.addAlert("Success", message: "Friend added")
                self.fetchFriends()
            })

            
        }))

            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
 
    
    
}
