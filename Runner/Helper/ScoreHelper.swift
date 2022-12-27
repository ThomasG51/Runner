//
//  ScoreHelper.swift
//  Runner
//
//  Created by Thomas George on 18/12/2022.
//

import Foundation

struct ScoreHelper {
    static func getCurrentScore(for levelKey: String) -> [String: Int] {
        if let existingData = UserDefaults.standard.dictionary(forKey: levelKey) as? [String: Int] {
            return existingData
        } else {
            return [GameConstants.Score.scoreKey: 0, GameConstants.Score.starsKey: 0, GameConstants.Score.coinsKey: 0]
        }
    }

    static func updateScore(for levelKey: String, and score: [String: Int]) {
        UserDefaults.standard.set(score, forKey: levelKey)
    }

    static func compare(scores: [[String: Int]], in levelKey: String) {
        let currentScore = getCurrentScore(for: levelKey)

        var newHighScore = false
        var maxScore = currentScore[GameConstants.Score.scoreKey]!
        var maxStars = currentScore[GameConstants.Score.starsKey]!
        var maxCoins = currentScore[GameConstants.Score.coinsKey]!

        for score in scores {
            if score[GameConstants.Score.scoreKey]! > maxScore {
                maxScore = score[GameConstants.Score.scoreKey]!
                newHighScore = true
            }
            if score[GameConstants.Score.starsKey]! > maxStars {
                maxStars = score[GameConstants.Score.starsKey]!
                newHighScore = true
            }
            if score[GameConstants.Score.coinsKey]! > maxCoins {
                maxCoins = score[GameConstants.Score.coinsKey]!
                newHighScore = true
            }
        }

        if newHighScore {
            let newScore = [
                GameConstants.Score.scoreKey: maxScore,
                GameConstants.Score.starsKey: maxStars,
                GameConstants.Score.coinsKey: maxCoins
            ]
            updateScore(for: levelKey, and: newScore)
        }
    }
}
