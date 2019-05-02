//
//  AppDelegate.swift
//  Project4-Browser
//
//  Created by Dmytro Kholodov on 5/2/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        self.window = self.window ?? UIWindow()

        let nc = UINavigationController(rootViewController: LinksTableViewController())
        self.window?.rootViewController = nc
        
        self.window?.makeKeyAndVisible()

        return true
    }

}

