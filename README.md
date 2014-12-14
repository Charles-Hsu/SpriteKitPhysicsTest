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

![](https://github.com/Charles-Hsu/SpriteKitPhysicsTest/blob/master/triangle.png)

接下來, 要將 playground PO 到 project, 測試發現 random(#min, max) 有問題, 在 iPad 下, 會產生小於零的 x 值, 所以將 random 改成先前的程式碼

```swift
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    }
    static func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min
    }
}
```

同時, 增加一小行程式偵測螢幕大小. 放在 GameViewController 裡頭:

```swift
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let scene = GameScene(size: CGSizeMake(screenSize.size.width, screenSize.size.height))
```

由於把自動地震的 shake() 移出, 改放到 touchesBegan().

另外, physicalBody 預設的 restitution (恢復原狀) 的值為 0.2, 限定在 0.0 ~ 1.0 之間. 且會依照體積的大小自動調整, 為了讓 shake() 看起來差不多. 所以加入這一段

```swift
square.physicsBody!.restitution = 0.5
```

不小心設定了 5.0, 結果一 shake(), square 就不見蹤影了 :]

最後, 把 circle 的 dynamic 設為 false, 在 touchesBegan() 裡將 circle 的 allActions 拿掉, 並且讓 circle 移到所 touch 的地方.

```swift
let touch = touches.anyObject() as UITouch
let touchLocation = touch.locationInNode(self)
circle.removeAllActions()
circle.runAction(SKAction.moveTo(touchLocation, duration: 1.0))
```

Done!