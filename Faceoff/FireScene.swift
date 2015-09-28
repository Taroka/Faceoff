//
//  FireScene.swift
//  Faceoff
//
//  Created by 圳 樊 on 15/9/21.
//  Copyright © 2015年 圳 樊. All rights reserved.
//

import UIKit
import SpriteKit

extension SKAction {
    static func spiral(startRadius startRadius: CGFloat, endRadius: CGFloat,
        centerPoint: CGPoint, duration: NSTimeInterval, type: Int) -> SKAction {
            
            // The distance the node will travel away from/towards the
            // center point, per revolution.
            
            let action = SKAction.customActionWithDuration(duration) { node, time in
                
                // The equation, r = a + bθ
                let radius = startRadius -  (startRadius - endRadius) * (time / CGFloat(duration))
                node.position = position(centerPoint, time: time, duration: duration, type: type)
                print(node.position.y)
                if time == CGFloat(duration) {
                    print("remove")
                    node.removeFromParent()
                }
                if type == 0 {
                    node.setScale(radius * 0.8 / startRadius)
                } else {
                    node.setScale((startRadius - radius) * 0.8 / startRadius)
                }
            }
            
            return action
    }
}

func position(center: CGPoint, time: CGFloat, duration: NSTimeInterval, type: Int) -> CGPoint {
    
    var x: CGFloat = 0.0
    let k: CGFloat = 490.0
    if time < CGFloat(duration) / 2 {
        x = time * 2 * (k - center.x) / CGFloat(duration) + center.x
    } else {
        x = (2 * (center.x - k) * time / CGFloat(duration)) + 2 * k - center.x
    }
    
    if type == 0 {
        print("x is \(x), y is \(600 * time / CGFloat(duration))")
        return CGPoint(x: x, y: 600 * time / CGFloat(duration))
    } else {
        return CGPoint(x: x, y: 600 - 600 * time / CGFloat(duration))
    }
}


class FireScene: SKScene {
    
    var fireAnimation = [SKTexture]()
    
    /* View loads */
    override func didMoveToView(view: SKView) {
        self.initFireScene()
    }
    
    /* Set up level */
    func initFireScene() {
        let spacemanAtlas = SKTextureAtlas(named: "spaceman")
        
        for index in 1...spacemanAtlas.textureNames.count {
            let imgName = String(format: "spaceman%01d", index)
            fireAnimation += [spacemanAtlas.textureNamed(imgName)]
        }
    }
    
    /* Animate the fire */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let spacemanNode = self.childNodeWithName("spacemanNode")
        
        if(spacemanNode != nil) {
            let animation = SKAction.animateWithTextures(fireAnimation, timePerFrame: 0.02)
            spacemanNode?.runAction(animation)
        }
        
        for touch in touches {
            let touchLocation = touch.locationInNode(self)
            if touchLocation.y < frame.midY {
                oneAttackCircle()
            } else {
                oneDefenseCircle()
            }
        }
    }
    
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
        self.addChild(Circle)
    }

}
