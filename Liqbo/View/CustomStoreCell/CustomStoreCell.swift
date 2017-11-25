//
//  CustomStoreCell.swift
//  Liqbo
//
//  Created by Christopher Ho on 2017-11-22.
//  Copyright © 2017 chovo. All rights reserved.
//

import UIKit

class CustomStoreCell: UITableViewCell {

    @IBOutlet weak var storeAddress: UILabel!
    
    @IBOutlet weak var storeCity: UILabel!
    
    @IBOutlet weak var storeHours: UILabel!
    
    @IBOutlet weak var storeDistance: UILabel!
    
  /*  @IBOutlet weak var itemThumbnail: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var itemPackage: UILabel!
    
    @IBOutlet weak var itemPrice: UILabel!
    
    @IBOutlet weak var itemSaleUntil: UILabel!
    
    @IBOutlet weak var itemSave: UILabel!*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
