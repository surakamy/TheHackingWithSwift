//
//  ViewController.swift
//  Project1
//
//  Created by Dmytro Kholodov on 4/27/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    let cellIdentifier = "Picture"
    let detailsControllerIdentifier = "Detail"

    var model = PictureFilesProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"

        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: TableView Delegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.files.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.attributedText = model.fileNameStyled(at: indexPath.row)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: detailsControllerIdentifier) as? DetailViewController {
            controller.viewModel = model.pictureViewModel(at: indexPath.row)
            show(controller, sender: nil)
        }
    }

}

