//
//  product.swift
//  Liqbo
//
//  Created by Christopher Ho on 2017-11-10.
//  Copyright © 2017 chovo. All rights reserved.
//

import Foundation

class ProductDataModel{
    
    var name: String = ""
    var price_in_cents: Float = 0
    var regular_price_in_cents: Float = 0
    var primary_category: String = ""
    var origin: String = ""
    var has_limited_time_offer: Bool = false
    var limited_time_offer_savings_in_cents: Float = 0
    var limited_time_offer_ends_on: String = ""
    var description: String = ""
    var package: String = ""
    var total_package_units: Int = 0
    var volume_in_milliliters: Int = 0
    var alcohol_content: Float = 0
    var style = ""
    var image_thumb_url : URL = URL(string: "https://s3.amazonaws.com/woof.nextglass.co/custom_item_type_images_production/af7e5a9d2a54837d65cae5637975ba8dfa05311f-custom-item-type-image.png?1476365129")!
    var image_url : URL = URL(string: "https://s3.amazonaws.com/woof.nextglass.co/custom_item_type_images_production/af7e5a9d2a54837d65cae5637975ba8dfa05311f-custom-item-type-image.png?1476365129")!
    var numberAddedToCart = 1;
    var currentPriceOfTotalCount: Float = 0
    
    
    init(name: String,price_in_cents: Float, primary_category: String, origin: String, has_limited_time_offer: Bool, limited_time_offer_savings_in_cents: Float, limited_time_offer_ends_on: String, description: String, package: String, total_package_units: Int, volume_in_milliliters: Int, alcohol_content: Float, style: String) {
        
        self.name = name
        self.price_in_cents = price_in_cents
        self.primary_category = primary_category
        self.origin = origin
        self.has_limited_time_offer = has_limited_time_offer
        self.limited_time_offer_savings_in_cents = limited_time_offer_savings_in_cents
        self.limited_time_offer_ends_on = limited_time_offer_ends_on
        self.description = description
        self.package = package
        self.total_package_units = total_package_units
        self.volume_in_milliliters = volume_in_milliliters
        self.alcohol_content = alcohol_content
        self.style = style

    }
    //need to divide alcohol_content by 100 to get percentage
}
