//
//  GameScene.swift
//  RunForUrLife
//
//  Created by Hai on 9/10/16.
//  Copyright (c) 2016 HaiTrung. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var you : SKSpriteNode!                     //player
    var lastUpdateTime : NSTimeInterval = -1
    var countEnemy = 0                          //dem tgian sinh enemy
    var countBulletEnemy = 0                    //dem tgian sinh Bullet tu Nest
    var indexEnemy = 0                          // chi so enemy vua sinh ra
    var enemies : [(SKSpriteNode,CGFloat)] = [] //cac enemy gom: Node va speed cua enemy
    var gates : [SKSpriteNode] = []             //cac Gate
    var yourScore = 0
    var yourSpeed : CGFloat = 1.5               //toc do di chuyen cua player
    var enemySpeed : CGFloat = 2                //toc do di chuyen cua enemy
    var enemyBulletSpeed : CGFloat = 1.5          //toc do di chuyen cua Bullet
    var scoreLabel : SKLabelNode!               //Display your score
    
    
    let timeNextEnemy = 70                       //khoang tgian sinh enemy
    let timeNextBulletEnemy = 5                 //khoang tgian sinh bullet
    let MAXEnemy = 7                            //so luong enemy
    let MAXGate = 4                             //so luong Gate
    
    let positionNest = CGPoint(x: 1, y: 0.5)    //vi tri nest tuong doi voi Gamescene vd:(1,0) nghia la goc duoi phai
    
    override func didMoveToView(view: SKView) {
        addBackground()
        
        //vi tri Nest chinh xac trong GameScene
        let positionNestInGS = CGPoint(x: self.frame.size.width * positionNest.x, y: self.frame.size.height * positionNest.y)
        
        addNest(positionNestInGS)   //them nest vao vitri positionNestInGS
        addMain()   //player
        addStar()   //star - food
        
        //them 4 Gate - 4 goc
        addGate(firstArg: "gate.png", secondArg: 0, thirdArg: CGPointZero)
        addGate(firstArg: "gate2.png", secondArg: 1, thirdArg: CGPoint(x: self.frame.size.width, y: 0))
        addGate(firstArg: "gate2.png", secondArg: 2, thirdArg: CGPoint(x: 0, y: self.frame.size.height))
        addGate(firstArg: "gate.png", secondArg: 3, thirdArg: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        //in ra score = 0
        scoreLabel = SKLabelNode(text: "Score :\(yourScore)")
        addChild(scoreLabel)
    }
    
    func updateLabel()  {
        //update score
        scoreLabel.removeFromParent()   //remove label cu
        scoreLabel = SKLabelNode(text: "Score :\(yourScore)")   //them label moi
        scoreLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height - scoreLabel.frame.height)
        scoreLabel.fontColor = UIColor.darkGrayColor()
        scoreLabel.fontSize = 30
        addChild(scoreLabel)    //hien thi label moi
    }
    func addBackground(){
        //cai background
        let background = SKSpriteNode(imageNamed: "background2.png")
        background.anchorPoint = CGPointZero
        background.position = CGPointZero
        //        print(self.frame.size.width)
        addChild(background)
    }
    
    func addNest(location : CGPoint){
        //cai Nest vao vi tri location
        let nest = SKSpriteNode(imageNamed: "circlenest.png")
        nest.setScale(0.5)// chinh kich thuoc Nest
        nest.position = location
        addChild(nest)
        let shotEnemyBullet = SKAction.runBlock {
            self.addEnemyBullet(location)
        }
        let shotEnemyBulletPeriod = SKAction.sequence([shotEnemyBullet, SKAction.waitForDuration(1)])
        let shotEnemyBulletForever = SKAction.repeatActionForever(shotEnemyBulletPeriod)
        nest.runAction(shotEnemyBulletForever)
    }
    
    func addMain() {
        //add player vao trung tam
        you = SKSpriteNode(imageNamed: "mouse.png")
        you.setScale(0.05) //chinh lai kich thuoc player
        you.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        addChild(you)
    }
    
    func addStar() {
        //them star
        let star = SKSpriteNode(imageNamed: "star2.png")
        star.setScale(0.1)  //chinh lai kich thuoc star
        
        //set position cua star bat ki
        star.position = CGPoint(x: CGFloat(Int(arc4random_uniform(UInt32 (self.frame.size.width)))), y: CGFloat(Int(arc4random_uniform(UInt32 (self.frame.size.height)))))
        addChild(star)
        
        //cho star runaction kiem tra va cham
        let test = SKAction.runBlock {
            if CGRectIntersectsRect(star.frame, self.you.frame) {
                //neu va cham thi tang diem
                self.yourScore = self.yourScore + 1
                let soundEat = SKAction.playSoundFileNamed("Pickup_Coin11.wav", waitForCompletion: false)
                star.runAction(soundEat)
                star.position = CGPoint(x: CGFloat(Int(arc4random_uniform(UInt32 (self.frame.size.width)))), y: CGFloat(Int(arc4random_uniform(UInt32 (self.frame.size.height)))))
                //dat lai vi tri star moi
            }
        }
        let testPeriod = SKAction.sequence([test,SKAction.waitForDuration(0.001)])
        let testForever = SKAction.repeatActionForever(testPeriod)
        star.runAction(testForever)
    }
    
    func addGate(firstArg name : String, secondArg index : Int, thirdArg positionGate : CGPoint) {
        //them Gate voi image:name, chi so Gate la index, vi tri Gate: positionGate
        let gate = SKSpriteNode(imageNamed: name)
        gate.setScale(0.02) //chinh lai kich thuoc
        gate.position = positionGate
        addChild(gate)
        //chen vao danh sach cac gate
        gates.insert(gate, atIndex: index)
        //center la point trung tam cua GameScene
        let center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        //cac Gate test va cham forever
        let test = SKAction.runBlock {
            // khoang cach xay ra va cham la bound
            let bound = (gate.frame.size.height + gate.frame.size.width) / 4
            if self.you.position.distance(gate.position) < bound {
                var yourPosition = CGPoint(x: self.frame.size.width, y: self.frame.size.height)
                yourPosition = yourPosition.subtract(positionGate)
                //can dat vi tri cua player ra xa hon bound so voi newGate moi de ko bi cham vao newGate
                //vector: vector can dich chuyen so voi vitri newGate
                let vector = center.subtract(yourPosition).normalize().multiply(bound * 1.2)
                self.you.position = yourPosition.add(vector)
                //                self.you.position = CGPoint(x: self.frame.size.width/2, y: self.size.height)
            }
        }
        let testPeriod = SKAction.sequence([test,SKAction.waitForDuration(0.001)])
        let testForever = SKAction.repeatActionForever(testPeriod)
        gate.runAction(testForever)
    }
    func addEnemy(firstArg positionEnemy : CGPoint, secondArg index : Int){
        //sinh ra enemy lan thu index + 1
        let enemy = SKSpriteNode(imageNamed: "enemy.png")
        enemy.position = positionEnemy
        if (index >= MAXEnemy) {
            //neu da qua so luong MAXEnemy thi xoa bot Enemy cu
            let (en,sp) = enemies[index % MAXEnemy]
            en.removeFromParent()   //xoa hinh anh
            enemies.removeAtIndex(index % MAXEnemy) //xoa phan tu
        }
        //chen enemy moi voi speed = enemySpeed * (1 + CGFloat(index)/5))
        enemies.insert((enemy, enemySpeed * (1 + CGFloat(index)/5)), atIndex: index % MAXEnemy)
        addChild(enemy)
    }
    
    func addEnemyBullet(positionBulletEnemy : CGPoint) {
        //them bullet ban ra tu positionBulletEnemy
        let enemyBullet = SKSpriteNode(imageNamed: "bullet-red-dot.png")
        enemyBullet.setScale(0.5)
        
        enemyBullet.position = positionBulletEnemy
        //vector dich chuyen
        let vectorMove = you.position.subtract(positionBulletEnemy).normalize().multiply(self.frame.size.height)
        //Action dich chuyen
        let move = SKAction.moveBy(CGVector(dx: vectorMove.x, dy: vectorMove.y), duration: NSTimeInterval ((self.frame.size.height + self.frame.size.width)/100/enemyBulletSpeed))
        let movePeriod = SKAction.sequence([move, SKAction.waitForDuration(0.001)])
        let moveForever = SKAction.repeatActionForever(movePeriod)
        enemyBullet.runAction(moveForever)
        //bullet dich chuyen forever
        
        let test = SKAction.runBlock {
            //check va cham
            if enemyBullet.position.distance(self.you.position) < enemyBullet.frame.size.width  {
                let soundDie = SKAction.playSoundFileNamed("Blip_Select3.wav", waitForCompletion: false)
                enemyBullet.runAction(soundDie)
                self.paused = true
            }
        }
        let testPeriod = SKAction.sequence([test,SKAction.waitForDuration(0.001)])
        let testForever = SKAction.repeatActionForever(testPeriod)
        enemyBullet.runAction(testForever)
        //check va cham forever
        addChild(enemyBullet)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first{
            let touchPosition = touch.locationInNode(self)
            let move = SKAction.moveTo(touchPosition, duration:  NSTimeInterval(you.position.distance(touchPosition) / yourSpeed / 100))
            you.runAction(move)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        updateLabel()
        
        if lastUpdateTime == -1 {
            lastUpdateTime = currentTime
        } else {
            let deltaTime = currentTime - lastUpdateTime
            let deltaTimeMiliseconds = deltaTime * 1000
            
            if deltaTimeMiliseconds > 100 {
                lastUpdateTime = currentTime
                countEnemy += 1
                if(countEnemy > timeNextEnemy){
                    let positionNestInGS = CGPoint(x: self.frame.size.width * positionNest.x, y: self.frame.size.height * positionNest.y)
                    
                    addEnemy(firstArg: positionNestInGS, secondArg: indexEnemy)
                    countEnemy = 0
                    indexEnemy += 1
                }
                countBulletEnemy += 1
            }
        }
        
        for (en,sp) in enemies {
            en.position = en.position.add(you.position.subtract(en.position).normalize().multiply(sp))
        }
        
        //check va cham cua cac enemy voi player
        for(en,_) in enemies {
            if en.position.distance(you.position) < (en.frame.size.height + en.frame.size.width) / 2{
//                print("die")
//                let temp = SKSpriteNode(imageNamed: "circlenest.png")
//                let soundDie = SKAction.playSoundFileNamed("Blip_Select3.wav", waitForCompletion: false)
//                addChild(temp)
//                temp.runAction(soundDie)
                //ko hieu sao ko co am thanh??
//                temp.removeFromParent()
                self.paused = true
            }
        }
    }
}
