//
//  CustomProductItemCell.swift
//  Liqbo
//
//  Created by Christopher Ho on 2017-11-15.
//  Copyright © 2017 chovo. All rights reserved.
//

import UIKit

class CustomProductItemCell: UITableViewCell {


    @IBOutlet weak var productImage: UIImageView!

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPackage: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
