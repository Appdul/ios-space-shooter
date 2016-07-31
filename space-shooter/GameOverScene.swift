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
    let muteLabel = SKLabelNode()
    
    init(size: CGSize, score: Int) {
        super.init(size: size)
        spawnBackgroundStars()
        let scoreLabel = SKLabelNode(fontNamed: "TimeBurner")
        scoreLabel.text = "YOUR SCORE: " + String(score)
        scoreLabel.fontColor = SKColor.redColor()
        scoreLabel.position = CGPointMake(self.frame.midX, self.frame.maxY - 200)
        self.addChild(scoreLabel)
        
        let highScoreLabel = SKLabelNode(fontNamed: "TimeBurner")
        highScoreLabel.text = "HIGH SCORE: " + String(highscore!)
        highScoreLabel.fontColor = SKColor.redColor()
        highScoreLabel.position = CGPointMake(self.frame.midX, scoreLabel.position.y - 100)
        self.addChild(highScoreLabel)
        
        playButton = SKSpriteNode(texture: playButtonTexture)
        playButton.position = CGPointMake(self.frame.midX, self.frame.midY - 100)
        self.addChild(playButton)
        
    }
    
    override func didMoveToView(view: SKView) {
        muteLabel.text = muted ? "🔇" : "🔈"
        muteLabel.position = CGPoint(x:self.size.width - 20, y:self.size.height - 50)
        self.addChild(muteLabel)
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
            else if node == muteLabel {
                if muteLabel.text == "🔇" {
                    muteLabel.text = "🔈"
                    muted = false
                }
                else {
                    muteLabel.text = "🔇"
                    muted = true
                }
            }
        }
    }
    
    func spawnBackgroundStars() {
        self.backgroundColor = blueBg
        let starsNode = SKEmitterNode(fileNamed: "background.sks")
        starsNode?.position = CGPointMake(self.frame.size.width/2, self.frame.size.height)
        self.addChild(starsNode!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}