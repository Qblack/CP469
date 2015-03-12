//
//  GameSceneLevel2.swift
//  blac_a06
//
//  Created by Quinton Black on 2015-03-11.
//  Copyright (c) 2015 Quinton Black. All rights reserved.
//

//
import SpriteKit

class GameSceneLevel2: SKScene, SKPhysicsContactDelegate {
    
    var monstersDestroyed = 0
    var borderBody: SKPhysicsBody?

    
    
    
    // 1
    let player = SKSpriteNode(imageNamed: "player")
    
    
    override func didMoveToView(view: SKView) {
        // 2
        backgroundColor = SKColor.whiteColor()
        self.physicsWorld.gravity = CGVectorMake(0.0, -9.8);
        
        //Ground Setup
        self.physicsBody = SKPhysicsBody(edgeFromPoint: CGPointMake(0.0, 0.0), toPoint: CGPointMake(size.width, 0.0))
        self.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        self.physicsBody?.affectedByGravity = false;

        
        // 3
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        player.name = "mario"
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Thwomp | PhysicsCategory.Monster
        player.physicsBody?.affectedByGravity = false;
        player.physicsBody?.mass=0.0
        player.physicsBody?.dynamic = false

        // 4
        addChild(player)
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addMonster),
                SKAction.waitForDuration(1.0),
                ])
            ))
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addThwomp),
                SKAction.waitForDuration(2.0),

                ])
            ))
   
        
        physicsWorld.contactDelegate = self
        
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addMonster() {
        
        // Create sprite
        let monster = SKSpriteNode(imageNamed: "monster")
        
        monster.physicsBody = SKPhysicsBody(rectangleOfSize: monster.size) // 1
        monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster // 3
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile // 4
        monster.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
        monster.physicsBody?.mass = 0.0
        monster.physicsBody?.affectedByGravity = false
        monster.physicsBody?.dynamic = true;
        
        
        // Determine where to spawn the monster along the Y axis
        let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
        
        // Add the monster to the scene
        addChild(monster)
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.moveTo(CGPoint(x: -monster.size.width/2, y: actualY), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        let loseAction = SKAction.runBlock() {
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false, level:2)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        monster.runAction(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
    }
    
    func addThwomp(){
        let thwomp = SKSpriteNode(imageNamed: "thwomp")
        
        thwomp.physicsBody = SKPhysicsBody(rectangleOfSize: thwomp.size) // 1
        
        // Determine where to spawn the TWOMP along the X axis
        let actualX = random(min: thwomp.size.width/2, max: size.width - thwomp.size.width/2)
        
        thwomp.position = CGPoint(x: actualX , y: size.height - thwomp.size.height)
        thwomp.physicsBody = SKPhysicsBody(rectangleOfSize: thwomp.size) // define boundary of body
        thwomp.physicsBody?.dynamic = true
        thwomp.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile | PhysicsCategory.Monster | PhysicsCategory.Player
        thwomp.physicsBody?.categoryBitMask = PhysicsCategory.Thwomp //
        thwomp.physicsBody?.collisionBitMask = PhysicsCategory.Ground // Bouncing on collision with ground
        
        thwomp.physicsBody?.friction = 0
        thwomp.physicsBody?.restitution = 0
        thwomp.physicsBody?.linearDamping = 0
        thwomp.physicsBody?.allowsRotation = false
        thwomp.physicsBody?.mass = 1.0
        
        addChild(thwomp)


    }
    
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)
        let theNode = self.nodeAtPoint(touchLocation)
        if( theNode.name == "mario"){
            let actionMove = SKAction.moveTo(touchLocation, duration: 0.1)
            player.runAction(SKAction.sequence([actionMove]))
        }
        
        
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        // 1 - Choose one of the touches to work with
        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)
        
        // 2 - Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.dynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster | PhysicsCategory.Thwomp
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        projectile.physicsBody?.affectedByGravity = false
        
        projectile.position = player.position
        projectile.position.x = projectile.position.x + 16.0
        
        
        // 3 - Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        // 4 - Bail out if you are shooting down or backwards
        if (offset.x < 0) { return }
        
        // 5 - OK to add now - you've double checked position
        addChild(projectile)
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // 9 - Create the actions
        let actionMove = SKAction.moveTo(realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        runAction(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
        
    }
    
    func projectileDidCollideWithMonster(projectile:SKSpriteNode, monster:SKSpriteNode) {
        projectile.removeFromParent()
        monster.removeFromParent()
        monstersDestroyed++
        if (monstersDestroyed >= 10) {
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true, level:2)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    func projectileDidCollideWithThwomp(projectile:SKSpriteNode, thwomp:SKSpriteNode) {
        projectile.removeFromParent()
        thwomp.removeFromParent()
    }
    
    func monsterDidCollideWithThwomp(monster: SKSpriteNode, thwomp:SKSpriteNode){
            //This was shown in class but i dont remember what was supposed to happen if the rock was on the ground.
        monster.removeFromParent()
    }
    
    func nonProjectileDidCollideWithPlayer(item:SKSpriteNode, player:SKSpriteNode) {
        item.removeFromParent()
        player.removeFromParent()
        
        runAction(SKAction.sequence([
                SKAction.playSoundFileNamed("scream.mp3", waitForCompletion: false),
                SKAction.waitForDuration(2.0),
            ]), completion: {
                    let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                    let gameOverScene = GameOverScene(size: self.size, won: false, level:2)
                    self.view?.presentScene(gameOverScene, transition: reveal)
            })
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
                projectileDidCollideWithMonster(firstBody.node as SKSpriteNode, monster: secondBody.node as SKSpriteNode)
        }else if((firstBody.categoryBitMask & PhysicsCategory.Thwomp != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
                projectileDidCollideWithThwomp(firstBody.node as SKSpriteNode, thwomp: secondBody.node as SKSpriteNode)
        }else if((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Thwomp != 0)) {
                monsterDidCollideWithThwomp(firstBody.node as SKSpriteNode, thwomp: secondBody.node as SKSpriteNode)
        }else if((firstBody.categoryBitMask & PhysicsCategory.Player != 0) &&
            ((secondBody.categoryBitMask & PhysicsCategory.Monster != 0) || (secondBody.categoryBitMask & PhysicsCategory.Thwomp != 0))) {
                nonProjectileDidCollideWithPlayer(firstBody.node as SKSpriteNode, player: secondBody.node as SKSpriteNode)
        }

        
    }
    
    
}

