import Cocoa

class StatusMenuController: NSObject {
    let databaseFile = ".database.txt"

    @IBOutlet var statusMenu: NSMenu!

    @IBAction func quitClick(_: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    @IBOutlet weak var counter: NSMenuItem!
    @IBOutlet weak var counterYesterday: NSMenuItem!
    
    var Timestamp: String {
        return String(String(format:"%.0f", NSDate().timeIntervalSince1970 * 1000).prefix(10))
    }

    @IBAction func addClick(_: NSMenuItem) {
        var content = getDatabaseContent()

        let now = Timestamp  + "\n"
        content = content + now
        writeToDatabase(content: content)

        let databaseLines = content.components(separatedBy: ["\n"])


        let resultsToday = databaseLines.filter() { (entry) in
            let date = Date(timeIntervalSince1970: (entry as NSString).doubleValue)
            return Calendar.current.isDateInToday(date)
        }

        counter.title = "Today: \(resultsToday.count)"


        let resultsYesterday = databaseLines.filter() { (entry) in
            let date = Date(timeIntervalSince1970: (entry as NSString).doubleValue)
            return Calendar.current.isDateInYesterday(date)
        }
        counterYesterday.title = "Yesterday: \(resultsYesterday.count)"
    }

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    override func awakeFromNib() {
        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu

        let databaseLines = getDatabaseContent().components(separatedBy: ["\n"])

        let resultsToday = databaseLines.filter() { (entry) in
            let date = Date(timeIntervalSince1970: (entry as NSString).doubleValue)
            return Calendar.current.isDateInToday(date)
        }

        counter.title = "Today: \(resultsToday.count)"


        let resultsYesterday = databaseLines.filter() { (entry) in
            let date = Date(timeIntervalSince1970: (entry as NSString).doubleValue)
            return Calendar.current.isDateInYesterday(date)
        }
        counterYesterday.title = "Yesterday: \(resultsYesterday.count)"

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
                let fileHandle = try FileHandle(forWritingTo: fileURL)
                fileHandle.seekToEndOfFile()
                fileHandle.write(content.data(using: .utf8)!)
                fileHandle.closeFile()

            } catch {
                print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            }

        }
    }
}
