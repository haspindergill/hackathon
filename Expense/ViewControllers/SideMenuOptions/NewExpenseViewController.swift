//
//  NewExpenseViewController.swift
//  Expense
//
//  Created by Haspinder on 06/07/18.
//  Copyright © 2018 Haspinder Singh. All rights reserved.
//

import UIKit
import FirebaseDatabase


class NewExpenseViewController: UIViewController {

    @IBOutlet weak var btnEqually: UIButton!
    @IBOutlet weak var btnFriendOwe: UIButton!
    @IBOutlet weak var btnYouOwe: UIButton!
    
    var percentage : Float = 0.0
    @IBOutlet weak var btnOwnPercentage: UIButton!
    var selection : Int = 0
    
    @IBAction func actionSelection(_ sender: UIButton) {
        for btn in btns {
            if btn.tag == sender.tag{
                btn.backgroundColor = UtilityFunctions().hexStringToUIColor(hex: "C6A28C")
                switch sender.tag{
                case 0:
                    selection = 0
                case 1:
                    selection = 1
                case 2:
                    selection = 2
                case 3:
                    selection = 3
                    let alert = UIAlertController(title: "Enter", message: "Enter percentage of amount own by you.", preferredStyle: .alert)
                    alert.addTextField { (textField) in
                        textField.placeholder = "Percentage"
                    }
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                        let textField = alert?.textFields![0]
                        if (textField?.text?.trimmed().count ?? 0) == 0{
                            return
                        }
                        self.percentage = textField?.text?.toFloat() ?? 0.0
                }))
                    self.present(alert, animated: true, completion: nil)
                default:
                    selection = 0
                }
            }
            else{
                btn.backgroundColor = UIColor.clear
            }
        }
    }
    
    @IBOutlet weak var textAmount: UITextField!
    @IBOutlet weak var textDec: UILabel!
    var ref: DatabaseReference!

    
    var friendUsername : String?
    var dataSource : TableDataSource?{
        didSet{
            
        }
    }
    
    var friendList = [String](){didSet{
        dataSource?.items = friendList as Array<AnyObject>
        }}
    
    var btns = [UIButton]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        btns = [btnEqually,btnFriendOwe,btnYouOwe,btnOwnPercentage]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func actionSubmit(_ sender: Any) {
        
        if self.textAmount.text?.trimmed().count == 0{
            self.addAlert("error", message: "enter amount")
            return
        }
        
        if self.textDec.text?.trimmed().count == 0{
            self.addAlert("error", message: "enter description")
            return
        }
        let amount = self.textAmount.text?.toFloat() ?? 0
        
        var credit : Float = 0.0;
        var debit : Float = 0.0;

        switch selection {
        case 0:
            credit = amount/2
            debit = amount/2
        case 1:
            credit = 0
            debit = amount
        case 2:
            credit = amount
            debit = 0
        case 3:
            debit = amount - (amount * (percentage/100))
            credit = 0
        default:
            credit = amount
            debit = amount
        }
        
        
        self.ref.child("expense").childByAutoId().setValue(["description" : textDec.text ?? "","user":UserDataSingleton.sharedInstance.loggedInUser?.username ?? "","friend":friendUsername,"owed" : credit,"me_owe":debit,"time":"12","location":"brampton"])
        self.navigationController?.popViewController(animated: true)
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
extension NewExpenseViewController{
    
    func setupTableView() {
       
    }
    
    func clickHandler(indexPath : NSIndexPath) {
        
    }
    func configureTableCell(cell : AnyObject?,item : AnyObject?,index : NSIndexPath?) {
        let  cell = cell as? UITableViewCell
        cell?.textLabel?.text = item as? String
    }
    
}
