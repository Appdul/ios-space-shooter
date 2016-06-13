//
//  MenuScene.swift
//  space-shooter
//
//  Created by Abdul Abdulghafar on 2016-06-13.
//  Copyright © 2016 Abdulrahman Abdulghafar. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    
    var playButton = SKSpriteNode()
    let playButtonTexture = SKTexture(imageNamed: "play")
    
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMoveToView(view: SKView) {
        playButton = SKSpriteNode(texture: playButtonTexture)
        playButton.position = CGPointMake(self.frame.midX, self.frame.midY)
        self.addChild(playButton)

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
    
    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")

    }
    
}