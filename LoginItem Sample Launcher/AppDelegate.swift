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
        UserDefaults.shared.set(true, forKey: UserDefaults.Key.startFromLauncher.rawValue)
        
        let pathComponents = Bundle.main.bundleURL.pathComponents
        let mainRange = 0..<(pathComponents.count - 4)
        let mainPath = pathComponents[mainRange].joined(separator: "/")
        let url = URL(fileURLWithPath: mainPath, isDirectory: false)
        let configuration = NSWorkspace.OpenConfiguration()
        launchMainApp(url, with: configuration)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    private func launchMainApp(_ url:URL, with configuration:NSWorkspace.OpenConfiguration) {
        NSWorkspace.shared.openApplication(at: url, configuration: configuration) { app, error in
            if error == nil {
                NSApp.terminate(nil)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [unowned self] in
                    launchMainApp(url, with: configuration)
                }
            }
        }
    }
}

