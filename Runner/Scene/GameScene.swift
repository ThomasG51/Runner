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
    var superCoins = 0
    var popup: PopupNode?
    var world: Int
    var level: Int
    var levelKey: String
    let soundPlayer = SoundPlayer()
    
    var hudDelegate: HudDelegate?
    var sceneManagerDelegate: SceneManagerDelegate?

    var gameState = GameState.ready {
        willSet {
            switch newValue {
            case .ongoing:
                player.state = .running
                pauseEnemies(bool: false)
            case .finished:
                player.state = .idle
                pauseEnemies(bool: true)
            case .paused:
                player.state = .idle
                pauseEnemies(bool: true)
            default:
                break
            }
        }
    }
    
    init(size: CGSize, world: Int, level: Int, sceneManagerDelegate: SceneManagerDelegate) {
        self.world = world
        self.level = level
        self.levelKey = "Level_\(world)-\(level)"
        self.sceneManagerDelegate = sceneManagerDelegate
        super.init(size: size)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        load(level: levelKey)
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
        addHud()
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
        
        if let sparky = ParticleHelper.addParticleEffect(name: GameConstants.Particle.brakeSparkEmitter, particlePositionRange: CGVector(dx: 30.0, dy: 30.0), position: CGPoint(x: player.position.x, y: player.position.y - player.size.height / 2)) {
            sparky.zPosition = GameConstants.Zpositions.elements
            addChild(sparky)
        }
        
        player.run(player.userData?.value(forKey: GameConstants.Actions.brakeDescendActionKEy) as! SKAction) {
            ParticleHelper.removeParticleEffect(name: GameConstants.Particle.brakeSparkEmitter, from: self)
        }
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
        case
            GameConstants.AssetNames.coin,
            _ where GameConstants.AssetNames.superCoinNames.contains(sprite.name!):
            run(soundPlayer.coinSound)
            collectCoin(sprite: sprite)
        default:
            break
        }
    }
    
    func collectCoin(sprite: SKSpriteNode) {
        if GameConstants.AssetNames.superCoinNames.contains(sprite.name!) {
            superCoins += 1
            for index in 0 ..< 3 {
                if GameConstants.AssetNames.superCoinNames[index] == sprite.name! {
                    hudDelegate?.addSuperCoin(index: index)
                }
            }
        } else {
            coins += 1
            hudDelegate?.updateCoinLabel(coins: coins)
        }
        
        guard let coinDust = ParticleHelper.addParticleEffect(name: GameConstants.Particle.coinDustEmitter, particlePositionRange: CGVector(dx: 5.0, dy: 5.0), position: CGPoint.zero) else { return }
        coinDust.zPosition = GameConstants.Zpositions.elements
        sprite.addChild(coinDust)
        
        sprite.run(SKAction.fadeOut(withDuration: 0.4)) {
            coinDust.removeFromParent()
            sprite.removeFromParent()
        }
    }
    
    func buttonHandler(index: Int) {
        if gameState == .ongoing {
            gameState = .paused
            createAndShowPopup(type: 0, title: GameConstants.State.pausedKey)
        }
    }
    
    func addHud() {
        let hud = GameHud(with: CGSize(width: frame.width, height: frame.height * 0.1))
        hud.position = CGPoint(x: frame.midX, y: frame.maxY - frame.height * 0.05)
        hud.zPosition = GameConstants.Zpositions.hud
        hudDelegate = hud
        addChild(hud)
        
        let pauseButton = ButtonNode(defaultButtonImage: GameConstants.AssetNames.pauseButton, action: buttonHandler, index: 0)
        pauseButton.scale(to: frame.size, width: false, multiplier: 0.1)
        pauseButton.position = CGPoint(x: frame.midX, y: frame.maxY - pauseButton.size.height / 1.9)
        pauseButton.zPosition = GameConstants.Zpositions.hud
        addChild(pauseButton)
    }
    
    func createAndShowPopup(type: Int, title: String) {
        switch type {
        case 0:
            popup = PopupNode(with: title, and: SKTexture(imageNamed: GameConstants.AssetNames.smallPopup), buttonHandlerDelegate: self)
            popup!.add(buttons: [0, 3, 2])
        default:
            popup = ScorePopupNode(buttonHandlerDelegate: self, title: title, level: levelKey, texture: SKTexture(imageNamed: GameConstants.AssetNames.largePopup), score: coins, coins: superCoins, animated: true)
            popup!.add(buttons: [2, 0])
        }
        popup!.position = CGPoint(x: frame.midX, y: frame.midY)
        popup!.zPosition = GameConstants.Zpositions.hud
        popup!.scale(to: frame.size, width: true, multiplier: 0.8)
        addChild(popup!)
    }
    
    func die(reason: Int) {
        run(soundPlayer.deathSound)
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
            self.createAndShowPopup(type: 1, title: GameConstants.State.failedKey)
        }
    }
    
    func finish() {
        run(soundPlayer.completedSound)
        gameState = .finished
        
        var stars = 0
        let percentage = CGFloat(coins) / 64.0
        
        if superCoins == 3, percentage >= 0.8 {
            stars = 3
        } else if percentage >= 0.6 {
            stars = 2
        } else if percentage >= 0.3 {
            stars = 1
        }
        
        let scores = [
            GameConstants.Score.scoreKey: coins,
            GameConstants.Score.starsKey: stars,
            GameConstants.Score.coinsKey: superCoins
        ]
        
        ScoreHelper.compare(scores: [scores], in: levelKey)
        createAndShowPopup(type: 1, title: GameConstants.State.completedKey)
        
        #if DEBUG
        print("Coins: \(coins)/64 (\(percentage * 100)%)")
        print("Super Coins: \(superCoins)/3")
        #endif
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
            finish()
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

extension GameScene: PopupButtonHandlerDelegate {
    func popupButtonHandler(index: Int) {
        switch index {
        case 0:
            // Menu
            sceneManagerDelegate?.presentMenuScene()
        case 1:
            // Play
            sceneManagerDelegate?.presentGameScene(for: world, in: level)
        case 2:
            // Retry
            sceneManagerDelegate?.presentLevelScene(for: level)
        case 3:
            // Cancel
            popup!.run(SKAction.fadeOut(withDuration: 0.2), completion: {
                self.popup!.removeFromParent()
                self.gameState = .ongoing
            })
        default:
            break
        }
    }
}
