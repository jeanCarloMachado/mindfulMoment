import Cocoa

class StatusMenuController: NSObject {
    let databaseFile = ".database.txt"

    @IBOutlet var statusMenu: NSMenu!

    @IBAction func quitClick(_: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    var Timestamp: String {
        return String(String(format:"%.0f", NSDate().timeIntervalSince1970 * 1000).prefix(10))
    }

    @IBAction func addClick(_: NSMenuItem) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(databaseFile)


            var content =  getDatabaseContent()
            let now = Timestamp  + "\n"

            content = content + now

            do {
                try content.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            }

        }
    }

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    override func awakeFromNib() {
        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu

        let content = getDatabaseContent()
        let linesCount = content.reduce(into: 0) { (count, letter) in
             if letter == "\n" {      // This treats CRLF as one "letter", contrary to UnicodeScalars
                count += 1
             }
        }

        let editMenuItem = NSMenuItem()
        editMenuItem.title = "Total: \(linesCount)"
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
