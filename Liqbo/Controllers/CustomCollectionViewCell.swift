//
//  CustomCollectionViewCell.swift
//  Liqbo
//
//  Created by Christopher Ho on 2018-01-02.
//  Copyright © 2018 chovo. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var itemDiscount: UILabel!
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPackage: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
}
