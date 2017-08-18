//
//  Bot.swift
//  Hus
//
//  Created by Yannick Winter on 18.08.17.
//  Copyright © 2017 Winterapps. All rights reserved.
//

import Foundation

class Bot {
    
    
    static func nextPositionToSelect(forGame game: Game, closure: @escaping (CellPosition) -> Void) {
        let player = game.next
        
        let group = DispatchGroup()
        
        var directionEvaluation: [CellPosition: Double] = [:]
        var winnerDirection: [CellPosition: Bool] = [:]
        
        // do something, including background threads
        for position in CellPosition.possibleCellPositions {
            guard game.getCell(atPosition: position, forPlayer: player).hasStones else {
                continue
            }
            group.enter()
            let gameCopy = game.copy()
            gameCopy.performProcess(position: position, withDelay: false)
            directionEvaluation[position] = gameCopy.evaluateGame(forPlayer: player)
            winnerDirection[position] = game.winner != nil
            group.leave()
        }
        
        
        group.notify(queue: DispatchQueue.main) {
            var bestPosition: CellPosition = directionEvaluation.keys.first!
            for position in directionEvaluation.keys {
                if winnerDirection[position]! {
                    closure(bestPosition)
                    return
                }
                if directionEvaluation[position]! > directionEvaluation[bestPosition]! {
                    bestPosition = position
                }
            }
            closure(bestPosition)
        }
        
    }
    
    static func chooseDirection() -> PlayerCells.Direction {
        if arc4random_uniform(1) == 0 {
            return .up
        }
        return .down
    }
    
}
