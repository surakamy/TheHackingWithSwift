//
//  ViewController.swift
//  Project5
//
//  Created by Dmytro Kholodov on 5/3/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var allWords = [String]()
    var usedWords = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        loadWords()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        startGame()
    }

    // MARK - Game logic

    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }

    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        guard isPossible(word: lowerAnswer) else {
            promptForAnswer(as: .impossible(word: answer))
            return
        }
        if let index = hasUsed(word: lowerAnswer) {
            let indexPath = IndexPath(row: index, section: 0)
            UIView.animate(withDuration: 1.0) {
                self.tableView.scrollToRow(at: indexPath, at: .none, animated: true)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
            return
        }
        guard isReal(word: lowerAnswer) else {
            promptForAnswer(as: .unreal(word: answer))
            return
        }
        usedWords.insert(lowerAnswer, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    func isPossible(word: String) -> Bool {
        guard let masterWord = title?.lowercased() else {
            return false
        }
        let lowerWord = word.lowercased()

        guard lowerWord.count >= 3 else {
            return false
        }

        guard masterWord != lowerWord else {
            return false
        }

        // Anagram check
        var buckets = [Character:Int]()

        for c in masterWord {
            buckets[c, default: 0] += 1
        }
        for c in lowerWord {
            guard let value = buckets[c], value > 0 else { return false }
            buckets[c, default: 0] -= 1
        }

        return true
    }

    func hasUsed(word: String) -> Int? {
        return usedWords.firstIndex(of:word)
    }

    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }

    // MARK - Helpers
    enum PromptMode {
        case empty
        case impossible(word: String)
        case unreal(word: String)
    }

    fileprivate func promptForAnswer(as mode: PromptMode = .empty) {
        let title: String
        var word = ""
        var message: String?

        switch mode {
        case .impossible(let previousWord):
            word = previousWord
            title = "Word not possible"
            message = "You can't spell that word from \(previousWord)"
        case .unreal(let previousWord):
            word = previousWord
            title = "Word not recognised"
            message = "You can't just make them up, you know! \nOr can you?"
        default:
            title = "Enter answer"
        }
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addTextField { field in
            field.text = word
        }
        let submitAction = UIAlertAction(title: "✅ Submit!", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?.first?.text else { return }
            self?.submit(answer)

        }
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "😔 Give up!", style: .cancel))
        present(ac, animated: true, completion: nil)
    }

    @objc fileprivate func promptForAnswer() {
        promptForAnswer(as: .empty)
    }

    fileprivate func loadWords() {
        if let path = Bundle.main.path(forResource: "start", ofType: "txt") {
            if let startWords = try? String(contentsOfFile: path) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }

        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
    }

    //MARK -- Table Delegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

