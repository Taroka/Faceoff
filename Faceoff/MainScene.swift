//
//  MainScene.swift
//  Faceoff
//
//  Created by Huaying Tsai on 9/26/15.
//  Copyright © 2015 huaying. All rights reserved.
//

import SpriteKit

class MainScene: SKScene {
    var 製造角色按鈕: SKNode! = nil
    var 進入遊戲按鈕: SKNode! = nil
    let a = ScrollNode()
    
    override func didMoveToView(view: SKView) {
        製造角色按鈕 = SKSpriteNode(color: UIColor.grayColor(), size: CGSize(width: 200, height: 40))
        製造角色按鈕.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame)+CGFloat(25.0))
        addChild(製造角色按鈕)
        
        let 製造角色文字 = SKLabelNode(fontNamed:"Chalkduster")
        製造角色文字.text = "Create a character";
        製造角色文字.fontSize = 14;
        製造角色文字.position = CGPoint(x:CGFloat(0),y:CGFloat(-5))
        製造角色按鈕.addChild(製造角色文字)
        
        進入遊戲按鈕 = SKSpriteNode(color: UIColor.grayColor(), size: CGSize(width: 200, height: 40))
        進入遊戲按鈕.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame)-CGFloat(25.0))
        addChild(進入遊戲按鈕)
        
        let 進入遊戲文字 = SKLabelNode(fontNamed:"Chalkduster")
        進入遊戲文字.text = "Play";
        進入遊戲文字.fontSize = 14;
        進入遊戲文字.position = CGPoint(x:CGFloat(0),y:CGFloat(-5))
        進入遊戲按鈕.addChild(進入遊戲文字)
        
        a.position = CGPoint(x:0,y:0)
        let b = SKLabelNode()
        b.text = "Top"
        b.position = CGPoint(x:50,y:2000-50)
        let c = SKLabelNode()
        c.text = "Bottom"
        c.position = CGPoint(x:50,y:50)
        let d = SKSpriteNode(color: UIColor.brownColor(), size: CGSize(width: 300, height: 300))
        d.position = CGPoint(x:200,y:500)
        a.addChild(b)
        a.addChild(c)
        a.addChild(d)
        addChild(a)
        a.setScrollingView(view)
        
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let location = touches.first?.locationInNode(self){
            if 製造角色按鈕.containsPoint(location){
                print("tapped")
            }
            if 進入遊戲按鈕.containsPoint(location){
                let transition = SKTransition.revealWithDirection(SKTransitionDirection.Up, duration: 0.5)
                
                let nextScene = PlayModeScene(size: scene!.size)
                nextScene.scaleMode = .AspectFill
                
                scene?.view?.presentScene(nextScene, transition: transition)
            }
        }
    }
    override func update(currentTime: NSTimeInterval) {
        
    }
}