//
//  ActionViewController.swift
//  Extension
//
//  Created by Dmytro Kholodov on 6/8/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    @IBOutlet var saved: UICollectionView!

    @IBOutlet var scriptEditor: UITextView!
    var pageTitle = ""
    var pageURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        saved.dataSource = self
        saved.delegate = self

        scriptEditor.layoutManager.delegate = self
        scriptEditor.backgroundColor = UIColor(patternImage: UIImage(named: "sheet")!)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    // do stuff!
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    print(javaScriptValues)
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    let url = URL(string: javaScriptValues["URL"] as? String ?? "")
                    self?.loadScripts(for: url)

                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
    }


    @objc func done() {
        let cururl = URL(string: self.pageURL)
        guard let url = cururl, let host = url.host else {
            extensionContext?.completeRequest(returningItems: [])
            return
        }

        let rawScript = scriptEditor.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if rawScript.isEmpty {
            extensionContext?.completeRequest(returningItems: [])
            return
        }

        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": rawScript]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]


        var newSet = Set(savedScripts)
        newSet.insert(rawScript)
        let ud = UserDefaults.standard
        ud.set(Array(newSet), forKey: host)

        extensionContext?.completeRequest(returningItems: [item])
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scriptEditor.contentInset = .zero
        } else {
            scriptEditor.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        scriptEditor.scrollIndicatorInsets = scriptEditor.contentInset

        let selectedRange = scriptEditor.selectedRange
        scriptEditor.scrollRangeToVisible(selectedRange)
    }

    var savedScripts = [String]()
    func loadScripts(for url: URL?) {
        savedScripts.removeAll()

        guard let url = url, let host = url.host else {
            return
        }

        let ud = UserDefaults.standard
        let tmp = ud.stringArray(forKey: host) ?? []
        savedScripts = tmp

        DispatchQueue.main.async {
            self.saved.reloadData()
        }
    }
}


extension ActionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedScripts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ScriptCell
        cell.textField.text = savedScripts[indexPath.item]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = savedScripts[indexPath.item]

        self.scriptEditor.text = item
        self.scriptEditor.delegate = self
    }
}

extension ActionViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let index = self.saved.indexPathsForSelectedItems?.first else {return}

        self.savedScripts[index.item] = textView.text

        self.saved.reloadItems(at: [index])
        self.saved.selectItem(at: index, animated: false, scrollPosition: .left)
    }

}
extension ActionViewController : NSLayoutManagerDelegate {
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 7.0
    }

    func layoutManager(_ layoutManager: NSLayoutManager, paragraphSpacingBeforeGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 7.0
    }

}

