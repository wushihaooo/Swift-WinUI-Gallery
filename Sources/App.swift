import WinAppSDK
import WinUI

@main
class App: SwiftApplication {
    required init() {
        super.init()

        self.requestedTheme = ApplicationTheme.dark
    }
    
    override func onLaunched(_ args: WinUI.LaunchActivatedEventArgs) {
        let tb = TextBlock()
        tb.fontSize = 22
        tb.text = "Hello WinUI World"

        let panel = StackPanel()
        var abc = "ASB"
        abc.append(contentsOf: "123")
        panel.horizontalAlignment = .center
        panel.verticalAlignment = .center
        panel.children.append(tb)

        let navigationView = NavigationView()
        navigationView.paneDisplayMode = .left
        navigationView.isSettingsVisible = true
        navigationView.openPaneLength = 220
        navigationView.isBackButtonVisible = .auto
        navigationView.content = panel
        
        let window = Window()
        window.title = "SwiftWinUIGallery"
        window.content = navigationView
        window.extendsContentIntoTitleBar = true
        //try! window.setTitleBar(tb)
        // let micaBackdrop = MicaBackdrop()
        // micaBackdrop.kind = MicaKind.baseAlt
        // window.systemBackdrop = micaBackdrop

        try! window.activate()
    }
}