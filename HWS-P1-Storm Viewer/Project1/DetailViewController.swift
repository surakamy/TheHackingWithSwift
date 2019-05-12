//
//  DetailViewController.swift
//  Project1
//
//  Created by Dmytro Kholodov on 4/27/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var viewModel: PictureViewModel?

    @IBOutlet weak private var pictureView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel?.detailTitle

        navigationItem.largeTitleDisplayMode = .never

        if let imageToLoad = viewModel?.selectedImage {
            pictureView.image = UIImage(named: imageToLoad)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

}
