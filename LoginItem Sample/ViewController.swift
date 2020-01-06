//
//  ViewController.swift
//  LoginItem Sample
//
//  Created by zhaoxin on 2020/1/6.
//  Copyright © 2020 zhaoxin. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    static let autoStartDidChange = Notification.Name(rawValue: "autoStartDidChange")
    static let autoStart = "autoStart"
    
    private let preferences = UserDefaults.standard
    
    @IBOutlet weak var autoStartsButton: NSButton! {
        didSet {
            self.autoStartsButton.state = preferences.bool(forKey: ViewController.autoStart) ? .on : .off
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func autoStartsButtonClicked(_ sender: Any) {
        preferences.set((sender as! NSButton).state == .on, forKey: ViewController.autoStart)
        NotificationCenter.default.post(name: ViewController.autoStartDidChange, object: nil)
    }
}

