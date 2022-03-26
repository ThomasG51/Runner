//
//  GameScene.swift
//  Runner
//
//  Created by Thomas George on 26/03/2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var mapNode: SKNode!
    var tileMap: SKTileMapNode!
    
    override func didMove(to view: SKView) {
        load(level: "Level_0-1")
    }
    
    func load(level: String) {
        guard let levelNode = SKNode.unarchiveFromFile(file: level) else { return }
        mapNode = levelNode
        addChild(mapNode)
        loadTileMap()
    }
    
    func loadTileMap() {
        guard let groundTiles = mapNode.childNode(withName: "Ground Tiles") as? SKTileMapNode else { return }
        tileMap = groundTiles
        tileMap.scale(to: frame.size, width: false, multiplier: 1.0)
    }

    override func update(_ currentTime: TimeInterval) {
        //
    }
    
}
