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
        case GameConstants.AssetNames.finishLine:
            PhysicsHelper.addPhysicsBody(to: sprite, with: name)
        default:
            break
        }
    }
}
