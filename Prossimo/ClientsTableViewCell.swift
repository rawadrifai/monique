//
//  ClientsTableViewCell.swift
//  Prossimo
//
//  Created by Rawad Rifai on 5/10/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit

class ClientsTableViewCell: UITableViewCell {

    @IBOutlet weak var clientImageView: UIImageView!
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
