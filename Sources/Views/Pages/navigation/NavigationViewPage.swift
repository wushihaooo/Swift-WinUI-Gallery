import WinUI
import WinAppSDK

class NavigationViewPage: Grid {
    override init() {
        super.init()
        setupView()
    }

    private func setupView() {
        let textBlock = TextBlock()
        textBlock.text = "NavigationView"
        textBlock.fontSize = 32
        textBlock.horizontalAlignment = .center
        textBlock.verticalAlignment = .center

        self.children.append(textBlock)
    }
}
