//
//  GroundNode.swift
//  Runner
//
//  Created by Thomas George on 28/03/2022.
//

import SpriteKit

class GroundNode: SKSpriteNode {
    
    var isBodyActivated: Bool = false {
        didSet {
            physicsBody =  isBodyActivated ? activatedBody : nil
        }
    }
    
    private var activatedBody: SKPhysicsBody?
    
    init(with size: CGSize) {
        super.init(texture: nil, color: UIColor.clear, size: size)
        
        let bodyStartPoint = CGPoint(x: 0, y: size.height)
        let bodyEndPoint = CGPoint(x: size.width, y: size.height)
        
        activatedBody = SKPhysicsBody(edgeFrom: bodyStartPoint, to: bodyEndPoint)
        activatedBody?.restitution = 0
        activatedBody?.categoryBitMask = GameConstants.PhysicsCategories.ground
        activatedBody?.collisionBitMask = GameConstants.PhysicsCategories.player
        
        physicsBody = isBodyActivated ? activatedBody : nil
        name = GameConstants.AssetNames.ground
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
