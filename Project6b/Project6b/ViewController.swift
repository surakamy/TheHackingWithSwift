//
//  ViewController.swift
//  Project6b
//
//  Created by Dmytro Kholodov on 5/4/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(generateRandomViewsAnchors))
        view.addGestureRecognizer(tap)
    }


    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        generateRandomViewsAnchors()
    }


    @objc func generateRandomViewsAnchors() {
        view.subviews.forEach { view in view.removeFromSuperview() }
        let labels = [
            UILabel(),
            UILabel(),
            UILabel(),
            UILabel(),
            UILabel()
        ]

        let titlesForLabels = [
            "THESE",
            "ARE",
            "SOME",
            "AWESOME",
            "LABELS"
        ]

        let colorsForLabels = [
            UIColor.random(),
            UIColor.random(),
            UIColor.random(),
            UIColor.random(),
            UIColor.random()
        ]


        assert(titlesForLabels.count == colorsForLabels.count)
        assert(labels.count == titlesForLabels.count)

        for (index, label) in labels.enumerated() {
            label.backgroundColor = colorsForLabels[index]
            label.text = titlesForLabels[index]
            label.layer.cornerRadius = 20.0
            label.clipsToBounds = true
            label.textAlignment = .center
            label.sizeToFit()
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
        }


        var previous: UILabel?
        for label in labels {
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            //label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            //label.heightAnchor.constraint(equalToConstant: 80).isActive = true

            label.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2, constant:  -10).isActive = true

            if let prev = previous {
                label.topAnchor.constraint(equalTo: prev.bottomAnchor, constant: 10).isActive = true
            } else {
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            }

            previous = label
        }

    }


    @objc func generateRandomViewsVLF() {
        view.subviews.forEach { view in view.removeFromSuperview() }
        let labels = [
            "label0" : UILabel(),
            "label1" : UILabel(),
            "label2" : UILabel(),
            "label3" : UILabel(),
            "label4" : UILabel(),
            "label5" : UILabel()
        ]

        let titlesForLabels = [
            "THESE",
            "ARE",
            "SOME",
            "AWESOME",
            "LABELS",
            "RANDOM"
        ]

        let colorsForLabels = [
            UIColor.red,
            UIColor.cyan,
            UIColor.yellow,
            UIColor.green,
            UIColor.orange,
            UIColor.blue
        ]


        assert(titlesForLabels.count == colorsForLabels.count)
        assert(labels.keys.count == titlesForLabels.count)

        for (index, label) in labels.values.enumerated() {
            label.backgroundColor = colorsForLabels[index]
            label.text = titlesForLabels[index]
            label.textAlignment = .center
            label.sizeToFit()
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
        }

        for label in labels.keys {
            view.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-[\(label)]-|",
                options: [],
                metrics: nil,
                views: labels))
        }

        let metrics = [
            "LabelHeight": Int.random(in: 30...100),
            "space": Int.random(in: 10...60)
        ]

        let format =
            """
            V:|-[label0(LabelHeight@999)]-(space)-\
            [label1(label0)]-(space)-\
            [label2(label0)]-(space)-\
            [label3(label0)]-(space)-\
            [label4(label0)]-(space)-\
            [label5(label0)]-(>=10)-|
            """

        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat:format,
            options: [],
            metrics: metrics,
            views: labels))
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}


extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            displayP3Red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1
        )
    }
}
