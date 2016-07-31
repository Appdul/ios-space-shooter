//
//  MenuScene.swift
//  space-shooter
//
//  Created by Abdul Abdulghafar on 2016-06-13.
//  Copyright © 2016 Abdulrahman Abdulghafar. All rights reserved.
//

import Foundation
import SpriteKit

public var playButton = SKSpriteNode()
public let playButtonTexture = SKTexture(imageNamed: "play")
public var creditsButton = SKSpriteNode()
public let creditsButtonTexture = SKTexture(imageNamed: "credits")
public let highScoreLabel = SKLabelNode(fontNamed: "TimeBurner")
public let muteLabel = SKLabelNode()


class MenuScene: SKScene {
    let title = SKLabelNode(fontNamed: "TimeBurner")
    let litOrbTexture = SKTexture(imageNamed: "litOrb")
    var player: SKSpriteNode = SKSpriteNode()
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMoveToView(view: SKView) {
        highscore = userDefaults.valueForKey("highscore") != nil ? userDefaults.valueForKey("highscore") as? Int : 0
        orbCount = userDefaults.valueForKey("orbs") != nil ? userDefaults.valueForKey("orbs") as? Int : 0
        spawnBackgroundStars()
        playButton = SKSpriteNode(texture: playButtonTexture)
        playButton.position = CGPointMake(self.frame.midX, self.frame.minY + 100)
        self.addChild(playButton)
        
//        creditsButton = SKSpriteNode(texture: creditsButtonTexture)
//        creditsButton.position = CGPointMake(self.frame.midX, playButton.position.y - 100)
//        self.addChild(creditsButton)
        
//        highScoreLabel.text = "HIGH SCORE: \(highscore!)"
//        highScoreLabel.fontColor = UIColor.redColor()
//        highScoreLabel.position = CGPointMake(self.frame.midX, playButton.position.y + 140)
//        self.addChild(highScoreLabel)
        
        title.text = "SP      RBS"
        title.fontColor = UIColor.redColor()
        title.fontSize = 45
        title.position =  CGPointMake(self.frame.midX, self.frame.maxY - 100)
        self.addChild(title)
        
        let letterOrb = SKSpriteNode(texture: litOrbTexture)
        letterOrb.position = CGPointMake(title.position.x - 13, title.position.y + 15)
        letterOrb.xScale = 0.8
        letterOrb.yScale = 0.8
        self.addChild(letterOrb)
        
        player = SKSpriteNode(texture: redFighterTexture )
        player.name = "player"
        player.position = CGPointMake(self.frame.midX, self.frame.midY)
        let playerScale = scene!.frame.size.width/1200
        player.xScale = playerScale
        player.yScale = playerScale
        self.addChild(player)
        addShipTrailEffect()

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in (touches ) {
            let pos = touch.locationInNode(self)
            let node = self.nodeAtPoint(pos)
            
            if node == playButton {
                //Configure the view
                let skView:SKView = self.view!
                let scene = GameScene(size: skView.bounds.size)
                    scene.scaleMode = SKSceneScaleMode.AspectFill
                    skView.presentScene(scene)
            }
        }
        

    }
    
    func spawnBackgroundStars() {
        self.backgroundColor = blueBg
        var starsNode = SKEmitterNode(fileNamed: "background.sks")
        starsNode?.position = CGPointMake(self.frame.size.width/2, self.frame.size.height)
        self.addChild(starsNode!)
    }
    
    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")

    }
    
    func addShipTrailEffect() {
        var emitterNode = SKEmitterNode(fileNamed: "rocketfire.sks")
        emitterNode!.targetNode = scene
        emitterNode!.position = CGPointMake(0, -180.0)
        emitterNode!.zPosition = 100
        self.player.addChild(emitterNode!)
    }
    
}