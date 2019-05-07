//
//  PetitionDetailsControllerViewController.swift
//  Project7
//
//  Created by Dmytro Kholodov on 5/7/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit
import WebKit

class PetitionDetailsControllerViewController: UIViewController {

    var webView: WKWebView!
    var petition: Petition?

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
                <style> body { font-size:150%; padding:2%; }</style>
            </head>
            <body>
                <h1>\(detailItem.title)</h1>
                <p>\(detailItem.body)</p>
            </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)
        title = "Petition"
    }

}
