//
//  GameScene.swift
//  Runner
//
//  Created by Thomas George on 26/03/2022.
//

import SpriteKit

enum GameState {
    case ready, ongoing, paused, finished
}

class GameScene: SKScene {
    
    var worldLayer: Layer!
    var backgroundLayer: RepeatingLayer!
    var mapNode: SKNode!
    var tileMap: SKTileMapNode!
    var player: PlayerNode!
    
    var lastTime: TimeInterval = 0
    var deltaTime: TimeInterval = 0

    var gameState = GameState.ready {
        willSet {
            switch newValue {
            case .ongoing:
                player.state = .running
            case .finished:
                player.state = .idle
            default:
                break
            }
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -6.0)
        
        createLayers()
    }
    
    func createLayers() {
        worldLayer = Layer()
        worldLayer.zPosition = GameConstants.Zpositions.world
        addChild(worldLayer)
        worldLayer.layerVelocity = CGPoint(x: -200, y: 0)
        
        backgroundLayer = RepeatingLayer()
        backgroundLayer.zPosition = GameConstants.Zpositions.farBackground
        addChild(backgroundLayer)
        
        for index in 0...1 {
            let backgroundImage = SKSpriteNode(imageNamed: GameConstants.assetNames.desertBackground)
            backgroundImage.name = String(index)
            backgroundImage.scale(to: frame.size, width: false, multiplier: 1.0)
            backgroundImage.anchorPoint = CGPoint.zero
            backgroundImage.position = CGPoint(x: 0.0 + CGFloat(index) * backgroundImage.size.width, y: 0)
            backgroundLayer.addChild(backgroundImage)
        }
        
        backgroundLayer.layerVelocity = CGPoint(x: -(100), y: 0)
        
        load(level: "Level_0-1")
    }
    
    func load(level: String) {
        guard let levelNode = SKNode.unarchiveFromFile(file: level) else { return }
        mapNode = levelNode
        worldLayer.addChild(mapNode)
        loadTileMap()
    }
    
    func loadTileMap() {
        guard let groundTiles = mapNode.childNode(withName: GameConstants.assetNames.groundTiles) as? SKTileMapNode else { return }
        tileMap = groundTiles
        tileMap.scale(to: frame.size, width: false, multiplier: 1.0)
        PhysicsHelper.addPhysics(to: tileMap, with: "ground")
        
        addPlayer()
    }

    func addPlayer() {
        player = PlayerNode(imageNamed: GameConstants.assetNames.playerDefault)
        player.scale(to: frame.size, width: false, multiplier: 0.1)
        player.name = GameConstants.assetNames.player
        PhysicsHelper.addPhysicsBody(to: player, with: player.name!)
        player.position = CGPoint(x: frame.midX / 2, y: frame.midY)
        player.zPosition = GameConstants.Zpositions.player
        player.loadTextures()
        player.state = .idle
        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .ready:
            gameState = .ongoing
        case .ongoing:
            break
        case .paused:
            break
        case .finished:
            break
        default:
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastTime > 0 {
            deltaTime = currentTime - lastTime
        } else {
            deltaTime = 0
        }
        lastTime = currentTime
        
        if gameState == .ongoing {
            worldLayer.update(deltaTime)
            backgroundLayer.update(deltaTime)
        }
    }
    
    override func didSimulatePhysics() {
        for node in tileMap[GameConstants.assetNames.ground] {
            if let groundNode = node as? GroundNode {
                let groundY = (groundNode.position.y + groundNode.size.height) * tileMap.yScale
                let playerY = player.position.y - player.size.height / 3
                groundNode.isBodyActivated = playerY > groundY
            }
        }
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
}
