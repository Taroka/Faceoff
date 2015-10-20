//
//  BattleScene.swift
//  SKInvaders
//
//  Created by Sunny Chiu on 10/20/15.

import SpriteKit
import AVFoundation
import Darwin

enum BodyType: UInt32 {
    case beam = 1
    case hero = 2
    case attack1 = 3
    case attack2 = 4
    
}

var screen_h: CGFloat = 0
var screen_w: CGFloat = 0

var v0x: CGFloat = 0
var v0y: CGFloat = 0
var ax: CGFloat = 0
var ay: CGFloat = 0
var T: CGFloat = 0
var startX: CGFloat = 0
var startY: CGFloat = 0
var endX: CGFloat = 0
var endY: CGFloat = 0
var xRatio: CGFloat = 0
var yRatio: CGFloat = 0

//the following vars are for straight movement
var vxStraight: CGFloat = 0
var vyStraight: CGFloat = 0
let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

var arr: [String] = []

enum WeaponType {
    case cannon
    case rocket
    case gun
}

class WeaponData {
    var position: CGPoint! = nil
    var id: WeaponType! = nil
    var scale: CGFloat! = nil
    init(position: CGPoint, id: WeaponType, scale: CGFloat) {
        self.position = position
        self.id = id
        self.scale = scale
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
extension SKAction {
    static func curve(startRadius startRadius: CGFloat, endRadius: CGFloat,
        centerPoint: CGPoint, duration: NSTimeInterval, type: Int) -> SKAction {
            
            
            let action = SKAction.customActionWithDuration(duration) { node, time in
                // The equation, r = a + bθ
                let radius = startRadius -  (startRadius - endRadius) * (time / CGFloat(duration))
                
                if type == 0 {
                    let pos = position(centerPoint, time: time, duration: duration, type: type)
                    node.position = pos
                    node.setScale(radius * 0.8 / startRadius)
                    if node.position.x > startX * 3 {
                        node.removeFromParent()
                        print("remove")
                        print(time)
                    }
                } else {
                    let pos = position(centerPoint, time: 0.866585-time, duration: duration, type: type)
                    node.position = CGPoint(x:pos.x, y:pos.y)
                    node.setScale((startRadius - radius) * 0.8 / startRadius)
                    if(node.position.x > startX && node.position.y < startY) {
                        node.removeFromParent()
                        print("remove")
                    }
                }
                //let scale = (startRadius - radius) * 0.8 / startRadius
                //var data = scale
                //data += Int(node.position.x * 10) + Int(node.position.y * 10 * 10000)
                //var data: Int = 0
                //data += Int(scale * 100.0)
                //data += Int(node.position.x) * 100
                //data += Int(node.position.y) * 100 * 10000
                //print(scale)
                //print(node.position.x)
                //print(node.position.y)
                //print(data)
                //appDelegate.connector.sendData(["attack": data])
                
                if time == CGFloat(duration) {
                    print("remove")
                    node.removeFromParent()
                }
            }
            
            return action
    }
    
    static func rocketPath(startRadius startRadius: CGFloat, endRadius: CGFloat, upMost: CGFloat,
        duration: NSTimeInterval, type: Int) -> SKAction {
            let action = SKAction.customActionWithDuration(duration) { node, time in
                // The equation, r = a + bθ
                let a: CGFloat = ay * 0.75
                
                var x: CGFloat = 0.0
                var y: CGFloat = 0.0
                if type == 0 {
                    y = v0y * time + 0.5 * a * time * time + startY
                    if v0y + a * time > 0 {
                        x = startX
                    } else {
                        x = endX
                        node.setScale(endRadius / startRadius)
                    }
                    node.position = CGPoint(x: x, y: y)
                    if x == endX && y <= endY {
                        print("remove")
                        node.removeFromParent()
                    }
                }else {
                    y = v0y * 0.75 * time + 0.5 * a * time * time + endY
                    if v0y * 0.75 + a * time > 0 {
                        x = endX
                        node.setScale(endRadius / startRadius)
                    } else {
                        x = startX
                        node.setScale(startRadius / endRadius)
                        
                    }
                    node.position = CGPoint(x: x, y: y)
                    if x == startX && y <= startY {
                        print("remove")
                        node.removeFromParent()
                    }
                }
            }
            
            return action
    }
    
    static func curveOfStraight(startRadius startRadius: CGFloat, endRadius: CGFloat,
        centerPoint: CGPoint, duration: NSTimeInterval, type: Int) -> SKAction {
            
            
            let action = SKAction.customActionWithDuration(duration) { node, time in
                // The equation, r = a + bθ
                let radius = startRadius -  (startRadius - endRadius) * (time / CGFloat(duration))
                let pos = positionOfStraight(centerPoint, time: time, duration: duration, type: type)
                if type == 0 {
                    node.position = pos
                    node.setScale(radius * 0.8 / startRadius)
                    if node.position.x > startX * 3 {
                        node.removeFromParent()
                        print("remove")
                    }
                } else {
                    node.position = CGPoint(x: screen_w - pos.x, y: screen_h - pos.y)
                    node.setScale((startRadius - radius) * 0.8 / startRadius)
                    if node.position.x < startX {
                        node.removeFromParent()
                        print("remove")
                    }
                }
            }
            
            return action
    }
}

func position(center: CGPoint, time: CGFloat, duration: NSTimeInterval, type: Int) -> CGPoint {
    
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    x = v0x * time + 0.5 * ax * time * time + startX
    y = v0y * time + 0.5 * ay * time * time + startY
    if type == 0 {
        return CGPoint(x: x, y: y)
    } else {
        return CGPoint(x: x, y: y)
    }
    
}

func positionOfStraight(center: CGPoint, time: CGFloat, duration: NSTimeInterval, type: Int) -> CGPoint {
    
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    x =  vxStraight * time  + startX
    y =  vyStraight * time  + startY
    if type == 0 {
        return CGPoint(x: x, y: y)
    } else {
        return CGPoint(x: x, y: y)
    }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
class BattleScene: SKScene, SKPhysicsContactDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var btns: Array<SKSpriteNode>?
    var otherBtns: Array<SKSpriteNode>?
    
    var hero: SKSpriteNode!
    var attacker: SKSpriteNode!
    var beam: SKSpriteNode!
    var attack: SKSpriteNode!
    var attack2: SKSpriteNode!
    var selectedIndex: Int = 0
    var oppoAttackPos: NSValue!
    
    var attack2_exist = false
    
    var weapons: Array<SKSpriteNode>?
    var boxes = [SKSpriteNode]()
    var weaponsStringArray: [String] = ["Bomb", "Bow", "Grenade", "Katachi", "Cannon"]
    var selected_weapon: SKSpriteNode!
    var weapon1_ori_pos: CGPoint!
    var weapon2_ori_pos: CGPoint!
    var weapon3_ori_pos: CGPoint!
    
    var bgMusic:AVAudioPlayer = AVAudioPlayer()
    var attackCount = 0
    var roundCount = 0
    var alertLight = false
    var attackerWHAnimation = [SKTexture]()
    var selfArmedStat = false
    var OppArmedStat = false
    var fighting = false
    var roundOver = true
    var countdown_num = 3;
    var countDownVideoNode = SKVideoNode()
    
    var 大炮按钮: SKNode! = nil
    var 火箭按钮: SKNode! = nil
    var gun按钮: SKNode! = nil
    var 被大炮射: SKShapeNode = SKShapeNode(circleOfRadius: 50)
    
    
    var gameOver = false{
        willSet {
            if (newValue) {
                let gameOverLayer = childNodeWithName(FaceoffGameSceneChildName.GameOverLayerName.rawValue) as SKNode?
//                gameOverLayer?.runAction(SKAction.moveDistance(CGVectorMake(0, 100), fadeInWithDuration: 0.2))
            }
            
        }
    }
    var score:Int = 0 {
        willSet {
            let scoreBand = childNodeWithName(FaceoffGameSceneChildName.ScoreName.rawValue) as? SKLabelNode
            scoreBand?.text = "\(newValue)"
            scoreBand?.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration: 0.1), SKAction.scaleTo(1, duration: 0.1)]))
            
            if (newValue == 1) {
                let tip = childNodeWithName(FaceoffGameSceneChildName.TipName.rawValue) as? SKLabelNode
                tip?.runAction(SKAction.fadeAlphaTo(0, duration: 0.4))
            }
        }
    }
    
    
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        start()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "losePeer:", name: "losePeerNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveRemoteData:", name: "receivedRemoteDataNotification", object: nil)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        //let firstNode = contact.bodyA.node as! SKSpriteNode
        //let secondNode = contact.bodyB.node as! SKSpriteNode
        
        print(contact.bodyA.categoryBitMask)
        print(contact.bodyA.categoryBitMask)
        
        if ((contact.bodyA.categoryBitMask == BodyType.beam.rawValue) &&
            (contact.bodyB.categoryBitMask == BodyType.attack1.rawValue) ||
            (contact.bodyA.categoryBitMask == BodyType.attack1.rawValue) &&
            (contact.bodyB.categoryBitMask == BodyType.beam.rawValue)) {
                
                
                appDelegate.connector.sendData(["didAttack": selectedIndex])
                
                if selectedIndex == 0 {
                    oneAttackCircle(0, index: selectedIndex)
                }
                else if selectedIndex == 1 {
                    rocketAttack(0, index: selectedIndex)
                }
                else  {
                    oneAttackStraight(0, index: selectedIndex)
                }
                
                
                attack.physicsBody = nil;
                attack.runAction(SKAction.fadeOutWithDuration(0.5))
                
                let rotate = SKAction.repeatAction(SKAction.rotateByAngle(CGFloat(M_PI), duration:0.1), count: 10)
                let action_array:Array<SKAction> = [SKAction.moveToX(0, duration: 1.0),
                    SKAction.moveToY(0, duration: 1.0),
                    SKAction.fadeOutWithDuration(1.0), rotate]
                let action_combine = SKAction.group(action_array)
                attack.runAction(action_combine)
                
                //let x = CGFloat(arc4random_uniform(UInt32(frame.size.width-100)))
                let y = CGFloat(arc4random_uniform(UInt32(50)))
                
                
                loadattack((self.view?.bounds.size.width)!/2, yPos: y+70)
                print("Hit")
                
                
                if(fighting){
                    attackCount++
                    
                    appDelegate.connector.sendData(["roundCount": attackCount])
                    
                    
                    if attackCount == 3 {
                        loadAlert(hero.position)
                    }
                    
                    if attackCount == 4 {
                        
                        
                        fighting = false;
                        
                        
                        //round three, game over
                        if (roundCount == 3) {
                            appDelegate.connector.sendData(["fightingSign": false])
                            appDelegate.connector.sendData(["gameOverSign": true])
                            gameOver = true
                            
                            
                            beam.removeFromParent()
                            attack.removeFromParent()
                            attack2.removeFromParent()
                            loadGameOverLayer()
                            
                            return
                            
                        }else{
                            
                            appDelegate.connector.sendData(["fightingSign": false])
                            
                        }
                        restartRound()
                        
                        //statusLabel()
                    }
                    
                }
                
                
        }
        /*
        if (contact.bodyA.categoryBitMask == BodyType.beam.rawValue) &&
        (contact.bodyB.categoryBitMask == BodyType.attack2.rawValue) {
        
        attack2.physicsBody = nil;
        let rotate = SKAction.repeatAction(SKAction.rotateByAngle(CGFloat(M_PI), duration:0.1), count: 10)
        let action_array:Array<SKAction> = [SKAction.moveToX(0, duration: 1.0),
        SKAction.moveToY(0, duration: 1.0),
        SKAction.fadeOutWithDuration(1.0), rotate]
        let action_combine = SKAction.group(action_array)
        attack2.runAction(action_combine)
        
        
        let x = CGFloat(arc4random_uniform(UInt32(frame.size.width-50)))
        let y = CGFloat(arc4random_uniform(UInt32(50)))
        
        loadattack2(x, yPos: y+70)
        print("Hit")
        
        }
        */
    }
    
    func start() {
        self.initAttackerWHScene()
        
        loadBackground()
        loadHero()
        
        
        //        loadScoreBackground()
        //        loadScore()
        loadAttacker()
        loadGameOverLayer()
        
        
        if let index = scene!.userData?.valueForKey("Ray") as? String {
            print(index)
            
            arr = index.componentsSeparatedByString("-")
            print(arr)
            loadWeapons(arr)
        }
        
        xRatio = 4
        yRatio = 6
        T = 1.0
        v0x = -self.view!.frame.size.width / (T * 1.2)
        v0y = yRatio *  self.view!.frame.size.height /  (T * 3)
        ax = -v0x * xRatio / (T * 1)//1.3)
        ay = -v0y * yRatio / (T * 4.3)//4)
        
        screen_h = (self.view?.frame.size.height)!
        screen_w = (self.view?.frame.size.width)!
        
        //the following vars are for straight movement
        vxStraight = self.view!.frame.size.width / (T*1.5)
        vyStraight = self.view!.frame.size.height / (T)
    }
    func restart() {
        gameOver = false
        attackCount = 0
        fighting = false
        score = 0
        statusLabel()
        roundCount = 0
        
        
        removeAllChildren()
        
        
        start()
        
        
    }
    func restartRound() {
        attackCount = 0
        removeAllChildren()
        
        /*
        beam.removeFromParent()
        attack.removeFromParent()
        attack2.removeFromParent()
        hero.removeFromParent()
        */
        
        start()
    }
    
    //拿來放跳出來的東西 (武器, 道具)
    func addSprite(imageNamed: String, location: CGPoint, scale: CGFloat, z:CGFloat) -> SKSpriteNode {
        let sprite = SKSpriteNode(imageNamed:imageNamed)
        
        sprite.xScale = scale
        sprite.yScale = scale
        sprite.zPosition = z
        sprite.position = location
        self.addChild(sprite)
        return sprite
    }
    
    func losePeer(notification: NSNotification){
        
        /*
        for btn in otherBtns!{
        btn.removeFromParent()
        }
        */
        
        print("QQQQ")
        
    }
    
    func loadAlert(point:CGPoint){
        _ = starEmitterActionAtPosition(point)
    }
    
    
    func receiveRemoteData(notification: NSNotification){
        let receivedData = NSKeyedUnarchiver.unarchiveObjectWithData(notification.object as! NSData) as! Dictionary<String,AnyObject>
        
        
        //set restart while the game is overs
        if let gameOverSign = receivedData["gameOverSign"] as? Bool{
            
            gameOver = gameOverSign
            
            
            let gameOverLayer = childNodeWithName(FaceoffGameSceneChildName.GameOverLayerName.rawValue) as SKNode?
            print("gameOveron receiveRemote")
            let location = CGPoint(x: frame.midX, y: frame.maxY * 0.6)
            let retry = gameOverLayer!.nodeAtPoint(location)
            
            if (retry.name == FaceoffGameSceneChildName.RetryButtonName.rawValue) {
                retry.runAction(SKAction.sequence([SKAction.setTexture(SKTexture(imageNamed: "button_retry_down"), resize: false), SKAction.waitForDuration(0.3)]), completion: {[unowned self] () -> Void in
                    self.restart()
                    })
            }
            
        }
        
        if let roundCount = receivedData["roundCount"] as? Int{
            
            if roundCount == 2 {
                loadAlert(attacker.position)
            }
        }
        
        
        if let fightingSign = receivedData["fightingSign"] as? Bool{
            fighting = fightingSign
            print("fightingSign: ", fighting)
            //restartRound()
        }
        
        
        if let index = receivedData["didSelectWeapon"] as? Int{
            
            if index != -1 {
                
                OppArmedStat = true
                
                if(selfArmedStat == true && OppArmedStat == true){
                    print("Fight!")
                    
                    setWeapon(selected_weapon)
                    
                    fighting = true
                    roundCount++
                }
                
            }
        }
        
        
        if let tappp = receivedData["tap"] as? Int{
            
            
            beamMove(CGFloat(-tappp))
            print(tappp);
            
            
        }
        
        /*
        if let _ = receivedData["attack_xPos"] as? CGFloat{
        
        if let y = receivedData["attack_yPos"] as? CGFloat{
        
        
        //var mySprite: SKSpriteNode = childNodeWithName("attack2") as! SKSpriteNode
        
        //attack2.removeFromParent()
        
        //loadattack2(x, yPos: y-20)
        
        
        if let parentNode = attack2?.parent{
        if parentNode == self{
        
        //print("++++++")
        attack2?.removeFromParent()
        loadattack2(((self.view?.bounds.size.width)!)/2, yPos: y)
        }
        }
        
        
        
        
        }
        }
        */
        
        if let index = receivedData["didAttack"] as? Int{
            
            self.fighting = false;
            
            
            if(selfArmedStat && OppArmedStat){
                setWeapon(selected_weapon)
            }
            
            
            let crushScale = CGFloat(arc4random_uniform(UInt32(4)))/3
            
            let crushPosX = CGFloat(arc4random_uniform(UInt32((self.view?.bounds.size.width)!)))
            let crushPosY = CGFloat(arc4random_uniform(UInt32((self.view?.bounds.size.height)!)))
            
            
            addSprite("crush1", location: CGPoint(x: crushPosX, y:crushPosY), scale: crushScale, z:150).runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.LittleBombName.rawValue, waitForCompletion: false))
            
            if index == 0 {
                oneAttackCircle(1, index: index)
            }
            else if index == 1 {
                rocketAttack(1, index: index)
            }
            else {
                oneAttackStraight(1, index: index)
            }
        }
        
        
        
        
        // in fighting mode then you received the attacked
        if (fighting){
            
            if let location = receivedData["location"] as? NSValue{
                
                //oneDefenseCircle()
                oppoAttackPos = location
                
                //attackCount++
            }
            
            
        }
    }
    
    func initAttackerWHScene() {
        let attackerWHAtlas = SKTextureAtlas(named: "attackerWH")
        attackerWHAnimation = []
        
        for index in 1...attackerWHAtlas.textureNames.count {
            let imgName = String(format: "attackerWH%01d", index)
            attackerWHAnimation += [attackerWHAtlas.textureNamed(imgName)]
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        //set attacker amination
        let attackerNode = self.childNodeWithName("attackerNode")
        
        if(attackerNode != nil) {
            let animation = SKAction.animateWithTextures(attackerWHAnimation, timePerFrame: 0.02)
            attackerNode?.runAction(animation)
        }
        
        //round while gameOver is true
        guard !gameOver else {
            let gameOverLayer = childNodeWithName(FaceoffGameSceneChildName.GameOverLayerName.rawValue) as SKNode?
            
            let location = touches.first?.locationInNode(gameOverLayer!)
            let retry = gameOverLayer!.nodeAtPoint(location!)
            print("gameOveron touchesBegan")
            
            if (retry.name == FaceoffGameSceneChildName.RetryButtonName.rawValue) {
                retry.runAction(SKAction.sequence([SKAction.setTexture(SKTexture(imageNamed: "button_retry_down"), resize: false), SKAction.waitForDuration(0.3)]), completion: {[unowned self] () -> Void in
                    
                    
                    self.restart()
                    
                    })
            }
            return
        }
        
        for touch in touches {
            
            let location = touch.locationInNode(self)
            appDelegate.connector.sendData(["location": NSValue(CGPoint: location)])
            
            
            
            
            if(fighting) {
                
                if attacker.containsPoint(location){
                    //tapCount++;
                    beamMove(CGFloat(15))
                    appDelegate.connector.sendData(["tap": 15])
                }
                
            }
            else{
                
                var n = true
                
                for (index,weapon) in weapons!.enumerate() {
                    if weapon.containsPoint(location){
                        appDelegate.connector.sendData(["didSelectWeapon": index])
                        n = false
                        selfArmedStat = true
                        
                        print("tapppp")
                        
                        selectedIndex = index
                        
                        weapon.alpha = 1.0
                        selected_weapon = weapon
                        
                        //weapon.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.SetWeaponAudioName.rawValue, waitForCompletion: true))
                        boxGlowing(boxes, box_index: index)
                        
                        if(selfArmedStat == true && OppArmedStat == true){
                            print("Fight!")
                            
                            setWeapon(selected_weapon)
                            
                            fighting = true
                            roundCount++
                        }
                    }
                    else{
                        weapon.alpha = 0.2
                    }
                    
                }
                if n {
                    boxStopGlowing(boxes)
                    appDelegate.connector.sendData(["didSelectWeapon": Int(-1)])
                }
                
                
            }
            
            //
            
            guard !fighting else {
                // oneAttackCircle()
                return
            }
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //print("show me how")
        
    }
    /* 準備使用 */
    
    
    func oneAttackCircle(type: Int, index: Int){
        //let Circle = SKShapeNode(circleOfRadius: 50 )
        let Circle = SKSpriteNode(imageNamed: weaponsStringArray[Int(arr[index])!])
        startX = self.view!.frame.size.width / xRatio
        startY = self.view!.frame.size.height / yRatio
        endX = self.view!.frame.size.width * (xRatio - 1.0) / xRatio
        endY = self.view!.frame.size.height * (yRatio - 1.0) / yRatio
        Circle.position = CGPointMake(startX, startY)
        //Circle.strokeColor = SKColor.blackColor()
        //Circle.glowWidth = 1.0
        //Circle.fillColor = SKColor.orangeColor()
        let spiral = SKAction.curve(startRadius: 20,
            endRadius: 1,
            centerPoint: Circle.position,
            duration: 1.0,
            type: type)
        Circle.runAction(spiral)
        self.addChild(Circle)
    }
    
    func rocketAttack(type: Int, index: Int){
        //let Circle = SKShapeNode(circleOfRadius: 10 )
        let Circle = SKSpriteNode(imageNamed: weaponsStringArray[Int(arr[index])!])
        
        startX = self.view!.frame.size.width / xRatio
        startY = self.view!.frame.size.height / yRatio
        endX = self.view!.frame.size.width * (xRatio - 1.0) / xRatio
        endY = self.view!.frame.size.height * (yRatio - 1.0) / yRatio
        Circle.position = CGPointMake(startX, startY)
        //Circle.strokeColor = SKColor.blackColor()
        //Circle.glowWidth = 1.0
        //Circle.fillColor = SKColor.orangeColor()
        let spiral = SKAction.rocketPath(startRadius: 10, endRadius: 6, upMost: self.view!.frame.size.height,duration: 2.0, type: type)
        Circle.runAction(spiral)
        
        self.addChild(Circle)
    }
    
    func oneAttackStraight(type: Int, index: Int){
        //let Circle = SKShapeNode(circleOfRadius: 50 )
        let Circle = SKSpriteNode(imageNamed: weaponsStringArray[Int(arr[index])!])
        startX = self.view!.frame.size.width / xRatio
        startY = self.view!.frame.size.height / yRatio
        Circle.position = CGPointMake(startX, startY)
        //Circle.strokeColor = SKColor.blackColor()
        //Circle.glowWidth = 1.0
        //Circle.fillColor = SKColor.darkTextColor()
        let spiral = SKAction.curveOfStraight(startRadius: 20,
            endRadius: 1,
            centerPoint: Circle.position,
            duration: 1.0,
            type: type)
        Circle.runAction(spiral)
        self.addChild(Circle)
        
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
private extension BattleScene {
    func loadBackground() {
        guard let _ = childNodeWithName("background") as! SKSpriteNode? else {
            let texture = SKTexture(image: UIImage(named: "background.jpg")!)
            let node = SKSpriteNode(texture: texture)
            node.size = self.frame.size;
            node.position = CGPoint(x: frame.midX, y: frame.midY)
            node.zPosition = FaceoffGameSceneZposition.BackgroundZposition.rawValue
            //    self.physicsWorld.gravity = CGVectorMake(0, gravity)
            
            addChild(node)
            return
        }
    }
    
    func loadAttacker(){
        
        attacker = SKSpriteNode(imageNamed: "attackerWH1")
        attacker.name = "attackerNode"
        attacker.position = CGPoint(x: frame.midX * 0.5, y: frame.midY * 0.5-150)
        attacker.xScale = 0.30
        attacker.yScale = 0.30
        attacker.zPosition = FaceoffGameSceneZposition.HeroZposition.rawValue
        //attacker.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(16, 18))
        //attacker.physicsBody?.affectedByGravity = false
        //attacker.physicsBody?.allowsRotation = false
        
        addChild(attacker)
        
    }
    
    // Just put a rival for demo
    func loadHero() {
        
        hero = SKSpriteNode(imageNamed: "cute")
        hero.name = FaceoffGameSceneChildName.HeroName.rawValue
        hero.position = CGPoint(x: frame.midX * 1.5 + 5, y: frame.midY * 1.5 + 20)
        hero.xScale = 0.15
        hero.yScale = 0.15
        hero.zPosition = FaceoffGameSceneZposition.HeroZposition.rawValue;
        //hero.zPosition = FaceoffGameSceneZposition.HeroZposition.rawValue
        //hero.physicsBody = SKPhysicsBody(rectangleOfSize: hero.frame.size)
        //hero.physicsBody?.affectedByGravity = false
        //hero.physicsBody?.allowsRotation = false
        addChild(hero)
    }
    
    func loadattack(xPos:CGFloat, yPos:CGFloat) {
        
        
        //let xPos = CGFloat(arc4random_uniform(UInt32(frame.size.width)))
        //let yPos = CGFloat(arc4random_uniform(UInt32(100)))
        
        appDelegate.connector.sendData(["attack_xPos": xPos,"attack_yPos":yPos])
        
        attack = SKSpriteNode(imageNamed: "attackIcon4")
        attack.name = "attack1"
        attack.position = CGPoint(x: xPos, y: beam.position.y + yPos)
        attack.xScale = 0.5
        attack.yScale = 0.5
        attack.zPosition = FaceoffGameSceneZposition.HeroZposition.rawValue + 10
        attack.physicsBody = SKPhysicsBody(rectangleOfSize: attack.frame.size)
        attack.physicsBody?.affectedByGravity = false
        attack.physicsBody?.allowsRotation = false
        attack.physicsBody?.categoryBitMask = BodyType.attack1.rawValue
        attack.physicsBody?.contactTestBitMask = BodyType.beam.rawValue
        attack.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(attack)
    }
    func loadattack2(xPos:CGFloat, yPos:CGFloat) {
        
        var beamY: CGFloat!
        if(beam == nil){
            beamY = (self.view?.bounds.size.width)!/2
        }
        else{
            beamY = beam.position.y
            
        }
        
        attack2 = SKSpriteNode(imageNamed: "attackIcon3")
        attack2.name = "attack2"
        attack2.position = CGPoint(x: xPos, y:  beamY - yPos)
        attack2.xScale = 0.5
        attack2.yScale = 0.5
        attack2.zPosition = FaceoffGameSceneZposition.HeroZposition.rawValue + 10
        //attack2.physicsBody = SKPhysicsBody(rectangleOfSize: attack2.frame.size)
        //attack2.physicsBody?.affectedByGravity = false
        //attack2.physicsBody?.allowsRotation = false
        //attack2.physicsBody?.categoryBitMask = BodyType.attack2.rawValue
        //attack2.physicsBody?.contactTestBitMask = BodyType.beam.rawValue
        //attack2.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(attack2)
        
        attack2_exist = true
    }
    
    func loadBeam() {
        
        beam = SKSpriteNode(imageNamed: "Beam")
        beam.name = FaceoffGameSceneChildName.HeroName.rawValue
        beam.position = CGPoint(x: 0.0, y: frame.midY)
        beam.size = CGSize(width: (self.view?.frame.size.width)!, height: beam.frame.size.height)
        beam.xScale = 2
        beam.yScale = 0.5
        beam.zPosition = FaceoffGameSceneZposition.HeroZposition.rawValue
        //let beamBody = SKPhysicsBody(rectangleOfSize: beam.frame.size, center: beam.position)
        beam.physicsBody = SKPhysicsBody(rectangleOfSize: beam.frame.size)
        beam.physicsBody?.dynamic = false
        //beam.physicsBody?.affectedByGravity = false
        beam.physicsBody?.allowsRotation = false
        beam.physicsBody?.categoryBitMask = BodyType.beam.rawValue
        beam.physicsBody?.contactTestBitMask =  BodyType.attack1.rawValue | BodyType.attack2.rawValue
        beam.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(beam)
    }
    
    
    
    func loadWeapons(imageName:[String]){
        
        
        boxes = [
            addSprite("weapon_box", location: CGPoint(x: scene!.size.width-40,y: 195.0),scale: 0.4, z:0),
            addSprite("weapon_box", location: CGPoint(x: scene!.size.width-40,y: 130.0),scale: 0.4, z:0),
            addSprite("weapon_box", location: CGPoint(x: scene!.size.width-40,y: 65.0),scale: 0.4, z:0)
        ]
        
        weapons = [
            addSprite(weaponsStringArray[Int(imageName[0])!], location: CGPoint(x: scene!.size.width-40,y: 195.0),scale: 0.5, z:0),
            addSprite(weaponsStringArray[Int(imageName[1])!], location: CGPoint(x: scene!.size.width-40,y: 130.0),scale: 0.5, z:0),
            addSprite(weaponsStringArray[Int(imageName[2])!], location: CGPoint(x: scene!.size.width-40,y: 65.0),scale: 0.5, z:0),
            
        ]
        
        
        
    }
    
    
    func statusLabel() -> SKSpriteNode{
        let label = SKSpriteNode(imageNamed: "win")
        let ready_action_array:Array<SKAction> = [SKAction.fadeInWithDuration(1.0),
            SKAction.scaleTo(2.0, duration: 2.0),SKAction.fadeOutWithDuration(2.0)]
        let ready_action_combine = SKAction.group(ready_action_array)
        
        //        label.text = statusName
        //        label.fontSize = 50
        label.position = CGPointMake(frame.midX, frame.midY)
        label.runAction(ready_action_combine)
        label.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.PowerUpAudioName.rawValue, waitForCompletion: false))
        
        addChild(label)
        return label
    }
    
    
    func setWeapon(weapon:SKSpriteNode){
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointZero)
        path.addQuadCurveToPoint(CGPoint(x: -200, y: 0), controlPoint: CGPoint(x: -100, y: 200))
        
        
        let rotate = SKAction.repeatAction(SKAction.rotateByAngle(CGFloat(M_PI), duration:0.1), count: 10)
        let route = SKAction.followPath(path.CGPath, asOffset: true, orientToPath: false, duration: 1.0)
        
        let action_array:Array<SKAction> = [route, rotate]
        let combine = SKAction.group(action_array)
        
        weapon1_ori_pos = weapon.position
        
        weapon.runAction(combine)
        
        
        let Ready = SKSpriteNode(imageNamed:"Ready")
        Ready.xScale = 0.5
        Ready.yScale = 0.5
        Ready.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.Round2Fight.rawValue, waitForCompletion: false))
        Ready.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        addChild(Ready)
        
        let ready_action_array:Array<SKAction> = [SKAction.fadeInWithDuration(1.0),
            SKAction.scaleTo(2.0, duration: 2.0),SKAction.fadeOutWithDuration(2.0)]
        let ready_action_combine = SKAction.group(ready_action_array)
        
        
        Ready.runAction(ready_action_combine) { () -> Void in
            
            let fight_action_array:Array<SKAction> = [SKAction.fadeInWithDuration(1.0),
                SKAction.scaleTo(10.0, duration: 2.0),
                SKAction.fadeOutWithDuration(1.0)]
            let action_combine = SKAction.group(fight_action_array)
            
            let Fight = SKSpriteNode(imageNamed:"Fight")
            Fight.xScale = 0.5
            Fight.yScale = 0.5
            Fight.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            self.addChild(Fight)
            
            weapon.removeFromParent()
            self.selfArmedStat = false;
            self.OppArmedStat = false;
            self.boxStopGlowing(self.boxes)
            
            
            
            
            self.loadBeam()
            self.LoadVideo("countdown3.mp4") // run function to load video
            self.countDown()
            
            
            /*
            //var x = CGFloat(arc4random_uniform(UInt32(self.frame.size.width-100)))
            var y = CGFloat(arc4random_uniform(UInt32(50)))
            self.loadattack((self.view?.bounds.size.width)!/2, yPos: y+70)
            
            //x = CGFloat(arc4random_uniform(UInt32(self.frame.size.width-100)))
            y = CGFloat(arc4random_uniform(UInt32(50)))
            self.loadattack2((self.view?.bounds.size.width)!/2, yPos: y+70)
            */
            
            Fight.runAction(action_combine) { () -> Void in
                
                //weapon.position = self.weapon1_ori_pos
            }
            
        }
    }
    
    
    func beamMoveRepeat(){
        
        //let yPos: CGFloat = CGFloat(random() % 50);
        let yPos = CGFloat(arc4random_uniform(UInt32(50)))
        //print(String(yPos))
        
        let moveUp = SKAction.moveByX(0, y:-yPos, duration:1)
        //let repeatMoveUp = SKAction.repeatActionForever(moveUp)
        
        beam.runAction(moveUp) { () -> Void in
            self.beamMoveRepeat()
        }
    }
    
    
    func beamMove(Ypos:CGFloat){
        let moveUp = SKAction.moveByX(0, y:Ypos, duration: 0.1)
        beam.runAction(moveUp)
    }
    
    func boxGlowing(boxes:[SKSpriteNode],box_index:Int){
        
        for (index, box) in boxes.enumerate() {
            
            if(index==box_index){
                box.texture = SKTexture(imageNamed: "box_glow")
            }
            else{
                box.texture = SKTexture(imageNamed: "weapon_box")
            }
        }
    }
    
    func boxStopGlowing(boxes:[SKSpriteNode]){
        for box in boxes {
            box.texture = SKTexture(imageNamed: "weapon_box")
        }
        
    }
    
    func showBeginText(){
        
    }
    
    func LoadVideo(FileToPlay:String)
    {
        
        countDownVideoNode =  SKVideoNode (videoFileNamed:FileToPlay)// fill spritenode with video file
        countDownVideoNode.position = CGPointMake(size.width/2, size.height/2);  // set size
        countDownVideoNode.name = "VideoSprite" // give it a name
        countDownVideoNode.zPosition = 1 // set its z position
        countDownVideoNode.play()// play video
        countDownVideoNode.alpha = 0.0
        
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            break
        case .Pad:
            countDownVideoNode.size = CGSizeMake((self.view?.bounds.size.width)!*2.5, (self.view?.bounds.size.height)!*1.0)
            break
        case .Unspecified:
            
            break
        }
        
        addChild(countDownVideoNode)// add video node to the sceene
        
        countDownVideoNode.runAction(SKAction.fadeAlphaTo(1, duration: 1.0))
        
        
    }
    
    func countDown(){
        
        let wait = SKAction.waitForDuration(5.0);
        
        runAction(wait, completion: {[unowned self] () -> Void in
            
            self.countDownVideoNode.runAction(SKAction.fadeAlphaTo(0, duration: 1.0))
            
            if(self.beam.position.y > (self.view?.bounds.size.height)!/2){
                
                
                self.beam.runAction(SKAction.sequence([SKAction.moveToY(0, duration: 0.5),SKAction.fadeAlphaTo(0, duration: 0.5)]), completion: {[unowned self] () -> Void in
                    
                    
                    self.attack = SKSpriteNode(imageNamed: "attackIcon4")
                    self.attack.name = "attack1"
                    self.attack.position = CGPoint(x: self.attacker.position.x + 10 , y: self.attacker.position.y)
                    self.attack.xScale = 0.5
                    self.attack.yScale = 0.5
                    self.attack.zPosition = FaceoffGameSceneZposition.HeroZposition.rawValue + 10
                    self.addChild(self.attack)
                    
                    let rotate = SKAction.repeatAction(SKAction.rotateByAngle(CGFloat(M_PI), duration:0.5), count: 10)
                    let action_array:Array<SKAction> = [SKAction.scaleBy(5.0, duration: 0.5),
                        SKAction.fadeOutWithDuration(1.0), rotate]
                    let action_combine = SKAction.group(action_array)
                    self.attack.runAction(action_combine)
                    
                    self.appDelegate.connector.sendData(["didAttack": self.selectedIndex])
                    
                    if self.selectedIndex == 0 {
                        
                        self.oneAttackCircle(0, index: self.selectedIndex)
                    }
                    else if self.selectedIndex == 1 {
                        self.rocketAttack(0, index: self.selectedIndex)
                    }
                    else  {
                        self.oneAttackStraight(0, index: self.selectedIndex)
                    }
                    
                    let seconds = 2.0
                    let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                        
                        if(self.fighting){
                            
                            self.attackCount++
                            
                            self.appDelegate.connector.sendData(["roundCount": self.attackCount])
                            
                            
                            if self.attackCount == 2 {
                                self.loadAlert(self.hero.position)
                            }
                            
                            //self.restartRound()
                            self.fighting = false;
                            
                            //round three, game over
                            if (self.roundCount == 3) {
                                self.appDelegate.connector.sendData(["fightingSign": false])
                                self.appDelegate.connector.sendData(["gameOverSign": true])
                                self.gameOver = true
                                
                                
                                self.beam.removeFromParent()
                                self.loadGameOverLayer()
                                
                                return
                                
                            }else{
                                
                                self.appDelegate.connector.sendData(["fightingSign": false])
                                
                            }
                            
                            
                        }
                        
                    })
                    
                    
                    })
                
                
            }
            else if(self.beam.position.y == (self.view?.bounds.size.height)!/2){
                
                self.beam.runAction(SKAction.sequence([SKAction.moveToY((self.view?.bounds.size.height)!/2, duration: 0.5),SKAction.fadeAlphaTo(0, duration: 0.5)]), completion: {[unowned self] () -> Void in
                    
                    self.appDelegate.connector.sendData(["didAttack": self.selectedIndex])
                    
                    if self.selectedIndex == 0 {
                        
                        self.oneAttackCircle(0, index: self.selectedIndex)
                    }
                    else if self.selectedIndex == 1 {
                        self.rocketAttack(0, index: self.selectedIndex)
                    }
                    else  {
                        self.oneAttackStraight(0, index: self.selectedIndex)
                    }
                    
                    
                    let seconds = 2.5
                    let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                        
                        if(self.fighting){
                            
                            self.attackCount++
                            
                            self.appDelegate.connector.sendData(["roundCount": self.attackCount])
                            
                            
                            if self.attackCount == 2 {
                                self.loadAlert(self.hero.position)
                            }
                            
                            //self.restartRound()
                            self.fighting = false;
                            
                            //round three, game over
                            if (self.roundCount == 3) {
                                self.appDelegate.connector.sendData(["fightingSign": false])
                                self.appDelegate.connector.sendData(["gameOverSign": true])
                                self.gameOver = true
                                
                                
                                self.beam.removeFromParent()
                                self.loadGameOverLayer()
                                
                                return
                                
                            }else{
                                
                                self.appDelegate.connector.sendData(["fightingSign": false])
                                
                            }
                            
                            
                        }
                        
                    })
                    
                    
                    })
                
                
            }
            else{
                self.beam.runAction(SKAction.sequence([SKAction.moveToY((self.view?.bounds.size.height)!, duration: 0.5),SKAction.fadeAlphaTo(0, duration: 0.5)]))
                
                let seconds = 2.5
                let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                
                dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                    self.fighting = false;
                    
                })
                
            }
            
            
            
            
            })
    }
    
    func starEmitterActionAtPosition(position: CGPoint) -> SKAction {
        let emitter = SKEmitterNode(fileNamed: "StarExplosion")
        emitter?.position = position
        //emitter?.zPosition = FaceoffGameSceneZposition.EmitterZposition.rawValue
        emitter?.zPosition = 0;
        emitter?.alpha = 0.6
        emitter?.setScale(0.5)
        addChild((emitter)!)
        
        let wait = SKAction.waitForDuration(0.15)
        
        return SKAction.runBlock({ () -> Void in
            emitter?.runAction(wait)
        })
    }
    
    //    func loadScore() {
    //        let scoreBand = SKLabelNode(fontNamed: "Arial")
    //        scoreBand.name = FaceoffGameSceneChildName.ScoreName.rawValue
    //        scoreBand.text = "0"
    //        scoreBand.position = CGPointMake(frame.midX, DefinedScreenHeight / 2 - 200)
    //        scoreBand.fontColor = SKColor.whiteColor()
    //        scoreBand.fontSize = 100
    //        scoreBand.zPosition = FaceoffGameSceneZposition.ScoreZposition.rawValue
    //        scoreBand.horizontalAlignmentMode = .Center
    //
    //        addChild(scoreBand)
    //    }
    //
    //    func loadScoreBackground() {
    //        let back = SKShapeNode(rect: CGRectMake(0-120, 1024-200-30, 240, 140), cornerRadius: 20)
    //        back.zPosition = FaceoffGameSceneZposition.ScoreBackgroundZposition.rawValue
    //        back.fillColor = SKColor.blackColor().colorWithAlphaComponent(0.3)
    //        back.strokeColor = SKColor.blackColor().colorWithAlphaComponent(0.3)
    //        addChild(back)
    //    }
    
    func loadGameOverLayer() {
        let node = SKNode()
        node.alpha = 0
        node.name = FaceoffGameSceneChildName.GameOverLayerName.rawValue
        node.zPosition = FaceoffGameSceneZposition.GameOverZposition.rawValue
        addChild(node)
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "GAME OVER"
        //you lost or you win
        //        if (yourpoint > oppoint) label.text = "YOU WIN"
        //        else lable.text = "YOU LOST"
        
        label.fontColor = SKColor.redColor()
        label.fontSize = 50
        label.position = CGPointMake(frame.midX, frame.maxY * 0.6)
        label.horizontalAlignmentMode = .Center
        node.addChild(label)
        
        let retry = SKSpriteNode(imageNamed: "button_retry_up")
        retry.name = FaceoffGameSceneChildName.RetryButtonName.rawValue
        retry.size = CGSize(width: frame.maxX * 0.3, height: frame.maxY * 0.1)
        retry.position = CGPointMake(frame.midX, frame.maxY * 0.4)
        node.addChild(retry)
    }
    
}
