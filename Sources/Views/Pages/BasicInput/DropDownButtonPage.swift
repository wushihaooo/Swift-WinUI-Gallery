import WinUI
import WinAppSDK

class DropDownButtonPage: StackPanel {
    private let outputText = TextBlock()

    override init() {
        super.init()
        setupLayout()
    }

    private func setupLayout() {
        self.orientation = .vertical
        self.spacing = 10
        self.padding = Thickness(left: 20, top: 20, right: 20, bottom: 20)

        // ✅ 标题
        let title = TextBlock()
        title.text = "DropDownButton Simulation (Using Button + MenuFlyout)"
        title.fontSize = 20
        self.children.append(title)

        // ✅ 文本版
        let textButtonTitle = TextBlock()
        textButtonTitle.text = "Text Button with Flyout"
        textButtonTitle.fontSize = 16
        textButtonTitle.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)
        self.children.append(textButtonTitle)
        self.children.append(createTextFlyoutButton())

        // ✅ 图标版
        let iconButtonTitle = TextBlock()
        iconButtonTitle.text = "Icon Button with Flyout"
        iconButtonTitle.fontSize = 16
        iconButtonTitle.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)
        self.children.append(iconButtonTitle)
        self.children.append(createIconFlyoutButton())

        // ✅ 输出文字
        outputText.text = "Output:"
        outputText.fontSize = 14
        outputText.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)
        self.children.append(outputText)
    }

    // MARK: - 混合版 DropDownButton (Email + ▼)
    private func createTextFlyoutButton() -> Button {
        let button = Button()

        // 布局：📧 + Email + ▼
        let stack = StackPanel()
        stack.orientation = .horizontal
        stack.spacing = 5

        let label = TextBlock()
        label.text = "Email"
        label.fontSize = 16

        let downIcon = FontIcon()
        downIcon.glyph = "\u{E70D}" // ▼ 图标
        downIcon.fontSize = 10
        downIcon.verticalAlignment = .center

        stack.children.append(label)
        stack.children.append(downIcon)
        button.content = stack

        // ✅ 添加 Flyout
        let menuFlyout = createCommonFlyout(suffix: "(hybrid version)")

        // ✅ 手动控制下拉弹出
        button.click.addHandler { _, _ in
            let options = FlyoutShowOptions()
            options.placement = .bottom
            try? menuFlyout.showAt(button, options)
        }

        // ✅ 修正样式构造
        button.padding = Thickness(left: 10, top: 6, right: 10, bottom: 6)
        button.cornerRadius = CornerRadius(topLeft: 6, topRight: 6, bottomRight: 6, bottomLeft: 6)
        button.horizontalAlignment = .left

        return button
    }

    // MARK: - 混合版 DropDownButton (Email + ▼)
    private func createIconFlyoutButton() -> Button {
        let button = Button()

        // 布局：📧 + Email + ▼
        let stack = StackPanel()
        stack.orientation = .horizontal
        stack.spacing = 5

        let emailIcon = FontIcon()
        emailIcon.glyph = "\u{E715}" // 邮件图标
        emailIcon.fontSize = 16

        let downIcon = FontIcon()
        downIcon.glyph = "\u{E70D}" // ▼ 图标
        downIcon.fontSize = 10
        downIcon.verticalAlignment = .center

        stack.children.append(emailIcon)
        stack.children.append(downIcon)
        button.content = stack

        // ✅ 添加 Flyout

        // ✅ 下拉菜单（提前定义）
        let menuFlyout = createCommonFlyout(suffix: "(hybrid version)")

        // ✅ 手动控制下拉弹出
        button.click.addHandler { _, _ in
            let options = FlyoutShowOptions()
            options.placement = .bottom
            try? menuFlyout.showAt(button, options)
        }


        // ✅ 修正样式构造
        button.padding = Thickness(left: 10, top: 6, right: 10, bottom: 6)
        button.cornerRadius = CornerRadius(topLeft: 6, topRight: 6, bottomRight: 6, bottomLeft: 6)
        button.horizontalAlignment = .left

        return button
    }

    // MARK: - 公共菜单生成函数
    private func createCommonFlyout(suffix: String) -> MenuFlyout {
        let flyout = MenuFlyout()

        let sendItem = MenuFlyoutItem()
        sendItem.text = "Send"
        sendItem.click.addHandler { [weak self] _, _ in
            self?.outputText.text = "Output: Send clicked \(suffix)"
        }

        let replyItem = MenuFlyoutItem()
        replyItem.text = "Reply"
        replyItem.click.addHandler { [weak self] _, _ in
            self?.outputText.text = "Output: Reply clicked \(suffix)"
        }

        let replyAllItem = MenuFlyoutItem()
        replyAllItem.text = "Reply All"
        replyAllItem.click.addHandler { [weak self] _, _ in
            self?.outputText.text = "Output: Reply All clicked \(suffix)"
        }

        flyout.items.append(sendItem)
        flyout.items.append(replyItem)
        flyout.items.append(replyAllItem)
        return flyout
    }
}
