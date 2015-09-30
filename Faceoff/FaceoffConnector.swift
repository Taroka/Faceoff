//
//  FaceoffConnector.swift
//  Faceoff
//
//  Created by Huaying Tsai on 9/20/15.
//  Copyright © 2015 huaying. All rights reserved.
//

import Foundation
import MultipeerConnectivity


class FaceoffConnector: MPCManagerDelegate{
    
    var mpcManager: MPCManager
    var isStart = false
    
    init(){
        
        mpcManager = MPCManager()
        mpcManager.delegate = self
    }
    
    func start(){
        if !isStart {
            print("start connector")
            mpcManager.browser.startBrowsingForPeers()
            mpcManager.advertiser.startAdvertisingPeer()
            isStart = true
        }
    }
    
    func stop(){
        if isStart {
            print("stop connector")
            mpcManager.browser.stopBrowsingForPeers()
            mpcManager.advertiser.stopAdvertisingPeer()
            mpcManager.foundPeers.removeAll()
            isStart = false
        }

    }
    
    // MARK: MPCManagerDelegate method implementation
    func fonudPeer(peerID: MCPeerID) {
        NSNotificationCenter.defaultCenter().postNotificationName("foundPeerNotification", object: nil)
    }
    
    func losePeer() {
        NSNotificationCenter.defaultCenter().postNotificationName("losePeerNotification", object: nil)
    }
    
    func invited(fromPeer: MCPeerID) {
        print("invited")
        mpcManager.invitationHandler(true,mpcManager.session)
    }
    
    func connected(peerID: MCPeerID){
        
        NSNotificationCenter.defaultCenter().postNotificationName("connectNotification", object: peerID)
    }
    
    func sendData(data: Dictionary<String, AnyObject>){
        let serializerData = NSKeyedArchiver.archivedDataWithRootObject(data)

        do {
            try mpcManager.session.sendData(serializerData, toPeers: mpcManager.foundPeers, withMode: MCSessionSendDataMode.Reliable)
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    func reiceveData(data: NSData) {
        NSNotificationCenter.defaultCenter().postNotificationName("receivedRemoteDataNotification", object: data)
    }
    
    // MARK: Custom method implementation
    func invitePeer(peerID: MCPeerID){
        print("invite")
        mpcManager.browser.invitePeer(peerID, toSession: mpcManager.session, withContext: nil, timeout: 20)
    }
    
    func getPeers() -> [MCPeerID]{
        return mpcManager.foundPeers
    }
    
}