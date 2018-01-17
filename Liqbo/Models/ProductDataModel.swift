//
//  product.swift
//  Liqbo
//
//  Created by Christopher Ho on 2017-11-10.
//  Copyright © 2017 chovo. All rights reserved.ß
//

import Foundation
import RealmSwift

class ProductDataModel: Object{
    
    @objc dynamic var name: String = ""
    @objc dynamic var price_in_cents: Float = 0
    @objc dynamic var regular_price_in_cents: Float = 0
    @objc dynamic var origin: String = ""
    @objc dynamic var has_limited_time_offer: Bool = false
    @objc dynamic var limited_time_offer_savings_in_cents: Float = 0
    @objc dynamic var limited_time_offer_ends_on: String = ""
    @objc dynamic var package: String = ""
    @objc dynamic var volume_in_milliliters: Int = 0
    @objc dynamic var alcohol_content: Float = 0
    @objc dynamic var image_thumb_url : String?
    @objc dynamic var image_url: String?
    @objc dynamic var numberAddedToCart = 1;
    @objc dynamic var currentPriceOfTotalCount: Float = 0
    @objc dynamic var primary_category: String = ""
    var parentCategory = LinkingObjects(fromType: ListOfItems.self, property: "itemsArray")
    
    //need to divide alcohol_content by 100 to get percentage
}
