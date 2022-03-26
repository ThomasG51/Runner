//
//  GameViewController.swift
//  Runner
//
//  Created by Thomas George on 26/03/2022.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            
            // Develop infos
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }

}
