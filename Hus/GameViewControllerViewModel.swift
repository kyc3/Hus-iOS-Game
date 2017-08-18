//
//  GameViewControllerViewModel.swift
//  Hus
//
//  Created by Yannick Winter on 15.08.17.
//  Copyright © 2017 Winterapps. All rights reserved.
//

import Foundation

class GameViewControllerViewModel {
    
    var game = Game()
    
    private var directionForPlayerOneSet = false
    private var directionForPlayerTwoSet = false
    
    init() {
        game.setDirection(forFirstPlayer: .up)
        game.setDirection(forSecondPlayer: .down)
    }
    
    func cell(forPlayer player: Player, andTag tag: Int) -> Cell {
        return self.game.getCell(atPosition: self.position(forTag: tag), forPlayer: player)
    }
    
    var wouldBeFirstSelectionForPlayer: Bool {
        if game.next == .one {
            return !directionForPlayerOneSet
        }
        else {
            return !directionForPlayerTwoSet
        }
    }
    
    func set(directionForNextPlayer direction: PlayerCells.Direction) {
        game.setDirection(forNextPlayer: direction)
        if nextPlayer() == .one {
            directionForPlayerOneSet = true
            return
        }
        directionForPlayerTwoSet = true
        
    }
    
    func performBotStep(closure: @escaping (GameViewController.ResponseReaction) -> Void) {
        if self.wouldBeFirstSelectionForPlayer {
            self.set(directionForNextPlayer: Bot.chooseDirection())
        }
        DispatchQueue.global().async {
            Bot.nextPositionToSelect(forGame: self.game, closure: { (position) in
                DispatchQueue.main.async(execute: {
                    self.performProcess(fromPlayer: self.nextPlayer(), andPosition: position, closure: closure)
                })
            })
        }
    }

    func didSelectItem(fromPlayer player: Player, andTag tag: Int, closure: @escaping (GameViewController.ResponseReaction) -> Void) {
        let position = self.position(forTag: tag)
        self.performProcess(fromPlayer: player, andPosition: position, closure: closure)
        
    }
    
    func performProcess(fromPlayer player: Player, andPosition position: CellPosition, closure: @escaping (GameViewController.ResponseReaction) -> Void) {
        if player == self.game.next && self.game.getCell(atPosition: position, forPlayer: player).hasStones {
            DispatchQueue.global().async {
                self.game.performProcess(position: position)
                DispatchQueue.main.async(execute: {
                    if let _ = self.game.winner {
                        closure(.showGameOverMessage)
                        return
                    }
                    closure(.nothing)
                })
                
            }
        }
        
    }
    
    private func indexPathToPositionAndPlayer(indexPath: IndexPath) -> (position: CellPosition, player: Player) {
        let player = indexPath.section > 1 ? Player.two : Player.one
        let position = CellPosition(row: (indexPath.section == 1 || indexPath.section == 2) ? .Front : .Back, number: indexPath.row)
        return (position, player)
    }
    
    private func position(forTag tag: Int) -> CellPosition {
        if tag < 8 {
            return CellPosition(row: .Front, number: tag)
        }
        else {
            return CellPosition(row: .Back, number: tag - 8)
        }
    }
    
    func nextPlayer() -> Player {
        return self.game.next
    }
    
    
}
