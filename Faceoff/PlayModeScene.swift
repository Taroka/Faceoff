//
//  PlayModeScene.swift
//  Faceoff
//
//  Created by Huaying Tsai on 9/26/15.
//  Copyright © 2015 huaying. All rights reserved.
//

import SpriteKit

class PlayModeScene: SKScene {
    var 選擇單人遊戲按鈕: SKNode! = nil
    var 選擇雙人遊戲按鈕: SKNode! = nil
    var 返回按鈕: SKNode! = nil
    
    override func didMoveToView(view: SKView) {
        選擇單人遊戲按鈕 = SKSpriteNode(color: UIColor.grayColor(), size: CGSize(width: 200, height: 40))
        選擇單人遊戲按鈕.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame)+CGFloat(50.0))
        addChild(選擇單人遊戲按鈕)
        
        let 製造角色文字 = SKLabelNode(fontNamed:"Chalkduster")
        製造角色文字.text = "Fight";
        製造角色文字.fontSize = 14;
        製造角色文字.position = CGPoint(x:CGFloat(0),y:CGFloat(-5))
        選擇單人遊戲按鈕.addChild(製造角色文字)
        
        選擇雙人遊戲按鈕 = SKSpriteNode(color: UIColor.grayColor(), size: CGSize(width: 200, height: 40))
        選擇雙人遊戲按鈕.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame))
        addChild(選擇雙人遊戲按鈕)
        
        let 進入遊戲文字 = SKLabelNode(fontNamed:"Chalkduster")
        進入遊戲文字.text = "2-Players Fight";
        進入遊戲文字.fontSize = 14;
        進入遊戲文字.position = CGPoint(x:CGFloat(0),y:CGFloat(-5))
        選擇雙人遊戲按鈕.addChild(進入遊戲文字)
        
        返回按鈕 = SKSpriteNode(color: UIColor.grayColor(), size: CGSize(width: 200, height: 40))
        返回按鈕.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame)-CGFloat(50.0))
        addChild(返回按鈕)
        
        let 返回文字 = SKLabelNode(fontNamed:"Chalkduster")
        返回文字.text = "Back";
        返回文字.fontSize = 14;
        返回文字.position = CGPoint(x:CGFloat(0),y:CGFloat(-5))
        返回按鈕.addChild(返回文字)

        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let location = touches.first?.locationInNode(self){
            if 選擇單人遊戲按鈕.containsPoint(location){
                print("single play")
                let nextScene = SelectWeaponScene(size: scene!.size)
                nextScene.backgroundColor = UIColor.grayColor()
                nextScene.scaleMode =  .AspectFill
                transitionForNextScene(nextScene)
                
            }else if 選擇雙人遊戲按鈕.containsPoint(location){
                print("multiplayer")
                let nextScene = PlayerListScene(size: scene!.size)
                nextScene.scaleMode = SKSceneScaleMode.AspectFill
                transitionForNextScene(nextScene)
                
            }else if 返回按鈕.containsPoint(location){
                let nextScene = MainScene(size: scene!.size)
                nextScene.scaleMode = SKSceneScaleMode.AspectFill
                transitionForNextScene(nextScene)
            }
        }
    }
    
    func transitionForNextScene(nextScene: SKScene){
        let transition = SKTransition.revealWithDirection(SKTransitionDirection.Up, duration: 0.5)
        
        scene?.view?.presentScene(nextScene, transition: transition)
    }
    
    override func update(currentTime: NSTimeInterval) {
        
    }
}