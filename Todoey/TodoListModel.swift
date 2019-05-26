//
//  TodoListModel.swift
//  Todoey
//
//  Created by Jack Calo on 5/26/19.
//  Copyright © 2019 Jack Calo. All rights reserved.
//

import Foundation

class TodoListModel {
    var ItemTitle : String = ""
    var IsDone : Bool = false
    
    init(itemTitle : String, isDone : Bool = false) {
        ItemTitle = itemTitle
        IsDone = isDone
    }
}
