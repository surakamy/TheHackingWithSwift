//
//  ScoreLabel.swift
//  Project8
//
//  Created by Dmytro Kholodov on 5/9/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class ScoreLabel: UILabel {
    
    var padding: CGFloat = 0

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let doublePadding = 2 * padding
        return CGSize(width: size.width + doublePadding, height: size.height + doublePadding)
    }
}
