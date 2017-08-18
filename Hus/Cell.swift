//
//  Cell.swift
//  Hus
//
//  Created by Yannick Winter on 15.08.17.
//  Copyright © 2017 Winterapps. All rights reserved.
//

import Foundation

class Cell {
    
    
    private var numberOfStones: Int
    private var position: CellPosition
    var delegate: CellUpdateDelegate? {
        didSet {
            self.delegate?.didUpdate(numberOfStones: self.numberOfStones)
        }
    }
    
    init(row: CellPosition.Row, number: Int) {
        self.position = CellPosition(row: row, number: number)
        self.numberOfStones = 2
    }
    
    init(position: CellPosition) {
        self.position = position
        self.numberOfStones = 2
    }
    
    var hasStones: Bool {
        return self.numberOfStones > 0
    }
    
    var mayContinue: Bool {
        return self.numberOfStones > 1
    }
    
    var cellPosition: CellPosition {
        return self.position
    }
    
    var stones: Int {
        return numberOfStones
    }
    
    func takeStones() -> Int {
        let stones: Int = numberOfStones
        numberOfStones = 0
        self.notifyDelegate()
        return stones
    }
    
    func addStone() {
        self.numberOfStones += 1
        self.notifyDelegate()
    }
    
    private func notifyDelegate() {
        if Thread.isMainThread {
            self.delegate?.didUpdate(numberOfStones: self.numberOfStones)
            return
        }
        
        DispatchQueue.main.async(execute: {
            self.delegate?.didUpdate(numberOfStones: self.numberOfStones)
        })
    }
    
    func copy() -> Cell {
        let cell = Cell(position: position)
        cell.numberOfStones = self.numberOfStones
        return cell
    }
    
}
