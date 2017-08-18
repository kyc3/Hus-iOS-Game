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
    
    func performProcess(position: CellPosition, withDelay delays: Bool = true) {
        gameField.shouldSleep = delays
        if gameField.getCell(atPosition: position, forPlayer: nextPlayer).hasStones {
            self.gameField.startProcess(forPlayer: self.nextPlayer, atPosition: position)
            nextPlayer = nextPlayer == .one ? .two : .one
        }
    }
    
    func getCell(atPosition position: CellPosition, forPlayer player: Player) -> Cell {
        return self.gameField.getCell(atPosition: position, forPlayer: player)
    }
    
    func setDirection(forNextPlayer direction: PlayerCells.Direction) {
        if next == .one {
            self.setDirection(forFirstPlayer: direction)
        }
        else {
            self.setDirection(forSecondPlayer: direction)
        }
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
    
    var winner: Player? {
        return self.gameField.winner
    }
    
    func doPrint() {
        self.gameField.printOutput()
    }
    
    
    func evaluateGame(forPlayer player: Player) -> Double {
        return gameField.evaluateGame(forPlayer: player)
    }
    
    func copy() -> Game {
        let game = Game()
        game.nextPlayer = nextPlayer
        game.gameField = gameField.copy()
        return game
    }
    
}

