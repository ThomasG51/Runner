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
    var touch = false
    var brake = false
    var lastTime: TimeInterval = 0
    var deltaTime: TimeInterval = 0
    var coins = 0

    var gameState = GameState.ready {
        willSet {
            switch newValue {
            case .ongoing:
                player.state = .running
                pauseEnemies(bool: false)
            case .finished:
                player.state = .idle
                pauseEnemies(bool: true)
            default:
                break
            }
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -6.0)
        physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: frame.minX, y: frame.minY), to: CGPoint(x: frame.maxX, y: frame.minY))
        physicsBody?.categoryBitMask = GameConstants.PhysicsCategories.frame
        physicsBody?.contactTestBitMask = GameConstants.PhysicsCategories.player
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
        for index in 0 ... 1 {
            let backgroundImage = SKSpriteNode(imageNamed: GameConstants.AssetNames.desertBackground)
            backgroundImage.name = String(index)
            backgroundImage.scale(to: frame.size, width: false, multiplier: 1.0)
            backgroundImage.anchorPoint = CGPoint.zero
            backgroundImage.position = CGPoint(x: 0.0 + CGFloat(index) * backgroundImage.size.width, y: 0)
            backgroundLayer.addChild(backgroundImage)
        }
        backgroundLayer.layerVelocity = CGPoint(x: -100, y: 0)
        load(level: "Level_0-1")
    }
    
    func load(level: String) {
        guard let levelNode = SKNode.unarchiveFromFile(file: level) else { return }
        mapNode = levelNode
        levelNode.isPaused = false
        worldLayer.addChild(mapNode)
        loadTileMap()
    }
    
    func loadTileMap() {
        guard let groundTiles = mapNode.childNode(withName: GameConstants.AssetNames.groundTiles) as? SKTileMapNode else { return }
        tileMap = groundTiles
        tileMap.scale(to: frame.size, width: false, multiplier: 1.0)
        PhysicsHelper.addPhysics(to: tileMap, with: "ground")
        for child in groundTiles.children {
            if let sprite = child as? SKSpriteNode, sprite.name != nil {
                ObjectHelper.handleChild(sprite: sprite, with: sprite.name!)
            }
        }
        addPlayer()
    }

    func addPlayer() {
        player = PlayerNode(imageNamed: GameConstants.AssetNames.playerDefault)
        player.scale(to: frame.size, width: false, multiplier: 0.1)
        player.name = GameConstants.AssetNames.player
        PhysicsHelper.addPhysicsBody(to: player, with: player.name!)
        player.position = CGPoint(x: frame.midX / 2, y: frame.midY)
        player.zPosition = GameConstants.Zpositions.player
        player.loadTextures()
        player.state = .idle
        addChild(player)
        addPlayerActions()
    }
    
    func addPlayerActions() {
        let up = SKAction.moveBy(x: 0, y: frame.size.height / 4, duration: 0.4)
        up.timingMode = .easeOut
        player.createUserData(entry: up, forkey: GameConstants.Actions.jumpUpActionKey)
        let move = SKAction.moveBy(x: 0, y: player.size.height, duration: 0.4)
        let jump = SKAction.animate(with: player.jumpFrames, timePerFrame: 0.4 / Double(player.jumpFrames.count), resize: true, restore: true)
        let group = SKAction.group([move, jump])
        player.createUserData(entry: group, forkey: GameConstants.Actions.brakeDescendActionKEy)
    }
    
    func jump() {
        player.airborne = true
        player.turnGravity(on: false)
        player.run(player.userData?.value(forKey: GameConstants.Actions.jumpUpActionKey) as! SKAction) {
            if self.touch {
                self.player.run(self.player.userData?.value(forKey: GameConstants.Actions.jumpUpActionKey) as! SKAction) {
                    self.player.turnGravity(on: true)
                }
            }
        }
    }
    
    func brakeDescend() {
        brake = true
        player.physicsBody?.velocity.dy = 0.0
        player.run(player.userData?.value(forKey: GameConstants.Actions.brakeDescendActionKEy) as! SKAction)
    }
    
    func handleEnemyContact() {
        die(reason: 0)
    }
    
    func pauseEnemies(bool: Bool) {
        for enemy in tileMap[GameConstants.AssetNames.enemy] {
            enemy.isPaused = bool
        }
    }
    
    func handleCollectible(sprite: SKSpriteNode) {
        switch sprite.name {
        case GameConstants.AssetNames.coin:
            collectCoin(sprite: sprite)
        default:
            break
        }
    }
    
    func collectCoin(sprite: SKSpriteNode) {
        coins += 1
        
        guard let coinDust = ParticleHelper.addParticleEffect(name: GameConstants.Particle.coinDustEmitter, particlePositionRange: CGVector(dx: 5.0, dy: 5.0), position: CGPoint.zero) else { return }
        coinDust.zPosition = GameConstants.Zpositions.elements
        sprite.addChild(coinDust)
        
        sprite.run(SKAction.fadeOut(withDuration: 0.4)) {
            coinDust.removeFromParent()
            sprite.removeFromParent()
        }
    }
    
    func die(reason: Int) {
        gameState = .finished
        player.turnGravity(on: false)
        let deathAnimation: SKAction!
        switch reason {
        case 0:
            deathAnimation = SKAction.animate(with: player.dieFrames, timePerFrame: 0.1, resize: true, restore: true)
        case 1:
            let up = SKAction.moveTo(y: frame.midY / 2, duration: 0.3)
            let wait = SKAction.wait(forDuration: 0.1)
            let down = SKAction.moveTo(y: -player.size.height, duration: 0.2)
            deathAnimation = SKAction.sequence([up, wait, down])
        default:
            deathAnimation = SKAction.animate(with: player.dieFrames, timePerFrame: 0.1, resize: true, restore: true)
        }
        player.run(deathAnimation) {
            self.player.removeFromParent()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .ready:
            gameState = .ongoing
        case .ongoing:
            touch = true
            if !player.airborne {
                jump()
            } else if !brake {
                brakeDescend()
            }
        case .paused:
            break
        case .finished:
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = false
        player.turnGravity(on: true)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = false
        player.turnGravity(on: true)
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
        for node in tileMap[GameConstants.AssetNames.ground] {
            if let groundNode = node as? GroundNode {
                let groundY = (groundNode.position.y + groundNode.size.height) * tileMap.yScale
                let playerY = player.position.y - player.size.height / 3
                groundNode.isBodyActivated = playerY > groundY
            }
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
        case GameConstants.PhysicsCategories.player | GameConstants.PhysicsCategories.ground:
            player.airborne = false
            brake = false
        case GameConstants.PhysicsCategories.player | GameConstants.PhysicsCategories.finish:
            gameState = .finished
        case GameConstants.PhysicsCategories.player | GameConstants.PhysicsCategories.enemy:
            handleEnemyContact()
        case GameConstants.PhysicsCategories.player | GameConstants.PhysicsCategories.frame:
            physicsBody = nil
            die(reason: 1)
        case GameConstants.PhysicsCategories.player | GameConstants.PhysicsCategories.collectible:
            let collectible = contact.bodyA.node?.name == player.name ? contact.bodyB.node as! SKSpriteNode : contact.bodyA.node as! SKSpriteNode
            handleCollectible(sprite: collectible)
        default:
            break
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
        case GameConstants.PhysicsCategories.player | GameConstants.PhysicsCategories.ground:
            player.airborne = true
        default:
            break
        }
    }
}
