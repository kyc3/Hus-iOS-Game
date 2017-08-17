//
//  GameCellCollectionViewCell.swift
//  Hus
//
//  Created by Yannick Winter on 15.08.17.
//  Copyright © 2017 Winterapps. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class GameCellCollectionViewCell: UICollectionViewCell, CellUpdateDelegate {
    
    static let identifier: String = "GameCellCollectionViewCell"
    
    @IBOutlet weak var roundedBackgroundView: UIView!
    @IBOutlet weak var numberCellsLabel: UILabel!
    @IBOutlet weak var roundedViewSizeConstraint: NSLayoutConstraint!
    
    override func layoutSubviews() {
        
        roundedBackgroundView.layer.cornerRadius = roundedBackgroundView.frame.height / 2
        roundedBackgroundView.layer.masksToBounds = true
    }
    
    func didUpdate(numberOfStones: Int) {
        self.numberCellsLabel.text = "\(numberOfStones)"
        
    }
    
}

