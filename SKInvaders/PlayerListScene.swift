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
    
    override func didMoveToView(view: SKView) {
        
        connector = appDelegate.connector
        connector.start()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "foundPeer:", name: "foundPeerNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "losePeer:", name: "losePeerNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "connected:", name: "connectNotification", object: nil)
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "invited:", name: "invitedNotification", object: nil)
        
 
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
        transitionForNextScene()
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
    }

    func transitionForNextScene(){
        removeAllChildren()
        let transition = SKTransition.revealWithDirection(SKTransitionDirection.Up, duration: 0.5)
        let nextScene = DualGameScene(size: scene!.size)
        nextScene.scaleMode = .AspectFill
        nextScene.backgroundColor = UIColor.grayColor()
        scene?.view?.presentScene(nextScene, transition: transition)
    }
    
    
    override func update(currentTime: NSTimeInterval) {
        
    }
}