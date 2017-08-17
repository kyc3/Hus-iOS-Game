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
    
    
    
    @IBAction func singlePlayer() {
        performSegue(withIdentifier: Config.startGameSegueIdentifier, sender: GameViewController.GameMode.singlePlayer)
    }
    
    @IBAction func multiPlayer() {
        performSegue(withIdentifier: Config.startGameSegueIdentifier, sender: GameViewController.GameMode.multiPlayer)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Config.startGameSegueIdentifier, let gameMode = sender as? GameViewController.GameMode, let gameViewController = ((segue.destination as? UINavigationController)?.viewControllers.first as? GameViewController) else {
            super.prepare(for: segue, sender: sender)
            return
        }
        gameViewController.gameMode = gameMode
    }
    
    
    
    
    private struct Config {
        static let startGameSegueIdentifier = "StartGame"
    }
    
}

