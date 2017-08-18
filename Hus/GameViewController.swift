//
//  GameViewController.swift
//  Hus
//
//  Created by Yannick Winter on 15.08.17.
//  Copyright © 2017 Winterapps. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, CellViewTapDelegate {
    
    static var delay: UInt32 = 250000
    static let spaceBetweenPlayers: CGFloat = 10
    
    var gameMode: GameMode!
    
    @IBOutlet weak var upperPlayerBack: UIStackView!
    @IBOutlet weak var upperPlayerFront: UIStackView!
    @IBOutlet weak var lowerPlayerFront: UIStackView!
    @IBOutlet weak var lowerPlayerBack: UIStackView!
    @IBOutlet weak var playerOneOverlay: UIView!
    @IBOutlet weak var playerTwoOverlay: UIView!
    
    let viewModel = GameViewControllerViewModel()
    var gameEnabled: Bool = true
    var botPlayer: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.adjustOverlays()
    }
    
    func configure() {
        if gameMode == GameMode.singlePlayer {
            botPlayer = .one
        }
        for view in upperPlayerBack.arrangedSubviews {
            guard let cellView = view as? CellView else {
                continue
            }
            cellView.configure(withUIParams: (cell: self.viewModel.cell(forPlayer: .one, andTag: cellView.tag), shouldRotateLabel: upperSideRotated , player: .one, delegate: self))
        }
        for view in upperPlayerFront.arrangedSubviews {
            guard let cellView = view as? CellView else {
                continue
            }
            cellView.configure(withUIParams:(cell: self.viewModel.cell(forPlayer: .one, andTag: cellView.tag), shouldRotateLabel: upperSideRotated, player: .one, delegate: self))
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
        nextStep()
    }
    
    var upperSideRotated: Bool {
        return gameMode == GameMode.multiPlayer
    }
    
    func gameClosure(reaction: ResponseReaction) -> Void {
        
        switch reaction {
        case .showGameOverMessage:
            self.removeOverlays()
            self.gameEnabled = false
            // TODO: message
            print("GameOver")
        default:
            self.adjustOverlays()
        }
        nextStep()
        
    }
    
    func nextStep() {
        if self.viewModel.nextPlayer() == botPlayer {
            self.viewModel.performBotStep(closure: gameClosure)
        }
    }
    
    func removeOverlays() {
        self.playerOneOverlay.isHidden = true
        self.playerTwoOverlay.isHidden = true
    }
    
    func adjustOverlays() {
        if self.viewModel.nextPlayer() == .one {
            showOverlay(view: self.playerTwoOverlay)
            return
        }
        showOverlay(view: self.playerOneOverlay)
    }
    
    private func showOverlay(view: UIView) {
        view.isHidden = false
        (view == playerOneOverlay ? playerTwoOverlay : playerOneOverlay)?.isHidden = true
    }
    
    
    func didTapCell(withTag tag: Int, fromPlayer player: Player) {
        guard gameEnabled else {
            return
        }
        if self.viewModel.wouldBeFirstSelectionForPlayer {
            let alert = UIAlertController(title: "Direction", message: "Which direction would you like to go", preferredStyle: .alert)
            
            let leftAction = UIAlertAction(title: "Left", style: .default, handler: {_ in
                let direction: PlayerCells.Direction
                if self.viewModel.nextPlayer() == .one {
                    direction = .up
                }
                else {
                    direction = .down
                }
                self.viewModel.set(directionForNextPlayer: direction)
                self.viewModel.didSelectItem(fromPlayer: player, andTag: tag, closure: self.gameClosure)
            })
            let rightAction = UIAlertAction(title: "Right", style: .default, handler: {_ in
                let direction: PlayerCells.Direction
                if self.viewModel.nextPlayer() == .two {
                    direction = .up
                }
                else {
                    direction = .down
                }
                self.viewModel.set(directionForNextPlayer: direction)
                self.viewModel.didSelectItem(fromPlayer: player, andTag: tag, closure: self.gameClosure)
            })
            alert.addAction(leftAction)
            alert.addAction(rightAction)
            self.present(alert, animated: true, completion: {_ in
                if self.viewModel.nextPlayer() == .one && self.upperSideRotated {
                    Helpers.rotate(view: alert.view, direction: .upsideDown)
                }
            })
            return
        }
        self.viewModel.didSelectItem(fromPlayer: player, andTag: tag, closure: self.gameClosure)
    }
    
    enum GameMode {
        case singlePlayer
        case multiPlayer
    }
    
    enum ResponseReaction {
        case nothing
        case showGameOverMessage
    }
    
}




