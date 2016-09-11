//
//  GameScene.swift
//  RunForUrLife
//
//  Created by Hai on 9/10/16.
//  Copyright (c) 2016 HaiTrung. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var you : SKSpriteNode!
    var lastUpdateTime : NSTimeInterval = -1
    var countEnemy = 0
    var indexEnemy = 0
    var enemies : [(SKSpriteNode,CGFloat)] = []
    var yourScore = 0
    var yourSpeed : CGFloat = 1.5
    var enemySpeed : CGFloat = 2
    
    let timeNextEnemy = 3
    let MAXEnemy = 10
    
    let positionNest = CGPoint(x: 1, y: 0)
    //vi tri nest trong voi Gamescene -(1,0) nghia la goc duoi phai
    
    override func didMoveToView(view: SKView) {
        addBackground()
        
        let positionNestInGS = CGPoint(x: self.frame.size.width * positionNest.x, y: self.frame.size.height * positionNest.y)
        addNest(positionNestInGS)
        
        addMain()
        addStar()
    }
    func addBackground(){
        let background = SKSpriteNode(imageNamed: "background.png")
        background.anchorPoint = CGPointZero
        background.position = CGPointZero
        //        print(self.frame.size.width)
        addChild(background)
    }
    
    func addNest(location : CGPoint){
        let nest = SKSpriteNode(imageNamed: "nest.png")
        
        //        nest.anchorPoint = CGPoint(x: 1, y: 0)
        nest.position = location
        addChild(nest)
    }
    
    func addMain() {
        you = SKSpriteNode(imageNamed: "main.png")
        you.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        addChild(you)
    }
    
    func addStar() {
        let star = SKSpriteNode(imageNamed: "star.png")
        star.position = CGPoint(x: CGFloat(Int(arc4random_uniform(UInt32 (self.frame.size.width)))), y: CGFloat(Int(arc4random_uniform(UInt32 (self.frame.size.height)))))
        addChild(star)
        //        print("hello")
        let test = SKAction.runBlock {
            if CGRectIntersectsRect(star.frame, self.you.frame) {
                self.yourScore += 1
                star.position = CGPoint(x: CGFloat(Int(arc4random_uniform(UInt32 (self.frame.size.width)))), y: CGFloat(Int(arc4random_uniform(UInt32 (self.frame.size.height)))))
                
                //                self.print("your scode: \(yourScore)")
            }
        }
        let testPeriod = SKAction.sequence([test,SKAction.waitForDuration(0.05)])
        let testForever = SKAction.repeatActionForever(testPeriod)
        star.runAction(testForever)
    }
    
    func addEnemy(firstArg positionEnemy : CGPoint, secondArg index : Int){
        let enemy = SKSpriteNode(imageNamed: "enemy.png")
        enemy.position = positionEnemy
        if (index >= MAXEnemy) {
            let (en,sp) = enemies[index % MAXEnemy]
            en.removeFromParent()
            enemies.removeAtIndex(index % MAXEnemy)
        }
        enemies.insert((enemy, enemySpeed + CGFloat(index)/5), atIndex: index % MAXEnemy)
        //        enemies.insert((enemy, CGFloat(enemySpeed + 0.1 * index)), atIndex: index % MAXEnemy)
        addChild(enemy)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        print("touchesBegan")
        if let touch = touches.first{
            let touchPosition = touch.locationInNode(self)
            let move = SKAction.moveTo(touchPosition, duration:  NSTimeInterval(you.position.distance(touchPosition) / yourSpeed / 100))
            you.runAction(move)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if lastUpdateTime == -1 {
            lastUpdateTime = currentTime
        } else {
            let deltaTime = currentTime - lastUpdateTime
            let deltaTimeMiliseconds = deltaTime * 1000
            
            if deltaTimeMiliseconds > 1000 {
                lastUpdateTime = currentTime
                countEnemy += 1
                if(countEnemy > timeNextEnemy){
                    let positionNestInGS = CGPoint(x: self.frame.size.width * positionNest.x, y: self.frame.size.height * positionNest.y)
                    
                    addEnemy(firstArg: positionNestInGS, secondArg: indexEnemy)
                    countEnemy = 0
                    indexEnemy += 1
                }
            }
        }
        
        for (en,sp) in enemies {
            en.position = en.position.add(you.position.subtract(en.position).normalize().multiply(sp))
        }
        
        //        for (bulletIndex, bullet) in bullets.enumerate() {
        //            for (enemyIndex, enemy) in enemies.enumerate() {
        //                let bulletFrame = bullet.frame
        //                let enemyFrame = enemy.frame
        //                if(CGRectIntersectsRect(bulletFrame, enemyFrame)){
        //                    bullets.removeAtIndex(bulletIndex)
        //                    enemies.removeAtIndex(enemyIndex)
        //                    bullet.removeFromParent()
        //                    enemy.removeFromParent()
        //                }
        //            }
        //        }
    }
}
