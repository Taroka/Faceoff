//
//  ScrollNode.swift
//  Faceoff
//
//  Created by Huaying Tsai on 9/27/15.
//  Copyright © 2015 huaying. All rights reserved.
//

import SpriteKit

class ScrollNode: SKNode{
    
    let coefficientOfSliding = 0.1
    let coefficientOfTransition = 0.3
    
    let maxYPosition: CGFloat = 0
    var minYPosition: CGFloat {
        get {
            return (self.parent?.frame.size.height)! - self.calculateAccumulatedFrame().size.height - yOffset!
        }
    }
    var yOffset: CGFloat?
    var recognizer:UIPanGestureRecognizer?
    
    override init(){
        super.init()
        yOffset = self.calculateAccumulatedFrame().origin.y
    }
    
    override func addChild(node: SKNode) {
        super.addChild(node)
        yOffset = self.calculateAccumulatedFrame().origin.y
    }
    
    func scrollToBottom(){
        self.position = CGPoint(x: 0,y: self.maxYPosition)
    }
    func scrollToTop(){
        self.position = CGPoint(x: 0,y: self.minYPosition)
        
    }
    
    func setScrollingView(view: SKView){
        
        recognizer = UIPanGestureRecognizer(target: self, action:Selector("handlePan:"))
        view.addGestureRecognizer(recognizer!)
        
        self.scrollToTop()
    }
    
    func handlePan(regcognizer: UIPanGestureRecognizer){
        if regcognizer.state == UIGestureRecognizerState.Changed{
            let translation = regcognizer.translationInView(regcognizer.view)
            panForTranslation(translation)
            regcognizer.setTranslation(CGPointZero, inView:regcognizer.view)
        }
        if regcognizer.state == UIGestureRecognizerState.Ended{
            let velocity = regcognizer.velocityInView(regcognizer.view)
            let distanceOfSliding = velocity.y * CGFloat(coefficientOfSliding)
            
            var newYPosition = self.position.y-distanceOfSliding
            newYPosition = min(max(newYPosition,self.minYPosition),self.maxYPosition)
            
            let moveTo = SKAction.moveTo(CGPoint(x:self.position.x,y: newYPosition), duration: coefficientOfTransition)
            moveTo.timingMode = SKActionTimingMode.EaseInEaseOut
            self.runAction(moveTo)
        }
        
    }
    func panForTranslation(translation:CGPoint){
        self.position = CGPoint(x:position.x,y: position.y-translation.y)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
