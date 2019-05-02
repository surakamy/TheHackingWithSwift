//
//  LinksTableViewController.swift
//  Project4-Browser
//
//  Created by Dmytro Kholodov on 5/2/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class LinksTableViewController: UITableViewController {

    var allowedHosts = [
        "apple.com",
        "hackingwithswift.com",
        "github.com",
        "mobile.twitter.com",
        "twitter.com"
    ].sorted()

    var links = [
        "apple.com",
        "hackingwithswift.com",
        "github.com/surakamy/TheHackingWithSwift",
        "twitter.com"
    ].sorted()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Browser 4"

        navigationController?.isToolbarHidden = false
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = links[indexPath.row]
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Favorites"
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = "https://" + links[indexPath.row]
        let browser = BrowserViewController(hosts: allowedHosts, defaultWebsite: url)
        navigationController?.pushViewController(browser, animated: true)
    }

}
