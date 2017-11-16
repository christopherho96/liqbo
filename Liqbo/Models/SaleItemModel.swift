//
//  SaleItemModel.swift
//  Liqbo
//
//  Created by Christopher Ho on 2017-11-11.
//  Copyright © 2017 chovo. All rights reserved.
//

import Foundation
import UIKit

class SaleItemModel{
    
    var id: Int = 0
    var name: String = ""
    var price_in_cents: Float = 0
    var primary_category: String = ""
    var has_limited_time_offer: Bool = false
    var limited_time_offer_savings_in_cents: Float = 0
    var limited_time_offer_ends_on: String = ""
    var package: String = ""
    var total_package_units: Int = 0
    var volume_in_milliliters: Int = 0
    var alcohol_content: Int = 0
    var description: String = ""
    var image_thumb_url : URL = URL(string: "https://s3.amazonaws.com/woof.nextglass.co/custom_item_type_images_production/af7e5a9d2a54837d65cae5637975ba8dfa05311f-custom-item-type-image.png?1476365129")!
    
}
