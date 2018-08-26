import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet var statusMenu: NSMenu!

    @IBAction func quitClick(_: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    override func awakeFromNib() {
        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu

        let file = ".database.txt" //this is the file. we will write to and read from it

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)

            do {
                let text = try String(contentsOf: fileURL, encoding: .utf8)
                let editMenuItem = NSMenuItem()
                editMenuItem.title = text
                statusMenu.addItem(editMenuItem)
            } catch {
                print("error:", error)
            }
        }

    }
}
