//
//  MenuScene.swift
//  Runner
//
//  Created by Thomas George on 23/12/2022.
//

import SpriteKit

class MenuScene: SKScene {
    var sceneManagerDelegate: SceneManagerDelegate?

    override func didMove(to _: SKView) {
        layoutView()
    }

    func layoutView() {
        let logoLabel = SKLabelNode(fontNamed: GameConstants.AssetNames.gameFontName)
        logoLabel.text = GameConstants.AssetNames.gameName
        logoLabel.fontSize = 200
        logoLabel.fontColor = UIColor.white
        logoLabel.scale(to: frame.size, width: true, multiplier: 0.8)
        logoLabel.position = CGPoint(x: frame.midX, y: frame.maxY * 0.75 - logoLabel.frame.size.height / 2)
        logoLabel.zPosition = GameConstants.Zpositions.hud
        addChild(logoLabel)

        let startButton = ButtonNode(defaultButtonImage: GameConstants.AssetNames.playButton, action: goToLevelScene, index: 0)
        startButton.scale(to: frame.size, width: false, multiplier: 0.1)
        startButton.position = CGPoint(x: frame.midX, y: frame.midY)
        startButton.zPosition = GameConstants.Zpositions.hud
        addChild(startButton)
    }

    func goToLevelScene(_: Int) {
        sceneManagerDelegate?.presentLevelScene(for: 0)
    }
}
