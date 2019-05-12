//
//  DocumentBrowserViewController.swift
//  JustType
//
//  Created by Dmytro Kholodov on 5/12/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit


class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate, UIViewControllerTransitioningDelegate {

    var transitionController: UIDocumentBrowserTransitionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        
        // Update the style of the UIDocumentBrowserViewController
        // browserUserInterfaceStyle = .dark
         view.tintColor = .red
        
        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        let baseDirectory = NSURL(fileURLWithPath: NSTemporaryDirectory())
        let filename = baseDirectory.appendingPathComponent("text.txt")
        let document = Document(fileURL: filename!)
        document.save(to: filename!, for: .forCreating) { succes in
            importHandler(filename, .move)
        }
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let documentViewController = storyBoard.instantiateViewController(withIdentifier: "DocumentViewController") as! DocumentViewController
        documentViewController.document = Document(fileURL: documentURL)

        let nc = UINavigationController(rootViewController: documentViewController)
        nc.view.tintColor = view.tintColor
        nc.transitioningDelegate = self
        transitionController = transitionController(forDocumentAt:  documentURL)
        transitionController?.targetView = documentViewController.textView 
        present(nc, animated: true, completion: nil)
    }


    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
         return transitionController
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionController
    }
}

