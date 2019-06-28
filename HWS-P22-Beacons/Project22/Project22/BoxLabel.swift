//
//  BoxLabel.swift
//  GameOfHangMan
//
//  Created by Dmytro Kholodov on 5/13/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

@IBDesignable
/// Label which has CSS Box model properties.
class BoxLabel: UILabel {
    /// Padding property of Box model.
    @IBInspectable var padding: CGFloat = 0 {
        didSet { invalidateIntrinsicContentSize() }
    }
    /// Margin property of Box model.
    @IBInspectable var margin: CGFloat = 0 {
        didSet { invalidateIntrinsicContentSize() }
    }

    override var alignmentRectInsets: UIEdgeInsets {
        return UIEdgeInsets(top: -margin, left: -margin, bottom: -margin, right: -margin)
    }
    override var intrinsicContentSize: CGSize {
        return CGRect.padded(size: super.intrinsicContentSize, padding: padding)
    }
}

extension CGRect {

    /// Modifies CGSize by adding padding.
    ///
    /// - Parameters:
    ///   - size: Original size
    ///   - padding: Value of padding
    /// - Returns: A new size with padding.
    static func padded(size: CGSize, padding: CGFloat = 0) -> CGSize {
        return CGRect(origin: .zero, size: size)
            .insetBy(dx: -padding, dy: -padding)
            .size
    }
}
