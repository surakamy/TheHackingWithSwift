//
//  ShoppingList.swift
//  ShoppingList
//
//  Created by Dmytro Kholodov on 5/6/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import Foundation

struct ShoppingList {
    struct Item {
        var name: String = ""
        var amount: String = "1"
    }
    private var products = [Item]()

    var count: Int {
        return products.count
    }

    var isEmpty: Bool {
        return products.isEmpty
    }

func product(at: Int) -> Item {
        return products[at]
    }

    @discardableResult
    mutating func insert() -> Item {
        let product = Item()
        products.insert(product, at: 0)
        return product
    }

    mutating func remove(at index: Int) {
        products.remove(at: index)
    }

    mutating func updateProduct(at index: Int, name: String? = nil, amount: String? = nil) {
        products[index].name = name ?? ""
        products[index].amount = amount ?? ""
    }
}
