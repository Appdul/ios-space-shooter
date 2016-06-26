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
public var exitButton = SKSpriteNode()
public let exitButtonTexture = SKTexture(imageNamed: "exit")
public let highScoreLabel = SKLabelNode(fontNamed: "TimeBurner")

class MenuScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMoveToView(view: SKView) {
        
        if userDefaults.valueForKey("highscore") != nil {
            highscore = userDefaults.valueForKey("highscore") as? Int
        }
        else {
            // no highscore exists
            highscore = 0
        }
        
        animateBackground()
//        let highscore = 0
        playButton = SKSpriteNode(texture: playButtonTexture)
        playButton.position = CGPointMake(self.frame.midX, self.frame.midY)
        self.addChild(playButton)
        creditsButton = SKSpriteNode(texture: creditsButtonTexture)
        creditsButton.position = CGPointMake(self.frame.midX, playButton.position.y - 100)
        self.addChild(creditsButton)
        exitButton = SKSpriteNode(texture: exitButtonTexture)
        exitButton.position = CGPointMake(self.frame.midX, creditsButton.position.y - 100)
        self.addChild(exitButton)
        
        highScoreLabel.text = "HIGH SCORE: \(highscore!)"
        highScoreLabel.fontColor = UIColor.redColor()
        highScoreLabel.position = CGPointMake(self.frame.midX, playButton.position.y + 140)
        self.addChild(highScoreLabel)
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
    
    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")

    }
    
}