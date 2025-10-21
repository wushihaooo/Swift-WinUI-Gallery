import WinUI
import WinAppSDK

class TabViewPage: Grid {
    override init() {
        super.init()
        setupView()
    }

    private func setupView() {
        let textBlock = TextBlock()
        textBlock.text = "TabView"
        textBlock.fontSize = 32
        textBlock.horizontalAlignment = .center
        textBlock.verticalAlignment = .center

        self.children.append(textBlock)
    }
}
