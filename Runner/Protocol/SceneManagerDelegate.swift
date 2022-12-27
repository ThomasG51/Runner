//
//  SceneManagerDelegate.swift
//  Runner
//
//  Created by Thomas George on 23/12/2022.
//

import Foundation

protocol SceneManagerDelegate {
    func presentLevelScene(for world: Int)
    func presentGameScene(for level: Int, in world: Int)
    func presentMenuScene()
}
