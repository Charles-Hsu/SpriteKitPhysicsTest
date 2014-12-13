SpriteKitPhysicsTest
====================
程式碼裡頭有一段需要記錄起來

View \ Assistant Editor \ Show Assistant Editor 可以看執行的過程

```swift
var trianglePath = CGPathCreateMutable()

triangle.anchorPoint // default (0.5, 0.5)

// moveTo (-35,-35)
CGPathMoveToPoint(trianglePath, nil, -triangle.size.width/2, -triangle.size.height/2)

// AddLineTo (35, -35)
CGPathAddLineToPoint(trianglePath, nil, triangle.size.width/2, -triangle.size.height/2)

// AddLineTo (0, 35)
CGPathAddLineToPoint(trianglePath, nil, 0, triangle.size.height/2)

// AddLineTo (-35, -35)
CGPathAddLineToPoint(trianglePath, nil, -triangle.size.width/2, -triangle.size.height/2)

triangle.physicsBody = SKPhysicsBody(polygonFromPath: trianglePath)
```
default 的錨點在 (0.5, 0.5), 也就是 SKPriteNode 的中心點, 因為 triangle 圖檔的大小為 70x70, 中心點為 (0,0), 所以 (-35, -35) 也就是左下角的座標. 然後 AddLineTo (35, -35), 也就是三角形右下角的座標. 然後再移到 (0, 35) 也就是三角形的上頂點. 最後再移回 (-35, -35).

![]()