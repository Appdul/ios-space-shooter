//
//  GameScene.swift
//  space-shooter
//
//  Created by Abdul Abdulghafar on 2016-05-14.
//  Copyright (c) 2016 Abdulrahman Abdulghafar. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
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
        player.xScale = 0.3
        player.yScale = 0.3
        
        
        self.addChild(player)
        self.physicsWorld.gravity = CGVectorMake(0, 0)
//        self.physicsWorld.contactDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAlien() {
        
        var alien:SKSpriteNode = SKSpriteNode(imageNamed: "alien")
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
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
//   
//    override func update(currentTime: CFTimeInterval) {
//        /* Called before each frame is rendered */
//    }
}