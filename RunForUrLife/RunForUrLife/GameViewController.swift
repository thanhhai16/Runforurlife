//
//  GameViewController.swift
//  RunForUrLife
//
//  Created by Hai on 9/10/16.
//  Copyright (c) 2016 HaiTrung. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //1 cast view to SKView
        let skView = self.view as! SKView
        
        skView.showsNodeCount = true
        skView.showsFPS = true
        //2 create game scene
        let gameScene = GameScene(size: skView.frame.size)
        
        //3 present gameScene
        skView.presentScene(gameScene)
    }

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
