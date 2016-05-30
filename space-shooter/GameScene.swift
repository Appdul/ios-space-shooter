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
    //var meteorsMissed:Int = 0
    var meteorCategory:UInt32 = 0x1 << 1 // 2
    var playerCategory:UInt32 = 0x1 << 0 // 1
    var orbCategory:UInt32 = 0x1 << 2 // 3
    var scoreLabel = SKLabelNode()
    let scoreLabelName = "scoreLabel"
    var score:Int = 0
    var pauseButton = SKLabelNode()
    var highscore = 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        fetch()
        pauseButton.text = "Pause"
        pauseButton.fontSize = 25
        pauseButton.position = CGPoint(x: CGRectGetWidth(self.frame) - 50, y:CGRectGetHeight(self.frame) - 50);
        self.addChild(pauseButton)
        
        
        scoreLabel.text = String(score)
        scoreLabel.fontSize = 30
        scoreLabel.position = CGPoint(x: 30, y:CGRectGetHeight(self.frame) - 50)
        
        self.addChild(scoreLabel)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        animateBackground()
        
        player = SKSpriteNode(imageNamed: "Spaceship")
        player.position = CGPointMake(self.frame.size.width/2, scene!.frame.size.height/6)
        player.xScale = 0.25
        player.yScale = 0.25
        
        let orbSpawnTime:NSTimeInterval = 2
        self.addChild(player)
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        var orbTimer = NSTimer.scheduledTimerWithTimeInterval(orbSpawnTime, target: self, selector: Selector("addOrb"), userInfo: nil, repeats: true)


    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let meteorPositionInX:CGFloat = CGFloat(arc4random()) % CGFloat(maxX)
        
        
        meteor.position = CGPointMake(meteorPositionInX, self.frame.size.height + meteor.size.height)
        
        self.addChild(meteor)
        
        let minDuration = 2
        let maxDuration = 4
        let rangeDuratiion = maxDuration -  minDuration
        let duration = Int(arc4random()) % Int(rangeDuratiion) + Int(minDuration)
        
        var actionArray:NSMutableArray = NSMutableArray()
        actionArray.addObject(SKAction.moveTo(CGPointMake(meteorPositionInX, -meteor.size.height), duration: NSTimeInterval(duration)))
        actionArray.addObject(SKAction.removeFromParent())
        meteor.runAction(SKAction.sequence(actionArray as [AnyObject] as! [SKAction]))
        
        let rotateAction = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        meteor.runAction(SKAction.repeatActionForever(rotateAction))
        
    
    }
    
    
    func addOrb(){
        var orb:SKSpriteNode = SKSpriteNode(imageNamed: "litOrb")
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
        let orbPositionInX:CGFloat = minX + CGFloat(arc4random()) % CGFloat(xRange)
        orb.position = CGPointMake(orbPositionInX, self.frame.size.height + orb.size.height)
        self.addChild(orb)
        
        let minDuration = 5
        let maxDuration = 8
        let rangeDuration = maxDuration -  minDuration
        let duration = Int(arc4random()) % Int(rangeDuration) + Int(minDuration)
        
        var orbActionArray:NSMutableArray = NSMutableArray()
        orbActionArray.addObject(SKAction.moveTo(CGPointMake(orbPositionInX, -orb.size.height), duration: NSTimeInterval(duration)))
        orbActionArray.addObject(SKAction.removeFromParent())
        
        orb.runAction(SKAction.sequence(orbActionArray as [AnyObject] as! [SKAction]))


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
            let time:NSTimeInterval = NSTimeInterval(displacment / CGFloat(velocity))
            let moveTo = SKAction.moveTo(newLocation, duration: time)
            self.player.runAction(moveTo)
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
        //self.runAction(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
//        var touch:UITouch = touches.first as! UITouch
//        var location:CGPoint = touch.locationInNode(self)
//        var torpedo:SKSpriteNode = SKSpriteNode(imageNamed: "torpedo")
//        torpedo.position = player.position
//        torpedo.physicsBody = SKPhysicsBody(circleOfRadius: torpedo.size.width/2)
//        torpedo.physicsBody!.dynamic = true
//        
//        torpedo.physicsBody!.categoryBitMask = photonTorpedoCategory
//        torpedo.physicsBody!.contactTestBitMask = alienCategory
//        torpedo.physicsBody!.collisionBitMask = 0
//        torpedo.physicsBody!.usesPreciseCollisionDetection = true
//        
//        var offSet:CGPoint = subtractVectors(location, b: torpedo.position)
        
        
        // dont allow users to shoot backwards
//        if (offSet.y < 0){
//            return
//        }
//        
//        self.addChild(torpedo)
//        
//        // Whre to shoot?
//        var direction:CGPoint = normalizeVector(offSet)
//        
//        // Shoot off screen
//        var shotLength:CGPoint = vectorByScalarMultiplication(direction, k: 3000)
//        
//        // Add Length to current position
//        var finalDestination:CGPoint = addVectors(shotLength, b: torpedo.position)
//        
//        // create action
//        let velocity = 570/1
//        let moveDuration:Float = Float(self.size.width) / Float(velocity)
//        
//        var actionArray:NSMutableArray = NSMutableArray()
//        actionArray.addObject(SKAction.moveTo(finalDestination, duration: NSTimeInterval(moveDuration)))
//        actionArray.addObject(SKAction.removeFromParent())
//        
        //torpedo.runAction(SKAction.sequence(actionArray as [AnyObject]))

        
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
        
        if score > highscore { seedScore() }
        
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
        let bgTexture = SKTexture(imageNamed: "6.jpg") //TODO: Optimize textures using imageoptim
        
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
    
    func seedScore() {
        
        // create an instance of our managedObjectContext
        let moc = DataController().managedObjectContext
        
        // we set up our entity by selecting the entity and context that we're targeting
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: moc) as! Score
        
        // add our data
        entity.setValue(score, forKey: "highScore")
        
        // we save our entity
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func fetch() {
        let moc = DataController().managedObjectContext
        let highScoreFetch = NSFetchRequest(entityName: "Score")
        
        do {
            let fetchedHighScore = try moc.executeFetchRequest(highScoreFetch) as! [Score]
            print(fetchedHighScore.first!.highScore!)
            highscore = fetchedHighScore.first!.highScore! as Int
            
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
        
        
    }
    
    
//    func storeHighScore() {
//        
//    }
//
//    override func update(currentTime: CFTimeInterval) {
//        /* Called before each frame is rendered */
//    }
}
