//
//  DocumentViewController.swift
//  JustType
//
//  Created by Dmytro Kholodov on 5/12/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit
import Sourceful

class DocumentViewController: UIViewController, SyntaxTextViewDelegate {

    @IBOutlet var textView: SyntaxTextView!

    var document: Document?

    var parser = SwiftLexer()

    func lexerForSource(_ source: String) -> Lexer {
        return parser
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        textView.theme = DefaultSourceCodeTheme()
        textView.delegate = self

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTappend(sender:)))

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissDocumentViewController ))


        // Access the document
        document?.open { success in
            if success {
                self.title = self.document?.fileURL.deletingPathExtension().lastPathComponent
                // Display the content of the document, e.g.:
                self.textView.text = self.document?.text ?? ""
            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
            }
        }
    }
    
    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true) {
            self.document?.text = self.textView.text
            self.document?.updateChangeCount(.done )
            self.document?.close(completionHandler: nil)
        }
    }

    @objc func shareTappend(sender: UIBarButtonItem) {
        guard let url = document?.fileURL else {
            return
        }

        let ac = UIActivityViewController(activityItems: [url], applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(ac, animated: true, completion: nil)
    }
}
