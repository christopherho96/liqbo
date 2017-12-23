//
//  CustomShoppingCartItemCell.swift
//  Liqbo
//
//  Created by Christopher Ho on 2017-12-16.
//  Copyright © 2017 chovo. All rights reserved.
//

import UIKit

class CustomShoppingCartItemCell: UITableViewCell {

    var count: Int = 0
 
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var nameOfItem: UILabel!
    
    @IBOutlet weak var itemDescription: UILabel!

    
    @IBOutlet weak var itemPrice: UILabel!
    
    

    @IBOutlet weak var currentCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
