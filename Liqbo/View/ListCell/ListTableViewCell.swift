//
//  ListTableViewCell.swift
//  Liqbo
//
//  Created by Christopher Ho on 2018-01-07.
//  Copyright © 2018 chovo. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleOfList: UILabel!
    @IBOutlet weak var dateListCreated: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
