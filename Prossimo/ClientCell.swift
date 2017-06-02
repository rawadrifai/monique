//
//  ClientCell.swift
//  Prossimo
//
//  Created by Rawad Rifai on 5/16/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit

class ClientCell: UITableViewCell {

    
    @IBOutlet weak var imageViewClient: UIImageView!
    @IBOutlet weak var labelClientName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
