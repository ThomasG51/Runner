//
//  GameViewController.swift
//  Runner
//
//  Created by Thomas George on 26/03/2022.
//

import AVFoundation
import SpriteKit
import UIKit

var backgroundMusicPlayer: AVAudioPlayer!

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        presentMenuScene()
        startBackgroundMusic()
    }

    func startBackgroundMusic() {
        let path = Bundle.main.path(forResource: "background", ofType: "wav")
        let url = URL(fileURLWithPath: path!)

        backgroundMusicPlayer = try! AVAudioPlayer(contentsOf: url)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.play()
    }
}

extension GameViewController: SceneManagerDelegate {
    func presentLevelScene(for world: Int) {
        let scene = LevelScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill
        scene.world = world
        scene.sceneManagerDelegate = self
        present(scene: scene)
    }

    func presentGameScene(for level: Int, in world: Int) {
        let scene = GameScene(size: view.bounds.size, world: world, level: level, sceneManagerDelegate: self)
        scene.scaleMode = .aspectFill
        present(scene: scene)
    }

    func presentMenuScene() {
        let scene = MenuScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill
        scene.sceneManagerDelegate = self
        present(scene: scene)
    }

    func present(scene: SKScene) {
        if let view = self.view as! SKView? {
            view.presentScene(scene)
            view.ignoresSiblingOrder = true

            #if DEBUG
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
            #endif
        }
    }
}
