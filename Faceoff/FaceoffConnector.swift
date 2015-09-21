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
    
    init(){
        print("start connector")
        mpcManager = MPCManager()
        
        mpcManager.browser.startBrowsingForPeers()
        mpcManager.advertiser.startAdvertisingPeer()
        mpcManager.delegate = self
    }
    
    // MARK: MPCManagerDelegate method implementation
    func fonudPeer(peerID: MCPeerID) {
        mpcManager.browser.invitePeer(peerID, toSession: mpcManager.session, withContext: nil, timeout: 50)

    }
    func losePeer() {
        NSNotificationCenter.defaultCenter().postNotificationName("losePeerNotification", object: nil)

    }
    func invite(fromPeer: MCPeerID) {
        mpcManager.invitationHandler(true,mpcManager.session)
    }
    func connect(peerID: MCPeerID){
        NSNotificationCenter.defaultCenter().postNotificationName("connectNotification", object: nil)
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
}