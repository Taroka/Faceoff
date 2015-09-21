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
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 45;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveRemoteData:", name: "receivedRemoteDataNotification", object: nil)
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
    
    func receiveRemoteData(notification: NSNotification){
        let receivedData = NSKeyedUnarchiver.unarchiveObjectWithData(notification.object as! NSData) as! Dictionary<String,AnyObject>
        
        if let location = receivedData["location"] as? NSValue{
            addSpaceship(location.CGPointValue())
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            addSpaceship(location)
            appDelegate.connector.sendData(["location": NSValue(CGPoint: location)])
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
