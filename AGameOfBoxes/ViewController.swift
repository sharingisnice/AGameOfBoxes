//
//  ViewController.swift
//  AGameOfBoxes
//
//  Created by Mert Ejder on 12.05.2021.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var remainingManoeuvresLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var gameArea: UIView!
    @IBOutlet weak var restartButtonOutlet: UIButton!
    
    
    var viewModel : GameScreenViewModel? = GameScreenViewModel()
    var setupComplete = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        
        //we check if the setup is complete, otherwise this code is called everytime the ui updates and calls the draw method of viewModel
        if !setupComplete {
            setupUI()
        }
    }
    
    
    func setupUI() {
        if let viewModel = viewModel {
            
            let initialView = viewModel.DrawBlocks(size: 5, enclosingView: gameArea)
            
            for sub in initialView {
                gameArea.addSubview(sub)
            }
            
            viewModel.delegate = self
            setupComplete = true
            
            restartButtonOutlet.isEnabled = false
            
        }
    }
    
    func updateUI() {
        if let viewModel = viewModel {
            remainingManoeuvresLabel.text = "Remaining Moves: \(viewModel.remainingManoeuvres)"
            totalScoreLabel.text = "Total Score: \(viewModel.totalScore)"
        }
    }
    
    @IBAction func restartGame(_ sender: Any) {
        viewModel = nil
        viewModel = GameScreenViewModel()
        setupComplete = false
        setupUI()
        updateUI()
        
    }
    
    
    
}

extension ViewController: GameScreenDelegate {
    func updateView() {
        self.updateUI()
    }
    
    func enableRestart() {
        restartButtonOutlet.isEnabled = true
    }
    
}
