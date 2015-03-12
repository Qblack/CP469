//
//  GameOverScene.swift
//  blac_a06
//
//  Created by Quinton Black on 2015-03-11.
//  Copyright (c) 2015 Quinton Black. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    
    init(size: CGSize, won:Bool, level: Int) {
        
        super.init(size: size)
        
        // 1
        backgroundColor = SKColor.whiteColor()
        
        // 2
        var message = won ? "You Won!" : "You Lose :["
        
        // 3
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.blackColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        // 4
        if(won&&level==1){
            runAction(SKAction.sequence([
                SKAction.waitForDuration(3.0),
                SKAction.runBlock() {
                    // 5
                    let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                    let scene = GameSceneLevel2(size: size)
                    self.view?.presentScene(scene, transition:reveal)
                }
                ]))

        }else{
            runAction(SKAction.sequence([
                SKAction.waitForDuration(3.0),
                SKAction.runBlock() {
                    // 5
                    let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                    let scene = GameMenuScene(size: size)
                    self.view?.presentScene(scene, transition:reveal)
                }
                ]))

        }
        
        
    }
    
    // 6
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}