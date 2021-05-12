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
    
    
    let viewModel = GameScreenViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    
    
    func updateUI() {
        remainingManoeuvresLabel.text = "Remaining Moves: \(viewModel.remainingManoeuvres)"
        totalScoreLabel.text = "Total Score: \(viewModel.totalScore)"
    }


}

