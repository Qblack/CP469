//
//  GameMenuScene.swift
//  blac_a06
//
//  Created by Quinton Black on 2015-03-11.
//  Copyright (c) 2015 Quinton Black. All rights reserved.
//

import Foundation
import SpriteKit

class GameMenuScene : SKScene {
    
    
    var playButton: SKSpriteNode?
    var musicOffButton: SKSpriteNode?
    var musicOnButton: SKSpriteNode?
    var instructionButton: SKSpriteNode?
    
    
    override init(size: CGSize) {
        
        super.init(size: size)
        
        backgroundColor = SKColor.whiteColor()
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Super Mario Shooter"
        label.fontSize = 40
        label.fontColor = SKColor.blackColor()
        label.position = CGPoint(x: size.width/2, y: size.height/8*7)
        self.addChild(label)
        
        instructionButton = SKSpriteNode(imageNamed: "InstructionButton.png")
        instructionButton!.name="instructionButton"
        instructionButton!.position = CGPoint(x:CGRectGetMidX(self.frame), y:size.height/8*5);
        self.addChild(instructionButton!)
        
        playButton = SKSpriteNode(imageNamed: "PlayButton.png")
        playButton!.name="playButton"
        playButton!.position = CGPoint(x:CGRectGetMidX(self.frame), y:size.height/8*4);
        self.addChild(playButton!)
        
        musicOffButton = SKSpriteNode(imageNamed: "StopMusic.png")
        musicOffButton!.name="musicOffButton"
        musicOffButton!.position = CGPoint(x:CGRectGetMidX(self.frame), y:size.height/8*3);
        self.addChild(musicOffButton!)
        
        musicOnButton = SKSpriteNode(imageNamed: "PlayMusic.png")
        musicOnButton!.name="musicOnButton"
        musicOnButton!.position = CGPoint(x:CGRectGetMidX(self.frame), y:size.height/8*2);
        self.addChild(musicOnButton!)
    
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let theNode = self.nodeAtPoint(location)
            
            if theNode.name == playButton!.name {
                let touchScene = GameScene(size: self.size)
                let transition = SKTransition.crossFadeWithDuration(1)
                self.view?.presentScene(touchScene, transition: transition)

            } else if theNode.name == musicOffButton!.name{
           
                backgroundMusicPlayer.stop()
                
            }else if theNode.name == musicOnButton!.name{

                playBackgroundMusic("background-music-aac.caf")

            }else if theNode.name == instructionButton!.name{
                let noTouchScene = InstructionScene(size: self.size)
                let transition = SKTransition.flipHorizontalWithDuration(1)
                self.view?.presentScene(noTouchScene, transition: transition)
                
            }


        } // for touches
    } // touchesBegan

    
    
}
