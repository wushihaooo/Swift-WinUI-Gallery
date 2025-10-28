import WinAppSDK
import WinUI

@main
class App: SwiftApplication {
    required init() {
        super.init()
        self.requestedTheme = ApplicationTheme.dark
    }    
    override func onLaunched(_ args: WinUI.LaunchActivatedEventArgs) {
        let window: Window = MainWindow()
        try! window.activate()
    }
}

