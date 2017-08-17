//
//  GameViewController.swift
//  Hus
//
//  Created by Yannick Winter on 15.08.17.
//  Copyright © 2017 Winterapps. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, CellViewTapDelegate {
    
    static var delay: UInt32 = 500000
    static let spaceBetweenPlayers: CGFloat = 10
    
    @IBOutlet weak var upperPlayerBack: UIStackView!
    @IBOutlet weak var upperPlayerFront: UIStackView!
    @IBOutlet weak var lowerPlayerFront: UIStackView!
    @IBOutlet weak var lowerPlayerBack: UIStackView!
    
    let viewModel = GameViewControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    func configure() {
        for view in upperPlayerBack.arrangedSubviews {
            guard let cellView = view as? CellView else {
                continue
            }
            cellView.configure(withUIParams: (cell: self.viewModel.cell(forPlayer: .one, andTag: cellView.tag), shouldRotateLabel: true, player: .one, delegate: self))
        }
        for view in upperPlayerFront.arrangedSubviews {
            guard let cellView = view as? CellView else {
                continue
            }
            cellView.configure(withUIParams:(cell: self.viewModel.cell(forPlayer: .one, andTag: cellView.tag), shouldRotateLabel: true, player: .one, delegate: self))
        }
        for view in lowerPlayerFront.arrangedSubviews {
            guard let cellView = view as? CellView else {
                continue
            }
            cellView.configure(withUIParams: (cell: self.viewModel.cell(forPlayer: .two, andTag: cellView.tag), shouldRotateLabel: false, player: .two, delegate: self))
        }
        for view in lowerPlayerBack.arrangedSubviews {
            guard let cellView = view as? CellView else {
                continue
            }
            cellView.configure(withUIParams: (cell: self.viewModel.cell(forPlayer: .two, andTag: cellView.tag), shouldRotateLabel: false, player: .two, delegate: self))
        }
        
    }
    
    func didTapCell(withTag tag: Int, fromPlayer player: Player) {
        self.viewModel.didSelectItem(fromPlayer: player, andTag: tag)
    }
    
}

