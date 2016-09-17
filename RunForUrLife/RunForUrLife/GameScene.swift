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
    let MAXEnemy = 5                            //so luong enemy
    let MAXGate = 4                             //so luong Gate
    var nest : SKSpriteNode!
    
    let positionNest = CGPoint(x: 1, y: 0.5)    //vi tri nest tuong doi voi Gamescene vd:(1,0) nghia la goc duoi phai
    
    override func didMoveToView(view: SKView) {
        addBackground()
        
        //vi tri Nest chinh xac trong GameScene
        let positionNestInGS = CGPoint(x: self.frame.size.width * positionNest.x, y: self.frame.size.height * positionNest.y)
        
        addNest(positionNestInGS)   //them nest vao vitri positionNestInGS
        addMain()   //player
        addStar()   //star - food
        
        //them 4 Gate - 4 goc
        addGate(firstArg: "gate1_0.png", secondArg: 0, thirdArg: CGPointZero)
        addGate(firstArg: "gate2_0.png", secondArg: 1, thirdArg: CGPoint(x: self.frame.size.width, y: 0))
        addGate(firstArg: "gate2_0.png", secondArg: 2, thirdArg: CGPoint(x: 0, y: self.frame.size.height))
        addGate(firstArg: "gate1_0.png", secondArg: 3, thirdArg: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
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
        let background = SKSpriteNode(imageNamed: "background.png")
        background.setScale(0.8)
        background.anchorPoint = CGPointZero
        background.position = CGPointZero
        //        print(self.frame.size.width)
        addChild(background)
    }
    
    func addNest(location : CGPoint){
        //cai Nest vao vi tri location
        nest = SKSpriteNode(imageNamed: "nest_0.png")
        let positionNestInGS = CGPoint(x: self.frame.size.width * positionNest.x, y: self.frame.size.height * positionNest.y)
        nest.anchorPoint = CGPoint(x: 1, y: 0.5)
        nest.setScale(0.17)// chinh kich thuoc Nest
        nest.position = location
        addChild(nest)
<<<<<<< HEAD
        var nestShotTexures : [SKTexture] = []
        let nameNestFormat = "nest_"
        for i in 0..<3 {
            let imageName = "\(nameNestFormat)\(i).png"
            let nestShotTexture = SKTexture(imageNamed: imageName)
            nestShotTexures.append(nestShotTexture)
        }
        let animateShot = SKAction.animateWithTextures(nestShotTexures, timePerFrame: 0.07)
        
        let enemyShot = SKAction.runBlock {
            self.addEnemyBullet(positionNestInGS)
            print("1")
        }
        let playShotSound = SKAction.playSoundFileNamed("shoot.wav", waitForCompletion: false)
        let enemyShotPeriod = SKAction.sequence([animateShot,enemyShot,playShotSound, SKAction.waitForDuration(1)])
        nest.runAction(SKAction.repeatActionForever(enemyShotPeriod))
        let enemySpawn = SKAction.runBlock {
            self.addEnemy(firstArg: positionNestInGS, secondArg: self.indexEnemy)
            self.indexEnemy += 1
        }
        var nestOpenTextures : [SKTexture] = []
        let nestOpen_0 = SKTexture(imageNamed: "nest_0")
        nestOpenTextures.append(nestOpen_0)
        let nestOpen_1 = SKTexture(imageNamed: "nest_open_1")
        nestOpenTextures.append(nestOpen_1)
        let nestOpen_2 = SKTexture(imageNamed: "nest_open_2")
        nestOpenTextures.append(nestOpen_2)
        let enemySpawnSound = SKAction.playSoundFileNamed("enemy_sound.wav", waitForCompletion: false)
        let animateOpen = SKAction.animateWithTextures(nestOpenTextures, timePerFrame: 0.07)
        let enemySpawnPeriod = SKAction.sequence([SKAction.waitForDuration(5),animateOpen, enemySpawn, enemySpawnSound])
        nest.runAction(SKAction.repeatActionForever(enemySpawnPeriod))
=======
        let shotEnemyBullet = SKAction.runBlock {
            self.addEnemyBullet(location)
        }
        let shotEnemyBulletPeriod = SKAction.sequence([shotEnemyBullet, SKAction.waitForDuration(1)])
        let shotEnemyBulletForever = SKAction.repeatActionForever(shotEnemyBulletPeriod)
        nest.runAction(shotEnemyBulletForever)
>>>>>>> 54165e5b9be73b454686d3b95d23c8f9c842e3e6
    }
    
    func addMain() {
        //add player vao trung tam
        you = SKSpriteNode(imageNamed: "main.png")
        you.setScale(0.8) //chinh lai kich thuoc player
        you.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        addChild(you)
        you.name = "you"
    }
    
    func addStar() {
        //them star
        let star = SKSpriteNode(imageNamed: "star2.png")
        star.setScale(0.1)  //chinh lai kich thuoc star
        
        //set position cua star bat ki
        repeat{
            star.position = CGPoint(x: CGFloat(Int(arc4random_uniform(UInt32 (self.frame.size.width)))), y: CGFloat(Int(arc4random_uniform(UInt32 (self.frame.size.height)))))
            addChild(star)
        }while (CGRectIntersection(star.frame, nest.frame) != CGRectNull)
     
       
        
        
        //cho star runaction kiem tra va cham
        let test = SKAction.runBlock {
            if CGRectIntersectsRect(star.frame, self.you.frame) {
                //neu va cham thi tang diem
                self.yourScore = self.yourScore + 1
                let soundEat = SKAction.playSoundFileNamed("Pickup_Coin11.wav", waitForCompletion: false)
                star.runAction(soundEat)
                star.position = CGPoint(x: CGFloat(Int(arc4random_uniform(UInt32 (self.frame.size.width)))), y: CGFloat(Int(arc4random_uniform(UInt32 (self.frame.size.height)))))
                let playSoundPickUp = SKAction.playSoundFileNamed("pickup_.wav", waitForCompletion: false)
                self.runAction(playSoundPickUp)
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
        gate.setScale(0.03) //chinh lai kich thuoc
        gate.position = positionGate
        var gateTextures : [SKTexture] = []
        let nameGateFormat = name.stringByReplacingOccurrencesOfString("0.png", withString: "")
        print(nameGateFormat)
        for i in 0..<2 {
            let imageName = "\(nameGateFormat)\(i).png"
            let gateTexure = SKTexture(imageNamed: imageName)
            gateTextures.append(gateTexure)
            //print(imageName)
        }
        let animateGate = SKAction.animateWithTextures(gateTextures, timePerFrame: 0.3)
        gate.runAction(SKAction.repeatActionForever(animateGate))

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
        let enemy = SKSpriteNode(imageNamed: "enemy_1.png")
        var enemyTextures : [SKTexture] = []
        let texture_0 = SKTexture(imageNamed: "enemy_0.png")
        enemyTextures.append(texture_0)
        let texture_1 = SKTexture(imageNamed: "enemy_1.png")
        enemyTextures.append((texture_1))
        let enemyAnimate = SKAction.animateWithTextures(enemyTextures, timePerFrame: 0.1)
        enemy.runAction(SKAction.repeatActionForever(enemyAnimate))
        enemy.setScale(0.029)
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
<<<<<<< HEAD
//        
//        let test = SKAction.runBlock {
//            //check va cham
//            if enemyBullet.position.distance(self.you.position) < enemyBullet.frame.size.width  {
//                self.paused = true
//            }
//        }
//        let testPeriod = SKAction.sequence([test,SKAction.waitForDuration(0.001)])
//        let testForever = SKAction.repeatActionForever(testPeriod)
//        enemyBullet.runAction(testForever)
//        //check va cham forever
              addChild(enemyBullet)
        enemyBullet.name = "enemyBullet"
=======
        
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
>>>>>>> 54165e5b9be73b454686d3b95d23c8f9c842e3e6
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
        
<<<<<<< HEAD
//        if lastUpdateTime == -1 {
//            lastUpdateTime = currentTime
//        } else {
//            let deltaTime = currentTime - lastUpdateTime
//            let deltaTimeMiliseconds = deltaTime * 1000
//            
//            if deltaTimeMiliseconds > 100 {
//                lastUpdateTime = currentTime
//                countEnemy += 1
//                if(countEnemy > timeNextEnemy){
//                    let positionNestInGS = CGPoint(x: self.frame.size.width * positionNest.x, y: self.frame.size.height * positionNest.y)
//                    
//                    addEnemy(firstArg: positionNestInGS, secondArg: indexEnemy)
//                    countEnemy = 0
//                    indexEnemy += 1
//                }
////                countBulletEnemy += 1
////                if(countBulletEnemy > timeNextBulletEnemy){
////                    let positionNestInGS = CGPoint(x: self.frame.size.width * positionNest.x, y: self.frame.size.height * positionNest.y)
////                    addEnemyBullet(positionNestInGS)
////                    countBulletEnemy = 0
////                }
//            }
//        }
=======
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
>>>>>>> 54165e5b9be73b454686d3b95d23c8f9c842e3e6
        
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
        enumerateChildNodesWithName("you"){
            youNode, _ in
            self.enumerateChildNodesWithName("enemyBullet"){
            enemyBulletNode, _ in
            let bulletFrame = enemyBulletNode.frame
            let youFrame = youNode.frame
                if CGRectIntersectsRect(bulletFrame, youFrame){
                    self.paused = true
                }
            }
        }
    }
}
