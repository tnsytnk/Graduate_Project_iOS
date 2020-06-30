//
//  itemModel.swift
//  toys
//
//  Created by Thanakorn Kaewsawang on 28/5/2562 BE.
//  Copyright © 2562 Thanakorn K. All rights reserved.
//

import Foundation
import UIKit

class itemModel {
    var name: String?
    var description: String?
    var itemImageURL : String?
    var price: String?
    var type: String?
    var owner: String?
    var itemId: String?
    var deliveryPrice: String?
    var status: String?
    
    init(name: String,price: String, description:String,type:String,itemImageURL:String,owner:String,itemId:String,deliveryPrice:String,status:String){
        self.name = name
        self.description = description
        self.itemImageURL = itemImageURL
        self.price = price
        self.type = type
        self.owner = owner
        self.itemId = itemId
        self.deliveryPrice = deliveryPrice
        self.status = status
        
        
    }
    
    init(itemId:String) {
        self.itemId = itemId
    }
    
}

