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
    
    init(size: CGSize, score:Int) {
        super.init(size: size)
        self.backgroundColor = SKColor.blackColor()
        
        var label:SKLabelNode = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        label.text = String(score)
        label.fontColor = SKColor.whiteColor()
        label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(label)
        self.runAction(SKAction.sequence([SKAction.waitForDuration(2.0),
            SKAction.runBlock({
                var transition:SKTransition = SKTransition.flipHorizontalWithDuration(0.5)
                var scene:SKScene = GameScene(size: self.size)
                self.view?.presentScene(scene, transition: transition)
                
                
                
            })
            
            
            ]))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}