//
//  PlayerNode.swift
//  Runner
//
//  Created by Thomas George on 28/03/2022.
//

import SpriteKit

enum PLayerState {
    case idle, running
}

class PlayerNode: SKSpriteNode {
    
    var idleFrames = [SKTexture]()
    var runFrames = [SKTexture]()
    var jumpFrames = [SKTexture]()
    var dieFrames = [SKTexture]()
    
    var state = PLayerState.idle {
        willSet {
            animate(for: newValue)
        }
    }
    
    func loadTextures() {
        idleFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.atlas.playerIdleAtlas), withName: GameConstants.atlas.idlePrefixKey)
        runFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.atlas.playerRunAtlas), withName: GameConstants.atlas.runPrefixKey)
        jumpFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.atlas.playerJumpAtlas), withName: GameConstants.atlas.jumpPrefixKey)
        dieFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.atlas.playerDieAtlas), withName: GameConstants.atlas.diePrefixKey)
    }
    
    func animate(for state: PLayerState) {
        removeAllActions()
        switch state {
        case .idle:
            self.run(SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame: 0.05, resize: true, restore: true)))
        case .running:
            self.run(SKAction.repeatForever(SKAction.animate(with: runFrames, timePerFrame: 0.05, resize: true, restore: true)))
        }
    }
    
}
