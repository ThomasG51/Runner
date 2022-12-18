//
//  HudDelegate.swift
//  Runner
//
//  Created by Thomas George on 17/12/2022.
//

import Foundation

protocol HudDelegate {
    func updateCoinLabel(coins: Int)
    func addSuperCoin(index: Int)
}
