//
//  ExpenseDetailsTVC.swift
//  Prossimo
//
//  Created by Rawad Rifai on 6/3/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ExpenseDetailsTVC: UITableViewController {

    var userId:String!
    var expense:Expense!
    var ref: FIRDatabaseReference!
    var delegate: PictureTimeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadExpense()
    }
    
    func loadExpense() {
        
        
        
    }

}

protocol ExpenseDetailsDelegate {
    func expenseChanged()
}
