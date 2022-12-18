//
//  GameHud.swift
//  Runner
//
//  Created by Thomas George on 18/12/2022.
//

import SpriteKit

class GameHud: SKSpriteNode {
    var coinLabel: SKLabelNode
    var superCoinCounter: SKSpriteNode
    
    init(with size: CGSize) {
        coinLabel = SKLabelNode(fontNamed: GameConstants.AssetNames.gameFontName)
        superCoinCounter = SKSpriteNode(texture: nil, color: UIColor.clear, size: CGSize(width: size.width * 0.3, height: size.height * 0.8))
        
        super.init(texture: nil, color: UIColor.clear, size: size)
        
        coinLabel.verticalAlignmentMode = .center
        coinLabel.text = "0"
        coinLabel.fontSize = 200
        coinLabel.scale(to: frame.size, width: false, multiplier: 0.8)
        coinLabel.position = CGPoint(x: frame.maxX - coinLabel.frame.size.width * 2, y: frame.midY)
        coinLabel.zPosition = GameConstants.Zpositions.hud
        addChild(coinLabel)
        
        superCoinCounter.position = CGPoint(x: frame.minX + superCoinCounter.frame.size.width / 2, y: frame.midY)
        superCoinCounter.zPosition = GameConstants.Zpositions.hud
        addChild(superCoinCounter)
        
        for i in 0 ..< 3 {
            let emptySlot = SKSpriteNode(imageNamed: GameConstants.AssetNames.superCoin)
            emptySlot.name = String(i)
            emptySlot.alpha = 0.5
            emptySlot.scale(to: superCoinCounter.size, width: true, multiplier: 0.3)
            emptySlot.position = CGPoint(
                x: -superCoinCounter.size.width / 2 + emptySlot.size.width / 2 + CGFloat(i) * superCoinCounter.size.width / 2 + superCoinCounter.size.width * 0.05,
                y: superCoinCounter.frame.midY)
            emptySlot.zPosition = GameConstants.Zpositions.hud
            superCoinCounter.addChild(emptySlot)
        }
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GameHud: HudDelegate {
    func updateCoinLabel(coins: Int) {
        coinLabel.text = "\(coins)"
    }
    
    func addSuperCoin(index: Int) {
        let emptySlot = superCoinCounter[String(index)].first as! SKSpriteNode
        emptySlot.alpha = 1.0
    }
}
