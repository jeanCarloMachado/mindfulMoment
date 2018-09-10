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
    @IBOutlet weak var counter: NSMenuItem!
    @IBOutlet weak var counterYesterday: NSMenuItem!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)


    let databaseFile = ".database.txt"
    var Timestamp: String {
        return String(String(format: "%.0f", NSDate().timeIntervalSince1970 * 1000).prefix(10))
    }

    @IBAction func addClick(_ sender: NSMenuItem) {
        var content = getDatabaseContent()

        let now = Timestamp + "\n"
        content = content + now
        writeEntryToDatabase(entry: now)

        let databaseLines = content.components(separatedBy: ["\n"])

        let resultsToday = databaseLines.filter { entry in
            let date = Date(timeIntervalSince1970: (entry as NSString).doubleValue)
            return Calendar.current.isDateInToday(date)
        }

        counter.title = "Today: \(resultsToday.count)"

        let resultsYesterday = databaseLines.filter { entry in
            let date = Date(timeIntervalSince1970: (entry as NSString).doubleValue)
            return Calendar.current.isDateInYesterday(date)
        }
        counterYesterday.title = "Yesterday: \(resultsYesterday.count)"
    }
    
    @IBAction func quitClick(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    func applicationDidFinishLaunching(_: Notification) {
        var notification = NSUserNotification()
        notification.title = "Jean Machado5"
        notification.informativeText = "The body of this Swift notification"
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)

        statusItem.menu = statusMenu

        if let button = statusItem.button {
            let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
            icon?.isTemplate = true // best for dark mode
            button.image = icon
            button.action = #selector(foo(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

     
        let databaseLines = getDatabaseContent().components(separatedBy: ["\n"])

        let resultsToday = databaseLines.filter { entry in
            let date = Date(timeIntervalSince1970: (entry as NSString).doubleValue)
            return Calendar.current.isDateInToday(date)
        }

        counter.title = "Today: \(resultsToday.count)"

        let resultsYesterday = databaseLines.filter { entry in
            let date = Date(timeIntervalSince1970: (entry as NSString).doubleValue)
            return Calendar.current.isDateInYesterday(date)
        }
        counterYesterday.title = "Yesterday: \(resultsYesterday.count)"
    }

    func applicationWillTerminate(_: Notification) {
        // Insert code here to tear down your application
    }



    @objc func foo(_ sender: NSStatusBarButton) {
        var notification = NSUserNotification()
        notification.title = "Jean Machado"
        notification.informativeText = "The body of this Swift notification"
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }

    func getDatabaseContent() -> String {
        var text = ""
        do {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathComponent(databaseFile)
                text = try String(contentsOf: fileURL, encoding: .utf8)
            }
        } catch {
            print("error:", error)
        }

        return text
    }

    func writeEntryToDatabase(entry: String) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(databaseFile)

            do {
                let fileHandle = try FileHandle(forWritingTo: fileURL)
                fileHandle.seekToEndOfFile()
                fileHandle.write(entry.data(using: .utf8)!)
                fileHandle.closeFile()

            } catch {
                print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            }
        }
    }
}
