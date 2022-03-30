//
//  GameConstants.swift
//  Runner
//
//  Created by Thomas George on 28/03/2022.
//

import Foundation
import CoreGraphics

struct GameConstants {
    
    struct Zpositions {
        static let farBackground: CGFloat = 0
        static let closeBackground: CGFloat = 1
        static let world: CGFloat = 2
        static let elements: CGFloat = 3
        static let player: CGFloat = 4
        static let hud: CGFloat = 5
    }
    
    struct assetNames {
        static let groundTiles = "Ground Tiles"
        static let desertBackground = "DesertBackground"
        static let grassBackground = "GrassBackground"
        static let player = "Player"
        static let playerDefault = "Idle_0"
        static let ground = "GroundNode"
    }
    
    struct atlas {
        static let playerIdleAtlas = "Player Idle Atlas"
        static let idlePrefixKey = "Idle_"
        static let playerRunAtlas = "Player Run Atlas"
        static let runPrefixKey = "Run_"
        static let playerJumpAtlas = "Player Jump Atlas"
        static let jumpPrefixKey = "Jump_"
        static let playerDieAtlas = "Player Die Atlas"
        static let diePrefixKey = "Die_"
    }
}
