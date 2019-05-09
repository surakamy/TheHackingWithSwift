//
//  ViewController.swift
//  Project8
//
//  Created by Dmytro Kholodov on 5/8/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

fileprivate extension UIColor {
    static var tint: UIColor { return #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) }
    static var light: UIColor { return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) }
    static var grayish: UIColor { return #colorLiteral(red: 0.9568627451, green: 0.873072545, blue: 0.8420772661, alpha: 1) }
}

class ViewController: UIViewController {

    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: ScoreLabel!
    var letterButtons = [UIButton]()


    override func loadView() {
        view = UIView()
        view.tintColor = UIColor.tint
        view.backgroundColor = UIColor.light

        scoreLabel = ScoreLabel()
        scoreLabel.text = "Score: 1000"
        scoreLabel.textAlignment = .center
        scoreLabel.backgroundColor = UIColor.tint
        scoreLabel.textColor = UIColor.light
        scoreLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .heavy)
        scoreLabel.padding = 10.0
        scoreLabel.clipsToBounds = true
        scoreLabel.layer.cornerRadius = 20.0
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreLabel)


        cluesLabel = UILabel()
        cluesLabel.text = "CLUES"
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.numberOfLines = 0
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)

        answersLabel = UILabel()
        answersLabel.text = "ANSWERS"
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.numberOfLines = 0
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)


        currentAnswer = UITextField()
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currentAnswer)


        let submit = UIButton(type: .system)
        submit.backgroundColor = UIColor.grayish
        submit.contentEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        submit.setTitle("SUBMIT", for: .normal)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.clipsToBounds = true
        submit.layer.cornerRadius = 10.0
        view.addSubview(submit)

        let clear = UIButton(type: .system)
        clear.backgroundColor = UIColor.grayish
        clear.contentEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        clear.setTitle("CLEAR", for: .normal)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.clipsToBounds = true
        clear.layer.cornerRadius = 10.0
        view.addSubview(clear)

        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)

        NSLayoutConstraint.activate([
            // Score Label
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 10),

            // Clues Label
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6, constant: -100),

            // Answers Label
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4, constant: -100),

            // Clues & Answers Labels
            cluesLabel.heightAnchor.constraint(equalTo: answersLabel.heightAnchor),

            //Current Answer Field
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),

            // Submit Button
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),

            // Clear Button
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.heightAnchor.constraint(equalToConstant: 44),

            // Buttons View
            buttonsView.widthAnchor.constraint(equalToConstant: 600),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)

        ])

        // Buttons

        let width = 150
        let height = 80

        let font = UIFont.systemFont(ofSize: 36)
        for row in 0..<4 {
            for col in 0..<4 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = font
                letterButton.setTitle("🀫🀫🀫", for: .normal)

                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame

                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
    }
}
