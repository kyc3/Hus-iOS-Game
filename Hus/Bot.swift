//
//  Bot.swift
//  Hus
//
//  Created by Yannick Winter on 18.08.17.
//  Copyright © 2017 Winterapps. All rights reserved.
//

import Foundation

class Bot {
    
    private let game: Game
    private let player: Player
    private let difficulty: Difficulty
    let direction: PlayerCells.Direction = Bot.chooseDirection()
    
    init(game: Game, player: Player, difficulty: Difficulty) {
        self.game = game
        self.player = player
        self.difficulty = difficulty
    }
    
    func nextPositionToSelect(closure: @escaping (CellPosition) -> Void) {
        let group = DispatchGroup()
        
        var directionEvaluation: [(position: CellPosition, value: Double)] = []
        var winnerDirection: [CellPosition: Bool] = [:]
        
        for position in CellPosition.possibleCellPositions {
            guard game.getCell(atPosition: position, forPlayer: player).hasStones else {
                continue
            }
            group.enter()
            let gameCopy = game.copy()
            gameCopy.performProcess(position: position, withDelay: false)
            directionEvaluation.append((position: position, value: gameCopy.evaluateGame(forPlayer: player)))
            winnerDirection[position] = game.winner != nil
            group.leave()
        }
        
        
        group.notify(queue: DispatchQueue.main) {
            directionEvaluation.sort(by: {first, second in
                if winnerDirection[second.position]! {
                    return false
                }
                else if winnerDirection[first.position]! {
                    return true
                }
                return first.value > second.value
            })
            closure(self.chooseDirection(evaluated: directionEvaluation))
        }
        
    }
    
    private func chooseDirection(evaluated: [(position: CellPosition, value: Double)]) -> CellPosition {
        if difficulty == .hard {
            return evaluated.first!.position
        }
        else if difficulty == .medium {
            return evaluated[Int(evaluated.count / 2)].position
        }
        else {
            return evaluated.last!.position
        }
    }
    
    private static func chooseDirection() -> PlayerCells.Direction {
        if arc4random_uniform(1) == 0 {
            return .up
        }
        return .down
    }
    
    enum Difficulty {
        case hard
        case medium
        case easy
        
        var title: String {
            switch self {
            case .easy:
                return "Easy"
            case .medium:
                return "Medium"
            case .hard:
                return "hard"
            }
        }
    }
    
}
