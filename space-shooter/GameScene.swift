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

public let userDefaults = NSUserDefaults.standardUserDefaults()
public var highscore: Int?
public var orbCount: Int?
public let reviveCost = 5

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode = SKSpriteNode()
    var lastYieldTimeInterval:NSTimeInterval = NSTimeInterval()
    var lastUpdateTimerInterval:NSTimeInterval = NSTimeInterval()
    var meteorCategory:UInt32 = 0x1 << 1 // 2
    var playerCategory:UInt32 = 0x1 << 0 // 1
    var orbCategory:UInt32 = 0x1 << 2 // 3
    var scoreLabel = SKLabelNode(fontNamed: "TimeBurner")
    var orbCountLabel = SKLabelNode(fontNamed: "TimeBurner")
    let orbImage = SKSpriteNode(imageNamed: "litOrb")
    var highScoreLabel = SKLabelNode()
    let scoreLabelName = "scoreLabel"
    var score:Int = 0
    var orbSound:SKAction?
    var maxMeteorDuration = 3.0
    var minMeteorDuration = 2.0
    var revivePromptLabel = SKLabelNode(fontNamed: "TimeBurner-Bold")
    var yesLabel = SKLabelNode(fontNamed: "TimeBurner-Bold")
    var noLabel = SKLabelNode(fontNamed: "TimeBurner-Bold")
    var modal = SKShapeNode(path: CGPathCreateWithRoundedRect(CGRectMake(-160, -75, 320, 150), 40, 40, nil))
//    let redExplosion1 = SKTextureAtlas
//    let destroyAnimation = SKAction.animateWithTextures([moveRightTexture1,moveRightTexture2,moveRightTexture3,moveRightTexture4,redFighterTexture], timePerFrame: 0.08)

    
    
    override func didMoveToView(view: SKView) {
        styleLabels()

        self.addChild(scoreLabel)
        self.addChild(orbCountLabel)
        self.addChild(orbImage)
        highscore = userDefaults.valueForKey("highscore") != nil ? userDefaults.valueForKey("highscore") as? Int : 0
        //self.addChild(highScoreLabel)
    }
    
    func styleLabels(){
        let orbColor = UIColor.init(red: 212/255, green: 175/255, blue: 55/255 , alpha: 1)
        let orbScale = scene!.frame.size.width/620
        
        scoreLabel.text = "SCORE: \(score)"
        scoreLabel.fontSize = 25
        scoreLabel.fontColor = orbColor
        scoreLabel.position = CGPoint(x: 55, y:CGRectGetHeight(self.frame) - 50)
        
        highScoreLabel.text = String(highscore!)
        highScoreLabel.fontSize = 30
        highScoreLabel.position = CGPoint(x: CGRectGetWidth(self.frame) - 30, y:CGRectGetHeight(self.frame) - 50)
        
        orbCountLabel.text = String(orbCount!)
        orbCountLabel.fontSize = 26
        orbCountLabel.fontColor = orbColor
        orbCountLabel.position = CGPoint(x: CGRectGetWidth(self.frame) - 60, y:CGRectGetHeight(self.frame) - 50)
        orbImage.position = CGPoint(x: orbCountLabel.position.x + 40, y: orbCountLabel.position.y + 14)
        orbImage.xScale = orbScale
        orbImage.yScale = orbScale
        
        revivePromptLabel.text = "Spend \(reviveCost) orbs to keep going?"
        revivePromptLabel.fontSize = 22
        revivePromptLabel.fontColor = orbColor
        revivePromptLabel.position = CGPointMake(self.frame.midX, self.frame.midY + 80)
        
        yesLabel.text = "Yes!"
        yesLabel.fontSize = 25
        yesLabel.fontColor = SKColor.greenColor()
        yesLabel.position = CGPointMake(self.frame.midX - 100, self.frame.midY)
        
        noLabel.text = "Nah"
        noLabel.fontSize = 25
        noLabel.fontColor = SKColor.redColor()
        noLabel.position = CGPointMake(self.frame.midX + 100, self.frame.midY)
        
        modal.fillColor = SKColor.whiteColor()
        modal.position = CGPointMake(self.frame.midX, self.frame.midY + 60)
        modal.alpha = 0.3
        
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        animateBackground()
        
        
        player = SKSpriteNode(texture: redFighterTexture )
        player.name = "player"
        player.position = CGPointMake(self.frame.size.width/2, scene!.frame.size.height/6)
        let playerScale = scene!.frame.size.width/1200
        player.xScale = playerScale
        player.yScale = playerScale
        self.addChild(player)
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        let wait = SKAction.waitForDuration(2)
        let spawnOrb = SKAction.runBlock {
            self.addOrb()
        }
        self.runAction(SKAction.sequence([wait, spawnOrb]))
        
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([wait, spawnOrb])))
        orbSound = SKAction.playSoundFileNamed("orb.mp3", waitForCompletion: false)
        
        
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
//        super.init(coder: aDecoder)
    }
    
    func spawnFallingItems() {
        let randomMeteor = arc4random_uniform(UInt32(3)) + 1
        var meteor:SKSpriteNode = SKSpriteNode(imageNamed: "greymeteor\(randomMeteor)")
        meteor.name = "meteor"
        let scaleFactor = ( 100 * CGFloat(arc4random_uniform(UInt32(3)) + 3) )
        let meteorScale = scene!.frame.size.width / scaleFactor
        meteor.xScale = meteorScale
        meteor.yScale = meteorScale
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

        let duration = Double(arc4random_uniform(UInt32(maxMeteorDuration))) + minMeteorDuration
        
        let actionArray:NSMutableArray = NSMutableArray()
        actionArray.addObject(SKAction.moveTo(CGPointMake(meteorPositionInX, -meteor.size.height), duration: NSTimeInterval(duration)))
        actionArray.addObject(SKAction.removeFromParent())
        meteor.runAction(SKAction.sequence(actionArray as [AnyObject] as! [SKAction]))
        
        let rotateAction = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        meteor.runAction(SKAction.repeatActionForever(rotateAction))
    
    }
    
    func difficultyCheck(){
        if score % 10 == 0 {
            if minMeteorDuration >= 0.8{
                maxMeteorDuration -= 0.15
                minMeteorDuration -= 0.15
            }
        }
    }

    
    
    func addOrb(){
        let orb:SKSpriteNode = SKSpriteNode(imageNamed: "litOrb")
        let orbScale = scene!.frame.size.width/650
        orb.xScale = orbScale
        orb.yScale = orbScale
        orb.physicsBody = SKPhysicsBody(circleOfRadius: orb.size.width/2)
        orb.physicsBody?.dynamic = true
        orb.physicsBody?.categoryBitMask = orbCategory
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
            player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/3)
            player.physicsBody!.dynamic = true
            player.physicsBody!.categoryBitMask = playerCategory
            player.physicsBody!.contactTestBitMask = meteorCategory
            player.physicsBody!.collisionBitMask = 0
            player.physicsBody!.usesPreciseCollisionDetection = true
            
            player.physicsBody!.contactTestBitMask = meteorCategory
            player.physicsBody!.collisionBitMask = 0
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in (touches) {
            let newLocation = touch.locationInNode(self)
            let velocity = 570
            let currentLocationOfShip:CGPoint = player.position
            let displacmentVector:CGPoint = subtractVectors(newLocation, b: currentLocationOfShip)
            let displacment = vectorLength(displacmentVector)
            let time:NSTimeInterval = NSTimeInterval(displacment / CGFloat(velocity))
            let moveTo = SKAction.moveTo(newLocation, duration: time)
            let node = self.nodeAtPoint(newLocation)
            
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
            
            // User has agreed to spend orbs to be revived
            if node == yesLabel {
                orbCount! -= reviveCost
                userDefaults.setValue(orbCount, forKey: "orbs")
                userDefaults.synchronize()
                orbCountLabel.text = String(orbCount!)
                clearScreenAfterRevivePrompt()
                self.scene!.view?.paused = false
                
            }
            if node == noLabel {
                endGame()
                self.removeChildrenInArray([modal,revivePromptLabel,yesLabel,noLabel])
                self.scene!.view?.paused = false
            }

        }
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
        
        self.runAction(orbSound!)//SKAction.playSoundFileNamed("orb.mp3", waitForCompletion: false))
        
        orb.removeFromParent()
        score++
        orbCount!++
        scoreLabel.text = "SCORE: \(score)"
        orbCountLabel.text = String(orbCount!)
        difficultyCheck()
        userDefaults.setValue(orbCount, forKey: "orbs")
        userDefaults.synchronize()
    }
    
    func collidedWithAMeteor(meteor: SKSpriteNode){
        
        // If the user can't afford to revive dont prompt them to
        if !userCanRevive() {
            endGame()
        }
        else {
            self.scene!.view?.paused = true
            promptUserToRevive()
        }
        
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
        
        let movebg = SKAction.moveByX(0, y: -bgTexture.size().height, duration: minMeteorDuration*4)
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
    
    func userCanRevive() -> Bool{
        return orbCount! >= reviveCost ? true : false
    }

    
    
    func promptUserToRevive() {
        self.addChild(modal)
        self.addChild(revivePromptLabel)
        self.addChild(yesLabel)
        self.addChild(noLabel)
    }
    
    func clearScreenAfterRevivePrompt() {
        self.removeChildrenInArray([modal,revivePromptLabel,yesLabel,noLabel])
        
        self.enumerateChildNodesWithName("meteor"){ node , stop in
            
            self.destroyNode(node)
        }
    }
    
    func endGame() {
        let transition:SKTransition = SKTransition.flipHorizontalWithDuration(0.5)
        let gameOverScene:SKScene = GameOverScene(size: self.size, score: score)
        let waitForAnimation = SKAction.waitForDuration(0.5)
        
        if score > highscore {
            userDefaults.setValue(score, forKey: "highscore")
            userDefaults.synchronize()
            //print("collided: score > highscore so new highscore is \(score)")
        }
        
        destroyNode(player)
        self.runAction(waitForAnimation) { 
            self.view?.presentScene(gameOverScene, transition: transition)
        }
        
        
        
    }
    
    func destroyNode(nodeToDestroy: SKNode) {
        let remove = SKAction.removeFromParent()
        nodeToDestroy.runAction(remove)
        explosion(nodeToDestroy.position)
    }
    
    func explosion(pos: CGPoint) {
        var emitterNode = SKEmitterNode(fileNamed: "explosion.sks")
        emitterNode!.particlePosition = pos
        self.addChild(emitterNode!)
        // Don't forget to remove the emitter node after the explosion
        self.runAction(SKAction.waitForDuration(2), completion: { emitterNode!.removeFromParent() })
        
    }

    
//
//    override func update(currentTime: CFTimeInterval) {
//        /* Called before each frame is rendered */
//    }
}
