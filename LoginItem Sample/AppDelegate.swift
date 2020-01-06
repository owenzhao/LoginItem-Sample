//
//  AppDelegate.swift
//  LoginItem Sample
//
//  Created by zhaoxin on 2020/1/6.
//  Copyright © 2020 zhaoxin. All rights reserved.
//

import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setAutoStart()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setAutoStart), name: ViewController.autoStartDidChange, object: nil)
    }
    
    @objc private func setAutoStart() {
        let shouldEnable = UserDefaults.standard.bool(forKey: ViewController.autoStart)
        
        if !SMLoginItemSetEnabled("com.parussoft.LoginItem-Sample-Launcher" as CFString, shouldEnable) {
            print("Login Item Was Not Successful")
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

