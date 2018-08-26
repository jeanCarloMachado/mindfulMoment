//
//  AppDelegate.swift
//  mindfulMoment
//
//  Created by Jean Machado on 26.08.18.
//  Copyright © 2018 Jean Machado. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var statusMenu: NSMenu!

    @IBAction func quitClick(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)


    func applicationDidFinishLaunching(_ aNotification: Notification) {

        statusItem.title = "Mindful Moment"
        statusItem.menu = statusMenu
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

