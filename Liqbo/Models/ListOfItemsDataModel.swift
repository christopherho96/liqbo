//
//  ListDataModel.swift
//  Liqbo
//
//  Created by Christopher Ho on 2018-01-06.
//  Copyright © 2018 chovo. All rights reserved.
//

import Foundation
import RealmSwift

class ListOfItems: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var date: Date?
    var itemsArray = RealmSwift.List<ProductDataModel>()
}
