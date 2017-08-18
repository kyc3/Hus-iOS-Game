//
//  GameViewController.swift
//  Hus
//
//  Created by Yannick Winter on 15.08.17.
//  Copyright © 2017 Winterapps. All rights reserved.
//

import UIKit
import QuartzCore

class GameViewController: UIViewController, CellViewTapDelegate {
    
    static var delay: UInt32 = 250000
    static let spaceBetweenPlayers: CGFloat = 10
    
    var gameMode: GameMode!
    var botDifficulty: Bot.Difficulty?
    
    @IBOutlet weak var upperPlayerBack: UIStackView!
    @IBOutlet weak var upperPlayerFront: UIStackView!
    @IBOutlet weak var lowerPlayerFront: UIStackView!
    @IBOutlet weak var lowerPlayerBack: UIStackView!
    @IBOutlet weak var playerOneOverlay: UIView!
    @IBOutlet weak var playerTwoOverlay: UIView!
    @IBOutlet weak var botThinkingView: UIView!
    @IBOutlet weak var winnerView: UIView!
    @IBOutlet weak var winnerLabel: UILabel!
    
    var viewModel = GameViewControllerViewModel()
    var gameEnabled: Bool = true
    var botPlayer: Player?
    
    private var highlightedView: CellView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWinnerView()
        self.setupThinkingView()
        self.setupTitle()
        startSteps()
    }
    
    func setupTitle() {
        let title: String
        if gameMode == GameMode.singlePlayer {
            title = "Single Player - \(botDifficulty!.title)"
        }
        else {
            title = "Multiplayer"
        }
        self.title = title
    }
    
    func startSteps() {
        
        self.configure()
        self.adjustOverlays()
    }
    
    func configure() {
        
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
        
        if gameMode == GameMode.singlePlayer {
            if self.botDifficulty != nil {
                self.viewModel.set(botDifficulty: self.botDifficulty!)
            }
            else {
                self.viewModel.set(botDifficulty: .hard)
            }
            botPlayer = .one
        }
        showWhoShouldStart()
    }
    
    func showWhoShouldStart() {
        let message: String = gameMode == GameMode.singlePlayer ? "You or the Opponent?" : "Upper or lower player?"
        let alert = UIAlertController(title: "Who should start?", message: message, preferredStyle: .actionSheet)
        let upperTitle: String = gameMode == GameMode.singlePlayer ? "Opponent" : "Upper player"
        let lowerTitle: String = gameMode == GameMode.singlePlayer ? "Me" : "Lower player"
        
        let upperAction = UIAlertAction(title: upperTitle, style: .default, handler: {_ in
            self.viewModel.startingPlayerSelected(player: .one)
            self.adjustOverlays()
            self.nextStep()
        })
        let lowAction = UIAlertAction(title: lowerTitle, style: .default, handler: {_ in
            self.viewModel.startingPlayerSelected(player: .two)
            self.adjustOverlays()
            self.nextStep()
        })
        alert.addAction(upperAction)
        alert.addAction(lowAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    var upperSideRotated: Bool {
        return gameMode == GameMode.multiPlayer
    }
    
    func gameClosure(reaction: ResponseReaction) -> Void {
        self.gameEnabled = true
        self.highlightedView?.unHighlight()
        switch reaction {
        case .showGameOverMessage:
            self.removeOverlays()
            self.gameEnabled = false
            self.showWinnerView()
            print("GameOver")
        default:
            self.adjustOverlays()
        }
        nextStep()
        
    }
    
    func setupWinnerView() {
        self.winnerView.layer.cornerRadius = 10
        self.winnerView.layer.masksToBounds = true
        self.winnerView.alpha = 0
    }
    
    func showWinnerView() {
        if self.viewModel.game.winner == .one && self.gameMode == GameMode.singlePlayer {
            self.winnerLabel.text = "Bot has won"
        }
        else if self.viewModel.game.winner == .one {
            self.winnerLabel.text = "Upper player has won"
        }
        else if self.viewModel.game.winner == .two && self.gameMode == GameMode.singlePlayer {
            self.winnerLabel.text = "You have won"
        }
        else {
            self.winnerLabel.text = "Lower player has one"
        }
        
        UIView.animate(withDuration: 0.8, animations: {_ in
            self.winnerView.alpha = 1
        })
    }
    
    func hideWinnerView() {
        UIView.animate(withDuration: 0.8, animations: {_ in
            self.winnerView.alpha = 0
        })
    }
    
    func nextStep() {
        guard botPlayer != nil && self.viewModel.game.winner == nil else {
            return
        }
        
        if self.viewModel.nextPlayer() == botPlayer {
            self.gameEnabled = false
            self.showThinkingView()
            self.viewModel.performBotStep(selectedPositionCallback: {position in
                self.hideThinkingView()
                self.highlightCell(withTag: position.hashValue, forPlayer: self.botPlayer!)
            },closure: gameClosure)
        }
    }
    
    func setupThinkingView() {
        self.botThinkingView.layer.cornerRadius = 10
        self.botThinkingView.layer.masksToBounds = true
        self.botThinkingView.alpha = 0
    }
    
    func showThinkingView() {
        UIView.animate(withDuration: 0.8, animations: {_ in
            self.botThinkingView.alpha = 1
        })
    }
    
    func hideThinkingView() {
        UIView.animate(withDuration: 0.8, animations: {_ in
            self.botThinkingView.alpha = 0
        })
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
            let alert = UIAlertController(title: "Direction", message: "Which direction would you like to go?", preferredStyle: .alert)
            
            let leftAction = UIAlertAction(title: "Left", style: .default, handler: {_ in
                let direction: PlayerCells.Direction
                if self.viewModel.nextPlayer() == .one && tag < 8 {
                    direction = .up
                }
                else if self.viewModel.nextPlayer() == .one {
                    direction = .down
                }
                else if tag < 8 {
                    direction = .down
                }
                else {
                    direction = .up
                }
                self.viewModel.set(directionForNextPlayer: direction)
                self.highlightCell(withTag: tag, forPlayer: player)
                self.viewModel.didSelectItem(fromPlayer: player, andTag: tag, closure: self.gameClosure)
            })
            let rightAction = UIAlertAction(title: "Right", style: .default, handler: {_ in
                let direction: PlayerCells.Direction
                if self.viewModel.nextPlayer() == .two && tag < 8 {
                    direction = .up
                }
                else if self.viewModel.nextPlayer() == .two {
                    direction = .down
                }
                else if tag < 8  {
                    direction = .down
                }
                else {
                    direction = .up
                }
                self.viewModel.set(directionForNextPlayer: direction)
                self.highlightCell(withTag: tag, forPlayer: player)
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
        if self.viewModel.canSelectItem(fromPlayer: player, andTag: tag) {
            self.highlightCell(withTag: tag, forPlayer: player)
            self.viewModel.didSelectItem(fromPlayer: player, andTag: tag, closure: self.gameClosure)
        }
        
    }
    
    func highlightCell(withTag tag: Int, forPlayer player: Player) {
        let stack: UIStackView
        if player == .one && tag < 8 {
            stack = self.upperPlayerFront
        }
        else if player == .one && tag > 7 {
            stack = self.upperPlayerBack
        }
        else if player == .two && tag < 8 {
            stack = self.lowerPlayerFront
        }
        else {
            stack = self.lowerPlayerBack
        }
        for view in stack.arrangedSubviews {
            if view.tag == tag {
                self.highlightedView = view as? CellView
                self.highlightedView?.highlight()
            }
        }
    }
    
    func showTippAtCell(withTag tag: Int, forPlayer player: Player) {
        let stackView = getStackView(forTag: tag, andPlayer: player)
        for view in stackView.arrangedSubviews {
            if view.tag == tag {
                (view as? CellView)?.performTippLogic()
                return
            }
        }
    }
    
    func getStackView(forTag tag: Int, andPlayer player: Player) -> UIStackView {
        if player == .one {
            if tag < 8 {
                return self.upperPlayerFront
            }
            else {
                return self.upperPlayerBack
            }
        }
        else {
            if tag < 8 {
                return self.lowerPlayerFront
            }
            else {
                return self.lowerPlayerBack
            }
        }
    }
    
    @IBAction func cancelGame(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func restartGame(_ sender: Any) {
        self.viewModel = GameViewControllerViewModel()
        self.hideThinkingView()
        self.hideWinnerView()
        self.gameEnabled = true
        self.startSteps()
    }
    
    @IBAction func showTipps(_ sender: Any) {
        if gameEnabled {
            gameEnabled = false
            showThinkingView()
            self.viewModel.getTipp(selectedPositionCallback: { (position) in
                self.hideThinkingView()
                self.showTippAtCell(withTag: position.hashValue, forPlayer: self.viewModel.nextPlayer())
                self.gameEnabled = true
            })
            
        }
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




