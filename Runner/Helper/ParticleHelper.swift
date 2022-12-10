//
//  ParticleHelper.swift
//  Runner
//
//  Created by Thomas George on 10/12/2022.
//

import SpriteKit

class ParticleHelper {
    static func addParticleEffect(name: String, particlePositionRange: CGVector, position: CGPoint) -> SKEmitterNode? {
        guard let emitter = SKEmitterNode(fileNamed: name) else { return nil }
        emitter.particlePositionRange = particlePositionRange
        emitter.position = position
        emitter.name = name
        return emitter
    }

    static func removeParticleEffect(name: String, node: SKNode) {
        let emitters = node[name]
        for emitter in emitters {
            emitter.removeFromParent()
        }
    }
}
