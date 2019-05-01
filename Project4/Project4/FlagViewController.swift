//
//  FlagViewController.swift
//  Project4
//
//  Created by Dmytro Kholodov on 5/1/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class FlagViewController: UIViewController {

    var selectedFlag: String?

    @IBOutlet weak var flagView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never

        view.backgroundColor = UIColor.init(white: 0.2, alpha: 1.0)

        if let flagName = selectedFlag {
            title = flagName.uppercased()
            flagView?.image = UIImage(named: flagName)
        }


        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    

    @objc func shareTapped() {
        guard let flagData = flagView.image?.jpegData(compressionQuality: 0.8) else { return }

        let vc = UIActivityViewController(activityItems: [flagData], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
