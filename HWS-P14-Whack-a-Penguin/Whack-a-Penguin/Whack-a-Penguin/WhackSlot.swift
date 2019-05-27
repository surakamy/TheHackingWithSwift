//
//  WhackSlot.swift
//  Whack-a-Penguin
//
//  Created by Dmytro Kholodov on 5/27/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import SpriteKit

class WhackSlot: SKNode {
    var charNode: SKSpriteNode!
    var blurb: SKLabelNode!

    var isVisible = false
    var isHit = false

    func configure(at position: CGPoint) {
        self.position = position

        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)

        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")

        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)

        addChild(cropNode)
    }


    func show(hideTime: Double) {
        if isVisible { return }

        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false

        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
            curse()
            let moveABit = SKAction.sequence([0.1, -0.1]
                .map {SKAction.rotate(toAngle: CGFloat($0), duration: 0.6, shortestUnitArc: true)})
            charNode.run(SKAction.repeatForever(moveABit))
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
    }

    func hide() {
        if !isVisible { return }

        if charNode.name == "charEnemy" {
            curse()
        }
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }

    func curse() {
        blurb?.removeFromParent()
        guard let parent = parent else {return}
        blurb = SKLabelNode(fontNamed: "Chalkduster")
        blurb.text = "Ha-ha"
        blurb.fontSize = 32
        let pos = position //convert(position, to: parent)
        blurb.position = CGPoint(x: pos.x, y: pos.y)
        blurb.run(SKAction.moveBy(x: 0, y: 100, duration: 1.0))
        parent.addChild(blurb)

        DispatchQueue.main.asyncAfter(deadline: .now() + (0.5)) { [weak self] in
            self?.blurb?.removeFromParent()
        }
    }
}
