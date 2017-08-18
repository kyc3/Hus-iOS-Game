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
    
    private var updateLabel: UILabel!
    
    private var rotated: Bool = false
    
    private var player: Player!
    private var delegate: CellViewTapDelegate?
    
    private var gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    
    func configure(withUIParams uiParams: UIParameters) {
        self.rotated = uiParams.shouldRotateLabel
        self.setupUpdateLabel()
        self.numberOfStonesLabel.text = nil
        uiParams.cell.delegate = self
        self.player = uiParams.player
        self.delegate = uiParams.delegate
        applyRotation(toLabel: self.numberOfStonesLabel)
        roundedView.layer.cornerRadius = self.frame.size.height / 2
        roundedView.layer.masksToBounds = true
        
        self.setUpGestureRecognizer()
    }
    
    private func setupUpdateLabel() {
        self.updateLabel = UILabel(frame: self.frame)
        self.updateLabel.text = ""
        self.updateLabel.textAlignment = .center
        self.updateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.updateLabel.alpha = 0
        self.applyRotation(toLabel: self.updateLabel)
        self.addSubview(updateLabel)
        
        let widthConstraint = NSLayoutConstraint(item: updateLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: updateLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
        let centerXConstraint = NSLayoutConstraint(item: updateLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: updateLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: self.rotated ? 20 : -20)
        
        NSLayoutConstraint.activate([
            widthConstraint, heightConstraint,
            centerXConstraint, centerYConstraint
            ])
    }
    
    private func applyRotation(toLabel label: UILabel) {
        if self.rotated {
            Helpers.rotate(view: label, direction: .upsideDown)
        }
        else {
            Helpers.rotate(view: label, direction: .normal)
        }
    }
    
    private func setUpGestureRecognizer() {
        self.gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.roundedView.addGestureRecognizer(self.gestureRecognizer)
    }
    
    func didUpdate(numberOfStones: Int) {
        self.showUpdateAnimation(newAmount: numberOfStones)
        numberOfStonesLabel.text = "\(numberOfStones)"
    }
    
    func showUpdateAnimation(newAmount: Int) {
        guard let text = numberOfStonesLabel.text else {
            return
        }
        guard let previous = Int(text) else {
            return
        }
        print("updating for player \(self.player == .one ? "1" : "2") row: \(tag)")
        let difference = newAmount - previous
        if difference > 0 {
            self.updateLabel.text = "+\(difference)"
            self.updateLabel.textColor = UIColor.green
        }
        else if difference == 0 {
            return
        }
        else {
            self.updateLabel.text = "\(difference)"
            self.updateLabel.textColor = UIColor.red
        }
        let delay = 0.8 // TimeInterval(GameViewController.delay / 100) / 2
        UIView.animate(withDuration: delay, animations: {_ in
            self.updateLabel.alpha = 1
        }, completion: {_ in
            UIView.animate(withDuration: delay, animations: {_ in
                self.updateLabel.alpha = 0
            })
        })
        
    }

    func didTap() {
        self.delegate?.didTapCell(withTag: self.tag, fromPlayer: player)
    }
    
    
}

protocol CellUpdateDelegate {
    
    func didUpdate(numberOfStones: Int)
    
}

protocol CellViewTapDelegate {
    
    func didTapCell(withTag tag: Int, fromPlayer player: Player)
    
}
