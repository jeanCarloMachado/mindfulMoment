import Cocoa

class StatusMenuController: NSObject {
    let databaseFile = ".database.txt"

    @IBOutlet var statusMenu: NSMenu!

    @IBAction func quitClick(_: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    @IBOutlet weak var counter: NSMenuItem!

    var Timestamp: String {
        return String(String(format:"%.0f", NSDate().timeIntervalSince1970 * 1000).prefix(10))
    }

    @IBAction func addClick(_: NSMenuItem) {

        let now = Timestamp  + "\n"
        var content = getDatabaseContent()
        content = content + now

        writeToDatabase(content: content)

        let linesCount = countLines(str: content)
        counter.title = "Total: \(linesCount)"
    }

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    override func awakeFromNib() {
        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu

        let content = getDatabaseContent()
        let linesCount = countLines(str: content)
        counter.title = "Total: \(linesCount)"
    }

    func countLines(str: String) -> Int {

        return  str.reduce(into: 0) { (count, letter) in
             if letter == "\n" {      // This treats CRLF as one "letter", contrary to UnicodeScalars
                count += 1
             }
        }

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

    func writeToDatabase(content: String) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(databaseFile)

            do {
                try content.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            }

        }
    }
}
