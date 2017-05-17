//
//  ClientDetailsCell.swift
//  Prossimo
//
//  Created by Rawad Rifai on 5/16/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit

class ClientDetailsCell: UITableViewCell {

    

    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelNotes: UILabel!
    @IBOutlet weak var labelVisitDate: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
