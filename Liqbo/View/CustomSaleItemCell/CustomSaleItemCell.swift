//
//  CustomSaleItemCell.swift
//  Liqbo
//
//  Created by Christopher Ho on 2017-11-22.
//  Copyright © 2017 chovo. All rights reserved.
//

import UIKit

class CustomSaleItemCell: UITableViewCell {

    
    @IBOutlet weak var itemThumbnail: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var itemPackage: UILabel!
    
    @IBOutlet weak var itemPrice: UILabel!
    
    @IBOutlet weak var itemSaleUntil: UILabel!
    
    @IBOutlet weak var itemSave: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
