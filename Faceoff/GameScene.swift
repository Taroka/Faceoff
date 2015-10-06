//
//  GameScene.swift
//  Faceoff
//
//  Created by Huaying Tsai on 9/20/15.
//  Copyright (c) 2015 huaying. All rights reserved.
//

import SpriteKit
import Darwin

var screen_h: CGFloat = 0
var screen_w: CGFloat = 0

var v0x: CGFloat = 0
var v0y: CGFloat = 0
var ax: CGFloat = 0
var ay: CGFloat = 0
var T: CGFloat = 0
var startX: CGFloat = 0
var startY: CGFloat = 0
var endX: CGFloat = 0
var endY: CGFloat = 0
var xRatio: CGFloat = 0
var yRatio: CGFloat = 0

//the following vars are for straight movement
var vxStraight: CGFloat = 0
var vyStraight: CGFloat = 0
let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

enum WeaponType {
    case cannon
    case rocket
    case gun
}

class WeaponData {
    var position: CGPoint! = nil
    var id: WeaponType! = nil
    var scale: CGFloat! = nil
    init(position: CGPoint, id: WeaponType, scale: CGFloat) {
        self.position = position
        self.id = id
        self.scale = scale
    }
}

extension SKAction {
    static func curve(startRadius startRadius: CGFloat, endRadius: CGFloat,
        centerPoint: CGPoint, duration: NSTimeInterval, type: Int) -> SKAction {
            
            
            let action = SKAction.customActionWithDuration(duration) { node, time in
                // The equation, r = a + bθ
                let radius = startRadius -  (startRadius - endRadius) * (time / CGFloat(duration))
                let pos = position(centerPoint, time: time, duration: duration, type: type)
                if type == 0 {
                    node.position = pos
                    node.setScale(radius * 0.8 / startRadius)
                    if node.position.x > startX * 3 {
                        node.removeFromParent()
                        print("remove")
                    }
                } else {
                    node.position = CGPoint(x:screen_w - pos.x, y:screen_h - pos.y)
                    node.setScale((startRadius - radius) * 0.8 / startRadius)
                    if(node.position.x < startX) {
                        node.removeFromParent()
                        print("remove")
                    }
                }
                //let scale = (startRadius - radius) * 0.8 / startRadius
                //var data = scale
                //data += Int(node.position.x * 10) + Int(node.position.y * 10 * 10000)
                //var data: Int = 0
                //data += Int(scale * 100.0)
                //data += Int(node.position.x) * 100
                //data += Int(node.position.y) * 100 * 10000
                //print(scale)
                //print(node.position.x)
                //print(node.position.y)
                //print(data)
                //appDelegate.connector.sendData(["attack": data])
                
                if time == CGFloat(duration) {
                    print("remove")
                    node.removeFromParent()
                }
            }
            
            return action
    }
    
    static func rocketPath(startRadius startRadius: CGFloat, endRadius: CGFloat, upMost: CGFloat,
        duration: NSTimeInterval, type: Int) -> SKAction {
            let action = SKAction.customActionWithDuration(duration) { node, time in
                // The equation, r = a + bθ
                let a: CGFloat = ay * 0.75

                var x: CGFloat = 0.0
                var y: CGFloat = 0.0
                
                if type == 0 {
                    y = v0y * time + 0.5 * a * time * time + startY
                    if v0y + a * time > 0 {
                        x = startX
                    } else {
                        x = endX
                        node.setScale(endRadius / startRadius)
                    }
                    node.position = CGPoint(x: x, y: y)
                    if x == endX && y <= endY {
                        print("remove")
                        node.removeFromParent()
                    }
                }
                /*else {
                    y = v0y * time + 0.5 * a * time * time + endY
                    if v0y + a * time > 0 {
                        x = endX
                        node.setScale(endRadius / startRadius)
                    } else {
                        x = startX
                    }
                    node.position = CGPoint(x: x, y: y)
                    if x == startX && y >= startY {
                        print("remove")
                        node.removeFromParent()
                    }
                }*/
            }
            
            return action
    }
    
    static func curveOfStraight(startRadius startRadius: CGFloat, endRadius: CGFloat,
        centerPoint: CGPoint, duration: NSTimeInterval, type: Int) -> SKAction {
            
            
            let action = SKAction.customActionWithDuration(duration) { node, time in
                // The equation, r = a + bθ
                let radius = startRadius -  (startRadius - endRadius) * (time / CGFloat(duration))
                let pos = positionOfStraight(centerPoint, time: time, duration: duration, type: type)
                if type == 0 {
                    node.position = pos
                    node.setScale(radius * 0.8 / startRadius)
                    if node.position.x > startX * 3 {
                        node.removeFromParent()
                        print("remove")
                    }
                } else {
                    node.position = CGPoint(x: screen_w - pos.x, y: screen_h - pos.y)
                    node.setScale((startRadius - radius) * 0.8 / startRadius)
                    if node.position.x < startX {
                        node.removeFromParent()
                        print("remove")
                    }
                }
            }
            
            return action
    }
}

func position(center: CGPoint, time: CGFloat, duration: NSTimeInterval, type: Int) -> CGPoint {
    
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    x = v0x * time + 0.5 * ax * time * time + startX
    y = v0y * time + 0.5 * ay * time * time + startY
    if type == 0 {
        return CGPoint(x: x, y: y)
    } else {
        return CGPoint(x: x, y: y)
    }
    
}

func positionOfStraight(center: CGPoint, time: CGFloat, duration: NSTimeInterval, type: Int) -> CGPoint {
    
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    x =  vxStraight * time  + startX
    y =  vyStraight * time  + startY
    if type == 0 {
        return CGPoint(x: x, y: y)
    } else {
        return CGPoint(x: x, y: y)
    }
}


class GameScene: SKScene {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var btns: Array<SKSpriteNode>?
    var otherBtns: Array<SKSpriteNode>?
    
    var 大炮按钮: SKNode! = nil
    var 火箭按钮: SKNode! = nil
    var gun按钮: SKNode! = nil
    var 被大炮射: SKShapeNode = SKShapeNode(circleOfRadius: 50)
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 20;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
        
        
        /*btns = [
            addSprite("Destroyer", location: CGPoint(x: 80.0,y: 100.0),scale: 0.46),
            addSprite("Bro", location: CGPoint(x: 200.0,y: 100.0),scale: 0.7),
            addSprite("Bro2", location: CGPoint(x: 320.0,y: 100.0),scale: 0.7)
            ]*/

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "connect:", name: "connectNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "losePeer:", name: "losePeerNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveRemoteData:", name: "receivedRemoteDataNotification", object: nil)
        
        xRatio = 4
        yRatio = 6
        T = 1.0
        v0x = -self.view!.frame.size.width / (T * 1.2)
        v0y = yRatio *  self.view!.frame.size.height /  (T * 3)
        ax = -v0x * xRatio / (T * 1)//1.3)
        ay = -v0y * yRatio / (T * 4.3)//4)
        
        screen_h = (self.view?.frame.size.height)!
        screen_w = (self.view?.frame.size.width)!
        
        //the following vars are for straight movement
        vxStraight = self.view!.frame.size.width / (T*1.5)
        vyStraight = self.view!.frame.size.height / (T)
        
        大炮按钮 = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: self.view!.frame.size.width / 6, height: 40))
        大炮按钮.position = CGPoint(x: self.view!.frame.size.width / 2, y: 100)
        火箭按钮 = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width: self.view!.frame.size.width / 6, height: 40))
        火箭按钮.position = CGPoint(x: self.view!.frame.size.width / 2 + self.view!.frame.size.width / 6, y: 100)
        gun按钮 = SKSpriteNode(color: UIColor.blueColor(), size: CGSize(width: self.view!.frame.size.width / 6, height: 40))
        gun按钮.position = CGPoint(x: self.view!.frame.size.width / 2  + self.view!.frame.size.width / 3, y: 100)
        
        被大炮射.position = CGPointMake(-100, -100)
        被大炮射.strokeColor = SKColor.blackColor()
        被大炮射.glowWidth = 1.0
        被大炮射.fillColor = SKColor.orangeColor()
        
        self.addChild(大炮按钮)
        self.addChild(火箭按钮)
        self.addChild(gun按钮)
        self.addChild(被大炮射)
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
        
        /*otherBtns = [
            addSprite("Bro2", location: CGPoint(x: 80.0,y: 550.0),scale: 0.7),
            addSprite("Bro", location: CGPoint(x: 200.0,y: 550.0),scale: 0.7),
            addSprite("Destroyer", location: CGPoint(x: 320.0,y: 550.0),scale: 0.46)
        ]*/
    }
    
    func receiveRemoteData(notification: NSNotification){
        let receivedData = NSKeyedUnarchiver.unarchiveObjectWithData(notification.object as! NSData) as! Dictionary<String,AnyObject>
        
        if let weapontype = receivedData["attack"] as? Int {
            if weapontype == 1 {
                oneAttackCircle(1)
            }
            else if weapontype == 2 {
                rocketAttack(1)
            }
            else {
                oneAttackStraight(1)
            }
        }
        
        //if let location = receivedData["location"] as? NSValue{
            //addSpaceship(location.CGPointValue())
        //}
        /*if let index = receivedData["index"] as? Int{

            for btn in otherBtns! {
                btn.position.y = 550
            }
            if index != -1 {
                otherBtns![otherBtns!.count-1-index].position.y = 500
            }
        }*/
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        /*for touch in touches {
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
        }*/
        
        if let location = touches.first?.locationInNode(self){
            if 大炮按钮.containsPoint(location){
                oneAttackCircle(0)
                appDelegate.connector.sendData(["attack": Int(1)])
            }
            if 火箭按钮.containsPoint(location){
                appDelegate.connector.sendData(["attack": Int(2)])
                rocketAttack(0)
            }
            if gun按钮.containsPoint(location){
                appDelegate.connector.sendData(["attack": Int(3)])
                oneAttackStraight(0)
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func oneAttackCircle(type: Int){
        let Circle = SKShapeNode(circleOfRadius: 50 )
        startX = self.view!.frame.size.width / xRatio
        startY = self.view!.frame.size.height / yRatio
        endX = self.view!.frame.size.width * (xRatio - 1.0) / xRatio
        endY = self.view!.frame.size.height * (yRatio - 1.0) / yRatio
        Circle.position = CGPointMake(startX, startY)
        Circle.strokeColor = SKColor.blackColor()
        Circle.glowWidth = 1.0
        Circle.fillColor = SKColor.orangeColor()
        let spiral = SKAction.curve(startRadius: 20,
            endRadius: 1,
            centerPoint: Circle.position,
            duration: 1.0,
            type: type)
        Circle.runAction(spiral)
        self.addChild(Circle)
    }
    
    func rocketAttack(type: Int){
        let Circle = SKShapeNode(circleOfRadius: 10 )
        startX = self.view!.frame.size.width / xRatio
        startY = self.view!.frame.size.height / yRatio
        endX = self.view!.frame.size.width * (xRatio - 1.0) / xRatio
        endY = self.view!.frame.size.height * (yRatio - 1.0) / yRatio
        Circle.position = CGPointMake(startX, startY)
        Circle.strokeColor = SKColor.blackColor()
        Circle.glowWidth = 1.0
        Circle.fillColor = SKColor.orangeColor()
        let spiral = SKAction.rocketPath(startRadius: 10, endRadius: 6, upMost: self.view!.frame.size.height,duration: 2.0, type: type)
        Circle.runAction(spiral)
        self.addChild(Circle)
    }
    
    func oneAttackStraight(type: Int){
        let Circle = SKShapeNode(circleOfRadius: 50 )
        startX = self.view!.frame.size.width / xRatio
        startY = self.view!.frame.size.height / yRatio
        Circle.position = CGPointMake(startX, startY)
        Circle.strokeColor = SKColor.blackColor()
        Circle.glowWidth = 1.0
        Circle.fillColor = SKColor.darkTextColor()
        let spiral = SKAction.curveOfStraight(startRadius: 20,
            endRadius: 1,
            centerPoint: Circle.position,
            duration: 1.0,
            type: type)
        Circle.runAction(spiral)
        self.addChild(Circle)
        
    }

}
