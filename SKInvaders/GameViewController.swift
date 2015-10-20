//
//  GameViewController.swift
//  Faceoff
//
//  Created by Huaying Tsai on 9/20/15.
//  Copyright (c) 2015 huaying. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {
    
    
    //var musicPlayer:AVAudioPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let scene = SelectWeaponScene(size: view.bounds.size)
        let scene = MainScene(size: view.bounds.size)
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
        
        
    }
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        musicPlayer = setupAudioPlayerWithFile("fighton", type: "wav")
//        musicPlayer.numberOfLoops = -1
//        //musicPlayer.play()
//        // 如果開始了就停止播放
//    }
    
//    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer  {
//        let url = NSBundle.mainBundle().URLForResource(file as String, withExtension: type as String)
//        var audioPlayer:AVAudioPlayer?
//        
//        do {
//            try audioPlayer = AVAudioPlayer(contentsOfURL: url!)
//        } catch {
//            print("NO AUDIO PLAYER")
//        }
//        
//        return audioPlayer!
//    }
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
