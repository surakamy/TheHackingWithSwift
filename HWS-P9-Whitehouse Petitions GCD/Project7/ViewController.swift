//
//  ViewController.swift
//  Project7
//
//  Created by Dmytro Kholodov on 5/7/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {

    var petitions = [Petition]()
    var petitionsToDisplay = [Petition]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        themeNavigationBar()

        let tab: UITabBarItem! = navigationController?.tabBarItem
        let category = tab.tag == 0 ? PetitionCategory.recent : PetitionCategory.top

        DispatchQueue.global(qos: .default).async {
            if let url = getSourceUrl(for: category),
                let data = try? Data(contentsOf: url) // this is such a bad idea
            {
                self.parse(data)
            } else {
                DispatchQueue.main.async {
                    self.showError()
                }
            }
        }
    }

    //MARK -- SearchBar
    var highlightedText: String?

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        highlightedText = searchText
        guard !searchText.isEmpty else {
            petitionsToDisplay = petitions
            return
        }
        petitionsToDisplay = petitions
            .filter { petition in
                petition.title.range(of: searchText, options: .caseInsensitive) != nil ||
                petition.body.range(of: searchText, options: .caseInsensitive) != nil
            }
    }

    //MARK -- Table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitionsToDisplay.count
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return petitionsToDisplay.isEmpty ? "Loading petitions..." : nil
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitionsToDisplay[indexPath.row]
        cell.textLabel?.attributedText = getHighlighted(for: petition.title, highlights: highlightedText)
        cell.detailTextLabel?.attributedText = getHighlighted(for: petition.body, highlights: highlightedText)
        return cell
    }

    var accessoryIndexPathSelected: IndexPath?

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        accessoryIndexPathSelected = indexPath
        performSegue(withIdentifier: "Petition", sender: nil)
    }

    // Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "Petition", accessoryIndexPathSelected != nil {
            return true
        } else {
            return false
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Petition" {
            guard let nextController = segue.destination as? PetitionDetailsControllerViewController else { fatalError("Petition seque destination controller is not of \(PetitionDetailsControllerViewController.self)")}

            guard let indexPath = accessoryIndexPathSelected else { return }
            nextController.petition = petitionsToDisplay[indexPath.row]
            nextController.highlight = highlightedText
            accessoryIndexPathSelected = nil
        }
    }

    //MARK: - Helpers


    // JSON
    func parse(_ data: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: data) {
            petitions = jsonPetitions.results
            petitionsToDisplay = petitions
        }
    }

    // Error

    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true, completion: nil)
    }


    // Credits

    @IBAction func showCredits(_ sender: Any) {
        let ac = UIAlertController(title: "Credits", message: "We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true, completion: nil)
    }


    // Helpers
    fileprivate func themeNavigationBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    let highlightedAttrs: [NSAttributedString.Key : Any] = [
        .backgroundColor : UIColor(named: "tint")!,
        .foregroundColor : UIColor.white,
        .font : UIFont.boldSystemFont(ofSize: 17)
    ]

    fileprivate func getHighlighted(for text: String, highlights: String? = nil) -> NSAttributedString {

        if let highlights = highlights {
            let attributedString = NSMutableAttributedString(string: text)
            if let range = text.range(of: highlights, options: .caseInsensitive) {
                attributedString.addAttributes(highlightedAttrs, range: NSRange(range, in: text))

            }
            return attributedString
        }

        return NSAttributedString(string: text)
    }
}
