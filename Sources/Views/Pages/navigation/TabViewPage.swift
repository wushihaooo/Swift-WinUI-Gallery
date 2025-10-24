import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

class TabViewPage: Grid {
    private var codeTextBlock: TextBlock?
    private var xamlButton: Button?
    private var csharpButton: Button?
    private var basicTabCounter = 3
    private weak var widthModeLabel: TextBlock?
    private weak var widthModeTabView: TabView?

    private enum CodeTab {
        case xaml
        case csharp
    }

    private let xamlSampleText = """
<TabView AddTabButtonClick="TabView_AddTabButtonClick"
        TabCloseRequested="TabView_TabCloseRequested">
    <TabView.TabItems>
        <TabViewItem Header="文档 0">
            <TextBlock Text="这是一个演示页签" />
        </TabViewItem>
        <TabViewItem Header="文档 1" />
        <TabViewItem Header="文档 2" />
    </TabView.TabItems>
</TabView>
"""

    private let csharpSampleText = """
var tabView = new TabView();
tabView.AddTabButtonClick += (sender, args) =>
{
    var tab = new TabViewItem { Header = $"文档 {sender.TabItems.Count}" };
    tab.Content = new TextBlock { Text = "动态创建的页签" };
    sender.TabItems.Add(tab);
};

tabView.TabCloseRequested += (sender, args) =>
{
    sender.TabItems.Remove(args.Tab);
};
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
        mainStack.children.append(createBasicTabViewSample())
        mainStack.children.append(createWidthModeSample())
        mainStack.children.append(createSourceCodeSection())
        mainStack.children.append(createFeatureList())

        let spacer = TextBlock()
        spacer.height = 24
        mainStack.children.append(spacer)

        selectCodeTab(.xaml)
    }

    private func createHeaderSection() -> StackPanel {
        let section = StackPanel()
        section.spacing = 12

        let title = TextBlock()
        title.text = "TabView 标签页"
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
        intro.text = "TabView 控件提供类似浏览器的页签体验，可在同一窗口中容纳多个文档或视图。它支持添加新标签、拖动重排、关闭按钮、自定义页签宽度以及键盘快捷键等特性。"
        intro.fontSize = 14
        intro.foreground = SolidColorBrush(Color(a: 255, r: 204, g: 204, b: 204))
        intro.textWrapping = .wrap
        return intro
    }

    private func createBasicTabViewSample() -> StackPanel {
        let container = StackPanel()
        container.spacing = 12

        let titleBlock = TextBlock()
        titleBlock.text = "支持添加与关闭的 TabView"
        titleBlock.fontSize = 18
        titleBlock.fontWeight = FontWeights.semiBold
        titleBlock.foreground = SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        container.children.append(titleBlock)

        let descBlock = TextBlock()
        descBlock.text = "通过 AddTabButtonClick 与 TabCloseRequested 事件，可以动态创建和移除页签，体验与 WinUI Gallery 一致。"
        descBlock.fontSize = 12
        descBlock.foreground = SolidColorBrush(Color(a: 255, r: 170, g: 170, b: 170))
        descBlock.textWrapping = .wrap
        container.children.append(descBlock)

        let border = Border()
        border.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = SolidColorBrush(Color(a: 255, r: 68, g: 68, b: 68))
        border.background = SolidColorBrush(Color(a: 255, r: 34, g: 34, b: 34))
        border.padding = Thickness(left: 12, top: 12, right: 12, bottom: 12)

        let tabView = TabView()
        tabView.tabWidthMode = .sizeToContent
        tabView.isAddTabButtonVisible = true
        tabView.canReorderTabs = true
        tabView.allowDrop = true
        tabView.minHeight = 320
        tabView.margin = Thickness(left: -12, top: -12, right: -12, bottom: -12)
        tabView.padding = Thickness(left: 12, top: 12, right: 12, bottom: 12)

        for index in 0..<3 {
            let tab = createDocumentTab(index: index)
            tabView.tabItems.append(tab)
        }
        tabView.selectedIndex = 0

        tabView.addTabButtonClick.addHandler { [weak self] sender, _ in
            guard let tabView = sender else { return }
            let nextIndex = self?.basicTabCounter ?? Int(tabView.tabItems.count)
            let newTab = self?.createDocumentTab(index: nextIndex) ?? TabViewItem()
            tabView.tabItems.append(newTab)
            tabView.selectedItem = newTab
            self?.basicTabCounter = nextIndex + 1
        }

        tabView.tabCloseRequested.addHandler { sender, args in
            guard let tabView = sender, let closeArgs = args, let tab = closeArgs.tab else { return }
            // Remove tab from tabItems by finding its index
            guard let items = tabView.tabItems else { return }
            var indexToRemove: UInt32?
            for i in 0..<items.size {
                if let item = items.getAt(i) as? TabViewItem, item === tab {
                    indexToRemove = i
                    break
                }
            }
            if let index = indexToRemove {
                items.removeAt(index)
            }
        }

        border.child = tabView
        container.children.append(border)
        return container
    }

    private func createWidthModeSample() -> StackPanel {
        let container = StackPanel()
        container.spacing = 12

        let titleBlock = TextBlock()
        titleBlock.text = "TabView 页签宽度模式"
        titleBlock.fontSize = 18
        titleBlock.fontWeight = FontWeights.semiBold
        titleBlock.foreground = SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        container.children.append(titleBlock)

        let descBlock = TextBlock()
        descBlock.text = "通过 TabWidthMode 属性可以在等宽、按内容和紧凑模式之间切换，满足不同布局需求。"
        descBlock.fontSize = 12
        descBlock.foreground = SolidColorBrush(Color(a: 255, r: 170, g: 170, b: 170))
        descBlock.textWrapping = .wrap
        container.children.append(descBlock)

        let border = Border()
        border.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = SolidColorBrush(Color(a: 255, r: 68, g: 68, b: 68))
        border.background = SolidColorBrush(Color(a: 255, r: 34, g: 34, b: 34))
        border.padding = Thickness(left: 12, top: 12, right: 12, bottom: 12)

        let tabView = TabView()
        tabView.isAddTabButtonVisible = false
        tabView.tabWidthMode = .sizeToContent
        tabView.minHeight = 260
        tabView.margin = Thickness(left: -12, top: -12, right: -12, bottom: -12)
        tabView.padding = Thickness(left: 12, top: 12, right: 12, bottom: 12)

        let tabTitles = ["主页", "带有较长标题的标签", "第三个标签"]
        for (index, title) in tabTitles.enumerated() {
            let tab = TabViewItem()
            tab.header = title
            tab.isClosable = false

            let icon = FontIconSource()
            icon.glyph = index == 0 ? "\u{E10F}" : (index == 1 ? "\u{E189}" : "\u{E7C3}")
            tab.iconSource = icon

            let content = TextBlock()
            content.text = "当前展示：\(title)"
            content.fontSize = 14
            content.foreground = SolidColorBrush(Color(a: 255, r: 204, g: 204, b: 204))
            content.verticalAlignment = .center
            content.horizontalAlignment = .center

            tab.content = content
            tabView.tabItems.append(tab)
        }

        tabView.selectedIndex = 0
        border.child = tabView
        container.children.append(border)

        widthModeTabView = tabView

        let optionsStack = StackPanel()
        optionsStack.orientation = .horizontal
        optionsStack.spacing = 12

        let label = TextBlock()
        label.text = "选择宽度模式："
        label.fontSize = 12
        label.foreground = SolidColorBrush(Color(a: 255, r: 204, g: 204, b: 204))
        optionsStack.children.append(label)

        let comboBox = ComboBox()
        comboBox.width = 180

        let modeOptions: [(String, String)] = [
            ("按内容", "SizeToContent"),
            ("等宽", "Equal"),
            ("紧凑", "Compact")
        ]

        for option in modeOptions {
            let item = WinUI.ComboBoxItem()
            item.content = option.0
            item.tag = option.1
            comboBox.items.append(item)
        }
        comboBox.selectedIndex = 0

        comboBox.selectionChanged.addHandler { [weak self] sender, _ in
            guard let combo = sender as? WinUI.ComboBox,
                  let tabView = self?.widthModeTabView,
                  let selected = combo.selectedItem as? WinUI.ComboBoxItem,
                  let tag = selected.tag as? String else { return }

            switch tag {
            case "Equal":
                tabView.tabWidthMode = .equal
                self?.widthModeLabel?.text = "当前宽度模式：等宽"
            case "Compact":
                tabView.tabWidthMode = .compact
                self?.widthModeLabel?.text = "当前宽度模式：紧凑"
            default:
                tabView.tabWidthMode = .sizeToContent
                self?.widthModeLabel?.text = "当前宽度模式：按内容"
            }
        }

        optionsStack.children.append(comboBox)

        container.children.append(optionsStack)

        let status = TextBlock()
        status.text = "当前宽度模式：按内容"
        status.fontSize = 12
        status.foreground = SolidColorBrush(Color(a: 255, r: 170, g: 170, b: 170))
        container.children.append(status)
        widthModeLabel = status

        return container
    }

    private func createDocumentTab(index: Int) -> TabViewItem {
        let tab = TabViewItem()
        tab.header = "文档 \(index)"

        let iconSource = FontIconSource()
        iconSource.glyph = "\u{E160}"
        tab.iconSource = iconSource

        let stack = StackPanel()
        stack.spacing = 8

        let title = TextBlock()
        title.text = "文档 \(index)"
        title.fontSize = 16
        title.fontWeight = FontWeights.semiBold
        title.foreground = SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        stack.children.append(title)

        let hint = TextBlock()
        hint.text = "这是动态添加的页签内容，可用于加载 Page 或 Frame。"
        hint.fontSize = 13
        hint.foreground = SolidColorBrush(Color(a: 255, r: 204, g: 204, b: 204))
        hint.textWrapping = .wrap
        stack.children.append(hint)

        tab.content = stack
        return tab
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
            "支持添加、关闭与拖动重排页签",
            "可自定义页签图标、内容与上下文菜单",
            "TabWidthMode 控制页签宽度策略",
            "CloseButtonOverlayMode 控制关闭按钮的显示时机",
            "可结合 ItemsSource 进行数据驱动的标签生成"
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
}
