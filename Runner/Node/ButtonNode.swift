//
//  ButtonNode.swift
//  Runner
//
//  Created by Thomas George on 18/12/2022.
//

import SpriteKit

class ButtonNode: SKSpriteNode {
    var defaultButton: SKSpriteNode
    var action: (Int) -> Void
    var index: Int
    var soundPlayer = SoundPlayer()

    init(defaultButtonImage: String, action: @escaping (Int) -> Void, index: Int) {
        self.defaultButton = SKSpriteNode(imageNamed: defaultButtonImage)
        self.action = action
        self.index = index

        super.init(texture: nil, color: UIColor.clear, size: defaultButton.size)

        isUserInteractionEnabled = true
        addChild(defaultButton)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        defaultButton.alpha = 0.75
        run(soundPlayer.buttonSound)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first! as UITouch
        let location: CGPoint = touch.location(in: self)

        if defaultButton.contains(location) {
            defaultButton.alpha = 0.75
        } else {
            defaultButton.alpha = 1.0
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first! as UITouch
        let location: CGPoint = touch.location(in: self)

        if defaultButton.contains(location) {
            action(index)
        }

        defaultButton.alpha = 1.0
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        defaultButton.alpha = 1.0
    }
}
