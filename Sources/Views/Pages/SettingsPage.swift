import WinUI

class SettingsPage: Page {
    override init() {
        super.init()
        let tb = TextBlock()
        tb.text = "Settings"
        self.content = tb
    }
}