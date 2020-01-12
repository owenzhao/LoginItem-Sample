//
//  MouseRightClickView.swift
//  Orange Planner
//
//  Created by 肇鑫 on 2018-12-18.
//  Copyright © 2018 ParusSoft.com. All rights reserved.
//

import Cocoa

class MouseRightClickView: NSView {
    var closure:(() -> ())!
    
    override func rightMouseUp(with event: NSEvent) {
        super.rightMouseUp(with: event)
        
        closure()
    }
}
