//
//  GameScene.swift
//  ninjiaGame
//
//  Created by Ken Wang on 15/8/18.
//  Copyright (c) 2015年 Ogilvy & Mather RW. All rights reserved.
//

import SpriteKit
import Foundation
import AVFoundation

class GameScene: SKScene {
    
    var monsters: NSMutableArray = NSMutableArray()
    
    var projectiles: NSMutableArray = NSMutableArray()
    
    
    //被摧毁的怪物数量
    /**
        SpriteKit 没有提供合适的背景音乐播放功能，所以只能使用AVAudioPlay来播放背景音乐
    */
    
    //背景音乐播放器
    var bgmPlayer = AVAudioPlayer()
    
    //游戏中被摧毁的怪物数量
    var monsterDestoryed:Int = 0
    
    //游戏音效可以通过action来实现
    let projectileSoundEffectAction: SKAction = SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false)
    
    override func didMoveToView(view: SKView) {
        bgmPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("background-music-aac", ofType: "caf")!)!, error: nil)
        
        bgmPlayer.prepareToPlay()
        
        bgmPlayer.numberOfLoops = -1
        
        bgmPlayer.play()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.backgroundColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        let player = SKSpriteNode(imageNamed: "player")
        
        player.position = CGPointMake(player.size.width/2, size.height/2)
        
        self.addChild(player)
        
        let actionAddMonster = SKAction.runBlock { () -> Void in
            self.addMonster()
        }
        
        let actionWaitNextMonster = SKAction.waitForDuration(1)
        
        let actionSequence = SKAction.sequence([actionAddMonster, actionWaitNextMonster])
        
        let actionRepeatForever = SKAction.repeatActionForever(actionSequence)
        
        self.runAction(actionRepeatForever)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //MARK: 点击操作开始
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            let winSize = self.size
            
            
            /**
                创建飞镖
            */
            
            let projectile = SKSpriteNode(imageNamed: "projectile")
            projectile.position = CGPointMake(projectile.size.width, winSize.height/2)
            
            
            let offset = CGPointMake(location.x - projectile.position.x, location.y - projectile.position.y)
            
            if offset.x <= 0 {
                return
            }
            
            self.addChild(projectile)
            self.projectiles.addObject(projectile)
            
            let realX = winSize.width + projectile.size.width/2
            let ratio = offset.y / offset.x
            let realY = realX * ratio + projectile.position.y
            let realDest = CGPointMake(realX, realY)
            
            let offRealX = realX - projectile.position.x
            let offRealY = realY - projectile.position.y
            let length = sqrtf(Float(offRealX * offRealX + offRealY * offRealY))
            
            let velocity = Float(self.size.width / 1.0)
            let realMoveDuration : Double = Double(length / velocity)
            
            let moveAction = SKAction.moveTo(realDest, duration: realMoveDuration)
            
            let projectileCastAction = SKAction.group([moveAction,self.projectileSoundEffectAction])
            
            projectile.runAction(projectileCastAction, completion: { () -> Void in
                self.projectiles.removeObject(projectile)
                projectile .removeFromParent()
            })
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        var projectilesToDelete = NSMutableArray()
        
        for projectile in self.projectiles {
            
            var monstersToDelete = NSMutableArray()
            
            for monster in self.monsters {
                if CGRectIntersectsRect(projectile.frame, monster.frame) {
                    monstersToDelete.addObject(monster)
                }
            }
            
            for monster in monstersToDelete {
                self.monsters.removeObject(monster)
                monster.removeFromParent()
                
                self.monsterDestoryed++
                
                if self.monsterDestoryed >= 30 {
//                    self.backgroundColor = SKColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.0)
//                    self.monsterDestoryed = 0
                    
                    changeToResultSceneWithWon(true)
                }
            }
            
            if monstersToDelete.count > 0 {
                projectilesToDelete.addObject(projectile)
            }
        }
        
        for projectile in projectilesToDelete {
            self.projectiles.removeObject(projectile)
            projectile.removeFromParent()
        }
    }
    
    override func didEvaluateActions() {
        
    }
    
    override func didSimulatePhysics() {
        
    }
    
    //MARK: 添加一个怪物
    
    func addMonster() {
        let monster = SKSpriteNode(imageNamed: "monster")
        let winSize = self.size
        
        let minY = monster.size.height / 2
        let maxY = winSize.height - monster.size.height/2
        let actualY = CGFloat.random(min: minY, max: maxY) + minY
        
        monster.position = CGPointMake(winSize.width + monster.size.width/2, actualY)
        self.addChild(monster)
        self.monsters.addObject(monster)
        
        let minDuration = 2.0
        let maxDuration = 4.0
        let rangeDuration : Double = maxDuration - minDuration
        let acturalDuration = (Double.random(min: minDuration, max: maxDuration) + minDuration)
        
        let actionMove = SKAction.moveTo(CGPointMake(-monster.size.width/2, actualY), duration: acturalDuration)
        
        let actionMoveDone = SKAction.runBlock { () -> Void in
            self.monsters .removeObject(monster)
            monster.removeFromParent()
            
            println("你输了")
            
            self.changeToResultSceneWithWon(false)
        }
        
        let actionSequence = SKAction.sequence([actionMove, actionMoveDone])
        
        monster.runAction(actionSequence)
    }
    
    //MARK: 切换到结果页面
    func changeToResultSceneWithWon(won: Bool) {
        bgmPlayer.stop()
        
        let rs = ResultScene(size: self.size, won: won)
        let reveal = SKTransition.revealWithDirection(SKTransitionDirection.Up, duration: 1.0)
        
        self.scene?.view?.presentScene(rs, transition: reveal)
    }
}
