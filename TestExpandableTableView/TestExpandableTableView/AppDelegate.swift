//
//  AppDelegate.swift
//  TestExpandableTableView
//
//  Created by Stephen Cao on 8/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow.initWindow(controllerName: "SampleThreePartTableViewController")
        window?.backgroundColor = UIColor.white
        return true
    }
}

