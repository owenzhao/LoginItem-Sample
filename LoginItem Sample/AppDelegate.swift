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
    private var window:NSWindow? = nil
    private let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setAutoStart()
        setupMenubarTray()
        ProcessInfo.processInfo.disableSuddenTermination()
        setupWorkspaceNotifications()
        
        if UserDefaults.shared.bool(forKey: UserDefaults.Key.startFromLauncher.rawValue) {
            UserDefaults.shared.set(false, forKey: UserDefaults.Key.startFromLauncher.rawValue)
        } else {
            showWindow()
        }
    }
    
    @objc private func setAutoStart() {
        let shouldEnable = UserDefaults.standard.bool(forKey: ViewController.autoStart)
        
        if !SMLoginItemSetEnabled("com.parussoft.LoginItem-Sample-Launcher" as CFString, shouldEnable) {
            print("Login Item Was Not Successful")
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
}

// MARK: - Menubar item
extension AppDelegate {
    private func setupMenubarTray() {
        guard let button = statusItem.button else {
            fatalError()
        }
        
        setTrayIcon(for:button)
        button.action = #selector(mouseLeftButtonClicked)
        
        // Add mouse right click
        let subView = MouseRightClickView(frame: button.frame)
        subView.closure = {
            self.constructMenu()
            button.performClick(nil) // menu won't show without this
        }
        button.addSubview(subView)
    }
    
    private func setTrayIcon(for button:NSStatusBarButton) {
        button.image = NSImage(imageLiteralResourceName: "MonochromeIcon")
    }
    
    private func constructMenu() {
        let menu = NSMenu()
        menu.delegate = self
        menu.addItem(withTitle: NSLocalizedString("About", comment: ""), action: #selector(NSApp.orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
        menu.addItem(withTitle: NSLocalizedString("Quit", comment: ""), action: #selector(quit), keyEquivalent: "")
        statusItem.menu = menu
    }
    
    @objc private func mouseLeftButtonClicked() {
        guard let window = self.window else {
            showWindow()
            return
        }
        
        var operated = false
        
        if NSApp.isHidden {
            unhide()
            if !operated { operated = true }
        }
        
        if window.isMiniaturized {
            window.deminiaturize(nil)
            if !operated { operated = true }
        }
        
        if !NSApp.isActive {
            NSApp.activate(ignoringOtherApps: true)
            if !operated { operated = true }
        }
        
        guard window.isKeyWindow else { return }
        
        if !operated {
            hide()
        }
    }
}

extension AppDelegate:NSMenuDelegate {
    // remove the menu or later mouse left click will call it.
    func menuDidClose(_ menu: NSMenu) {
        statusItem.menu = nil
    }
}

// MARK: - NSApp and Window
extension AppDelegate {
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // must delay this operation or the main menu will leave a selected state when the app shows next time.
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.hide()
        }
        return .terminateCancel
    }
    
    private func showWindow() {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "mainWindowController") as! NSWindowController
        
        window = windowController.window
        window?.delegate = self
        
        showInDock()
        window!.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setAutoStart), name: ViewController.autoStartDidChange, object: nil)
    }
    
    private func hide() {
        removeFromDock()
        NSApp.hide(nil)
    }
    
    private func unhide() {
        showInDock()
        NSApp.unhide(nil)
    }
    
    private func showInDock() {
        NSApp.setActivationPolicy(.regular)
    }
    
    private func removeFromDock() {
        NSApp.setActivationPolicy(.accessory)
    }
    
    @objc private func quit() {
        ProcessInfo.processInfo.enableSuddenTermination()
        NSApp.terminate(nil)
    }
}

extension AppDelegate:NSWindowDelegate {
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        hide()
        return false
    }
}

// MARK: - NSWorkspace
extension AppDelegate {
    private func setupWorkspaceNotifications() {
        let center = NSWorkspace.shared.notificationCenter
        center.addObserver(self, selector: #selector(didWake(_:)), name: NSWorkspace.didWakeNotification, object: nil)
        center.addObserver(self, selector: #selector(willSleep(_:)), name: NSWorkspace.willSleepNotification, object: nil)
        center.addObserver(self, selector: #selector(willPowerOff(_:)), name: NSWorkspace.willPowerOffNotification, object: nil)
    }
    
    @objc private func didWake(_ noti:Notification) {
        ProcessInfo.processInfo.disableSuddenTermination()
    }
    
    @objc private func willSleep(_ noti:Notification) {
        ProcessInfo.processInfo.enableSuddenTermination()
    }
    
    @objc private func willPowerOff(_ noti:Notification) {
        quit()
    }
}
