//
//  AppDelegate.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 3/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityIndicator
import SVProgressHUD
import SDWebImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupBasicSettings()
        window = UIWindow.initWindow(controllerName: "SCMainViewController")
        window?.backgroundColor = UIColor.white
        return true
    }
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }
}
private extension AppDelegate{
    func setupBasicSettings(){
        SVProgressHUD.setForegroundColor(InfoCommon.barColor)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
        NetworkActivityIndicatorManager.shared.isEnabled = true
    }
}


