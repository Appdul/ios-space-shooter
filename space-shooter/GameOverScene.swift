//
//  GameOverScene.swift
//  space-shooter
//
//  Created by Abdul Abdulghafar on 2016-05-23.
//  Copyright (c) 2016 Abdulrahman Abdulghafar. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, score: Int) {
        super.init(size: size)
        animateBackground()
        let scoreLabel = SKLabelNode(fontNamed: "TimeBurner-Bold")
        scoreLabel.text = "YOUR SCORE: " + String(score)
        scoreLabel.fontColor = SKColor.redColor()
        scoreLabel.position = CGPointMake(self.frame.midX, self.frame.maxY - 200)
        self.addChild(scoreLabel)
        
        let highScoreLabel = SKLabelNode(fontNamed: "TimeBurner-Bold")
        highScoreLabel.text = "HIGH SCORE: " + String(highscore!)
        highScoreLabel.fontColor = SKColor.redColor()
        highScoreLabel.position = CGPointMake(self.frame.midX, scoreLabel.position.y - 100)
        self.addChild(highScoreLabel)
        
        playButton = SKSpriteNode(texture: playButtonTexture)
        playButton.position = CGPointMake(self.frame.midX - 100, self.frame.midY - 100)
        self.addChild(playButton)

        exitButton = SKSpriteNode(texture: exitButtonTexture)
        exitButton.position = CGPointMake(self.frame.midX + 100, self.frame.midY - 100)
        self.addChild(exitButton)
        
        
//      self.runAction(SKAction.sequence([SKAction.waitForDuration(2.0),
//          SKAction.runBlock({
//                let transition:SKTransition = SKTransition.flipHorizontalWithDuration(0.5)
//                let scene:SKScene = GameScene(size: self.size)
//                self.view?.presentScene(scene, transition: transition)
//      
//           })
//      ]))
    }
    
//    override func didMoveToView(view: SKView) {
//        animateBackground()
//    }
    
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
            
            if node == exitButton {
                //TODO: quit the app
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
        fatalError("init(coder:) has not been implemented")
    }

}