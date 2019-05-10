//
//  ViewController.swift
//  Test
//
//  Created by Dmytro Kholodov on 5/10/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sut: BoxLabel!

    @IBAction func changedPadding(_ sender: Any) {
        guard let slider = sender as? UISlider else {
            return
        }
        sut.padding = CGFloat(slider.value)
    }
    @IBAction func changedMargin(_ sender: Any) {
        guard let slider = sender as? UISlider else {
            return
        }
        sut.margin = CGFloat(slider.value)
    }

}

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

