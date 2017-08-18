//
//  StartViewController.swift
//  Hus
//
//  Created by Yannick Winter on 17.08.17.
//  Copyright © 2017 Winterapps. All rights reserved.
//

import Foundation
import UIKit

class StartViewController: UIViewController {
    
    typealias GameConfig = (gameMode: GameViewController.GameMode, difficulty: Bot.Difficulty?)
    
    @IBAction func singlePlayer(_ sender: Any?) {
        let difficulty: Bot.Difficulty
        if (sender as? UIView)?.tag == 0 {
            difficulty = .easy
        }
        else if (sender as? UIView)?.tag == 1 {
            difficulty = .medium
        }
        else {
            difficulty = .hard
        }
        
        performSegue(withIdentifier: Config.startGameSegueIdentifier, sender: (gameMode: GameViewController.GameMode.singlePlayer, difficulty: difficulty))
    }
    
    @IBAction func multiPlayer() {
        let config = (gameMode: GameViewController.GameMode.multiPlayer, difficulty: Bot.Difficulty.easy)
        performSegue(withIdentifier: Config.startGameSegueIdentifier, sender: config)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Config.startGameSegueIdentifier, let gameConfig = sender as? GameConfig, let gameViewController = ((segue.destination as? UINavigationController)?.viewControllers.first as? GameViewController) else {
            super.prepare(for: segue, sender: sender)
            return
        }
        gameViewController.gameMode = gameConfig.gameMode
        gameViewController.botDifficulty = gameConfig.difficulty
    }
    
    
    
    
    private struct Config {
        static let startGameSegueIdentifier = "StartGame"
    }
    
}

