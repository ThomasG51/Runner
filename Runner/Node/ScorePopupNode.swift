//
//  ScorePopupNode.swift
//  Runner
//
//  Created by Thomas George on 18/12/2022.
//

import SpriteKit

class ScorePopupNode: PopupNode {
    var level: String
    var score: [String: Int]
    var scoreLabel: SKLabelNode!

    init(buttonHandlerDelegate: PopupButtonHandlerDelegate, title: String, level: String, texture: SKTexture, score: Int, coins: Int, animated: Bool) {
        self.level = level
        self.score = ScoreHelper.getCurrentScore(for: level)

        super.init(with: title, and: texture, buttonHandlerDelegate: buttonHandlerDelegate)

        addScoreLabel()
        addStars()
        addCoins(count: coins)

        if animated {
            animateResult(with: CGFloat(score), and: 100.0)
        } else {
            scoreLabel.text = "\(score)"
            for i in 0 ..< self.score[GameConstants.Score.starsKey]! {
                self[GameConstants.AssetNames.fullStar + "_\(i)"].first!.alpha = 1.0
            }
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: GameConstants.AssetNames.gameFontName)
        scoreLabel.fontSize = 200
        scoreLabel.text = "0"
        scoreLabel.scale(to: size, width: false, multiplier: 0.1)
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - size.height * 0.6)
        scoreLabel.zPosition = GameConstants.Zpositions.hud
        addChild(scoreLabel)
    }

    func addStars() {
        for i in 0 ... 2 {
            let emptyStar = SKSpriteNode(imageNamed: GameConstants.AssetNames.emptyStar)
            emptyStar.scale(to: size, width: true, multiplier: 0.25)
            emptyStar.position = CGPoint(x: -emptyStar.size.width + CGFloat(i) * emptyStar.size.width, y: frame.maxY - size.height * 0.4)
            if i == 1 { emptyStar.position.y += emptyStar.size.height/4 }
            emptyStar.zRotation = -CGFloat(-Double.pi/4/2) + CGFloat(i) * CGFloat(-Double.pi/4/2)
            emptyStar.zPosition = GameConstants.Zpositions.hud
            addChild(emptyStar)

            let fullStar = SKSpriteNode(imageNamed: GameConstants.AssetNames.fullStar)
            fullStar.size = emptyStar.size
            fullStar.position = emptyStar.position
            fullStar.zRotation = emptyStar.zRotation
            fullStar.zPosition = GameConstants.Zpositions.hud
            fullStar.name = GameConstants.AssetNames.fullStar + "_\(i)"
            fullStar.alpha = 0.0
            addChild(fullStar)
        }
    }

    func addCoins(count: Int) {
        let numberOfCoins = count == 3 ? score[GameConstants.Score.coinsKey]! : count

        let coin = SKSpriteNode(imageNamed: GameConstants.AssetNames.superCoin)
        coin.scale(to: size, width: false, multiplier: 0.15)
        coin.position = CGPoint(x: -coin.size.width/1.5, y: frame.maxY - size.height * 0.75)
        coin.zPosition = GameConstants.Zpositions.hud
        addChild(coin)

        let coinLabel = SKLabelNode(fontNamed: GameConstants.AssetNames.gameFontName)
        coinLabel.verticalAlignmentMode = .center
        coinLabel.fontSize = 200.0
        coinLabel.text = "\(numberOfCoins)/3"
        coinLabel.scale(to: coin.size, width: false, multiplier: 1.0)
        coinLabel.position = CGPoint(x: coin.size.width/1.5, y: frame.maxY - size.height * 0.75)
        coinLabel.zPosition = GameConstants.Zpositions.hud
        addChild(coinLabel)
    }

    func animateResult(with achievedScore: CGFloat, and maxScore: CGFloat) {
        var counter = 0

        let wait = SKAction.wait(forDuration: 0.05)

        let count = SKAction.run {
            counter += 1
            self.scoreLabel.text = String(counter)
            if CGFloat(counter)/maxScore == 0.8 {
                self.animateStar(number: 2)
            } else if CGFloat(counter)/maxScore == 0.4 {
                self.animateStar(number: 1)
            } else if counter == 1 {
                self.animateStar(number: 0)
            }
        }

        let sequence = SKAction.sequence([wait, count])

        self.run(SKAction.repeat(sequence, count: Int(achievedScore)))
    }

    func animateStar(number: Int) {
        let star = self[GameConstants.AssetNames.fullStar + "_\(number)"].first!
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.2)
        let scaleBack = SKAction.scale(to: 1.0, duration: 0.1)
        star.run(SKAction.group([fadeIn, scaleUp, scaleBack]))
    }
}
