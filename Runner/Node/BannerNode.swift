//
//  BannerNode.swift
//  Runner
//
//  Created by Thomas George on 18/12/2022.
//

import SpriteKit

class BannerNode: SKSpriteNode {
    init(with title: String) {
        let texture = SKTexture(imageNamed: GameConstants.AssetNames.banner)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())

        let label = SKLabelNode(fontNamed: GameConstants.AssetNames.gameFontName)
        label.fontSize = 200
        label.verticalAlignmentMode = .center
        label.text = title
        label.scale(to: size, width: false, multiplier: 0.3)
        label.zPosition = GameConstants.Zpositions.hud
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
