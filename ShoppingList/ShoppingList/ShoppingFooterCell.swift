//
//  ShoppingFooterCell.swift
//  ShoppingList
//
//  Created by Dmytro Kholodov on 5/6/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class ShoppingFooterCell: UIView {

    @IBOutlet weak var button: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        button.tintColor = UIColor(named: "accent")
    }

    static func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: ShoppingFooterCell.self)
        let nib = UINib(nibName: String(describing: ShoppingFooterCell.self), bundle: bundle)
        let view = nib.instantiate(withOwner: ShoppingFooterCell.self, options: nil)

        return view[0] as! ShoppingFooterCell
    }

}
