import Cocoa

class StatusMenuController: NSObject {
    let databaseFile = ".database.txt"

    @IBOutlet var statusMenu: NSMenu!

    @IBAction func quitClick(_: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    @IBAction func addClick(_: NSMenuItem) {
        // if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        //     let fileURL = dir.appendingPathComponent(databaseFile)

        //     let outString = "Write this text to the file"
        //     do {
        //         try outString.write(to: fileURL, atomically: true, encoding: .utf8)
        //     } catch {
        //         print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
        //     }

        // }
    }

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    override func awakeFromNib() {
        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu

        let content = getDatabaseContent()
        let editMenuItem = NSMenuItem()
        editMenuItem.title = content
        statusMenu.addItem(editMenuItem)
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
}
