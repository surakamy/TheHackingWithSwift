//
//  Enemy.swift
//  SwiftyNinja
//
//  Created by Dmytro Kholodov on 6/23/19.
//  Copyright © 2019 TheHackingWithSwift. All rights reserved.
//

import SpriteKit

enum EnemyType: CaseIterable {
    case bomb, penguin, fastPenguin
}

class Enemy: SKSpriteNode {
    var type: EnemyType = .penguin

    var speedFactor: Int {
        switch type {
        case .bomb:
            return 40
        case .penguin:
            return 40
        case .fastPenguin:
            return 45
        }
    }

    var scoreDelta: Int {
        switch type {
        case .bomb:
            return 0
        case .penguin:
            return 1
        case .fastPenguin:
            return 2
        }
    }
}
