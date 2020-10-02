//
//  AppDelegate.swift
//  Work Courses LMS
//
//  Created by Abhishek Dubey on 30/07/20.
//  Copyright © 2020 Dev Abhi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.setRoot()
        
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
        
        return true
    }

    //MARK:- Support
    func setRoot() {
        let pref = Preferences()
        if pref.auth != nil {
            let storyboard = UIStoryboard(name:"Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "sib_mainTabViewController")
            self.window?.rootViewController = vc
        }else{
            let storyboard = UIStoryboard(name:"Auth", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "sbi_nvcauthentication")
            self.window?.rootViewController = vc
        }
    }
}

