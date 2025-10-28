import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

class SelectorBarPage: Grid {
    private var codeTextBlock: TextBlock?
    private var xamlButton: Button?
    private var csharpButton: Button?
    private var previousSelectedIndex = 0
    private var contentFrame: Frame?
    private var colorContentPanel: StackPanel?

    private var pinkColorCollection: [SolidColorBrush] = []
    private var plumColorCollection: [SolidColorBrush] = []
    private var powderBlueColorCollection: [SolidColorBrush] = []

    private enum CodeTab {
        case xaml
        case csharp
    }

    private let xamlSampleText = """
<SelectorBar x:Name="SelectorBar1">
    <SelectorBarItem Text="最近 (Recent)" Icon="Clock" />
    <SelectorBarItem Text="共享 (Shared)" Icon="Share" />
    <SelectorBarItem Text="收藏 (Favorites)" Icon="Favorite" />
</SelectorBar>
"""

    private let csharpSampleText = """
// Example 2: SelectorBar with Selection Handling
private void SelectorBar2_SelectionChanged(SelectorBar sender, 
    SelectorBarSelectionChangedEventArgs args)
{
    SelectorBarItem selectedItem = sender.SelectedItem;
    int currentSelectedIndex = sender.Items.IndexOf(selectedItem);
    
    switch (currentSelectedIndex)
    {
        case 0: pageType = typeof(SamplePage1); break;
        case 1: pageType = typeof(SamplePage2); break;
        case 2: pageType = typeof(SamplePage3); break;
    }
}

// Example 3: Display Collection Based on Selection
private void SelectorBar3_SelectionChanged(SelectorBar sender, 
    SelectorBarSelectionChangedEventArgs args)
{
    if (sender.SelectedItem == SelectorBarItemPink)
        ItemsView3.ItemsSource = PinkColorCollection;
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
        mainStack.children.append(createBasicSelectorBarExample())
        mainStack.children.append(createFrameTransitionExample())
        mainStack.children.append(createItemsViewExample())
        mainStack.children.append(createSourceCodeSection())

        let spacer = TextBlock()
        spacer.height = 24
        mainStack.children.append(spacer)

        selectCodeTab(.xaml)
        populateColorCollections()
    }

    private func createHeaderSection() -> TextBlock {
        let title = TextBlock()
        title.text = "SelectorBar 选择器栏"
        title.fontSize = 32
        title.fontWeight = FontWeights.semiBold
        title.foreground = SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        title.margin = Thickness(left: 0, top: 0, right: 0, bottom: 12)
        return title
    }

    // MARK: - Example 1: Basic SelectorBar
    private func createBasicSelectorBarExample() -> StackPanel {
        let container = StackPanel()
        container.spacing = 12

        let titleBlock = TextBlock()
        titleBlock.text = "示例 1：基础 SelectorBar"
        titleBlock.fontSize = 18
        titleBlock.fontWeight = FontWeights.semiBold
        titleBlock.foreground = SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        container.children.append(titleBlock)

        let border = Border()
        border.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = SolidColorBrush(Color(a: 255, r: 68, g: 68, b: 68))
        border.background = SolidColorBrush(Color(a: 255, r: 34, g: 34, b: 34))
        border.padding = Thickness(left: 12, top: 12, right: 12, bottom: 12)

        let selectorBar = SelectorBar()

        let items = ["最近 (Recent)", "共享 (Shared)", "收藏 (Favorites)"]
        for text in items {
            let item = SelectorBarItem()
            item.text = text
            selectorBar.items.append(item)
        }

        // 示例1仅展示，不做内容切换，无需事件处理

        border.child = selectorBar
        container.children.append(border)

        return container
    }

    // MARK: - Example 2: SelectorBar with Frame Transitions
    private func createFrameTransitionExample() -> StackPanel {
        let container = StackPanel()
        container.spacing = 12

        let titleBlock = TextBlock()
        titleBlock.text = "示例 2：带页面切换的 SelectorBar"
        titleBlock.fontSize = 18
        titleBlock.fontWeight = FontWeights.semiBold
        titleBlock.foreground = SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        container.children.append(titleBlock)

        let border = Border()
        border.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = SolidColorBrush(Color(a: 255, r: 68, g: 68, b: 68))
        border.background = SolidColorBrush(Color(a: 255, r: 34, g: 34, b: 34))
        border.padding = Thickness(left: 12, top: 12, right: 12, bottom: 12)

        let stack = StackPanel()
        stack.spacing = 12

        let selectorBar = SelectorBar()

        let pageTexts = ["第1页", "第2页", "第3页", "第4页", "第5页"]
        for text in pageTexts {
            let item = SelectorBarItem()
            item.text = text
            selectorBar.items.append(item)
        }

        let pageContent = TextBlock()
        pageContent.text = "页面 1 内容 - 这是通过 SelectorBar 切换的页面"
        pageContent.fontSize = 14
        pageContent.foreground = SolidColorBrush(Color(a: 255, r: 204, g: 204, b: 204))
        pageContent.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        pageContent.textWrapping = .wrap

        stack.children.append(selectorBar)
        stack.children.append(pageContent)
        border.child = stack
        container.children.append(border)

        // 默认选中第一个
        if selectorBar.items.size > 0 {
            selectorBar.selectedItem = selectorBar.items.getAt(0)
        }

        selectorBar.selectionChanged.addHandler { sender, _ in
            guard let senderBar = sender, let selectedItem = senderBar.selectedItem else {
                print("[SelectorBar] selectionChanged: senderBar或selectedItem为nil")
                return
            }
            var currentSelectedIndex = -1
            for i in 0..<senderBar.items.size {
                if let item = senderBar.items.getAt(i), item.text == selectedItem.text {
                    currentSelectedIndex = Int(i)
                    break
                }
            }
            print("[SelectorBar] selectionChanged: 当前索引=\(currentSelectedIndex)")
            if currentSelectedIndex >= 0 {
                let pageNumber = currentSelectedIndex + 1
                pageContent.text = "页面 \(pageNumber) 内容 - 这是通过 SelectorBar 切换的页面"
                print("[SelectorBar] 切换到页面 \(pageNumber)")
            }
        }

        return container
    }

    // MARK: - Example 3: SelectorBar with ItemsView
    private func createItemsViewExample() -> StackPanel {
        let container = StackPanel()
        container.spacing = 12

        let titleBlock = TextBlock()
        titleBlock.text = "示例 3：使用 StackPanel 显示不同集合的 SelectorBar"
        titleBlock.fontSize = 18
        titleBlock.fontWeight = FontWeights.semiBold
        titleBlock.foreground = SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        container.children.append(titleBlock)

        let border = Border()
        border.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = SolidColorBrush(Color(a: 255, r: 68, g: 68, b: 68))
        border.background = SolidColorBrush(Color(a: 255, r: 34, g: 34, b: 34))
        border.padding = Thickness(left: 12, top: 12, right: 12, bottom: 12)

        let stack = StackPanel()
        stack.spacing = 12

        let selectorBar = SelectorBar()

        let colorTexts = ["粉红色 (Pink)", "梅紫色 (Plum)", "淡蓝色 (PowderBlue)"]
        for text in colorTexts {
            let item = SelectorBarItem()
            item.text = text
            selectorBar.items.append(item)
        }

        let colorPanel = StackPanel()
        colorPanel.orientation = .horizontal
        colorPanel.spacing = 8
        colorPanel.padding = Thickness(left: 8, top: 8, right: 8, bottom: 8)
        colorPanel.minHeight = 150
        colorContentPanel = colorPanel
        stack.children.append(selectorBar)
        stack.children.append(colorPanel)
        border.child = stack
        container.children.append(border)

        func updateColorPanel(_ brushes: [SolidColorBrush]) {
            while colorPanel.children.size > 0 {
                colorPanel.children.removeAt(0)
            }
            for brush in brushes {
                let box = Border()
                box.width = 60
                box.height = 60
                box.background = brush
                box.cornerRadius = CornerRadius(topLeft: 4, topRight: 4, bottomRight: 4, bottomLeft: 4)
                colorPanel.children.append(box)
            }
        }
        // 初始化颜色集合
        if pinkColorCollection.isEmpty || plumColorCollection.isEmpty || powderBlueColorCollection.isEmpty {
            populateColorCollections()
        }
        // 默认选中第一个并显示
        if selectorBar.items.size > 0 {
            selectorBar.selectedItem = selectorBar.items.getAt(0)
            updateColorPanel(pinkColorCollection)
        }

        selectorBar.selectionChanged.addHandler { sender, _ in
            guard let senderBar = sender, let selectedItem = senderBar.selectedItem else {
                print("[SelectorBar] selectionChanged: senderBar或selectedItem为nil")
                return
            }
            var selectedIndex = -1
            for i in 0..<senderBar.items.size {
                if let item = senderBar.items.getAt(i), item.text == selectedItem.text {
                    selectedIndex = Int(i)
                    break
                }
            }
            print("[SelectorBar] selectionChanged: 当前索引=\(selectedIndex)")
            switch selectedIndex {
            case 0:
                updateColorPanel(self.pinkColorCollection)
                print("[SelectorBar] 切换到粉红色集合")
            case 1:
                updateColorPanel(self.plumColorCollection)
                print("[SelectorBar] 切换到梅紫色集合")
            case 2:
                updateColorPanel(self.powderBlueColorCollection)
                print("[SelectorBar] 切换到淡蓝色集合")
            default:
                print("[SelectorBar] 未知集合")
                break
            }
        }
        return container
    }

    private func createSourceCodeSection() -> Expander {
        let expander = Expander()
        expander.header = "源代码"
        expander.isExpanded = false
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
        codeText.fontSize = 10
        codeText.textWrapping = .wrap
        codeText.foreground = SolidColorBrush(Color(a: 255, r: 212, g: 212, b: 212))
        codeBorder.child = codeText
        codeTextBlock = codeText

        stack.children.append(codeBorder)
        expander.content = stack
        return expander
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

    private func populateColorCollections() {
        // Pink colors
        let pinkBrush = SolidColorBrush(Color(a: 255, r: 255, g: 192, b: 203))
        for _ in 0..<5 {
            pinkColorCollection.append(pinkBrush)
        }

        // Plum colors
        let plumBrush = SolidColorBrush(Color(a: 255, r: 221, g: 160, b: 221))
        for _ in 0..<7 {
            plumColorCollection.append(plumBrush)
        }

        // PowderBlue colors
        let powderBlueBrush = SolidColorBrush(Color(a: 255, r: 176, g: 224, b: 230))
        for _ in 0..<4 {
            powderBlueColorCollection.append(powderBlueBrush)
        }
    }
}
