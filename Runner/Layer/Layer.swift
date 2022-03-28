//
//  Layer.swift
//  Runner
//
//  Created by Thomas George on 28/03/2022.
//

import SpriteKit

public func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}
    
public func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
    
public func +=(left: inout CGPoint, right: CGPoint) {
    left = left + right
}

class Layer: SKNode {
    
    // MARK: - PROPERTY
    
    var layerVelocity = CGPoint.zero
    
    // MARK: - FUNCTION
    
    func update(_ deltaTime: TimeInterval) {
        for child in children {
            updateNodesGlobal(deltaTime, childNode: child)
        }
    }
    
    func updateNodesGlobal(_ deltaTime: TimeInterval, childNode: SKNode) {
        let offset = layerVelocity * CGFloat(deltaTime)
        childNode.position += offset
        updateNodes(deltaTime, childNode: childNode)
    }
    
    func updateNodes(_ deltaTime: TimeInterval, childNode: SKNode) {
        // Overidded in subclass
    }
    
}
