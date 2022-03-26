//
//  SKNode+Extension.swift
//  Runner
//
//  Created by Thomas George on 26/03/2022.
//

import SpriteKit

extension SKNode {
    
    class func unarchiveFromFile(file: String) -> SKNode? {
        guard let path = Bundle.main.path(forResource: file, ofType: "sks") else { return nil }

        do {
            let sceneData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            
            let unarchiver = try NSKeyedUnarchiver(forReadingWith: sceneData)
            unarchiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = unarchiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! SKNode
            unarchiver.finishDecoding()
            
            return scene
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func scale(to screenSize: CGSize, width: Bool, multiplier: CGFloat) {
        let scale = width ? (screenSize.width * multiplier) / frame.size.width : (screenSize.height * multiplier) / frame.size.height
        setScale(scale)
    }
    
    func turnGravity(on value: Bool) {
        physicsBody?.affectedByGravity = value
    }
    
    func createUserData(entry: Any, forkey key: String) {
        if userData == nil {
            userData = NSMutableDictionary()
        }
        
        userData!.setValue(entry, forKey: key)
    }
}
