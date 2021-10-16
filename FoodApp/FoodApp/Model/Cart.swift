//
//  Cart.swift
//  FoodApp
//
//  Created by Md Shah Alam on 10/16/21.
//

import SwiftUI

struct Cart: Identifiable {
    var id = UUID().uuidString
    var item: Item
    var quantity: Int
}
