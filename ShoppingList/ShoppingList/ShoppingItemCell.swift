//
//  ShoppingItemCell.swift
//  ShoppingList
//
//  Created by Dmytro Kholodov on 5/6/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class ShoppingItemCell: UITableViewCell {

    var isEvenRow: Bool = false {
        didSet {
            setTheme(isSelected)
            setNeedsDisplay()
        }
    }

    func load(_ item: ShoppingList.Item) {
        productTitle.text = item.name
        productAmount.text = item.amount
    }

    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productAmount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        productAmount.layer.cornerRadius = 10.0
        productAmount.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setTheme(selected)
    }

    private func setTheme(_ selected: Bool) {
        let tintColor = UIColor(named: "accent")
        let textColor = UIColor(named: "text")
        let baseColor = UIColor(named: "base")

        switch (isSelected, isEvenRow) {
        case (true, _):
            backgroundColor = tintColor
            productTitle.textColor = textColor
            productAmount.textColor = tintColor
            productAmount.backgroundColor = textColor
            productAmount.layer.cornerRadius = 20.0
        case (false, true):
            backgroundColor = textColor
            productTitle.textColor = tintColor
            productAmount.textColor = textColor
            productAmount.backgroundColor = tintColor

        case (false, false):
            backgroundColor = baseColor
            productTitle.textColor = tintColor
            productAmount.textColor = textColor
            productAmount.backgroundColor = tintColor
            productAmount.layer.cornerRadius = 12.0
        }
    }
}
