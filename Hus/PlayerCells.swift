//
//  PlayerCells.swift
//  Hus
//
//  Created by Yannick Winter on 15.08.17.
//  Copyright © 2017 Winterapps. All rights reserved.
//

import Foundation

class PlayerCells {
    
    private var frontRow: [Cell] = []
    private var backRow: [Cell] = []
    private var direction: Direction!
    
    init() {
        self.frontRow = createCells(forRow: .Front)
        self.backRow = createCells(forRow: .Back)
    }
    
    func set(direction: Direction) {
        self.direction = direction
    }
    
    func createCells(forRow row: CellPosition.Row) -> [Cell] {
        var cells: [Cell] = []
        for number in 0..<GameField.cellsPerRow {
            cells.append(Cell(row: row, number: number))
        }
        return cells
    }
    
    func nextCell(afterCell cell: Cell) -> Cell {
        if cell.cellPosition.row == .Front && cell.cellPosition.number == GameField.cellsPerRow - 1 && direction == .up {
            return backRow[cell.cellPosition.number]
        }
        else if cell.cellPosition.row == .Back && cell.cellPosition.number == 0 && direction == .up {
            return frontRow[cell.cellPosition.number]
        }
        else if cell.cellPosition.row == .Front && cell.cellPosition.number == 0 && direction == .down {
            return backRow[cell.cellPosition.number]
        }
        else if cell.cellPosition.row == .Back && cell.cellPosition.number == GameField.cellsPerRow - 1 && direction == .down {
            return frontRow[cell.cellPosition.number]
        }
        else if direction == .up && cell.cellPosition.row == .Back {
            return backRow[cell.cellPosition.number - 1]
        }
        else if direction == .up {
            return frontRow[cell.cellPosition.number + 1]
        }
        else if direction == .down && cell.cellPosition.row == .Back {
            return backRow[cell.cellPosition.number + 1]
        }
        else if direction == .down {
            return frontRow[cell.cellPosition.number - 1]
        }
        else {
            return frontRow[1]
        }
    }
    
    func getCell(at position: CellPosition) -> Cell {
        if position.row == .Front {
            return self.frontRow[position.number]
        }
        return self.backRow[position.number]
        
    }
    
    func toString(player: Player) -> String {
        
        var backRowText: String = ""
        for cell in backRow {
            backRowText += "\(cell.stones)\t"
        }
        var frontRowText: String = ""
        for cell in frontRow {
            frontRowText += "\(cell.stones)\t"
        }
        if player == .one {
            return "\(backRowText)\n\(frontRowText)"
        }
        return "\(frontRowText)\n\(backRowText)"
    }
    
    
    enum Direction {
        case up
        case down
    }
    
}
