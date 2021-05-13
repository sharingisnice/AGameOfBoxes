//
//  gameScreenViewModel.swift
//  AGameOfBoxes
//
//  Created by Mert Ejder on 12.05.2021.
//

import UIKit

protocol GameScreenDelegate {
    func updateView()
}

class GameScreenViewModel {
    
    var delegate: GameScreenDelegate?
    var remainingManoeuvres = 10
    var totalScore = 0
    let radiusSize: CGFloat = 12
    var itemPositions = [[Int]]()
    
    let colorBox = [UIColor.BoxGameTheme.coolOrange, .BoxGameTheme.coolGreen, .BoxGameTheme.coolMagenta, .BoxGameTheme.coolBlue, .BoxGameTheme.coolRed , .BoxGameTheme.coolLightGreen, .BoxGameTheme.coolDarkerBlue]
    
    init() {
        print("initialized")
    }
    
    func DrawBlocks(size: Int, enclosingView: UIView) -> [Block] {
        var blockArray = [Block()]
        blockArray.removeAll()
        
        //populating positions array
        itemPositions = Array(repeating: Array(repeating: 0, count: size), count: size)
        
        let boxSize = enclosingView.bounds.width / CGFloat(size)
        
        for i in 0...(size-1) {
            for j in 0...(size-1) {
                let rect = CGRect( x: CGFloat(i)*boxSize ,
                                   y: CGFloat(j)*boxSize ,
                                   width: boxSize,
                                   height: boxSize)
                
                let block = Block(frame: rect)
                block.backgroundColor = .BoxGameTheme.coolGray
                block.layer.borderWidth = 2
                block.layer.cornerRadius = radiusSize
                block.layer.borderColor = UIColor.white.cgColor
                block.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
                block.position = [i,j]
                
                blockArray.append(block)
            }
        }
        
        return blockArray
    }
    
    
    @objc func tappedButton(sender: Block) {
        print("tapped on \(sender.position ?? [0])")
        
        
        
        if !canAddToPosition(position: sender.position!) {
            return
        }
        
        let newView = UIView(frame: sender.bounds)
        newView.backgroundColor = colorBox.randomElement()
        newView.layer.cornerRadius = radiusSize
        let animation = growAnimation(view: newView)
        newView.layer.add(animation, forKey: nil)
        
        remainingManoeuvres -= 1
        
        sender.addSubview(newView)
        delegate?.updateView()
    }
    
    func canAddToPosition(position: [Int]) -> Bool {
        if remainingManoeuvres <= 0 { return false }
        let hasBox = itemPositions[position[0]][position[1]]
        if (hasBox != 0) { return false }
        
        
        return true
    }
    
    
    func growAnimation(view: UIView) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.1
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        
        return animation
    }
    
    
    func dropAnimation(view: UIView, toPosition: CGRect) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.y")
        
        animation.fromValue = 0
        animation.toValue = toPosition
        animation.duration = 1
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        
        return animation
    }
    
}
