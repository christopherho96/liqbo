//
//  product.swift
//  Liqbo
//
//  Created by Christopher Ho on 2017-11-10.
//  Copyright © 2017 chovo. All rights reserved.
//

import Foundation

class ProductDataModel{
    
    var id: Int = 0;
    var name: String = ""
    var price_in_cents: Int = 0
    var primary_category: String = ""
    var origin: String = ""
    var has_limited_time_offer: Bool = false
    var limited_time_offer_savings_in_cents: Int = 0
    var limited_time_offer_ends_on: String = ""
    var description: String = ""
    var package_unit_type: String = ""
    var total_package_units: Int = 0
    var volume_in_milliliters: Int = 0
    var alcohol_content: Int = 0
    //need to divide alcohol_content by 100 to get percentage
}
