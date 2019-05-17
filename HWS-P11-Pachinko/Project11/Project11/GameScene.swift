//
//  GameScene.swift
//  Project11
//
//  Created by Dmytro Kholodov on 5/17/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .alpha
        background.zPosition = -1
        addChild(background)

        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)

        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)

        let ball = SKSpriteNode(imageNamed: "ballRed")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width)
        ball.physicsBody?.restitution = 0.4
        ball.position = point
        addChild(ball)
    }


    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
}
