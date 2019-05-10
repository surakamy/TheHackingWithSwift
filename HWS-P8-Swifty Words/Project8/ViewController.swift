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

    var activatedButtons = [UIButton]()
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    var solutions = [String]()


    override func loadView() {
        view = UIView()
        view.tintColor = UIColor.tint
        view.backgroundColor = UIColor.light

        scoreLabel = ScoreLabel()
        scoreLabel.text = "Score: 0"
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
        answersLabel.textColor = UIColor.tint
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
        submit.addTarget(self, action: #selector(submitTapped(_:)), for: .touchUpInside)
        submit.backgroundColor = UIColor.grayish
        submit.contentEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        submit.setTitle("SUBMIT", for: .normal)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.clipsToBounds = true
        submit.layer.cornerRadius = 10.0
        view.addSubview(submit)

        let clear = UIButton(type: .system)
        clear.addTarget(self, action: #selector(clearTapped(_:)), for: .touchUpInside)
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
            answersLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.4, constant: -100),

            // Clues & Answers Labels
            cluesLabel.heightAnchor.constraint(equalTo: answersLabel.heightAnchor),
            cluesLabel.trailingAnchor.constraint(equalTo: answersLabel.leadingAnchor),

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
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)

        ])

        // Buttons

        let width = 150
        let height = 80

        let font = UIFont.systemFont(ofSize: 36)
        for row in 0...3 {
            for col in 0...4 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = font
                letterButton.setTitle("🀫🀫🀫", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped(_:)), for: .touchUpInside)
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                letterButton.layer.borderWidth = 0.5
                letterButton.layer.borderColor = UIColor.grayish.cgColor
                letterButton.layer.cornerRadius = 4
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }

        loadLevel()
    }

    @objc func letterTapped(_ sender: UIButton) {
        guard let bits = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(bits)
        activatedButtons.append(sender)
        sender.isHidden = true
    }

    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }
        if let position = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()

            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[position] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")

            currentAnswer.text = ""
            score += 1

            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        } else {
            currentAnswer.backgroundColor = UIColor.tint
            currentAnswer.textColor = UIColor.light

            let ac = UIAlertController(title: "Ouch!", message: "That was close. Try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: tryAgain))
            present(ac, animated: true)
        }

    }

    @objc func clearTapped(_ sender: UIButton!) {
        currentAnswer.text = ""
        for button in activatedButtons {
            button.isHidden = false
        }
        activatedButtons.removeAll()
    }

    func levelUp(action: UIAlertAction) {
        currentAnswer.backgroundColor = UIColor.tint
        currentAnswer.textColor = UIColor.light
    }

    func tryAgain(action: UIAlertAction) {
        currentAnswer.backgroundColor = view.backgroundColor
        currentAnswer.textColor = UIColor.darkText
        clearTapped(nil)
    }

    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()

        if let levelContents = Bundle.main.loadContentOf(level: level) {
            let lines = levelContents.components(separatedBy: "\n")
            for (index, line) in lines.enumerated() {
                let parts = line.components(separatedBy: ":")
                let answer = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let clue = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)

                clueString += "\(index + 1). \(clue)\n"

                let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                solutionString += "\(solutionWord.count) letters\n"
                solutions.append(solutionWord)


                let bits = answer.components(separatedBy: "|")
                letterBits += bits
            }
        }


        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)

        letterBits.shuffle()
        for (bits, button) in zip(letterBits, letterButtons) {
            button.setTitle(bits, for: .normal)
        }
    }

}


fileprivate extension Bundle {
    func loadContentOf(level: Int) -> String? {
        if let levelFileUrl = self.url(forResource: "level\(level)", withExtension: "txt") {
            return try? String(contentsOf: levelFileUrl)
        }
        return nil
    }
}
