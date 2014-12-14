//
//  GameScene.swift
//  SpriteKitPhysicsTest
//
//  Created by Charles Hsu on 12/14/14.
//  Copyright (c) 2014 Loxoll. All rights reserved.
//

import SpriteKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    }
    static func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min
    }
}

class GameScene: SKScene {
    
    let square = SKSpriteNode(imageNamed: "square")
    let triangle = SKSpriteNode(imageNamed: "triangle")
    let circle = SKSpriteNode(imageNamed: "circle")
    
    var dt: NSTimeInterval = 0
    var lastUpdateTime: NSTimeInterval = 0
    var windForce: CGVector = CGVector(dx:0, dy:0)
    var blowing: Bool = false
    var timeUntilSwitchingDirection: NSTimeInterval = 0
    
    func delay(#seconds: Double, completion:()->()) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64( Double(NSEC_PER_SEC) * seconds ))
        
        dispatch_after(popTime,
            dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
                completion()
        }
    }
    
    func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min
    }
    
    func spawnSand() {
        
        
        let sand: SKSpriteNode = SKSpriteNode(imageNamed: "sand")
        
        //println("spawnSand()->random(): \(self.size.width)")
        sand.position = CGPoint(x: random(min: 0, max: self.size.width), y: self.size.height - sand.size.height)
        //println("spawnSand()->\(sand.position)")

        sand.physicsBody = SKPhysicsBody(circleOfRadius: sand.size.width/2)
        sand.name = "sand"
        sand.physicsBody!.restitution = 1.0
        sand.physicsBody!.density = 20.0
        
        self.addChild(sand)
        
    }
    
    func shake() {
        self.enumerateChildNodesWithName("sand") { node, _ in
            node.physicsBody!.applyImpulse(CGVector(dx: 0, dy: self.random(min:20, max:40)))
        }
        
        self.enumerateChildNodesWithName("shape") { node, _ in
            node.physicsBody!.applyImpulse(CGVector(dx: self.random(min:20, max:60), dy:
                self.random(min:20, max:60)))
        }
        
        //delay(seconds: 3, shake)
    }

    
    override init(size: CGSize) {
        
        super.init(size: size)
        
        println("init:\(size)")
        println("init:\(self.frame.size)")

        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        //self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame.size)

        square.position = CGPoint(x: self.size.width*0.25, y: self.size.height*0.50)
        triangle.position = CGPoint(x: self.size.width*0.75, y: self.size.height * 0.50)
        circle.position = CGPoint(x: self.size.width*0.5, y: self.size.height * 0.5)
            
        square.name = "shape"
        circle.name = "shape"
        triangle.name = "shape"
        
        addChild(square)
        addChild(triangle)
        addChild(circle)

        circle.physicsBody = SKPhysicsBody(circleOfRadius: circle.size.width/2)
        circle.physicsBody!.dynamic = false
        
        square.physicsBody = SKPhysicsBody(rectangleOfSize: square.frame.size)
            
        square.physicsBody!.restitution = 1.0
        

        var trianglePath = CGPathCreateMutable()
        
        CGPathMoveToPoint(trianglePath, nil, -triangle.size.width/2, -triangle.size.height/2)
        CGPathAddLineToPoint(trianglePath, nil, triangle.size.width/2, -triangle.size.height/2)
        CGPathAddLineToPoint(trianglePath, nil, 0, triangle.size.height/2)
        CGPathAddLineToPoint(trianglePath, nil, -triangle.size.width/2, -triangle.size.height/2)
        
        triangle.physicsBody = SKPhysicsBody(polygonFromPath: trianglePath)
        
        
        let l = SKSpriteNode(imageNamed: "L")
        l.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.75)
        l.physicsBody = SKPhysicsBody(texture: l.texture, size: l.size)
        addChild(l)


    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
        //println("didMoveToView")
        
        /* Setup your scene here */
        /*
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
        */
        
        delay(seconds: 1.0) {
            
            //println("delay(seconds: 2.0)")
            self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
            
            self.runAction(
                SKAction.repeatAction(
                    SKAction.sequence(
                        [
                            SKAction.runBlock(self.spawnSand),
                            SKAction.waitForDuration(0.01)
                        ]),
                    count: 100))
            
            //self.delay(seconds: 8, self.shake)
            
        }

        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */

        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)
        
        println("touchLocation=\(touchLocation)")
        
        circle.removeAllActions()
        
        circle.runAction(SKAction.moveTo(touchLocation, duration: 1.0))
        
        //let touchLocation = touch.locationInNode(backgroundLayer)
        //sceneTouched(touchLocation)

        
        
        for touch: AnyObject in touches {
        
            shake()
        
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
        }
    }
   
    
    func windBlowing() {
        self.enumerateChildNodesWithName("sand") { node, _ in
            node.physicsBody!.applyForce(self.windForce)
        }
        
        self.enumerateChildNodesWithName("shape") { node, _ in
            node.physicsBody!.applyForce(self.windForce)
        }
        
        //delay(seconds: 3, shake)
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        }
        else {
            dt = 0
        }
        
        lastUpdateTime = currentTime
        
        timeUntilSwitchingDirection -= dt
        
        if timeUntilSwitchingDirection < 0 {
            timeUntilSwitchingDirection = NSTimeInterval(random(min: 1, max: 5))
            windForce = CGVector(dx: random(min: -50, max: 50), dy: 0)
            
            //println("windForce=(\(windForce.dx),\(windForce.dy))")
            
            
        }
        
        windBlowing()
        
        
    }
}
