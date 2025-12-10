import WinAppSDK
import WinUI
import Foundation

@main
class App: SwiftApplication {
    required init() {
        super.init()
        self.requestedTheme = ApplicationTheme.dark
    }    
    override func onLaunched(_ args: WinUI.LaunchActivatedEventArgs) {
        loadGlobalResources()
        let window: Window = MainWindow()
        try! window.activate()
    }

    private func loadGlobalResources() {
        guard let appResources = Application.current?.resources else {
            debugPrint("App resources not ready"); return
        }
        guard let path = Bundle.module.path(forResource: "SharedResources",
                                            ofType: "xaml",
                                            inDirectory: "Assets/xaml") else {
            debugPrint("SharedResources.xaml not found"); return
        }
        guard let xaml = FileReader.readFileFromPath(path) else {
            debugPrint("SharedResources.xaml read failed"); return
        }
        guard let dict = try? XamlReader.load(xaml) as? ResourceDictionary else {
            debugPrint("XamlReader returned non-ResourceDictionary"); return
        }
        appResources.mergedDictionaries.append(dict)
        debugPrint("Merged SharedResources.xaml")
    }
}

