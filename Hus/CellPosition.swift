//
//  CellPosition.swift
//  Hus
//
//  Created by Yannick Winter on 15.08.17.
//  Copyright © 2017 Winterapps. All rights reserved.
//

import Foundation

class CellPosition: Hashable {
    
    var hashValue: Int
    
    let row: Row
    let number: Int
    
    init(row: Row, number: Int) {
        self.row = row
        self.number = number
        hashValue = row.hashValue * 8 + number
    }
    
    static func ==(lhs: CellPosition, rhs: CellPosition) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    enum Row: Int  {
        case Front = 0, Back = 1
    }
    
    static var possibleCellPositions: [CellPosition] {
        var possible: [CellPosition] = []
        for row in [Row.Front, Row.Back] {
            for number in 0..<GameField.cellsPerRow {
                possible.append(CellPosition(row: row, number: number))
            }
        }
        return possible
        
    }
    
    
}
