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
        sut.invalidateIntrinsicContentSize()
    }
    @IBAction func changedMargin(_ sender: Any) {
        guard let slider = sender as? UISlider else {
            return
        }
        sut.margin = CGFloat(slider.value)
        sut.invalidateIntrinsicContentSize()
    }

}



import UIKit

@IBDesignable
class BoxLabel: UILabel {
    @IBInspectable var padding: CGFloat = 0
    @IBInspectable var margin: CGFloat = 0

    override var alignmentRectInsets: UIEdgeInsets {
        return UIEdgeInsets(top: -margin, left: -margin, bottom: -margin, right: -margin)
    }
    override var intrinsicContentSize: CGSize {
        return CGRect.padded(size: super.intrinsicContentSize, padding: padding)
    }
}

extension CGRect {
    static func padded(size: CGSize, padding: CGFloat = 0) -> CGSize {
        return CGRect(origin: .zero, size: size)
            .insetBy(dx: -padding, dy: -padding)
            .size
    }
}

