//
//  Expense.swift
//  Prossimo
//
//  Created by Rawad Rifai on 6/3/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit

class ExpenseCell: UITableViewCell {

    
    @IBOutlet weak var labelItem: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var imageViewDate: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
