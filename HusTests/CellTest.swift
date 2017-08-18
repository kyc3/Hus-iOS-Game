//
//  CellTest.swift
//  Hus
//
//  Created by Yannick Winter on 18.08.17.
//  Copyright © 2017 Winterapps. All rights reserved.
//

import XCTest
@testable import Hus

class CellTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        let cell = Cell(row: .Front, number: 0)
        assert(cell.stones == 2)
        
        
    }
    
    func testTakeStones() {
        let delegate = DummyCellDelegate()
        let cell = Cell(row: .Front, number: 0)
        cell.delegate = delegate
        delegate.invalidate()
        _ = cell.takeStones()
        assert(!cell.hasStones && cell.stones == 0 && delegate.wasCalled && delegate.presentedNumber == 0)
    }
    
    func testAddStone() {
        let delegate = DummyCellDelegate()
        let cell = Cell(row: .Front, number: 0)
        let stonesBefore = cell.stones
        cell.delegate = delegate
        delegate.invalidate()
        cell.addStone()
        assert(cell.hasStones && cell.stones == stonesBefore + 1 && delegate.wasCalled && delegate.presentedNumber == stonesBefore + 1)
    }
    
}


class DummyCellDelegate: CellUpdateDelegate {
    
    var wasCalled: Bool = false
    var presentedNumber: Int = 999
    
    func didUpdate(numberOfStones: Int) {
        self.wasCalled = true
        self.presentedNumber = numberOfStones
    }
    
    func invalidate() {
        wasCalled = false
        presentedNumber = 999
    }
    
}
