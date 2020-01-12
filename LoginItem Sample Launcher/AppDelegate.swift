//
//  AppDelegate.swift
//  LoginItem Sample Launcher
//
//  Created by zhaoxin on 2020/1/6.
//  Copyright © 2020 zhaoxin. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        UserDefaults.shared.set(true, forKey: UserDefaults.Key.autoLaunchWhenUserLogin.rawValue)
        
        let pathComponents = Bundle.main.bundleURL.pathComponents
        let mainRange = 0..<(pathComponents.count - 4)
        let mainPath = pathComponents[mainRange].joined(separator: "/")
        try! NSWorkspace.shared.launchApplication(at: URL(fileURLWithPath: mainPath, isDirectory: false), options: [], configuration: [:])
        NSApp.terminate(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

