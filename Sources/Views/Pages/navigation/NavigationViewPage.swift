import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

class NavigationViewPage: Grid {
    private var codeTextBlock: TextBlock?
    private var xamlButton: Button?
    private var csharpButton: Button?
    private var leftSampleContent: TextBlock?
    private var topSampleContent: TextBlock?
    private var autoSampleContent: TextBlock?

    private enum CodeTab {
        case xaml
        case csharp
    }

    private let xamlSampleText = """
<NavigationView Header="这是标题文本"
                PaneDisplayMode="Auto">
    <NavigationView.MenuItems>
        <NavigationViewItem Content="菜单项 1" Icon="Play" />
        <NavigationViewItem Content="菜单项 2" Icon="Save" />
        <NavigationViewItem Content="菜单项 3" Icon="Refresh" />
    </NavigationView.MenuItems>
    <Frame />
</NavigationView>
"""

    private let csharpSampleText = """
var navView = NavigationView()
navView.header = "这是标题文本"
navView.paneDisplayMode = .auto

let item = NavigationViewItem()
item.content = "菜单项 1"
item.icon = SymbolIcon(symbol: .play)
navView.menuItems.append(item)

navView.selectionChanged.addHandler { sender, args in
    if let selected = args.selectedItem as? NavigationViewItem,
       let title = selected.content as? String {
        sender.header = title
    }
}
"""

    override init() {
        super.init()
        setupView()
    }

    private func setupView() {
        let scrollViewer = ScrollViewer()
        scrollViewer.verticalScrollMode = .enabled
        scrollViewer.horizontalScrollMode = .disabled
        scrollViewer.verticalScrollBarVisibility = .auto
        scrollViewer.horizontalScrollBarVisibility = .hidden

        let mainStack = StackPanel()
        mainStack.spacing = 24
        mainStack.padding = Thickness(left: 24, top: 24, right: 24, bottom: 24)
        scrollViewer.content = mainStack
        self.children.append(scrollViewer)

        mainStack.children.append(createHeaderSection())
        mainStack.children.append(createIntroText())
        mainStack.children.append(createNavigationViewSample(
            title: "默认 PaneDisplayMode 的 NavigationView",
            description: "当应用在较宽窗口中需要突出显示五个以上同等重要的导航类别时，推荐使用左侧导航面板。",
            paneDisplayMode: .left,
            storage: &leftSampleContent,
            height: 320
        ))
        mainStack.children.append(createNavigationViewSample(
            title: "PaneDisplayMode 为 Top 的 NavigationView",
            description: "当导航类别同等重要，但需要弱化以凸显主要内容时，可以改用顶部导航面板。",
            paneDisplayMode: .top,
            storage: &topSampleContent,
            height: 300
        ))
        mainStack.children.append(createAutoSample())
        mainStack.children.append(createSourceCodeSection())
        mainStack.children.append(createFeatureList())

        let spacer = TextBlock()
        spacer.height = 24
        mainStack.children.append(spacer)

        selectCodeTab(.xaml)
    }

    private func selectCodeTab(_ tab: CodeTab) {
        guard let codeTextBlock else { return }

        switch tab {
        case .xaml:
            codeTextBlock.text = xamlSampleText
            highlight(button: xamlButton, isSelected: true)
            highlight(button: csharpButton, isSelected: false)
        case .csharp:
            codeTextBlock.text = csharpSampleText
            highlight(button: xamlButton, isSelected: false)
            highlight(button: csharpButton, isSelected: true)
        }
    }

    private func makeGlyphIcon(_ glyph: String) -> FontIcon {
        let icon = FontIcon()
        icon.glyph = glyph
        return icon
    }

    private func highlight(button: Button?, isSelected: Bool) {
        guard let button else { return }
        if isSelected {
            button.background = SolidColorBrush(Color(a: 255, r: 0, g: 120, b: 212))
            button.foreground = SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        } else {
            button.background = SolidColorBrush(Color(a: 0, r: 0, g: 0, b: 0))
            button.foreground = SolidColorBrush(Color(a: 255, r: 153, g: 153, b: 153))
        }
    }

    private func createHeaderSection() -> StackPanel {
        let section = StackPanel()
        section.spacing = 12

    let title = TextBlock()
    title.text = "NavigationView 导航视图"
        title.fontSize = 32
        title.fontWeight = FontWeights.semiBold
        title.foreground = SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        section.children.append(title)

        let tabs = StackPanel()
        tabs.orientation = .horizontal
        tabs.spacing = 20

    let docTab = TextBlock()
    docTab.text = "文档"
        docTab.fontSize = 14
        docTab.fontWeight = FontWeights.semiBold
        docTab.foreground = SolidColorBrush(Color(a: 255, r: 0, g: 120, b: 212))
        tabs.children.append(docTab)

    let sourceTab = TextBlock()
    sourceTab.text = "源码"
        sourceTab.fontSize = 14
        sourceTab.foreground = SolidColorBrush(Color(a: 255, r: 153, g: 153, b: 153))
        tabs.children.append(sourceTab)

        section.children.append(tabs)
        return section
    }

    private func createIntroText() -> TextBlock {
        let intro = TextBlock()
    intro.text = "NavigationView 控件是 Windows 应用的主要导航方式。它支持多种显示模式（Left、Top、LeftCompact、LeftMinimal），并内置页眉、内容区、顶部选项卡、页脚项目与搜索集成。"
        intro.fontSize = 14
        intro.foreground = SolidColorBrush(Color(a: 255, r: 204, g: 204, b: 204))
        intro.textWrapping = .wrap
        return intro
    }

    private func createNavigationViewSample(
        title: String,
        description: String,
        paneDisplayMode: NavigationViewPaneDisplayMode,
        storage: inout TextBlock?,
        height: Double
    ) -> StackPanel {
        let container = StackPanel()
        container.spacing = 12

        let titleBlock = TextBlock()
        titleBlock.text = title
        titleBlock.fontSize = 18
        titleBlock.fontWeight = FontWeights.semiBold
        titleBlock.foreground = SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        container.children.append(titleBlock)

        let descBlock = TextBlock()
        descBlock.text = description
        descBlock.fontSize = 12
        descBlock.foreground = SolidColorBrush(Color(a: 255, r: 170, g: 170, b: 170))
        descBlock.textWrapping = .wrap
        container.children.append(descBlock)

        let border = Border()
        border.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        border.padding = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = SolidColorBrush(Color(a: 255, r: 68, g: 68, b: 68))
        border.background = SolidColorBrush(Color(a: 255, r: 34, g: 34, b: 34))
        border.height = height

        let navView = NavigationView()
        navView.height = height
        navView.isTabStop = false
        navView.paneDisplayMode = paneDisplayMode
        navView.isSettingsVisible = false
        navView.header = "导航视图"
        navView.compactModeThresholdWidth = 720

        let contentPanel = Grid()
        let contentText = TextBlock()
        contentText.text = "选择一个菜单项以更新此区域。"
        contentText.fontSize = 14
        contentText.foreground = SolidColorBrush(Color(a: 255, r: 204, g: 204, b: 204))
        contentText.textWrapping = .wrap
        contentText.horizontalAlignment = .center
        contentText.verticalAlignment = .center
        contentPanel.children.append(contentText)
        navView.content = contentPanel
        storage = contentText

        let homeItem = NavigationViewItem()
        homeItem.content = "主页"
        homeItem.tag = "SamplePage1"
        homeItem.icon = makeGlyphIcon("\u{E80F}")

        let item2 = NavigationViewItem()
        item2.content = "菜单项 2"
        item2.tag = "SamplePage2"
        item2.icon = makeGlyphIcon("\u{E74E}")

        let item3 = NavigationViewItem()
        item3.content = "菜单项 3"
        item3.tag = "SamplePage3"
        item3.icon = makeGlyphIcon("\u{E72C}")

        navView.menuItems.append(homeItem)
        navView.menuItems.append(item2)
        navView.menuItems.append(item3)

        navView.selectionChanged.addHandler { [weak contentText] sender, args in
            guard let sender = sender, let args = args else { return }
            if args.isSettingsSelected {
                sender.header = "设置"
                contentText?.text = "此处将展示“设置”页面内容。"
                return
            }

            if let selected = args.selectedItem as? NavigationViewItem,
               let title = selected.content as? String {
                sender.header = title
                contentText?.text = "已加载 \(title)。使用 SelectionChanged 将内容导航到目标页面。"
            }
        }

        navView.selectedItem = homeItem
        contentText.text = "已加载 主页。使用 SelectionChanged 将内容导航到目标页面。"

        border.child = navView
        container.children.append(border)
        return container
    }

    private func createAutoSample() -> StackPanel {
        let container = StackPanel()
        container.spacing = 12

        let titleBlock = TextBlock()
        titleBlock.text = "NavigationView 会根据窗口宽度切换面板方向"
        titleBlock.fontSize = 18
        titleBlock.fontWeight = FontWeights.semiBold
        titleBlock.foreground = SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        container.children.append(titleBlock)

        let descBlock = TextBlock()
        descBlock.text = "Auto 模式会监控窗口宽度，并在顶部与左侧面板之间自动切换。调整窗口大小即可实时查看面板方向的变化。"
        descBlock.fontSize = 12
        descBlock.foreground = SolidColorBrush(Color(a: 255, r: 170, g: 170, b: 170))
        descBlock.textWrapping = .wrap
        container.children.append(descBlock)

        let border = Border()
        border.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = SolidColorBrush(Color(a: 255, r: 68, g: 68, b: 68))
        border.background = SolidColorBrush(Color(a: 255, r: 34, g: 34, b: 34))
        border.height = 320

        let navView = NavigationView()
        navView.paneDisplayMode = .auto
        navView.height = 320
        navView.header = "调整窗口大小"
        navView.isSettingsVisible = true
        navView.isTabStop = false
        navView.compactModeThresholdWidth = 720
        navView.expandedModeThresholdWidth = 1008

        let contentPanel = Grid()
        let text = TextBlock()
        text.text = "当前 PaneDisplayMode：Auto"
        text.fontSize = 14
        text.foreground = SolidColorBrush(Color(a: 255, r: 204, g: 204, b: 204))
        text.horizontalAlignment = .center
        text.verticalAlignment = .center
        text.textWrapping = .wrap
        contentPanel.children.append(text)
        navView.content = contentPanel
        autoSampleContent = text

        let minimalItem = NavigationViewItem()
        minimalItem.content = "最小模式"
        minimalItem.tag = "最小模式"
        minimalItem.icon = makeGlyphIcon("\u{E14C}")
        navView.menuItems.append(minimalItem)

        let compactItem = NavigationViewItem()
        compactItem.content = "紧凑模式"
        compactItem.tag = "紧凑模式"
        compactItem.icon = makeGlyphIcon("\u{E11A}")
        navView.menuItems.append(compactItem)

        navView.selectionChanged.addHandler { [weak self] sender, args in
            guard let sender = sender, let args = args else { return }
            if let selected = args.selectedItem as? NavigationViewItem,
               let tag = selected.tag as? String {
                sender.header = "面板模式：\(tag)"
                self?.autoSampleContent?.text = "当前 PaneDisplayMode：\(sender.paneDisplayMode)。已选择 \(tag)。"
            }
        }

        navView.displayModeChanged.addHandler { [weak self] sender, _ in
            guard let navView = sender else { return }
            self?.autoSampleContent?.text = "PaneDisplayMode 已切换为 \(navView.displayMode)。"
        }

        navView.selectedItem = minimalItem
        border.child = navView
        container.children.append(border)
        return container
    }

    private func createSourceCodeSection() -> Expander {
        let expander = Expander()
    expander.header = "源代码"
        expander.isExpanded = true
        expander.margin = Thickness(left: 0, top: 12, right: 0, bottom: 0)

        let stack = StackPanel()
        stack.spacing = 8
        stack.padding = Thickness(left: 0, top: 8, right: 0, bottom: 0)

        let tabStack = StackPanel()
        tabStack.orientation = .horizontal
        tabStack.spacing = 12

        let xamlBtn = Button()
        xamlBtn.content = "XAML"
        xamlBtn.padding = Thickness(left: 12, top: 6, right: 12, bottom: 6)
        xamlBtn.cornerRadius = CornerRadius(topLeft: 4, topRight: 4, bottomRight: 4, bottomLeft: 4)
        xamlBtn.click.addHandler { [weak self] _, _ in
            self?.selectCodeTab(.xaml)
        }
        tabStack.children.append(xamlBtn)
        xamlButton = xamlBtn

        let csharpBtn = Button()
        csharpBtn.content = "C#"
        csharpBtn.padding = Thickness(left: 12, top: 6, right: 12, bottom: 6)
        csharpBtn.cornerRadius = CornerRadius(topLeft: 4, topRight: 4, bottomRight: 4, bottomLeft: 4)
        csharpBtn.click.addHandler { [weak self] _, _ in
            self?.selectCodeTab(.csharp)
        }
        tabStack.children.append(csharpBtn)
        csharpButton = csharpBtn

        stack.children.append(tabStack)

        let codeBorder = Border()
        codeBorder.cornerRadius = CornerRadius(topLeft: 6, topRight: 6, bottomRight: 6, bottomLeft: 6)
        codeBorder.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        codeBorder.borderBrush = SolidColorBrush(Color(a: 255, r: 68, g: 68, b: 68))
        codeBorder.background = SolidColorBrush(Color(a: 255, r: 30, g: 30, b: 30))
        codeBorder.padding = Thickness(left: 12, top: 12, right: 12, bottom: 12)

        let codeText = TextBlock()
        codeText.fontFamily = FontFamily("Consolas")
        codeText.fontSize = 11
        codeText.textWrapping = .wrap
        codeText.foreground = SolidColorBrush(Color(a: 255, r: 212, g: 212, b: 212))
        codeBorder.child = codeText
        codeTextBlock = codeText

        stack.children.append(codeBorder)
        expander.content = stack
        return expander
    }

    private func createFeatureList() -> StackPanel {
        let container = StackPanel()
        container.spacing = 12

        let titleBlock = TextBlock()
    titleBlock.text = "关键特性"
        titleBlock.fontSize = 18
        titleBlock.fontWeight = FontWeights.semiBold
        titleBlock.foreground = SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        container.children.append(titleBlock)

        let border = Border()
        border.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = SolidColorBrush(Color(a: 255, r: 68, g: 68, b: 68))
        border.background = SolidColorBrush(Color(a: 255, r: 34, g: 34, b: 34))
        border.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)

        let listStack = StackPanel()
        listStack.spacing = 8

        let items = [
            "多种面板显示模式（Left、Top、LeftCompact、LeftMinimal）",
            "支持分层菜单结构",
            "内置页眉、页脚与自定义内容插槽",
            "支持 AutoSuggestBox 与搜索集成",
            "页脚菜单项与主菜单共享选择模型"
        ]

        for text in items {
            let row = StackPanel()
            row.orientation = .horizontal
            row.spacing = 8

            let bullet = TextBlock()
            bullet.text = "•"
            bullet.fontSize = 14
            bullet.foreground = SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
            row.children.append(bullet)

            let body = TextBlock()
            body.text = text
            body.fontSize = 12
            body.textWrapping = .wrap
            body.foreground = SolidColorBrush(Color(a: 255, r: 204, g: 204, b: 204))
            row.children.append(body)

            listStack.children.append(row)
        }

        border.child = listStack
        container.children.append(border)
        return container
    }
}
