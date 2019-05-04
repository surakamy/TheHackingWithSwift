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

        let tap = UITapGestureRecognizer(target: self, action: #selector(generateRandomViews))
        view.addGestureRecognizer(tap)
        generateRandomViews()
    }


    @objc func generateRandomViews() {
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

