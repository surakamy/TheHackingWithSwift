//
//  ViewController.swift
//  Project4
//
//  Created by Dmytro Kholodov on 5/1/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var flags: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        title = "Flags"

        navigationController?.navigationBar.prefersLargeTitles = true

        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let files = try! fm.contentsOfDirectory(atPath: path)

        let suffix2x = "@2x.png"
        let suffixCount = suffix2x.count
        flags = files.filter { $0.hasSuffix(suffix2x) }.map { String($0.dropLast(suffixCount)) }
    }

    //MARK - Table Delegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlagCell", for: indexPath)
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        cell.textLabel?.text = flags[indexPath.row].uppercased()
        cell.imageView?.image = UIImage(named: flags[indexPath.row])
        return cell
    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedIndex = indexPath.row
//    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Flag" {
            if let flagController = segue.destination as? FlagViewController,
               let selectedIndex = tableView.indexPathForSelectedRow
            {
                flagController.selectedFlag = flags[selectedIndex.row]

            }



        }
    }

}

