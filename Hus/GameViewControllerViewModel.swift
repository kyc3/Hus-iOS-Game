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
    
    init() {
        game.setDirection(forFirstPlayer: .up)
        game.setDirection(forSecondPlayer: .down)
    }
    
    func cell(forPlayer player: Player, andTag tag: Int) -> Cell {
        return self.game.getCell(atPosition: self.position(forTag: tag), forPlayer: player)
    }
    
    func didSelectItem(fromPlayer player: Player, andTag tag: Int) {
        let position = self.position(forTag: tag)
        if player == self.game.next && self.game.getCell(atPosition: position, forPlayer: player).hasStones {
            self.game.performProcess(position: position)
            self.game.doPrint()
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
    
    
}
