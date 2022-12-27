//
//  SoundPlayer.swift
//  Runner
//
//  Created by Thomas George on 27/12/2022.
//

import SpriteKit

class SoundPlayer {
    let buttonSound = SKAction.playSoundFileNamed("button", waitForCompletion: false)
    let coinSound = SKAction.playSoundFileNamed("coin", waitForCompletion: false)
    let deathSound = SKAction.playSoundFileNamed("gameover", waitForCompletion: false)
    let completedSound = SKAction.playSoundFileNamed("completed", waitForCompletion: false)
    let powerupSound = SKAction.playSoundFileNamed("powerup", waitForCompletion: false)
}
