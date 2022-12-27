//
//  PopupNode.swift
//  Runner
//
//  Created by Thomas George on 18/12/2022.
//

import SpriteKit

class PopupNode: SKSpriteNode {
    var buttonHandlerDelegate: PopupButtonHandlerDelegate
    init(with title: String, and texture: SKTexture, buttonHandlerDelegate: PopupButtonHandlerDelegate) {
        self.buttonHandlerDelegate = buttonHandlerDelegate

        super.init(texture: texture, color: UIColor.clear, size: texture.size())

        let banner = BannerNode(with: title)
        banner.scale(to: size, width: true, multiplier: 1.1)
        banner.zPosition = GameConstants.Zpositions.hud
        banner.position = CGPoint(x: frame.midX, y: frame.maxY)
        addChild(banner)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func add(buttons: [Int]) {
        let scalar = 1.0/CGFloat(buttons.count - 1)
        for (index, button) in buttons.enumerated() {
            let buttonToAdd = ButtonNode(defaultButtonImage: GameConstants.AssetNames.popupButtons[button], action: buttonHandlerDelegate.popupButtonHandler, index: button)
            buttonToAdd.position = CGPoint(x: -frame.maxX/2 + CGFloat(index) * scalar * (frame.size.width * 0.5), y: frame.minY)
            buttonToAdd.zPosition = GameConstants.Zpositions.hud
            buttonToAdd.scale(to: frame.size, width: true, multiplier: 0.25)
            addChild(buttonToAdd)
        }
    }
}
