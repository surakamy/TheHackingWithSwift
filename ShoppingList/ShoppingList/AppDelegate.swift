//
//  AppDelegate.swift
//  ShoppingList
//
//  Created by Dmytro Kholodov on 5/6/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.tintColor = UIColor(named: "accent")
        return true
    }
}

