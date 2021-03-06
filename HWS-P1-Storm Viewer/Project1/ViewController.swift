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

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAppTapped))

        navigationController?.navigationBar.prefersLargeTitles = true

        DispatchQueue
            .global(qos: .userInitiated)
            .asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.model.loadPictures { [weak self] in
                    self?.tableView.reloadData()
                }
        }
    }

    // MARK: Reload


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


    @objc func shareAppTapped() {

        let vc = UIActivityViewController(activityItems: ["Hi there, this is Strom Viewer."], applicationActivities: [])
        vc.navigationItem.rightBarButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}

