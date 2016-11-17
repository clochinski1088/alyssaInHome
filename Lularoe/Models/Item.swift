//
//  Item.swift
//  Lularoe
//
//  Created by Collin Lochinski on 11/15/16.
//  Copyright © 2016 Collin Lochinski. All rights reserved.
//

import UIKit

class Item {
    
    var id : Int?
    var style : Style?
    var size : Size?
    var inventoryID : Int?
    
    init(id: Int?, style: Style?, size: Size?, inventoryID: Int?) {
        self.id = id
        self.style = style
        self.size = size
        self.inventoryID = inventoryID
    }
}
