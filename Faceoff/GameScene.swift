//
//  GameScene.swift
//  Faceoff
//
//  Created by Huaying Tsai on 9/20/15.
//  Copyright (c) 2015 huaying. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var btns: Array<SKSpriteNode>?
    var otherBtns: Array<SKSpriteNode>?
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 20;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
        
        
        btns = [
            addSprite("Destroyer", location: CGPoint(x: 80.0,y: 100.0),scale: 0.46),
            addSprite("Bro", location: CGPoint(x: 200.0,y: 100.0),scale: 0.7),
            addSprite("Bro2", location: CGPoint(x: 320.0,y: 100.0),scale: 0.7)
            ]

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "connect:", name: "connectNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "losePeer:", name: "losePeerNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveRemoteData:", name: "receivedRemoteDataNotification", object: nil)
    }
   

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
    func addSpaceship(location: CGPoint){
        let sprite = SKSpriteNode(imageNamed:"Spaceship")
        
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        sprite.position = location
        
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        sprite.runAction(SKAction.repeatActionForever(action))
        
        self.addChild(sprite)

    }
    func losePeer(notification: NSNotification){
        
        for btn in otherBtns!{
            btn.removeFromParent()
        }
    }
    func connect(notification: NSNotification){
        
        otherBtns = [
            addSprite("Bro2", location: CGPoint(x: 80.0,y: 550.0),scale: 0.7),
            addSprite("Bro", location: CGPoint(x: 200.0,y: 550.0),scale: 0.7),
            addSprite("Destroyer", location: CGPoint(x: 320.0,y: 550.0),scale: 0.46)
        ]
    }
    
    func receiveRemoteData(notification: NSNotification){
        let receivedData = NSKeyedUnarchiver.unarchiveObjectWithData(notification.object as! NSData) as! Dictionary<String,AnyObject>
        
        //if let location = receivedData["location"] as? NSValue{
            //addSpaceship(location.CGPointValue())
        //}
        if let index = receivedData["index"] as? Int{

            for btn in otherBtns! {
                btn.position.y = 550
            }
            if index != -1 {
                otherBtns![otherBtns!.count-1-index].position.y = 500
            }
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
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
