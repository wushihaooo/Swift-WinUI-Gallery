import WinUI
import WinAppSDK
import WindowsFoundation  // ✅ 添加这一行

class HyperlinkButtonPage: StackPanel {
    var onToggleButtonClicked: (() -> Void)?  // 回调

    private let outputText = TextBlock()

    override init() {
        super.init()
        setupLayout()
    }

    private func setupLayout() {
        self.orientation = .vertical
        self.spacing = 12
        self.padding = Thickness(left: 20, top: 20, right: 20, bottom: 20)

        // ✅ 标题
        let title = TextBlock()
        title.text = "HyperlinkButton Demo"
        title.fontSize = 20
        title.margin = Thickness(left: 0, top: 0, right: 0, bottom: 10)
        self.children.append(title)

        // ✅ 第一个：跳转到 Microsoft 官网
        let homeLink = HyperlinkButton()
        homeLink.content = "Microsoft home page"
        homeLink.navigateUri = Uri("https://www.microsoft.com") // ✅ 正确的 Uri 构造
        self.children.append(homeLink)

        // ✅ 第二个：带点击事件的超链接
        let toggleLink = HyperlinkButton()
        toggleLink.content = "ToggleButton"
        // toggleLink.click.addHandler { [weak self] _, _ in
        //     self?.onToggleButtonClicked?()
        // }
        self.children.append(toggleLink)

        // ✅ 输出结果显示区域
        outputText.text = "Output: (waiting for action)"
        outputText.fontSize = 14
        outputText.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)
        self.children.append(outputText)
    }
}
