//
//  PersonCell.swift
//  NamesToFaces
//
//  Created by Dmytro Kholodov on 5/14/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

protocol PersonCellDelegate: class {
    func didTapPersonCellImageViewAt(person: PersonOnTwitter)
    func didTapPersonCellNameViewAt(person: PersonOnTwitter)
}

class PersonCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameView: UILabel!
    @IBOutlet var handlerView: UILabel!

    weak var person: PersonOnTwitter? {
        didSet {
            self.nameView.text = person?.name
            if let handler = person?.handler {
                self.handlerView.text = handler.isEmpty ? "" : "@\(handler)"
            } else {
                self.handlerView.text = ""
            }
        }
    }

    weak var delegate: PersonCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = .white

        nameView.textColor = .darkText
        handlerView.textColor = .gray

        imageView.contentMode = .scaleToFill
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 5
        imageView.layer.cornerRadius = imageView.bounds.maxX / 2
        layer.cornerRadius = 7

        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))

        nameView.isUserInteractionEnabled = true
        nameView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(nameTapped(_:))))

        handlerView.isUserInteractionEnabled = true
        handlerView.addGestureRecognizer(
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
