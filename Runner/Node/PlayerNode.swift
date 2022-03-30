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
    
    var airborne = false
    
    func loadTextures() {
        idleFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.Atlas.playerIdleAtlas), withName: GameConstants.Atlas.idlePrefixKey)
        runFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.Atlas.playerRunAtlas), withName: GameConstants.Atlas.runPrefixKey)
        jumpFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.Atlas.playerJumpAtlas), withName: GameConstants.Atlas.jumpPrefixKey)
        dieFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.Atlas.playerDieAtlas), withName: GameConstants.Atlas.diePrefixKey)
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
