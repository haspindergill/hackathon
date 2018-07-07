//
//  YourExpenseViewController.swift
//  Expense
//
//  Created by Haspinder on 06/07/18.
//  Copyright © 2018 Haspinder Singh. All rights reserved.
//

import UIKit
import FirebaseDatabase


class YourExpenseViewController: UIViewController {

    @IBAction func actionChangeCurrency(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.picker.alpha = 1.0
        }) { (compl) in
            self.picker.isHidden = false
        }
    }
    @IBOutlet weak var tableView: UITableView!{didSet{
        self.tableView.estimatedRowHeight = 20
        }}
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var currencyLbl: UILabel!
    
    var currencySelected = 0
    
    var dataSource : TableDataSource?{
        didSet{
            tableView.delegate = dataSource
            tableView.dataSource = dataSource
        }
    }
    var pickerData: [String] = [String]()
    
    @IBOutlet weak var picker: UIPickerView!
    

    
    var friendList = [User](){didSet{
        dataSource?.items = friendList as Array<AnyObject>
        self.tableView?.reloadData()
        }}

    
    @IBAction func actionMenu(_ sender: Any) {
        if self.slideMenuController()?.isLeftOpen() ?? true{
            self.slideMenuController()?.closeLeft()
        }else{
            self.slideMenuController()?.openLeft()
        }
        
    }
    
    //yourexpense
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.isHidden = true
        self.tableView.estimatedRowHeight = 20
        pickerData = ["Canadian Dollar - CAD","Amercian Dollar - USD","Indian Rupee - INR","Austrialan Dollar - AUD" ,"Pounds"]
        ref = Database.database().reference()
        setupTableView()
        picker.delegate = self
        picker.dataSource = self
    }

    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchFriends()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    

    
    
    
    func fetchFriends() {
        self.friendList = [User]()
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
                    let user = User(user:rest.key ?? "",email: value?["email"] as? String ?? "", password: "", name: name, credit: credit, debit: debit)
                    self.friendList.append(user)

                })
                self.tableView.reloadData()
            }
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


//MARK: TableView
extension YourExpenseViewController{
    
    func setupTableView() {
        dataSource = TableDataSource(items:friendList as Array<AnyObject>, height: UITableViewAutomaticDimension, tableView: tableView, cellIdentifier: "FriendTableViewCell", configureCellBlock: { (cell, item, index) in
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
        let  cell = cell as? FriendTableViewCell
        let user = item as? User
        cell?.user = user
        var total : Float = 0.0

        if user?.expenseDebit ?? 0.0 > user?.expenseCredit ?? 0.0{
            total = ((user?.expenseDebit ?? 0.0) - (user?.expenseCredit ?? 0.0))
            cell?.lblExpense?.textColor = UtilityFunctions().hexStringToUIColor(hex: "#003300")
        }else if user?.expenseDebit ?? 0.0 < user?.expenseCredit ?? 0.0{
            cell?.lblExpense?.textColor = UtilityFunctions().hexStringToUIColor(hex: "#990033")
            total = ((user?.expenseCredit ?? 0.0) - (user?.expenseDebit ?? 0.0))
        }
        switch currencySelected {
        case 0:
            self.currencyLbl.text = "Current Currency is CAD"
            cell?.lblExpense?.text = "$\(total.description)"
        case 1:
            total = total * 0.76
            self.currencyLbl.text = "Current Currency is USD"
            cell?.lblExpense?.text = "$\(total.description)"
        case 2:
            total = total * 52.53
            self.currencyLbl.text = "Current Currency is INR"
            cell?.lblExpense?.text = "₹\(total.description)"
        case 3:
            total = total * 1.03
            self.currencyLbl.text = "Current Currency is AUD"
            cell?.lblExpense?.text = "$\(total.description)"
        case 4:
            total = total * 0.58
            self.currencyLbl.text = "Current Currency is Pounds"
            cell?.lblExpense?.text = "£\(total.description)"
        default:
            cell?.lblExpense?.text = "CAD$\(total.description)"

        }
        
       
    }
    
    
}

extension YourExpenseViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1

    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UIView.animate(withDuration: 0.5, animations: {
            self.picker.alpha = 0.0
        }) { (compl) in
            self.picker.isHidden = true
        }
        currencySelected = row
        tableView.reloadData()
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
}

