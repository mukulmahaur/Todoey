//
//  Item.swift
//  Todoey
//
//  Created by BIREN on 13/04/19.
//  Copyright © 2019 cdot. All rights reserved.
//

import Foundation

class Item : Encodable,Decodable {
    var title : String = ""
    var done : Bool = false
}
