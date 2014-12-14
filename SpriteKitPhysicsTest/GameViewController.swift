//
//  GameViewController.swift
//  SpriteKitPhysicsTest
//
//  Created by Charles Hsu on 12/14/14.
//  Copyright (c) 2014 Loxoll. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let scene = GameScene(size: CGSizeMake(screenSize.size.width, screenSize.size.height))
        
            let skView = self.view as SKView
        
            skView.showsFPS = true
            skView.showsNodeCount = true
        
        skView.showsPhysics = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        //}
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
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
