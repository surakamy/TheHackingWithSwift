//
//  ViewHolderController.swift
//  Capital Cities
//
//  Created by Dmytro Kholodov on 6/1/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class ViewHolderController: UIViewController {

    var holderView: UIView?

    convenience init(_ holder: ()->UIView) {
        self.init()
        self.holderView = holder()
    }

    override func loadView() {
        view = holderView ?? UIView()
    }
}



extension NSLayoutConstraint {
    static func match(_ view: UIView, parent: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: parent.topAnchor),
            view.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: parent.trailingAnchor)
            ])
    }

    static func match(_ view: UIView, layoutGuide: UILayoutGuide) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            view.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor)
            ])
    }
}
