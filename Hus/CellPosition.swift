//
//  CellPosition.swift
//  Hus
//
//  Created by Yannick Winter on 15.08.17.
//  Copyright © 2017 Winterapps. All rights reserved.
//

import Foundation

class CellPosition {
    
    let row: Row
    let number: Int
    
    init(row: Row, number: Int) {
        self.row = row
        self.number = number
    }
    
    enum Row: Int  {
        case Front = 0, Back = 1
    }
}
