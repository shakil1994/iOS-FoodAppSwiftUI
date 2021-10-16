//
//  Item.swift
//  FoodApp
//
//  Created by Md Shah Alam on 10/15/21.
//

import SwiftUI

struct Item: Identifiable {
    var id: String
    var item_name: String
    var item_cost: NSNumber
    var item_details: String
    var item_image: String
    var item_rating: String
    
    //to indentify whether it is added to cart...
    var isAdded: Bool = false
}
