//
//  ViewController.swift
//  Project2
//
//  Created by Dmytro Kholodov on 4/29/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    weak var scoresButton: UIBarButtonItem!

    var countries = [String]()
    var score = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]

        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1

        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        scoresButton = navigationItem.rightBarButtonItem

        askQuestion()
    }

    let questionsInRow = 10
    var correctAnswer = 0
    var questionsAsked = 0
    func askQuestion(action: UIAlertAction! = nil) {
        self.scoresButton.title = "\(score) / \(questionsInRow)"

        if questionsAsked == questionsInRow {
            let ac = UIAlertController(title: "Game over", message: "Your score is \(score).", preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: askQuestion))
            present(ac, animated: true)

            questionsAsked = 0
            score = 0

            return
        }

        questionsAsked += 1

        countries.shuffle()

        correctAnswer = Int.random(in: 0...2)

        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)

        title = countries[correctAnswer].uppercased()
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var message: String
        if sender.tag == correctAnswer {
            score += 1
            title =  "Correct"
            message = "Your score is \(score)."
        } else {
            score -= 1
            title =  "Wrong"
            message = "Wrong! That’s the flag of \(countries[correctAnswer].uppercased())"
        }

        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
    }

}

