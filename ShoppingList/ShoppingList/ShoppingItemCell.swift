//
//  ShoppingItemCell.swift
//  ShoppingList
//
//  Created by Dmytro Kholodov on 5/6/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class ShoppingItemCell: UITableViewCell {

    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productAmount: UILabel!

    func load(_ item: ShoppingList.Item) {
        productTitle.text = item.name
        productAmount.text = item.amount
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tintColor = UIColor(named: "accent")
        let textColor = UIColor(named: "text")
        productTitle.textColor = tintColor
        productAmount.textColor = textColor

        productAmount.backgroundColor = tintColor
        productAmount.layer.cornerRadius = 10.0
        productAmount.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        let tintColor = UIColor(named: "accent")
        let textColor = UIColor(named: "text")

        backgroundColor = selected ? tintColor : textColor

        productTitle.textColor = selected ? textColor : tintColor
        productAmount.textColor = selected ? tintColor : textColor

        productAmount.backgroundColor = selected ? textColor : tintColor
        productAmount.layer.cornerRadius = 10.0
        productAmount.clipsToBounds = true
    }

}
