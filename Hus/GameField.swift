//
//  GameField.swift
//  Hus
//
//  Created by Yannick Winter on 15.08.17.
//  Copyright © 2017 Winterapps. All rights reserved.
//

import Foundation

class GameField {
    
    static let cellsPerRow = 8
    
    private var firstPlayerCells: PlayerCells!
    private var secondPlayerCells: PlayerCells!
    
    init() {
        self.firstPlayerCells = PlayerCells()
        self.secondPlayerCells = PlayerCells()
    }
    
    func setDirection(forFirstPlayer direction: PlayerCells.Direction) {
        self.firstPlayerCells.set(direction: direction)
    }
    
    func setDirection(forSecondPlayer direction: PlayerCells.Direction) {
        self.secondPlayerCells.set(direction: direction)
    }
    
    func startProcess(forPlayer player: Player, atPosition position: CellPosition) {
        let playerCells: PlayerCells = player == .one ? self.firstPlayerCells : self.secondPlayerCells
        let otherPlayerCells: PlayerCells = player == .one ? self.secondPlayerCells : self.firstPlayerCells
        var hasfinished: Bool = false
        var previousCell = playerCells.getCell(at: position)
        var stones = previousCell.takeStones()
        while !hasfinished {
            previousCell = distributesStones(stones: stones, inList: playerCells, selectedCell: previousCell)
            if !((previousCell.cellPosition.row == .Front && otherPlayerCells.getCell(at: previousCell.cellPosition).hasStones) || previousCell.mayContinue) {
                hasfinished = true
                continue
            }
            stones = previousCell.takeStones()
            if previousCell.cellPosition.row == .Front {
                stones += otherPlayerCells.getCell(at: previousCell.cellPosition).takeStones()
            }
        }
    }
    
    private func distributesStones(stones: Int, inList playerCells: PlayerCells, selectedCell: Cell) -> Cell {
        var remainingStones: Int = stones
        var lastCell: Cell = selectedCell
        while remainingStones != 0 {
            lastCell = playerCells.nextCell(afterCell: lastCell)
            var label: String
            if lastCell.cellPosition.row == CellPosition.Row.Front {
                label = "front"
            }
            else {
                label = "back"
            }
            print("updating at row: \(label) number: \(lastCell.cellPosition.number)")
            lastCell.addStone()
            remainingStones -= 1
        }
        return lastCell
    }
    
    func getCell(atPosition position: CellPosition, forPlayer player: Player) -> Cell {
        if player == .one {
            return firstPlayerCells.getCell(at: position)
        }
        else {
            return secondPlayerCells.getCell(at: position)
        }
    }
    
    func printOutput() {
        print("\(firstPlayerCells.toString(player: .one))\n-----------------------------\n\(secondPlayerCells.toString(player: .two))\n\n\n")
    }
    
                         
}

