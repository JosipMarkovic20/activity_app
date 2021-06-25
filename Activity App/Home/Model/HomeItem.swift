//
//  HomeItem.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation

public class HomeItem: HomeBaseItem{
    let item: ActivityViewItem

    init(identity: String, item: ActivityViewItem) {
        self.item = item
        super.init(identity: identity)
    }
}

public class ActivityViewItem: Equatable {
    public static func == (lhs: ActivityViewItem, rhs: ActivityViewItem) -> Bool {
        lhs.key == rhs.key
    }
    
    let name: String
    let type: ActivityType
    let key: String
    let price: Float
    let participants: Int
    let accessibility: Float
    
    
    var priceSign: String{
        switch price{
        case 0.0...0.30:
           return "$"
        case 0.31...0.60:
            return "$$"
        case 0.61...0.90:
            return "$$$"
        default:
            return "$$$$"
        }
    }
    
    init(name: String, type: ActivityType, key: String, price: Float, participants: Int, accessibility: Float) {
        self.name = name
        self.type = type
        self.key = key
        self.price = price
        self.participants = participants
        self.accessibility = accessibility
    }
    
}
