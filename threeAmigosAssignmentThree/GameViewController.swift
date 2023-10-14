//
//  GameViewController.swift
//  threeAmigosAssignmentThree
//
//  Created by Hans Soland on 10/13/23.
//


import UIKit
import SpriteKit


class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // print("GameViewController loaded!")

        // ensure SKView
        guard let skView = self.view as? SKView else {
            print("The view is not an SKView")
            return
        }
        
        skView.isPaused = false
        skView.ignoresSiblingOrder = true
//        // Debugging information
//        skView.showsFPS = true
//        skView.showsNodeCount = true
//        skView.showsPhysics = true

        // create/config game scene
        let scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill

        // present scene
        skView.presentScene(scene)
    }


}

