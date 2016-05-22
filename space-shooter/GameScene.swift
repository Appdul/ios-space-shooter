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
    //var meteorsMissed:Int = 0
    var meteorCategory:UInt32 = 0x1 << 1
    var playerCategory:UInt32 = 0x1 << 0
    var orbCategory:UInt32 = 0x1 << 2
    var scoreLabel = SKLabelNode()
    let scoreLabelName = "scoreLabel"
    
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
    
    func spawnFallingItems() {
        
        var meteor:SKSpriteNode = SKSpriteNode(imageNamed: "1")
        var orb:SKSpriteNode = SKSpriteNode(imageNamed: "litOrb")
        orb.xScale = 0.7
        orb.yScale = 0.7
        meteor.xScale = 0.7
        meteor.yScale = 0.7
        orb.physicsBody = SKPhysicsBody(circleOfRadius: orb.size.width/2)
        meteor.physicsBody = SKPhysicsBody(circleOfRadius: meteor.size.width/4)
        orb.physicsBody?.dynamic = true
        meteor.physicsBody?.dynamic = true
        orb.physicsBody?.categoryBitMask = orbCategory //2
        meteor.physicsBody?.categoryBitMask = meteorCategory
        meteor.physicsBody?.contactTestBitMask  = playerCategory
        meteor.physicsBody?.collisionBitMask = 0
        //orb.physicsBody?.collisionBitMask = todo figure out a number bit mask
        
        let minX = meteor.size.width/2
        let maxX = self.frame.size.width - meteor.size.width/2
        let rangeX = maxX - minX
        let randomNumber1 = arc4random()
        let randomNumber2 = arc4random()
        let meteorPositionInX:CGFloat = CGFloat(randomNumber1) % CGFloat(maxX)
        let orbPositionInX:CGFloat = CGFloat(randomNumber2) % CGFloat(maxX)
        
        meteor.position = CGPointMake(meteorPositionInX, self.frame.size.height + meteor.size.height)
        orb.position = CGPointMake(orbPositionInX, self.frame.size.height + orb.size.height)
        self.addChild(meteor)
        self.addChild(orb)
        
        let minDuration = 2
        let maxDuration = 4
        let rangeDuratiion = maxDuration -  minDuration
        let duration = Int(arc4random()) % Int(rangeDuratiion) + Int(minDuration)
        
        var actionArray:NSMutableArray = NSMutableArray()
        actionArray.addObject(SKAction.moveTo(CGPointMake(meteorPositionInX, -meteor.size.height), duration: NSTimeInterval(duration)))
        actionArray.addObject(SKAction.removeFromParent())
        //meteorsMissed++
        
        
        //Update the score
//        scoreLabel = SKLabelNode(fontNamed: "ScoreLabel")
//        scoreLabel.name = scoreLabelName
//        scoreLabel.fontSize = 45
//        scoreLabel.fontColor = SKColor.whiteColor()
//        scoreLabel.text = "\(meteorsMissed)"
//        //scoreLabel.position = CGPointMake(frame.size.width / 2, frame.size.height / 14)
//        scoreLabel.position = CGPointMake(60, self.frame.size.height - 60)
//        self.addChild(scoreLabel)
        
        meteor.runAction(SKAction.sequence(actionArray as [AnyObject]))
        
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        meteor.runAction(SKAction.repeatActionForever(action))
        
    
    }
    
    func addOrb(){
        
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let newLocation = touch.locationInNode(self)
            //self.player.position = newLocation
            let velocity = 570
            let currentLocationOfShip:CGPoint = player.position
            let displacmentVector:CGPoint = subtractVectors(newLocation, b: currentLocationOfShip)
            let displacment = vectorLength(displacmentVector)
            let time:NSTimeInterval = NSTimeInterval(displacment / CGFloat(velocity))
            let moveTo = SKAction.moveTo(newLocation, duration: time)
            self.player.runAction(moveTo)
            player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/12)
            player.physicsBody!.dynamic = true
            player.physicsBody!.categoryBitMask = playerCategory
            player.physicsBody!.contactTestBitMask = meteorCategory
            player.physicsBody!.collisionBitMask = 0
            player.physicsBody!.usesPreciseCollisionDetection = true
            
            player.physicsBody!.contactTestBitMask = meteorCategory
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
    
    
    func playerDidCollide(player:SKSpriteNode, meteor:SKSpriteNode){
        //Print("Hit")
        player.removeFromParent()
        meteor.removeFromParent()
        
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
        
        playerDidCollide(contact.bodyA.node as! SKSpriteNode, meteor: contact.bodyB.node as! SKSpriteNode)
        
    }
    func score(meteorsDestroyed: Int) {
        
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
