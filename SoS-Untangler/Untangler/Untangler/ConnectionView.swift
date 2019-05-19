//
//  ConnectionView.swift
//  Untangler
//
//  Created by Dmytro Kholodov on 5/19/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class ConnectionView: UIView {

    var draggedChanged: (() -> Void)!
    var draggedFinished: (() -> Void)!
    var dragAnchor: CGPoint!

    var after: ConnectionView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        dragAnchor = touch.location(in: self)
        dragAnchor.x -= frame.width / 2
        dragAnchor.y -= frame.height / 2

        transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        superview?.bringSubviewToFront(self)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self.superview!)

        center = CGPoint(x: point.x + dragAnchor.x/2, y: point.y + dragAnchor.y/2)
        draggedChanged()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        transform = CGAffineTransform.identity
        draggedFinished()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }

}
