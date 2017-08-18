//
//  PlayerCellsTest.swift
//  Hus
//
//  Created by Yannick Winter on 18.08.17.
//  Copyright © 2017 Winterapps. All rights reserved.
//

import XCTest
@testable import Hus

class PlayerCellsTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        let playersCells = PlayerCells()
        assert(playersCells.numberOfStonesInFrontRow == 2 * 8 && playersCells.totalNumberOfStones == 4 * 8)
    }
    
    func testNextCellDirectionUp() {
        let playersCells = PlayerCells()
        playersCells.set(direction: .up)
        
        var nextCell = playersCells.getCell(at: CellPosition(row: .Front, number: 0))
        nextCell = playersCells.nextCell(afterCell: nextCell)
        assert(nextCell.cellPosition.row == .Front && nextCell.cellPosition.number == 1)
        
        nextCell = playersCells.getCell(at: CellPosition(row: .Front, number: 7))
        nextCell = playersCells.nextCell(afterCell: nextCell)
        assert(nextCell.cellPosition.row == .Back && nextCell.cellPosition.number == 7)
        
        nextCell = playersCells.nextCell(afterCell: nextCell)
        assert(nextCell.cellPosition.row == .Back && nextCell.cellPosition.number == 6)
        
        nextCell = playersCells.getCell(at: CellPosition(row: .Back, number: 0))
        nextCell = playersCells.nextCell(afterCell: nextCell)
        assert(nextCell.cellPosition.row == .Front && nextCell.cellPosition.number == 0)
    }
    
    func testNextCellDirectionDown() {
        let playersCells = PlayerCells()
        playersCells.set(direction: .down)
        
        var nextCell = playersCells.getCell(at: CellPosition(row: .Front, number: 7))
        nextCell = playersCells.nextCell(afterCell: nextCell)
        assert(nextCell.cellPosition.row == .Front && nextCell.cellPosition.number == 6)
        
        nextCell = playersCells.getCell(at: CellPosition(row: .Front, number: 0))
        nextCell = playersCells.nextCell(afterCell: nextCell)
        assert(nextCell.cellPosition.row == .Back && nextCell.cellPosition.number == 0)
        
        nextCell = playersCells.nextCell(afterCell: nextCell)
        assert(nextCell.cellPosition.row == .Back && nextCell.cellPosition.number == 1)
        
        
        nextCell = playersCells.getCell(at: CellPosition(row: .Back, number: 7))
        nextCell = playersCells.nextCell(afterCell: nextCell)
        assert(nextCell.cellPosition.row == .Front && nextCell.cellPosition.number == 7)
        
    }
    
}
