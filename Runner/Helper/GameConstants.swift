//
//  GameConstants.swift
//  Runner
//
//  Created by Thomas George on 28/03/2022.
//

import CoreGraphics
import Foundation

struct GameConstants {
    struct Zpositions {
        static let farBackground: CGFloat = 0
        static let closeBackground: CGFloat = 1
        static let world: CGFloat = 2
        static let elements: CGFloat = 3
        static let player: CGFloat = 4
        static let hud: CGFloat = 5
    }
    
    struct AssetNames {
        static let gameName = "Indie Run"
        static let groundTiles = "Ground Tiles"
        static let desertBackground = "DesertBackground"
        static let grassBackground = "GrassBackground"
        static let worldBackgroundNames = ["DesertBackground", "GrassBackground"]
        static let player = "Player"
        static let playerDefault = "Idle_0"
        static let ground = "GroundNode"
        static let enemy = "Enemy"
        static let finishLine = "FinishLine"
        static let coin = "Coin"
        static let coinDefault = "gold0"
        static let superCoin = "SuperCoin"
        static let superCoinNames = ["Super1", "Super2", "Super3"]
        static let gameFontName = "Unanimous Inverted -BRK-"
        static let playButton = "PlayButton"
        static let retryButton = "RetryButton"
        static let menuButton = "MenuButton"
        static let pauseButton = "PauseButton"
        static let emptyButton = "EmptyButton"
        static let cancelButton = "CancelButton"
        static let largePopup = "PopupLarge"
        static let smallPopup = "PopupSmall"
        static let fullStar = "StarFull"
        static let emptyStar = "StarEmpty"
        static let banner = "Banner"
        static let popupButtons = ["MenuButton", "PlayButton", "RetryButton", "CancelButton"]
    }
    
    struct Score {
        static let scoreKey = "score"
        static let coinsKey = "coins"
        static let starsKey = "stars"
    }
    
    struct State {
        static let pausedKey = "Paused"
        static let completedKey = "Completed"
        static let failedKey = "Failed"
    }
    
    struct Atlas {
        static let playerIdleAtlas = "Player Idle Atlas"
        static let idlePrefixKey = "Idle_"
        static let playerRunAtlas = "Player Run Atlas"
        static let runPrefixKey = "Run_"
        static let playerJumpAtlas = "Player Jump Atlas"
        static let jumpPrefixKey = "Jump_"
        static let playerDieAtlas = "Player Die Atlas"
        static let diePrefixKey = "Die_"
        static let coinRotateAtlas = "Coin Rotate Atlas"
        static let coinPrefixKey = "gold"
    }
    
    struct Actions {
        static let jumpUpActionKey = "JumpUp"
        static let brakeDescendActionKEy = "BrakeDescend"
    }
    
    struct Particle {
        static let coinDustEmitter = "CoinDustEmitter"
        static let brakeSparkEmitter = "BrakeSparkEmitter"
    }
    
    struct PhysicsCategories {
        static let no: UInt32 = 0
        static let all: UInt32 = .max
        static let player: UInt32 = 0x1
        static let ground: UInt32 = 0x1 << 1
        static let finish: UInt32 = 0x1 << 2
        static let collectible: UInt32 = 0x1 << 3
        static let enemy: UInt32 = 0x1 << 4
        static let frame: UInt32 = 0x1 << 5
        static let ceiling: UInt32 = 0x1 << 6
    }
}
