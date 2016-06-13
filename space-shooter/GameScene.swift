//
//  GameScene.swift
//  space-shooter
//
//  Created by Abdul Abdulghafar on 2016-05-14.
//  Copyright (c) 2016 Abdulrahman Abdulghafar. All rights reserved.
//

import SpriteKit
import Foundation
import AVFoundation
import CoreData

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode = SKSpriteNode()
    var lastYieldTimeInterval:NSTimeInterval = NSTimeInterval()
    var lastUpdateTimerInterval:NSTimeInterval = NSTimeInterval()
    var meteorCategory:UInt32 = 0x1 << 1 // 2
    var playerCategory:UInt32 = 0x1 << 0 // 1
    var orbCategory:UInt32 = 0x1 << 2 // 3
    var scoreLabel = SKLabelNode()
    var highScoreLabel = SKLabelNode()
    let scoreLabelName = "scoreLabel"
    var score:Int = 0
    var pauseButton = SKLabelNode()
    var highscore: Int?
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let redFighterTexture = SKTexture(imageNamed: "redfighter")
    let moveRightTexture1 = SKTexture(imageNamed: "redfighter0006")
    let moveRightTexture2 = SKTexture(imageNamed: "redfighter0007")
    let moveRightTexture3 = SKTexture(imageNamed: "redfighter0008")
    let moveRightTexture4 = SKTexture(imageNamed: "redfighter0009")
    let moveLeftTexture1 = SKTexture(imageNamed: "redfighter0004")
    let moveLeftTexture2 = SKTexture(imageNamed: "redfighter0003")
    let moveLeftTexture3 = SKTexture(imageNamed: "redfighter0002")
    let moveLeftTexture4 = SKTexture(imageNamed: "redfighter0001")

    
    
    override func didMoveToView(view: SKView) {
        
        if userDefaults.valueForKey("highscore") != nil {
            highscore = userDefaults.valueForKey("highscore") as? Int
            print(highscore)
        }
        else {
            // no highscore exists
            highscore = 0
        }
        
        
        scoreLabel.text = String(score)
        scoreLabel.fontSize = 30
        scoreLabel.position = CGPoint(x: 30, y:CGRectGetHeight(self.frame) - 50)
        highScoreLabel.text = String(highscore!)
        highScoreLabel.fontSize = 30
        highScoreLabel.position = CGPoint(x: CGRectGetWidth(self.frame) - 30, y:CGRectGetHeight(self.frame) - 50)
        self.addChild(scoreLabel)
        self.addChild(highScoreLabel)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        animateBackground()
        
        
        player = SKSpriteNode(texture: redFighterTexture )
        player.position = CGPointMake(self.frame.size.width/2, scene!.frame.size.height/6)
        let playerScale = scene!.frame.size.width/1200
        player.xScale = playerScale
        player.yScale = playerScale
        
        let orbSpawnTime:NSTimeInterval = 2
        self.addChild(player)
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        var orbTimer = NSTimer.scheduledTimerWithTimeInterval(orbSpawnTime, target: self, selector: Selector("addOrb"), userInfo: nil, repeats: true)


    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
//        super.init(coder: aDecoder)
    }
    
    func spawnFallingItems() {
        
        var meteor:SKSpriteNode = SKSpriteNode(imageNamed: "1")
        meteor.xScale = 0.7
        meteor.yScale = 0.7
        meteor.physicsBody = SKPhysicsBody(circleOfRadius: meteor.size.width/4)
        meteor.physicsBody?.dynamic = true
        meteor.physicsBody?.categoryBitMask = meteorCategory
        meteor.physicsBody?.contactTestBitMask  = playerCategory
        meteor.physicsBody?.collisionBitMask = 0
        
        let minX = meteor.size.width/2
        let maxX = self.frame.size.width - meteor.size.width/2
        let rangeX = maxX - minX
        let meteorPositionInX:CGFloat = CGFloat(arc4random_uniform(UInt32(maxX))) + minX
        
        
        meteor.position = CGPointMake(meteorPositionInX, self.frame.size.height + meteor.size.height)
        
        self.addChild(meteor)

        let maxDuration = 3
        let duration = arc4random_uniform(UInt32(maxDuration)) + 2
        
        let actionArray:NSMutableArray = NSMutableArray()
        actionArray.addObject(SKAction.moveTo(CGPointMake(meteorPositionInX, -meteor.size.height), duration: NSTimeInterval(duration)))
        actionArray.addObject(SKAction.removeFromParent())
        meteor.runAction(SKAction.sequence(actionArray as [AnyObject] as! [SKAction]))
        
        let rotateAction = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        meteor.runAction(SKAction.repeatActionForever(rotateAction))
        
    
    }
    
    
    func addOrb(){
        let orb:SKSpriteNode = SKSpriteNode(imageNamed: "litOrb")
        orb.xScale = 0.6
        orb.yScale = 0.6
        orb.physicsBody = SKPhysicsBody(circleOfRadius: orb.size.width/2)
        orb.physicsBody?.dynamic = true
        orb.physicsBody?.categoryBitMask = orbCategory //3
        orb.physicsBody?.contactTestBitMask = playerCategory
        orb.physicsBody!.collisionBitMask = 0
        let minX = orb.size.width * 2
        let maxX = self.frame.size.width - orb.size.width * 2
        let xRange = maxX - minX
        let orbPositionInX:CGFloat = minX + CGFloat(arc4random_uniform(200)) % CGFloat(xRange)
        orb.position = CGPointMake(orbPositionInX, self.frame.size.height + orb.size.height)
        self.addChild(orb)
        
        let maxDuration = 5
        let duration =  arc4random_uniform(UInt32(maxDuration)) + 2
        
        var orbActionArray:NSMutableArray = NSMutableArray()
        orbActionArray.addObject(SKAction.moveTo(CGPointMake(orbPositionInX, -orb.size.height), duration: NSTimeInterval(duration)))
        orbActionArray.addObject(SKAction.removeFromParent())
        
        orb.runAction(SKAction.sequence(orbActionArray as [AnyObject] as! [SKAction]))
        
        let rotateAction = SKAction.rotateByAngle(CGFloat(M_PI), duration:1.2)
        orb.runAction(SKAction.repeatActionForever(rotateAction))

    }
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate:CFTimeInterval){
        lastYieldTimeInterval += timeSinceLastUpdate
        if (lastYieldTimeInterval > 1) {
            lastYieldTimeInterval = 0
            spawnFallingItems()
        }
    }
    
    override func update(currentTime:CFTimeInterval) {
        var timeSinceLastUpdate = currentTime - lastUpdateTimerInterval
        lastUpdateTimerInterval = currentTime
        if (timeSinceLastUpdate > 1) {
            timeSinceLastUpdate = 1/60
            lastUpdateTimerInterval = currentTime
        }
        
        updateWithTimeSinceLastUpdate(timeSinceLastUpdate)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in (touches ) {
            let newLocation = touch.locationInNode(self)
            //self.player.position = newLocation
            let velocity = 570
            let currentLocationOfShip:CGPoint = player.position
            let displacmentVector:CGPoint = subtractVectors(newLocation, b: currentLocationOfShip)
            let displacment = vectorLength(displacmentVector)
            print(normalizeVector(displacmentVector))
            let time:NSTimeInterval = NSTimeInterval(displacment / CGFloat(velocity))
            let moveTo = SKAction.moveTo(newLocation, duration: time)
            //print(displacmentVector)
            
            //Ship is moving straight
            if displacmentVector.x <= 10 && displacmentVector.x >= -10 {
                self.player.runAction(moveTo)
            }
            //ship is moving to the right
            else if newLocation.x > currentLocationOfShip.x {
                let moveRightAnimation = SKAction.animateWithTextures([moveRightTexture1,moveRightTexture2,moveRightTexture3,moveRightTexture4,redFighterTexture], timePerFrame: 0.08)
                self.player.runAction(moveRightAnimation)
                self.player.runAction(moveTo)
            }
            //ship is moving to the left
            else if newLocation.x < currentLocationOfShip.x {
                let moveLeftAnimation = SKAction.animateWithTextures([moveLeftTexture1,moveLeftTexture2,moveLeftTexture3,moveLeftTexture4,redFighterTexture], timePerFrame: 0.08)
                self.player.runAction(moveLeftAnimation)
                self.player.runAction(moveTo)
            }
            
            player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/3)
            player.physicsBody!.dynamic = true
            player.physicsBody!.categoryBitMask = playerCategory
            player.physicsBody!.contactTestBitMask = meteorCategory
            player.physicsBody!.collisionBitMask = 0
            player.physicsBody!.usesPreciseCollisionDetection = true
            
            player.physicsBody!.contactTestBitMask = meteorCategory
            player.physicsBody!.collisionBitMask = 0
            
    
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        let player = contact.bodyA.categoryBitMask == 1 ? contact.bodyA : contact.bodyB
        let otherObject = player == contact.bodyA ? contact.bodyB : contact.bodyA
        
         if otherObject.categoryBitMask == orbCategory { //player collided with an orb
            collidedWithAnOrb(otherObject.node as! SKSpriteNode)
        }
        
         else { //player must have collided with a meteor
            collidedWithAMeteor(otherObject.node as! SKSpriteNode)
        }

    }
    func collidedWithAnOrb(orb: SKSpriteNode) {
        
        self.runAction(SKAction.playSoundFileNamed("orb.mp3", waitForCompletion: false))
        
        orb.removeFromParent()
        score++
        scoreLabel.text = String(score)
    }
    
    func collidedWithAMeteor(meteor: SKSpriteNode){
        
        if score > highscore {
            userDefaults.setValue(score, forKey: "highscore")
            userDefaults.synchronize()
            print("collided: score > highscore so new highscore is \(score)")
        }
        
        let transition:SKTransition = SKTransition.flipHorizontalWithDuration(0.5)
        let gameOverScene:SKScene = GameOverScene(size: self.size, score: score)
        self.view?.presentScene(gameOverScene, transition: transition)
    }
    
    func addVectors(a:CGPoint,b:CGPoint) -> CGPoint{
        return CGPoint(x: a.x + b.x, y: a.y + b.y)
    }
    
    func subtractVectors(a: CGPoint, b:CGPoint) -> CGPoint{
        return CGPoint(x: a.x - b.x, y: a.y - b.y)
    }
    
    func vectorByScalarMultiplication (a: CGPoint, k: CGFloat) ->CGPoint {
        return CGPoint(x: a.x * k, y: a.y * k)
    }
    
    func vectorLength(a: CGPoint) -> CGFloat {
        return CGFloat(sqrt(CGFloat(a.x * a.x) + CGFloat(a.y * a.y)))
    }
    func normalizeVector(a: CGPoint) -> CGPoint {
        let length: CGFloat = vectorLength(a)
        return CGPointMake(a.x / length, a.y/length)
    }
    
    func animateBackground() {
        let randomBackground = "dark"
        let bgTexture = SKTexture(imageNamed: "bg\(randomBackground).jpg")
        
        let movebg = SKAction.moveByX(0, y: -bgTexture.size().height, duration: 9)
        let replacebg = SKAction.moveByX(0, y: bgTexture.size().height, duration: 0)
        let movebgForever = SKAction.repeatActionForever(SKAction.sequence([movebg, replacebg]))
        
        for var i:CGFloat=0; i<3; i++ {
            let bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: CGRectGetMidX(self.frame), y: bgTexture.size().height/2 + bgTexture.size().height * i)
            bg.size.height = self.frame.height
            bg.runAction(movebgForever)
            self.addChild(bg)
        }
        
    }
    
//
//    override func update(currentTime: CFTimeInterval) {
//        /* Called before each frame is rendered */
//    }
}
