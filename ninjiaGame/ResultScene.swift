//
//  ResultScene.swift
//  ninjiaGame
//
//  Created by Ken Wang on 15/8/18.
//  Copyright (c) 2015年 Ogilvy & Mather RW. All rights reserved.
//

import SpriteKit

class ResultScene: SKScene {
    
    init(size: CGSize, won: Bool) {
        super.init(size: size)
        
        backgroundColor = SKColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        let resultLabel = SKLabelNode(fontNamed:"JDaiYu")
        resultLabel.text = won ? "你赢了" : "你输了"
        resultLabel.fontSize = 65;
        resultLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(resultLabel)
    
        
        let retryLabel = SKLabelNode(fontNamed: "JDaiYu")
        retryLabel.text = "再试一次？"
        retryLabel.fontSize = 20
        retryLabel.fontColor = SKColor.blueColor()
        retryLabel.position = CGPoint(x:resultLabel.position.x, y:resultLabel.position.y * 0.8)
        
        
        retryLabel.name = "retryLabel"
        self.addChild(retryLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            if let name = node.name {
                if name == "retryLabel" {
                    changeToGamgeScene()
                }
            }
        }
    }
    
    //MARK:切换到游戏场景
    func changeToGamgeScene() {
        let gameScene = GameScene(size: self.size)
        let reveal = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1.0)
        
        self.scene?.view?.presentScene(gameScene, transition: reveal)
    }
}
