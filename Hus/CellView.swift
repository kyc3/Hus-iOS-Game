//
//  CellView.swift
//  Hus
//
//  Created by Yannick Winter on 17.08.17.
//  Copyright © 2017 Winterapps. All rights reserved.
//

import UIKit
import QuartzCore

class CellView: UIView, CellUpdateDelegate {
    typealias UIParameters = (cell: Cell, shouldRotateLabel: Bool, player: Player, delegate: CellViewTapDelegate)
    
    
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var numberOfStonesLabel: UILabel!
    
    private var player: Player!
    private var delegate: CellViewTapDelegate?
    
    private var gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    
    func configure(withUIParams uiParams: UIParameters) {
        uiParams.cell.delegate = self
        self.player = uiParams.player
        self.delegate = uiParams.delegate
        if uiParams.shouldRotateLabel {
            numberOfStonesLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        else {
            numberOfStonesLabel.transform = CGAffineTransform(rotationAngle: 0)
        }
        roundedView.layer.cornerRadius = self.frame.size.height / 2
        roundedView.layer.masksToBounds = true
        self.setUpGestureRecognizer()
    }
    
    private func setUpGestureRecognizer() {
        self.gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.roundedView.addGestureRecognizer(self.gestureRecognizer)
    }
    
    func didUpdate(numberOfStones: Int) {
        print("updating.....")
        numberOfStonesLabel.text = "\(numberOfStones)"
    }

    func didTap() {
        print("did Tap: \(self.tag)")
        self.delegate?.didTapCell(withTag: self.tag, fromPlayer: player)
    }
    
    
}

protocol CellUpdateDelegate {
    
    func didUpdate(numberOfStones: Int)
    
}

protocol CellViewTapDelegate {
    
    func didTapCell(withTag tag: Int, fromPlayer player: Player)
    
}
