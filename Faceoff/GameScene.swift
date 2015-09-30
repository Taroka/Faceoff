//
//  GameScene.swift
//  Faceoff
//
//  Created by Huaying Tsai on 9/20/15.
//  Copyright (c) 2015 huaying. All rights reserved.
//

import SpriteKit
import AVFoundation


class GameScene: SKScene {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var btns: Array<SKSpriteNode>?
    var otherBtns: Array<SKSpriteNode>?
    var bgMusic:AVAudioPlayer = AVAudioPlayer()
    var gameOver = false
    var isBegin = false
    var isEnd = false
    var attackCount = 0
    var alertLight = false
    
    override func didMoveToView(view: SKView) {
        start()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "losePeer:", name: "losePeerNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveRemoteData:", name: "receivedRemoteDataNotification", object: nil)
    }
    func start() {
        loadBackground()
        loadHero()
        loadButton()
        //loadGameOverLayer()
        
        gameOver = false
    }
    func restart() {
        
        attackCount = 0
        isBegin = false
        isEnd = false
        //score = 0
        removeAllChildren()
        start()
    }
    
    //拿來放跳出來的東西 (武器, 道具)
    func addSprite(imageNamed: String, location: CGPoint, scale: CGFloat) -> SKSpriteNode {
        let sprite = SKSpriteNode(imageNamed:imageNamed)
        
        sprite.xScale = scale
        sprite.yScale = scale
        sprite.position = location
        
        //let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        //sprite.runAction(SKAction.repeatActionForever(action))
        
        self.addChild(sprite)
        return sprite
    }

    func losePeer(notification: NSNotification){
        
        for btn in otherBtns!{
            btn.removeFromParent()
        }
    }

    func showAlertLight(){
        let light = SKLightNode();
        light.position = CGPoint(x: frame.midX, y: frame.midY)
        // light.falloff = 1
        // light.ambientColor = ambientColor
        light.lightColor = UIColor.redColor()
        light.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.AlertAudioName.rawValue, waitForCompletion: false))
        addChild(light)
        
    }
    
    func attackedCrash(location: CGPoint){
        
        //should be rebuild
        var theCrash = ""
        if (attackCount % 2 == 0) {
            theCrash = "crush"
        }
        else {
            theCrash = "crush2"
        }
        //        else if (attackCount % 4 == 0){
        //            theCrash = "crush3"
        //        }
        //
        
        
        
        
        attackCount++
        //FaceoffScreenCrashEffectAudioName
        let sprite = SKSpriteNode(imageNamed: theCrash)
        sprite.xScale = 2
        sprite.yScale = 2
        sprite.position = location
        
        
        sprite.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.LittleBombName.rawValue, waitForCompletion: false))
        
        self.addChild(sprite)
        
    }

    func receiveRemoteData(notification: NSNotification){
        let receivedData = NSKeyedUnarchiver.unarchiveObjectWithData(notification.object as! NSData) as! Dictionary<String,AnyObject>
        
        
        if let location = receivedData["location"] as? NSValue{
            attackedCrash(location.CGPointValue())
        }
        
        if let index = receivedData["index"] as? Int{
            
            for btn in otherBtns! {
                btn.position.y = 450
            }
            if index != -1 {
                otherBtns![otherBtns!.count-1-index].position.y = 400
            }
        }
        
        if (attackCount > 5){
            showAlertLight()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            //addSpaceship(location)
            //appDelegate.connector.sendData(["location": NSValue(CGPoint: location)])
            var n = true
            for (index,btn) in btns!.enumerate() {
                if btn.containsPoint(location){
                    appDelegate.connector.sendData(["index": index])
                    n = false
                    btn.position.y = 150
                }else{
                    btn.position.y = 100
                }
            }
            if n {
                appDelegate.connector.sendData(["index": Int(-1)])
            }
            
            //let touchLocation = touch.locationInNode(self)
            if location.y < frame.midY {
                oneAttackCircle()
            } else {
                oneDefenseCircle()
            }

        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    /* 準備使用 */
    func oneAttackCircle(){
        let Circle = SKShapeNode(circleOfRadius: 50 )
        
        Circle.position = CGPointMake(frame.midX, frame.midY / 10)  //Middle of Screen
        Circle.strokeColor = SKColor.blackColor()
        Circle.glowWidth = 1.0
        Circle.fillColor = SKColor.orangeColor()
        let spiral = SKAction.spiral(startRadius: 50,
            endRadius: 0,
            centerPoint: Circle.position,
            duration: 1.0,
            type: 0)
        Circle.runAction(spiral)
        //Audio Effect
        Circle.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.AttackAudioName.rawValue, waitForCompletion: false))
        
        self.addChild(Circle)
    }
    
    func oneDefenseCircle(){
        let Circle = SKShapeNode(circleOfRadius: 50 )
        
        Circle.position = CGPointMake(frame.midX, frame.midY * 9 / 10)  //Middle of Screen
        Circle.strokeColor = SKColor.blackColor()
        Circle.glowWidth = 1.0
        Circle.fillColor = SKColor.orangeColor()
    
        let spiral = SKAction.spiral(startRadius: 20,
            endRadius: 0,
            centerPoint: Circle.position,
            duration: 1.0,
            type: 1)
        Circle.runAction(spiral)
        //Audio Effect
        Circle.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.AttackedAudioName.rawValue, waitForCompletion: false))
        self.addChild(Circle)
    }
    
    
}

private extension GameScene {
    func loadBackground() {
        guard let _ = childNodeWithName("background") as! SKSpriteNode? else {
            let texture = SKTexture(image: UIImage(named: "background3.jpg")!)
            let node = SKSpriteNode(texture: texture)
            node.xScale = 1.5
            node.yScale = 1.5
            node.position = CGPoint(x: frame.midX, y: frame.midY)
            node.zPosition = FaceoffGameSceneZposition.BackgroundZposition.rawValue
            //    self.physicsWorld.gravity = CGVectorMake(0, gravity)
            
            addChild(node)
            return
        }
    }
    
    // Just put a rival for demo
    func loadHero() {
        let hero = SKSpriteNode(imageNamed: "cute")
        hero.name = FaceoffGameSceneChildName.HeroName.rawValue
        hero.position = CGPoint(x: frame.midX * 1.5, y: frame.midY * 1.5)
        hero.xScale = 0.25
        hero.yScale = 0.25
        hero.zPosition = FaceoffGameSceneZposition.HeroZposition.rawValue
        hero.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(16, 18))
        hero.physicsBody?.affectedByGravity = false
        hero.physicsBody?.allowsRotation = false
        
        addChild(hero)
    }
    
    func loadButton() {
        btns = [
            addSprite("Destroyer", location: CGPoint(x: 80.0,y: 100.0),scale: 0.46),
            addSprite("Bro", location: CGPoint(x: 200.0,y: 100.0),scale: 0.7),
            addSprite("Bro2", location: CGPoint(x: 320.0,y: 100.0),scale: 0.7)
        ]
        otherBtns = [
            addSprite("Bro2", location: CGPoint(x: 80.0,y: 450.0),scale: 0.7),
            addSprite("Bro", location: CGPoint(x: 200.0,y: 450.0),scale: 0.7),
            addSprite("Destroyer", location: CGPoint(x: 320.0,y: 450.0),scale: 0.46)
        ]
    }
    
}