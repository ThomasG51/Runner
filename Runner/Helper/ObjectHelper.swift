//
//  ObjectHelper.swift
//  Runner
//
//  Created by Thomas George on 03/12/2022.
//

import Foundation
import SpriteKit

class ObjectHelper {
    static func handleChild(sprite: SKSpriteNode, with name: String) {
        switch name {
        case
            GameConstants.AssetNames.finishLine,
            GameConstants.AssetNames.enemy,
            _ where GameConstants.AssetNames.superCoinNames.contains(name):
            PhysicsHelper.addPhysicsBody(to: sprite, with: name)
        default:
            let component = name.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            if let rows = Int(component[0]), let columns = Int(component[1]) {
                calculateGridWidth(rows: rows, columns: columns, parent: sprite)
            }
        }
    }

    static func calculateGridWidth(rows: Int, columns: Int, parent: SKSpriteNode) {
        parent.color = UIColor.clear
        for x in 0..<columns {
            for y in 0..<rows {
                let position = CGPoint(x: x, y: y)
                addCoin(to: parent, at: position, columns: columns)
            }
        }
    }

    static func addCoin(to parent: SKSpriteNode, at position: CGPoint, columns: Int) {
        let coin = SKSpriteNode(imageNamed: GameConstants.AssetNames.coinDefault)
        coin.size = CGSize(width: parent.size.width / CGFloat(columns), height: parent.size.width / CGFloat(columns))
        coin.name = GameConstants.AssetNames.coin

        let positionX = position.x * coin.size.width + coin.size.width / 2
        let positionY = position.y * coin.size.height + coin.size.height / 2
        coin.position = CGPoint(x: positionX, y: positionY)

        let coinFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.Atlas.coinRotateAtlas), withName: GameConstants.Atlas.coinPrefixKey)

        coin.run(SKAction.repeatForever(SKAction.animate(with: coinFrames, timePerFrame: 0.1)))
        
        PhysicsHelper.addPhysicsBody(to: coin, with: GameConstants.AssetNames.coin)
        
        parent.addChild(coin)
    }
}
