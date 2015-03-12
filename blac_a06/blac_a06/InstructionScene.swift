//
//  InstructionScene.swift
//  blac_a06
//
//  Created by Quinton Black on 2015-03-11.
//  Copyright (c) 2015 Quinton Black. All rights reserved.
//

import Foundation
import SpriteKit


class InstructionScene: SKScene {
    
    var backButton : SKSpriteNode!

    
    override init(size: CGSize) {
        super.init(size: size)
  
        backgroundColor = SKColor.whiteColor()
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Level 1 kill three goombas."
        label.fontSize = 20
        label.fontColor = SKColor.blackColor()
        label.position = CGPoint(x: size.width/2, y: size.height/8*7)
        addChild(label)

        let label2 = SKLabelNode(fontNamed: "Chalkduster")
        label2.text = "Level 2 dodge thomps and kill 10 goombas."
        label2.fontSize = 20
        label2.fontColor = SKColor.blackColor()
        label2.position = CGPoint(x: size.width/2, y: size.height/8*5)
        addChild(label2)

        let labelF = SKLabelNode(fontNamed: "Chalkduster")
        labelF.text = "Dont let any get past you."
        labelF.fontSize = 20
        labelF.fontColor = SKColor.blackColor()
        labelF.position = CGPoint(x: size.width/2, y: size.height/8*3)
        addChild(labelF)
        
        backButton = SKSpriteNode(imageNamed: "goBack.png")
        backButton!.name="backButton"
        backButton!.position = CGPoint(x:CGRectGetMidX(self.frame), y:size.height/8*2);
        self.addChild(backButton!)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let theNode = self.nodeAtPoint(location)
            
            if theNode.name == backButton!.name {
                let touchScene = GameMenuScene(size: self.size  )
                let transition = SKTransition.crossFadeWithDuration(1)
                self.view?.presentScene(touchScene, transition: transition)
            }
            
        } // for touches
    } // touchesBegan

    // 6
  
}