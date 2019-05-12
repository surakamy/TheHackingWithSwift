//
//  PetitionDetailsControllerViewController.swift
//  Project7
//
//  Created by Dmytro Kholodov on 5/7/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit
import WebKit

class PetitionDetailsControllerViewController: UIViewController, UIScrollViewDelegate {

    var webView: WKWebView!
    var petition: Petition?
    var highlight: String?

    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = petition else { return }


        let html = """
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <style>
                    body { font-size:150%; padding:2%; }
                    .selected {
                        color: white;
                        background: red;
                        font-weight: bold;
                        padding: 1px;
                    }
                </style>
            </head>
            <body>
                <h1>
                \(getHighlighted(for: detailItem.title, highlights: highlight))
                </h1>
                <p>
                \(getHighlighted(for: detailItem.body, highlights: highlight))
                </p>
            </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)
        title = "Petition"
    }



    fileprivate func getHighlighted(for text: String, highlights: String? = nil) -> String {
        guard let highlights = highlights else {
            return text
        }

        let selectedText = """
        <span class="selected">\(highlights)</span>
        """

        let altered = NSMutableString(string: text)
        altered .replaceOccurrences(of: highlights, with: selectedText, options: .caseInsensitive, range: NSRange(location: 0, length: text.utf16.count))
        return altered as String
    }
}
