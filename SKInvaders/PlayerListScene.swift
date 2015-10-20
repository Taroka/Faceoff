//
//  PlayerListScene.swift
//  Faceoff
//
//  Created by Huaying Tsai on 9/28/15.
//  Copyright © 2015 huaying. All rights reserved.
//

import SpriteKit
import MultipeerConnectivity

class PlayerListScene: SKScene {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var connector: FaceoffConnector!
    var peers: [MCPeerID]?
    var scrollnode = ScrollNode()
    var statusnode = SKLabelNode(fontNamed: "Chalkduster")
    var 返回按鈕: SKNode! = nil
    var battleMode = false
    
    override func didMoveToView(view: SKView) {
        
        connector = appDelegate.connector
        connector.start()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "foundPeer:", name: "foundPeerNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "losePeer:", name: "losePeerNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "connected:", name: "connectNotification", object: nil)
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "invited:", name: "invitedNotification", object: nil)
        
 
        返回按鈕 = SKSpriteNode(color: UIColor.grayColor(), size: CGSize(width: 50, height: 30))
        返回按鈕.position = CGPoint(x:CGRectGetMinX(self.frame)+40,y:CGRectGetMinY(self.frame)+CGFloat(30.0))
        addChild(返回按鈕)
        
        let 返回文字 = SKLabelNode(fontNamed:"Chalkduster")
        返回文字.text = "Back";
        返回文字.fontSize = 14;
        返回文字.position = CGPoint(x:CGFloat(0),y:CGFloat(-5))
        返回按鈕.addChild(返回文字)

        
        addChild(scrollnode)
        
        statusnode.fontSize = 50
        statusnode.position = CGPointMake(frame.midX, frame.midY)
        statusnode.text = "Hi"
        addChild(statusnode)
        scrollnode.setScrollingView(view)
        updateScene()
       
    }
    
    func updateScene(){
        scrollnode.removeAllChildren()
        peers = connector.getPeers()
        if peers != nil {
            for (i,peer) in peers!.enumerate() {
                let peerNode = SKLabelNode()
                peerNode.text = peer.displayName;
                peerNode.fontSize = 30;
                peerNode.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGFloat(i*40)+50)
                scrollnode.addChild(peerNode)
                }
        }
    }
    
    func statusLabel(statusName: String) -> SKLabelNode{

        statusnode.text = statusName

        return statusnode
    }
    
    
    func foundPeer(notification: NSNotification){
        updateScene()
        
        //statusLabel("Found Peer")
      
        print("foundPeer",peers)
    }
    func losePeer(notification: NSNotification){
        updateScene()
        
        statusLabel("Lost Peer")

        print("losePeer",peers)

    }
    
    func invited(notification: NSNotification){
        updateScene()
        statusLabel("Invited!")
        
    }
    
    
    func connected(notification: NSNotification){
        print("connected")
        
        statusLabel("Connected")
        
        if battleMode{
            transitionForNextScene(SelectWeaponScene(size: scene!.size))
        }else{
            transitionForNextScene(DualGameScene(size: scene!.size))
        }
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let location = touches.first?.locationInNode(scrollnode){
            let peerNodes = scrollnode.children
            for peerNode in peerNodes{
                if peerNode.containsPoint(location){
                    for peer in peers! {
                        if peer.displayName == (peerNode as! SKLabelNode).text {
                            connector.invitePeer(peer)
                            
                            statusLabel("Invite!")
                        }
                    }
                }
            }
        }
        
        if let location = touches.first?.locationInNode(self){
            if 返回按鈕.containsPoint(location){
                返回按鈕.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.ButtonAudioName.rawValue, waitForCompletion: false))
                let nextScene = MainScene(size: scene!.size)
                //nextScene.scaleMode = SKSceneScaleMode.AspectFill
                transitionForNextScene(nextScene)
            }
        }
    }

//    func transitionForNextScene(){
//        removeAllChildren()
//        let transition = SKTransition.revealWithDirection(SKTransitionDirection.Up, duration: 0.5)
//        let nextScene = DualGameScene(size: scene!.size)
//        nextScene.scaleMode = .AspectFill
//        nextScene.backgroundColor = UIColor.grayColor()
//        scene?.view?.presentScene(nextScene, transition: transition)
//    }
    
    func transitionForNextScene(nextScene: SKScene){
        let transition = SKTransition.revealWithDirection(SKTransitionDirection.Up, duration: 0.5)
        removeAllChildren()
        nextScene.scaleMode = .AspectFill
        //nextScene.backgroundColor = UIColor.grayColor()
        scene?.view?.presentScene(nextScene, transition: transition)
    }

    
    
    override func update(currentTime: NSTimeInterval) {
        
    }
}