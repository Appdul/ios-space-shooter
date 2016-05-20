//
//  GameScene.swift
//  space-shooter
//
//  Created by Abdul Abdulghafar on 2016-05-14.
//  Copyright (c) 2016 Abdulrahman Abdulghafar. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode = SKSpriteNode()
    var lastYieldTimeInterval:NSTimeInterval = NSTimeInterval()
    var lastUpdateTimerInterval:NSTimeInterval = NSTimeInterval()
    var aliensDestroyed:Int = 0
    var alienCategory:UInt32 = 0x1 << 1
    var photonTorpedoCategory:UInt32 = 0x1 << 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!";
//        myLabel.fontSize = 65;
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
//        
//        self.addChild(myLabel)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = SKColor.blackColor()
        player = SKSpriteNode(imageNamed: "Spaceship")
        player.position = CGPointMake(self.frame.size.width/2, scene!.frame.size.height/6)
        player.xScale = 0.25
        player.yScale = 0.25
        
        
        self.addChild(player)
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        


    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAlien() {
        
        var alien:SKSpriteNode = SKSpriteNode(imageNamed: "1")
        alien.xScale = 0.7
        alien.yScale = 0.7
        alien.physicsBody = SKPhysicsBody(rectangleOfSize: alien.size)
        alien.physicsBody?.dynamic = true
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask  = photonTorpedoCategory
        alien.physicsBody?.collisionBitMask = 0
        
        let minX = alien.size.width/2
        let maxX = self.frame.size.width - alien.size.width/2
        let rangeX = maxX - minX
        let position:CGFloat = CGFloat(arc4random()) % CGFloat(maxX)
        
        alien.position = CGPointMake(position, self.frame.size.height + alien.size.height)
        self.addChild(alien)
        
        let minDuration = 2
        let maxDuration = 4
        let rangeDuratiion = maxDuration -  minDuration
        let duration = Int(arc4random()) % Int(rangeDuratiion) + Int(minDuration)
        
        var actionArray:NSMutableArray = NSMutableArray()
        actionArray.addObject(SKAction.moveTo(CGPointMake(position, -alien.size.height), duration: NSTimeInterval(duration)))
        actionArray.addObject(SKAction.removeFromParent())
        
        alien.runAction(SKAction.sequence(actionArray as [AnyObject]))
        
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        alien.runAction(SKAction.repeatActionForever(action))
    
    }
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate:CFTimeInterval){
        lastYieldTimeInterval += timeSinceLastUpdate
        if (lastYieldTimeInterval > 1) {
            lastYieldTimeInterval = 0
            addAlien()
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let newLocation = touch.locationInNode(self)
            //self.player.position = newLocation
            let velocity = 10
            let currentLocationOfShip:CGPoint = player.position
            let displacmentVector:CGPoint = subtractVectors(newLocation, b: currentLocationOfShip)
            let displacment = vectorLength(displacmentVector)
            let time = displacment / 10
            //SKAction.
            let moveTo = SKAction.moveTo(newLocation, duration: 0.3)
            //let moveTo = SKAction
            self.player.runAction(moveTo)
            player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
            player.physicsBody!.dynamic = true
            player.physicsBody!.categoryBitMask = photonTorpedoCategory
            player.physicsBody!.contactTestBitMask = alienCategory
            player.physicsBody!.collisionBitMask = 0
            player.physicsBody!.usesPreciseCollisionDetection = true
            
            player.physicsBody!.contactTestBitMask = alienCategory
            player.physicsBody!.collisionBitMask = 0

        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
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
    
    func playerDidCollide(torped:SKSpriteNode, alien:SKSpriteNode){
        //Print("Hit")
        player.removeFromParent()
        alien.removeFromParent()
        
        aliensDestroyed++
        
        if (aliensDestroyed > 10) {
            //transition to game over or success
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        // Body1 and 2 depend on the categoryBitMask << 0 und << 1
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        playerDidCollide(contact.bodyA.node as! SKSpriteNode, alien: contact.bodyB.node as! SKSpriteNode)
        
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
        var length: CGFloat = vectorLength(a)
        return CGPointMake(a.x / length, a.y/length)
    }
//   
//    override func update(currentTime: CFTimeInterval) {
//        /* Called before each frame is rendered */
//    }
}
