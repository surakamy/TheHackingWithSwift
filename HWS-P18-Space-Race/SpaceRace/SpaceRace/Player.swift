//
//  Player.swift
//  SpaceRace
//
//  Created by Dmytro Kholodov on 6/3/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import SpriteKit

class Player: SKNode {
    var inControl: Bool = false
    var charNode: SKSpriteNode!
    var circle: SKShapeNode!
    var smokes: SKEmitterNode!

    func configure(at position: CGPoint) {
        self.position = position

        charNode = SKSpriteNode(imageNamed: "penguin")
        charNode.position = CGPoint(x: 0, y: 0)
        charNode.physicsBody = SKPhysicsBody(texture: charNode.texture!, size: charNode.size)
        charNode.physicsBody?.contactTestBitMask = 1
        charNode.zPosition = 10
        addChild(charNode)

        circle = SKShapeNode(circleOfRadius: 100 )
        circle.fillColor = .yellow
        circle.zPosition = charNode.zPosition - 1
        circle.position = CGPoint(x: 0, y: 0)
        addChild(circle)


    }


    func control(from position: CGPoint) -> Bool {
        if abs(self.position.x - position.x) > 100 ||
            abs(self.position.y - position.y) > 100 {
            return false
        }

        inControl = true
        circle.alpha = 0

        if let smoke = SKEmitterNode(fileNamed: "icy") {
            smokes = smoke
            smoke.position = charNode.position
            circle.zPosition = charNode.zPosition - 2
            addChild(smoke)
        }

        return true
    }

    func uncontrol() {
        inControl = false
        smokes.removeFromParent()
        circle.alpha = 1
    }
}
