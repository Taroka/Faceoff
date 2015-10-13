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
    
    override func didMoveToView(view: SKView) {
        
        connector = appDelegate.connector
        connector.start()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "foundPeer:", name: "foundPeerNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "losePeer:", name: "losePeerNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "connected:", name: "connectNotification", object: nil)
        addChild(scrollnode)
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
//        let list = [String](count: 20, repeatedValue: "DisplayName")
//        for (i,el) in list.enumerate() {
//            let peerNode = SKLabelNode()
//            peerNode.text = el;
//            peerNode.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGFloat(i*40)+50)
//            scrollnode.addChild(peerNode)
//        }
    }
    
    func statusLabel(statusName: String) -> SKLabelNode{
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = statusName
        label.fontSize = 50
        label.position = CGPointMake(frame.midX, frame.midY)
        self.addChild(label)
        return label
    }
    
    
    func foundPeer(notification: NSNotification){
        updateScene()
      
        print("foundPeer",peers)
    }
    func losePeer(notification: NSNotification){
        updateScene()
        
        statusLabel("Lost Peer")

        print("losePeer",peers)

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
                            
                            statusLabel("Connecting....")
                        }
                    }
                }
            }
        }
    }

    func transitionForNextScene(){
        removeAllChildren()
        let transition = SKTransition.revealWithDirection(SKTransitionDirection.Up, duration: 0.5)
        let nextScene = SelectWeaponScene(size: scene!.size)
        nextScene.scaleMode = .AspectFill
        nextScene.backgroundColor = UIColor.grayColor()
        scene?.view?.presentScene(nextScene, transition: transition)
    }
    
    
    override func update(currentTime: NSTimeInterval) {
        
    }
}