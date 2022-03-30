//
//  PhysicsHelper.swift
//  Runner
//
//  Created by Thomas George on 28/03/2022.
//

import SpriteKit

class PhysicsHelper {
    
    static func addPhysicsBody(to sprite: SKSpriteNode, with name: String) {
        switch name {
        case GameConstants.AssetNames.player:
            sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width/2, height: sprite.size.height))
            sprite.physicsBody!.restitution = 0
            sprite.physicsBody!.allowsRotation = false
            sprite.physicsBody?.categoryBitMask = GameConstants.PhysicsCategories.player
            sprite.physicsBody?.collisionBitMask = GameConstants.PhysicsCategories.ground | GameConstants.PhysicsCategories.finish
            sprite.physicsBody?.contactTestBitMask = GameConstants.PhysicsCategories.all
        default:
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        }
    }
    
    static func addPhysics(to tileMap: SKTileMapNode, with tileInfo: String) {
        let tileSize = tileMap.tileSize
        
        for row in 0..<tileMap.numberOfRows {
            var groundTiles = [Int]()
            
            for column in 0..<tileMap.numberOfColumns {
                let tileDefinition = tileMap.tileDefinition(atColumn: column, row: row)
                let isUSedTile = tileDefinition?.userData?[tileInfo] as? Bool
                
                if isUSedTile ?? false {
                    groundTiles.append(1)
                } else {
                    groundTiles.append(0)
                }
            }
            
            if groundTiles.contains(1) {
                var platform = [Int]()
                
                for (index, tile) in groundTiles.enumerated() {
                    if tile == 1 && index < (tileMap.numberOfColumns - 1) {
                        platform.append(index)
                    } else if !platform.isEmpty {
                        let x = CGFloat(platform[0]) * tileSize.width
                        let y = CGFloat(row) * tileSize.height
                        
                        let tileNode = GroundNode(with: CGSize(width: tileSize.width * CGFloat(platform.count), height: tileSize.height))
                        tileNode.position = CGPoint(x: x, y: y)
                        tileNode.anchorPoint = CGPoint.zero
                        
                        tileMap.addChild(tileNode)
                        platform.removeAll()
                    }
                }
            }
        }
    }
    
}
