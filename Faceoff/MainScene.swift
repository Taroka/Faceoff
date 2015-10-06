//
//  MainScene.swift
//  Faceoff
//
//  Created by Huaying Tsai on 9/26/15.
//  Copyright © 2015 huaying. All rights reserved.
//

import UIKit
import GLKit
import SpriteKit



class MainScene: SKScene, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    var photoView: UIImageView!
    var layerView: UIImageView!
    
    var imagePicker: UIImagePickerController!
    
    let logo = UIImage(named: "headdd")!
    let mask = CALayer()
    
    var finalImg : UIImage!
    var imgForPlayer : UIImage!
    
    
    var 製造角色按鈕: SKNode! = nil
    var 進入遊戲按鈕: SKNode! = nil
    
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
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let location = touches.first?.locationInNode(self){
            if 製造角色按鈕.containsPoint(location){
                製造角色按鈕.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.ButtonAudioName.rawValue, waitForCompletion: false))

                //takePictures()
            }
            if 進入遊戲按鈕.containsPoint(location){
                進入遊戲按鈕.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.ButtonAudioName.rawValue, waitForCompletion: false))
                
                let transition = SKTransition.revealWithDirection(SKTransitionDirection.Up, duration: 0.5)
                
                let nextScene = PlayModeScene(size: scene!.size)
                nextScene.scaleMode = .AspectFill
                
                scene?.view?.presentScene(nextScene, transition: transition)
            }
        }
    }
    
//    func takePictures(){
//        //use camera
//        layerView = UIImageView()
//        imagePicker =  UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = .Camera
//        imagePicker.allowsEditing = true
//        //imagePicker.cameraOverlayView = viewShow
//        
//        imagePicker.showsCameraControls = true;
//        
//        
//        //add astronaut layer to camera
//        layerView.image = UIImage(named: ("player"))
//        layerView.frame.size.width = self.view!.frame.size.width
//        layerView.frame.size.height = self.view!.frame.size.height
//        
//        
//        imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.Front
//        imagePicker.cameraOverlayView = layerView //3.0以后可以直接设置cameraOverlayView为overlay
//        presentViewController(imagePicker, animated: true , completion: nil)
//        //photoView.getMirror()
//
//    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    }
        override func update(currentTime: NSTimeInterval) {
        
    }
}