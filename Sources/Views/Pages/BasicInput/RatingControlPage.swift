import WinUI
import WinAppSDK

class RatingControlPage: Grid {
    // MARK: - Initialization
    override init() {
        super.init()
        setupView()
    }

    private func setupView() {
        let textBlock = TextBlock()
        textBlock.text = "there is a problem"
        textBlock.fontSize = 24
        textBlock.horizontalAlignment = .center
        textBlock.verticalAlignment = .center

        self.children.append(textBlock)
    }
}