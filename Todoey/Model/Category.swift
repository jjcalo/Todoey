//
//  Category.swift
//  Todoey
//
//  Created by Jack Calo on 5/30/19.
//  Copyright © 2019 Jack Calo. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var backgroundColor : String = ""
    let items = List<Item>()
}

