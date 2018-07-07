

//
//  FriendTableViewCell.swift
//  Expense
//
//  Created by Haspinder on 06/07/18.
//  Copyright © 2018 Haspinder Singh. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var lblExpense: UILabel!
    @IBOutlet weak var lblUser: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    var user : User?{didSet{self.setUI()}}
    
    func setUI() {
        lblUser.text = user?.name
       
    }

}
