//
//  RepeatingLayer.swift
//  Runner
//
//  Created by Thomas George on 28/03/2022.
//

import SpriteKit

class RepeatingLayer: Layer {
    
    override func updateNodes(_ deltaTime: TimeInterval, childNode: SKNode) {
        guard let node = childNode as? SKSpriteNode else { return }
        guard node.position.x <= -(node.size.width) else { return }
        guard node.name == "0" && self.childNode(withName: "1") != nil || node.name == "1" && self.childNode(withName: "0") != nil else { return }
        
        node.position = CGPoint(x: node.position.x + (node.size.width * 2), y: node.position.y)
    }
    
}
