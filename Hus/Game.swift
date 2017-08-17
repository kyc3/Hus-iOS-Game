//
//  Game.swift
//  Hus
//
//  Created by Yannick Winter on 15.08.17.
//  Copyright © 2017 Winterapps. All rights reserved.
//

import Foundation

class Game {
    
    private var gameField: GameField = GameField()
    private var nextPlayer: Player = .one
    
    func performProcess(position: CellPosition) {
        if gameField.getCell(atPosition: position, forPlayer: nextPlayer).hasStones {
            self.gameField.startProcess(forPlayer: self.nextPlayer, atPosition: position)
            nextPlayer = nextPlayer == .one ? .two : .one
        }
    }
    
    func getCell(atPosition position: CellPosition, forPlayer player: Player) -> Cell {
        return self.gameField.getCell(atPosition: position, forPlayer: player)
    }
    
    func setDirection(forFirstPlayer direction: PlayerCells.Direction) {
        self.gameField.setDirection(forFirstPlayer: direction)
    }
    
    func setDirection(forSecondPlayer direction: PlayerCells.Direction) {
        self.gameField.setDirection(forSecondPlayer: direction)
    }
    
    var next: Player {
        return nextPlayer
    }
    
    func doPrint() {
        self.gameField.printOutput()
    }
    
}

