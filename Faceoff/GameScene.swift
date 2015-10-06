
import SpriteKit
import AVFoundation


class GameScene: SKScene {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var btns: Array<SKSpriteNode>?
    var otherBtns: Array<SKSpriteNode>?
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
    
    
    var gameOver = false {
        willSet {
            if (newValue) {
                let gameOverLayer = childNodeWithName(FaceoffGameSceneChildName.GameOverLayerName.rawValue) as SKNode?
                gameOverLayer?.runAction(SKAction.moveDistance(CGVectorMake(0, 100), fadeInWithDuration: 0.2))
            }
            
        }
    }
    
    
    
    override func didMoveToView(view: SKView) {
        start()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "losePeer:", name: "losePeerNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveRemoteData:", name: "receivedRemoteDataNotification", object: nil)
    }
    func start() {
        loadBackground()
        loadHero()
       // loadAttacker()
        loadGameOverLayer()
        
        
        if let index = scene!.userData?.valueForKey("Ray") as? String {
            print(index)
            
            let arr = index.componentsSeparatedByString("-")
            print(arr)
            loadWeapons(arr)
        }
    
    }
    func restart() {
        gameOver = false
        attackCount = 0
        fighting = false
        //score = 0
        removeAllChildren()
        start()
    }
    
    //拿來放跳出來的東西 (武器, 道具)
    func addSprite(imageNamed: String, location: CGPoint, scale: CGFloat) -> SKSpriteNode {
        let sprite = SKSpriteNode(imageNamed:imageNamed)
        
        sprite.xScale = scale
        sprite.yScale = scale
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

    func loadAlert(){
        _ = starEmitterActionAtPosition(CGPointMake(frame.midX, frame.midY))
    }
    

    func receiveRemoteData(notification: NSNotification){
        let receivedData = NSKeyedUnarchiver.unarchiveObjectWithData(notification.object as! NSData) as! Dictionary<String,AnyObject>
        
        //detect 回合開始了嗎 roundOver == true >> choose weapon again
//        if let roundOverSign = receivedData["roundOverSign"] as? Bool{
//            roundOver = roundOverSign
//            
//            print("roundOver: ", roundOver)
//            //roundOver = true
//        }
        if let fightingSign = receivedData["fightingSign"] as? Bool{
            fighting = fightingSign
            print("fightingSign: ", fighting)
            //roundOver = true
        }
        
        //run while roundOver is true
     //      guard !roundOver else {
                
       //         roundOver = false // reset a round

                //set weapon before each round
                if let index = receivedData["didSelectWeapon"] as? Int{
            
                    if index != -1 {
                        OppArmedStat = true
                
                        if(selfArmedStat && OppArmedStat){
                            setWeapon(selected_weapon)
                        }
                    }
                }
            
//                return
//            }
        
        //set restart while the game is overs
        if let gameOverSign = receivedData["gameOverSign"] as? Bool{
            
            if (gameOverSign) {
                print("gameGG")
                gameOver = true
                guard !gameOver else {
                    let gameOverLayer = childNodeWithName(FaceoffGameSceneChildName.GameOverLayerName.rawValue) as SKNode?
                    
                    let location = CGPoint(x: frame.midX, y: frame.midY)
                    let retry = gameOverLayer!.nodeAtPoint(location)
                    
                    
                    if (retry.name == FaceoffGameSceneChildName.RetryButtonName.rawValue) {
                        retry.runAction(SKAction.sequence([SKAction.setTexture(SKTexture(imageNamed: "button_retry_down"), resize: false), SKAction.waitForDuration(0.3)]), completion: {[unowned self] () -> Void in
                            self.restart()
                            })
                    }
                    return
                }
                }
            }
        

        // in fighting mode then you received the attacked
        if (fighting){
        
        if let location = receivedData["location"] as? NSValue{

            oneDefenseCircle()
            
            addSprite("crush1", location: location.CGPointValue(), scale: 0.4).runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.LittleBombName.rawValue, waitForCompletion: false))

            attackCount++
        }
        
        if attackCount == 3 {loadAlert()}
        
        if attackCount == 5 {fighting = false;
            
            //round three, game over
            if (roundCount == 3) {
                appDelegate.connector.sendData(["fightingSign": false])
                appDelegate.connector.sendData(["gameOverSign": true])

            }else{
           // appDelegate.connector.sendData(["roundOverSign": true])
            appDelegate.connector.sendData(["fightingSign": false])
            //fighting = false
            }
            }
        }
        

        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        //round while gameOver is true
        guard !gameOver else {
            let gameOverLayer = childNodeWithName(FaceoffGameSceneChildName.GameOverLayerName.rawValue) as SKNode?
            
            let location = CGPoint(x: frame.midX, y: frame.midY)
            let retry = gameOverLayer!.nodeAtPoint(location)
            
            
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
            //set attacker amination
//            let attackerNode = self.childNodeWithName("attackerNode")
//            
//            if(attackerNode != nil) {
//                let animation = SKAction.animateWithTextures(attackerWHAnimation, timePerFrame: 0.02)
//                attackerNode?.runAction(animation)
//            }
         //   guard !roundOver else {

            var n = true
      
            for (index,weapon) in weapons!.enumerate() {
                if weapon.containsPoint(location){
                    appDelegate.connector.sendData(["didSelectWeapon": index])
                    n = false
                    selfArmedStat = true
                    
                    weapon.alpha = 1.0
                    selected_weapon = weapon
                    boxGlowing(boxes, box_index: index)
                    
                    if(selfArmedStat == true && OppArmedStat == true){
                        print("Fight!")

                        setWeapon(selected_weapon)
                        
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
            
//                return
//            }
//            

          guard !fighting else {
                oneAttackCircle()
            return
            }
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //print("show me how")
        
    }
    /* 準備使用 */
    func oneAttackCircle(){
        let Circle = SKShapeNode(circleOfRadius: 50 )
        
        Circle.position = CGPointMake(frame.midX, frame.midY / 10)  //Middle of Screen
        Circle.strokeColor = SKColor.blackColor()
        Circle.glowWidth = 1.0
        Circle.fillColor = SKColor.orangeColor()
        let spiral = SKAction.spiral(startRadius: 50,
            endRadius: 0,
            centerPoint: Circle.position,
            duration: 1.0,
            type: 0)
        Circle.runAction(spiral)
        //Audio Effect
        Circle.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.AttackAudioName.rawValue, waitForCompletion: false))
        
        self.addChild(Circle)
    }
    
    func oneDefenseCircle(){
        let Circle = SKShapeNode(circleOfRadius: 50 )
        
        Circle.position = CGPointMake(frame.midX, frame.midY * 9 / 10)  //Middle of Screen
        Circle.strokeColor = SKColor.blackColor()
        Circle.glowWidth = 1.0
        Circle.fillColor = SKColor.orangeColor()
    
        let spiral = SKAction.spiral(startRadius: 20,
            endRadius: 0,
            centerPoint: Circle.position,
            duration: 1.0,
            type: 1)
        Circle.runAction(spiral)
        //Audio Effect
        Circle.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.AttackedAudioName.rawValue, waitForCompletion: false))
        self.addChild(Circle)
    }
    
    
}

private extension GameScene {
    func loadBackground() {
        guard let _ = childNodeWithName("background") as! SKSpriteNode? else {
            let texture = SKTexture(image: UIImage(named: "background3.jpg")!)
            let node = SKSpriteNode(texture: texture)
            node.xScale = 1.5
            node.yScale = 1.5
            node.position = CGPoint(x: frame.midX, y: frame.midY)
            node.zPosition = FaceoffGameSceneZposition.BackgroundZposition.rawValue
            //    self.physicsWorld.gravity = CGVectorMake(0, gravity)
            
            addChild(node)
            return
        }
    }
    
    func loadAttacker(){
        let attacker = SKSpriteNode(imageNamed: "attackerWH1")
        attacker.name = "attackerNode"
        attacker.position = CGPoint(x: frame.midX * 0.5, y: frame.midY * 0.5)
        attacker.xScale = 0.15
        attacker.yScale = 0.15
        attacker.zPosition = FaceoffGameSceneZposition.HeroZposition.rawValue
        attacker.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(16, 18))
        attacker.physicsBody?.affectedByGravity = false
        attacker.physicsBody?.allowsRotation = false
        
        addChild(attacker)
        
    }

    // Just put a rival for demo
    func loadHero() {
        let hero = SKSpriteNode(imageNamed: "cute")
        hero.name = FaceoffGameSceneChildName.HeroName.rawValue
        hero.position = CGPoint(x: frame.midX * 1.5, y: frame.midY * 1.5)
        hero.xScale = 0.2
        hero.yScale = 0.2
        hero.zPosition = FaceoffGameSceneZposition.HeroZposition.rawValue
        hero.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(16, 18))
        hero.physicsBody?.affectedByGravity = false
        hero.physicsBody?.allowsRotation = false
        
        addChild(hero)
    }
    

    
    func loadWeapons(imageName:[String]){
        
    
        boxes = [
            addSprite("weapon_box", location: CGPoint(x: scene!.size.width-40,y: 195.0),scale: 0.4),
            addSprite("weapon_box", location: CGPoint(x: scene!.size.width-40,y: 130.0),scale: 0.4),
            addSprite("weapon_box", location: CGPoint(x: scene!.size.width-40,y: 65.0),scale: 0.4)
        ]
        
        weapons = [
            addSprite(weaponsStringArray[Int(imageName[0])!], location: CGPoint(x: scene!.size.width-40,y: 195.0),scale: 0.5),
            addSprite(weaponsStringArray[Int(imageName[1])!], location: CGPoint(x: scene!.size.width-40,y: 130.0),scale: 0.5),
            addSprite(weaponsStringArray[Int(imageName[2])!], location: CGPoint(x: scene!.size.width-40,y: 65.0),scale: 0.5),

        ]
        

        
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
            
            Fight.runAction(action_combine) { () -> Void in
                
                //weapon.position = self.weapon1_ori_pos
                weapon.removeFromParent()
                self.selfArmedStat = false;
                self.OppArmedStat = false;
                self.boxStopGlowing(self.boxes)
            }
            
        }
        fighting = true
        roundCount++
        
        /*
        let myLabel = SKLabelNode(fontNamed: "Arial")
        myLabel.text = "Ready"
        myLabel.fontSize = 50
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        addChild(myLabel)
        */

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
    
    func starEmitterActionAtPosition(position: CGPoint) -> SKAction {
        let emitter = SKEmitterNode(fileNamed: "StarExplosion")
        emitter?.position = position
        emitter?.zPosition = FaceoffGameSceneZposition.EmitterZposition.rawValue
        emitter?.alpha = 0.6
        addChild((emitter)!)
        
        let wait = SKAction.waitForDuration(0.15)
        
        return SKAction.runBlock({ () -> Void in
            emitter?.runAction(wait)
        })
    }
    
    func loadGameOverLayer() {
        let node = SKNode()
        node.alpha = 0
        node.name = FaceoffGameSceneChildName.GameOverLayerName.rawValue
        node.zPosition = FaceoffGameSceneZposition.GameOverZposition.rawValue
        addChild(node)
        
        let label = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
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