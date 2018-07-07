//
//  PlacesViewController.swift
//  Expense
//
//  Created by Haspinder on 07/07/18.
//  Copyright © 2018 Haspinder Singh. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PlacesViewController: UIViewController {

    var ref: DatabaseReference!
    
    var dataSource : TableDataSource?{
        didSet{
            tableView.delegate = dataSource
            tableView.dataSource = dataSource
        }
    }
    
    
    var places = [Place](){didSet{
        dataSource?.items = places as Array<AnyObject>
        self.tableView?.reloadData()
        }}
    
    

    @IBAction func actionAddPlace(_ sender: Any) {
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        setupTableView()
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
    
    func fetchPlaces() {
        self.ref.child("places").child("hasp").observeSingleEvent(of: .value, with: { snapshot in
            
            for rest in (snapshot.children.allObjects as? [DataSnapshot])! {
                let value = rest.value as? NSDictionary
                
                
                let place = Place(name:value?["name"] as? String ?? "" , lat: value?["lat"] as? String ?? "", long: value?["long"] as? String ?? "")
                //                let email = value?["email"] as? String ?? ""
                self.places.append(place)
            }
        })

    }

}

//MARK: TableView
extension PlacesViewController{
    
    func setupTableView() {
        dataSource = TableDataSource(items:places as Array<AnyObject>, height: UITableViewAutomaticDimension, tableView: tableView, cellIdentifier: "cell", configureCellBlock: { (cell, item, index) in
            self.configureTableCell(cell: cell, item: item,index: index)
        }, aRowSelectedListener: { (indexPath) in
            self.clickHandler(indexPath: indexPath)
        })
    }
    
    func clickHandler(indexPath : NSIndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewExpenseViewController") as! NewExpenseViewController
       
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func configureTableCell(cell : AnyObject?,item : AnyObject?,index : NSIndexPath?) {
        let  cell = cell as? UITableViewCell
        let user = places[index?.row ?? 0]
        cell?.textLabel?.text = user.name
     }

}
