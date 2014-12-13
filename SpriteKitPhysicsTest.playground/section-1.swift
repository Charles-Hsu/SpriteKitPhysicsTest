// Playground - noun: a place where people can play

import Cocoa
import SpriteKit
import XCPlayground

func delay(#seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW,
        Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(popTime,
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
            completion()
        }
}

let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 480, height: 320))

let scene = SKScene(size: CGSize(width: 480, height: 320))
scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
scene.physicsBody = SKPhysicsBody(edgeLoopFromRect: scene.frame)

sceneView.showsFPS = true
sceneView.presentScene(scene)

XCPShowView("My Scene", sceneView)

let square = SKSpriteNode(imageNamed: "square")

square.position = CGPoint(x: scene.size.width*0.25, y: scene.size.height*0.50)

let triangle = SKSpriteNode(imageNamed: "triangle")
triangle.position = CGPoint(x: scene.size.width*0.75, y: scene.size.height * 0.50)

let circle = SKSpriteNode(imageNamed: "circle")

circle.position = CGPoint(x: scene.size.width*0.5, y: scene.size.height * 0.5)


scene.addChild(square)
scene.addChild(triangle)
scene.addChild(circle)


circle.physicsBody = SKPhysicsBody(circleOfRadius: circle.size.width/2)
square.physicsBody = SKPhysicsBody(rectangleOfSize: square.frame.size)

var trianglePath = CGPathCreateMutable()



triangle.anchorPoint // default (0.5, 0.5)

triangle.size.width
triangle.size.height


// moveTo
CGPathMoveToPoint(trianglePath, nil, -triangle.size.width/2, -triangle.size.height/2)

println("moveTo")
-triangle.size.width/2
-triangle.size.height/2


// AddLineTo
CGPathAddLineToPoint(trianglePath, nil, triangle.size.width/2, -triangle.size.height/2)

println("addLineTo")
triangle.size.width/2
-triangle.size.height/2

// AddLineTo
CGPathAddLineToPoint(trianglePath, nil, 0, triangle.size.height/2)

println("addLineTo")
0
triangle.size.height/2

// AddLineTo
CGPathAddLineToPoint(trianglePath, nil, -triangle.size.width/2, -triangle.size.height/2)

println("addLineTo")
-triangle.size.width/2
-triangle.size.height/2



triangle.physicsBody = SKPhysicsBody(polygonFromPath: trianglePath)

func random(#min: CGFloat, #max: CGFloat) -> CGFloat {
    return CGFloat(Float(arc4random()) / Float(0xffffffff)) * (max - min) + min
}

func spawnSand() {
    let sand: SKSpriteNode = SKSpriteNode(imageNamed: "sand")
    sand.position = CGPoint(x: random(min: 0, max: scene.size.width), y: scene.size.height - sand.size.height)
    
    sand.physicsBody = SKPhysicsBody(circleOfRadius: sand.size.width/2)
    sand.name = "sand"
    scene.addChild(sand)
    
}


delay(seconds: 2.0) {
 
    scene.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
    
    
    scene.runAction(
    SKAction.repeatAction(
        SKAction.sequence(
        [
            SKAction.runBlock(spawnSand),
            SKAction.waitForDuration(0.01)
        ]),
        count: 100))
    
    
}






