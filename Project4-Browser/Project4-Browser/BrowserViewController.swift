//
//  ViewController.swift
//  Project4-Browser
//
//  Created by Dmytro Kholodov on 5/2/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController {

    var allowedHosts: [String] = []
    var defaultWebsite: String = ""

    convenience init(hosts: [String], defaultWebsite: String) {
        self.init()
        self.allowedHosts = hosts
        self.defaultWebsite = defaultWebsite
    }

    private var webView: WKWebView!
    private var progressView: UIProgressView!

    var goBack: UIBarButtonItem!
    var goForward: UIBarButtonItem!

    override func loadView() {
        webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        view = webView
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        request(page: defaultWebsite)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))

        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        goBack = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        goForward = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))

        toolbarItems = [progressButton, spacer, goBack, goForward, refresh]

        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        updateState()
    }

    func request(page source: String) {
        guard let url = URL(string: source) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    @objc func openPage(action: UIAlertAction) {
        request(page: "https://" + action.title!)
    }

    @objc func openTapped() {
        let ac = UIAlertController(title: "Surf the web within these hosts…", message: nil, preferredStyle: .actionSheet)
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem

        allowedHosts
            .map {
                UIAlertAction(title: $0, style: .default, handler: openPage)
            }.forEach {
                ac.addAction($0)
            }

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(ac, animated: true, completion: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    private func updateState() {
        goForward.isEnabled = webView.canGoForward
        goBack.isEnabled = webView.canGoBack
    }
}

extension BrowserViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
        updateState()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if var host = url?.host?.lowercased() {
            if host.hasPrefix("www.") {
                host = String(host.dropFirst(4))
            }
            if allowedHosts.contains(host) {
                decisionHandler(.allow)
                return
            }
        }
        decisionHandler(.cancel)

        let ac = UIAlertController(title: nil, message: url?.absoluteString, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "This URL isn’t allowed.", style: .default, handler: nil))

        self.present(ac, animated: true, completion: nil)
    }
}
