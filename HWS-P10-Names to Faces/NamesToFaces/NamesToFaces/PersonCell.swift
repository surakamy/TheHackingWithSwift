//
//  PersonCell.swift
//  NamesToFaces
//
//  Created by Dmytro Kholodov on 5/14/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

protocol PersonCellDelegate: class {
    func didTapPersonCellImageViewAt(person: Person)
    func didTapPersonCellNameViewAt(person: Person)
}

class PersonCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameView: UILabel!

    weak var person: Person? {
        didSet {
            self.nameView.text = person?.name
        }
    }

    weak var delegate: PersonCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.contentMode = .scaleToFill
        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = imageView.bounds.maxX / 2
        layer.cornerRadius = 7

        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))

        nameView.isUserInteractionEnabled = true
        nameView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(nameTapped(_:))))
    }

    @objc func imageTapped(_ sender: UIImageView) {
        guard let person = person else { return }
        delegate?.didTapPersonCellImageViewAt(person: person)
    }

    @objc func nameTapped(_ sender: UILabel) {
        guard let person = person else { return }
        delegate?.didTapPersonCellNameViewAt(person: person)
    }
}
