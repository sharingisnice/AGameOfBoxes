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
    
    var totalScore = 0
    var remainingManoeuvres = 10
    let radiusSize: CGFloat = 12
    
    var delegate: GameScreenDelegate?
    var itemPositions = [[Bool]]()
    var gameView = UIView()
    var viewSize = 0
    var localBlockRectsArray = [[CGRect]]()
    
    let colorBox = [UIColor.BoxGameTheme.coolOrange, .BoxGameTheme.coolGreen, .BoxGameTheme.coolMagenta, .BoxGameTheme.coolBlue, .BoxGameTheme.coolRed , .BoxGameTheme.coolLightGreen, .BoxGameTheme.coolDarkerBlue]
    var colorsToUse = [UIColor]()
    
    func DrawBlocks(size: Int, enclosingView: UIView) -> [Block] {
        var blockArray = [Block()]
        localBlockRectsArray.removeAll()
        blockArray.removeAll()
        gameView = enclosingView
        viewSize = size
        colorsToUse = colorBox.shuffled()
        
        //populating positions array
        itemPositions = Array(repeating: Array(repeating: false, count: size), count: size)
        localBlockRectsArray = Array(repeating: Array(repeating: CGRect.zero, count: size), count: size)
        
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
                localBlockRectsArray[i][j] = rect
            }
        }
        
        return blockArray
    }
    
    
    @objc func tappedButton(sender: Block) {
        if !canAddToPosition(position: sender.position!) {
            return
        }
        
        let box = BlockBox(frame: sender.frame)
        let animation = growAnimation(view: box)
        
        if colorsToUse.isEmpty {
            colorsToUse = colorBox.shuffled()
        }
        box.backgroundColor = colorsToUse[0]
        colorsToUse.removeFirst()
        box.layer.cornerRadius = radiusSize
        box.position = sender.position
        box.layer.add(animation, forKey: nil)

        remainingManoeuvres -= 1
        
        gameView.addSubview(box)
        delegate?.updateView()
        
        
        let newPosition = dropBoxToPosition(box: box)
        let distance = newPosition.origin.y - box.frame.origin.y
        let duration = animationDuration(distance: distance, speed: 250)
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn) {
            box.frame = newPosition
        }
        
        if remainingManoeuvres <= 0 {
            finishGame()
        }
    }
    
     
    func finishGame() {
        
    }

    
    
    func dropBoxToPosition(box: BlockBox) -> CGRect {
        var hasLeft = true
        var hasRight = true
        if box.position![0] == 0 { hasLeft = false }
        if box.position![0] == (viewSize-1) { hasRight = false }
        
        //bottom check
        var isFinalPosition = false
        while !isFinalPosition {
            if box.position![1] >= (viewSize-1) {
                isFinalPosition = true
                itemPositions[box.position![0]][box.position![1]] = true
                return localBlockRectsArray[box.position![0]][box.position![1]]
            }
            
            
            if hasLeft && (itemPositions[box.position![0]-1][box.position![1]] == true) {
                if hasRight && (itemPositions[(box.position![0])+1][(box.position![1])] == true) {
                    itemPositions[box.position![0]][box.position![1]] = true
                    isFinalPosition = true
                    return localBlockRectsArray[box.position![0]][box.position![1]]
                }
            }
            
            if itemPositions[box.position![0]][box.position![1]+1] == true {
                itemPositions[box.position![0]][box.position![1]] = true
                isFinalPosition = true
                return localBlockRectsArray[box.position![0]][box.position![1]]
            } else {
                box.position = [box.position![0],box.position![1]+1]
            }
            
        }
        
        return localBlockRectsArray[box.position![0]][box.position![1]]
    }
    
    
    func canAddToPosition(position: [Int]) -> Bool {
        if remainingManoeuvres <= 0 { return false }
        let hasBox = itemPositions[position[0]][position[1]]
        if (hasBox == true) { return false }
        
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
    
    
    func animationDuration(distance: CGFloat, speed: Float ) -> TimeInterval {
        return TimeInterval(Float(distance) / speed)
    }
    
}
