//
//  ViewController.swift
//  ShoppingList
//
//  Created by Dmytro Kholodov on 5/6/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class ShoppingListController: UITableViewController {

    var list = ShoppingList()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Shopping list"

        tableView.estimatedSectionFooterHeight = 300.0

        tableView.backgroundColor = UIColor(named: "base")

        footerCell.button.addTarget(self, action: #selector(appendTappend(_:)), for: .touchUpInside)
    }

    @IBAction func shareTapped(_ sender: Any) {
        let textToShare = list.descriptionInShort
        let ac = UIActivityViewController(activityItems: [textToShare], applicationActivities: [])
        present(ac, animated: true, completion: nil)
    }

    @IBAction func clearAllTappend(_ sender: Any) {
        let count = list.count

        list = ShoppingList()

        tableView.beginUpdates()
        let rowsToDelete = (0..<count)
            .map {[IndexPath(row: $0, section: 0)]}
            .reduce([], +)
        tableView.deleteRows(at: rowsToDelete, with: .automatic)
        tableView.endUpdates()
    }

    @IBAction func appendTappend(_ sender: Any) {
        let product = self.list.insert()
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)

        let ac = UIAlertController(title: "Add", message: "Product", preferredStyle: .alert)
        ac.addTextField { textField in
            textField.font = UIFont.preferredFont(forTextStyle: .title1)
            textField.text = product.name
        }
        ac.addTextField { textField in
            textField.font = UIFont.preferredFont(forTextStyle: .title1)
            textField.textColor = UIColor(named: "accent")
            textField.text = product.amount
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            self.list.updateProduct(at: indexPath.row, name: ac.textFields?[0].text, amount: ac.textFields?[1].text )
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        ac.addAction(addAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            self.list.remove(at: 0)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        ac.addAction(cancelAction)

        present(ac, animated: true, completion: nil)
    }

    // MARK - TableView
    @IBOutlet var footerCell: ShoppingFooterCell!

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerCell
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        footerCell.isHidden = !list.isEmpty
        return  list.isEmpty ? view.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom : 0.01
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as? ShoppingItemCell else { fatalError("No cell") }
        let product = list.product(at: indexPath.row)
        cell.load(product)
        cell.isEvenRow = list.count % 2 != 0
        return cell
    }

}

