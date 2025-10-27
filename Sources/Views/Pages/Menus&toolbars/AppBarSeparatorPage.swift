import WinUI
import UWP

class AppBarSeparatorPage: Grid {
    // MARK: - 颜色常量定义
    private let demoBackgroundColor = UWP.Color(a: 255, r: 30, g: 30, b: 30)
    private let borderColor = UWP.Color(a: 255, r: 60, g: 60, b: 60)
    private let textColor = UWP.Color(a: 255, r: 200, g: 200, b: 200)
    private let translucentBgColor = UWP.Color(a: 80, r: 50, g: 50, b: 50)
    private let overlayBgColor = UWP.Color(a: 255, r: 50, g: 50, b: 50)
    
    // MARK: - 控件属性
    private var sourceCodePanel: StackPanel!
    private var arrowTextBlock: TextBlock!
    private var isCodeExpanded: Bool = false
    private var compactButtonPanel: StackPanel!  // 紧凑按钮栏
    private var expandedButtonPanel: Border!     // 展开的按钮栏（带标签）
    private var isExpanded: Bool = false
    
    // MARK: - 初始化
    override init() {
        super.init()
        setupView()
    }
    
    private func setupView() {
        // 滚动容器
        let scrollViewer = ScrollViewer()
        scrollViewer.verticalScrollBarVisibility = .auto
        
        // 主容器
        let mainPanel = StackPanel()
        mainPanel.padding = Thickness(left: 32.0, top: 24.0, right: 32.0, bottom: 24.0)
        mainPanel.spacing = 16.0
        
        // 添加各个部分
        mainPanel.children.append(createHeader())
        mainPanel.children.append(createDescription())
        mainPanel.children.append(createExampleSection())
        
        scrollViewer.content = mainPanel
        self.children.append(scrollViewer)
    }
    
    // MARK: - 创建页眉
    private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 12.0
        
        // 标题
        let titleText = TextBlock()
        titleText.text = "AppBarSeparator"
        titleText.fontSize = 32.0
        titleText.fontWeight = FontWeights.bold
        headerPanel.children.append(titleText)
        
        // 功能按钮栏
        let buttonPanel = StackPanel()
        buttonPanel.orientation = .horizontal
        buttonPanel.spacing = 12.0
        
        // Documentation 按钮
        let docButton = createDocumentationButton()
        buttonPanel.children.append(docButton)
        
        // Source 按钮
        let sourceButton = createSourceButton()
        buttonPanel.children.append(sourceButton)
        
        headerPanel.children.append(buttonPanel)
        return headerPanel
    }
    
    // MARK: - 创建 Documentation 按钮
    private func createDocumentationButton() -> Button {
        let button = Button()
        button.padding = Thickness(left: 12.0, top: 8.0, right: 12.0, bottom: 8.0)
        
        let content = StackPanel()
        content.orientation = .horizontal
        content.spacing = 8.0
        
        let icon = TextBlock()
        icon.text = "📚"
        icon.fontSize = 14.0
        content.children.append(icon)
        
        let label = TextBlock()
        label.text = "Documentation"
        label.fontSize = 14.0
        content.children.append(label)
        
        let arrow = TextBlock()
        arrow.text = "▼"
        arrow.fontSize = 10.0
        content.children.append(arrow)
        
        button.content = content
        
        let flyout = MenuFlyout()
        let item1 = MenuFlyoutItem()
        item1.text = "AppBarSeparator API"
        flyout.items.append(item1)
        
        let item2 = MenuFlyoutItem()
        item2.text = "Guidelines"
        flyout.items.append(item2)
        
        button.flyout = flyout
        return button
    }
    
    // MARK: - 创建 Source 按钮
    private func createSourceButton() -> Button {
        let button = Button()
        button.padding = Thickness(left: 12.0, top: 8.0, right: 12.0, bottom: 8.0)
        
        let content = StackPanel()
        content.orientation = .horizontal
        content.spacing = 8.0
        
        let icon = TextBlock()
        icon.text = "🐙"
        icon.fontSize = 14.0
        content.children.append(icon)
        
        let label = TextBlock()
        label.text = "Source"
        label.fontSize = 14.0
        content.children.append(label)
        
        let arrow = TextBlock()
        arrow.text = "▼"
        arrow.fontSize = 10.0
        content.children.append(arrow)
        
        button.content = content
        
        let flyout = MenuFlyout()
        let item1 = MenuFlyoutItem()
        item1.text = "Control source code"
        flyout.items.append(item1)
        
        let separator = MenuFlyoutSeparator()
        flyout.items.append(separator)
        
        let item2 = MenuFlyoutItem()
        item2.text = "Sample page source code"
        flyout.items.append(item2)
        
        button.flyout = flyout
        return button
    }
    
    // MARK: - 创建描述文本
    private func createDescription() -> TextBlock {
        let descText = TextBlock()
        descText.text = "An AppBarSeparator creates a vertical line to visually separate groups of commands in an app bar. It has a compact state with reduced padding to match the compact state of the AppBarButton and AppBarToggleButton controls."
        descText.textWrapping = .wrap
        descText.fontSize = 14.0
        descText.foreground = SolidColorBrush(textColor)
        return descText
    }
    
    // MARK: - 创建示例区域整体布局
    private func createExampleSection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 0.0
        panel.margin = Thickness(left: 0.0, top: 24.0, right: 0.0, bottom: 0.0)
        
        // 示例标题
        let exampleTitle = TextBlock()
        exampleTitle.text = "AppBarButtons separated by AppBarSeparators."
        exampleTitle.fontSize = 18.0
        exampleTitle.fontWeight = FontWeights.semiBold
        panel.children.append(exampleTitle)
        
        // 演示区域
        let demoContainer = createDemoArea()
        panel.children.append(demoContainer)
        
        // Source Code 区域
        let sourceCodeContainer = createSourceCodeContainer()
        panel.children.append(sourceCodeContainer)
        
        return panel
    }
    
    // MARK: - 演示区域
    private func createDemoArea() -> Border {
        let border = Border()
        border.borderThickness = Thickness(left: 1.0, top: 1.0, right: 1.0, bottom: 1.0)
        border.borderBrush = SolidColorBrush(borderColor)
        border.background = SolidColorBrush(demoBackgroundColor)
        border.cornerRadius = CornerRadius(topLeft: 4.0, topRight: 4.0, bottomRight: 0.0, bottomLeft: 0.0)
        border.padding = Thickness(left: 16.0, top: 16.0, right: 16.0, bottom: 16.0)
        border.minHeight = 120.0
        
        // 使用 Grid 来实现覆盖效果
        let containerGrid = Grid()
        
        // 紧凑按钮栏（默认显示）
        compactButtonPanel = createCompactButtonPanel()
        compactButtonPanel.horizontalAlignment = .center
        compactButtonPanel.verticalAlignment = .center
        containerGrid.children.append(compactButtonPanel)
        
        // 展开的按钮栏（覆盖显示）
        expandedButtonPanel = createExpandedButtonPanel()
        expandedButtonPanel.visibility = .collapsed
        expandedButtonPanel.horizontalAlignment = .center
        expandedButtonPanel.verticalAlignment = .center
        containerGrid.children.append(expandedButtonPanel)
        
        border.child = containerGrid
        return border
    }
    
    // MARK: - 创建紧凑按钮栏（只显示图标）
    private func createCompactButtonPanel() -> StackPanel {
        let panel = StackPanel()
        panel.orientation = .horizontal
        panel.spacing = 0.0
        
        // 第一组按钮
        panel.children.append(createCompactButton("📷"))
        panel.children.append(createCompactButton("👍"))
        
        // 第一个分隔符
        panel.children.append(createSeparator())
        
        // 第二组按钮
        panel.children.append(createCompactButton("👎"))
        panel.children.append(createCompactButton("🔄"))
        
        // 第二个分隔符
        panel.children.append(createSeparator())
        
        // More 按钮
        let moreButton = createCompactButton("⋯")
        moreButton.click.addHandler { [weak self] _, _ in
            self?.toggleExpanded()
        }
        panel.children.append(moreButton)
        
        return panel
    }
    
    // MARK: - 创建展开的按钮栏（显示图标和标签）
    private func createExpandedButtonPanel() -> Border {
        let border = Border()
        border.background = SolidColorBrush(overlayBgColor)
        border.cornerRadius = CornerRadius(topLeft: 8.0, topRight: 8.0, bottomRight: 8.0, bottomLeft: 8.0)
        border.padding = Thickness(left: 16.0, top: 16.0, right: 16.0, bottom: 16.0)
        border.borderThickness = Thickness(left: 1.0, top: 1.0, right: 1.0, bottom: 1.0)
        border.borderBrush = SolidColorBrush(borderColor)
        
        let panel = StackPanel()
        panel.orientation = .horizontal
        panel.spacing = 0.0
        
        // 第一组按钮（带标签）
        panel.children.append(createLabeledButton("📷", "Attach\nCamera"))
        panel.children.append(createLabeledButton("👍", "Like"))
        
        // 第一个分隔符
        panel.children.append(createSeparator())
        
        // 第二组按钮（带标签）
        panel.children.append(createLabeledButton("👎", "Dislike"))
        panel.children.append(createLabeledButton("🔄", "Orientati\non"))
        
        // 第二个分隔符
        panel.children.append(createSeparator())
        
        // More 按钮（可点击关闭）
        let moreButtonPanel = createLabeledButton("⋯", "")
        // 添加点击事件到整个面板来关闭
        border.tapped.addHandler { [weak self] _, _ in
            self?.toggleExpanded()
        }
        panel.children.append(moreButtonPanel)
        
        border.child = panel
        return border
    }
    
    // MARK: - 切换展开/收起状态
    private func toggleExpanded() {
        isExpanded.toggle()
        
        if isExpanded {
            compactButtonPanel.visibility = .collapsed
            expandedButtonPanel.visibility = .visible
        } else {
            compactButtonPanel.visibility = .visible
            expandedButtonPanel.visibility = .collapsed
        }
    }
    
    // MARK: - 创建紧凑型按钮（只显示图标）
    private func createCompactButton(_ icon: String) -> Button {
        let button = Button()
        button.content = icon
        button.fontSize = 24.0
        button.width = 48.0
        button.height = 48.0
        button.margin = Thickness(left: 8.0, top: 0.0, right: 8.0, bottom: 0.0)
        button.background = nil
        button.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        
        return button
    }
    
    // MARK: - 创建带标签的按钮
    private func createLabeledButton(_ icon: String, _ label: String) -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 4.0
        panel.margin = Thickness(left: 12.0, top: 0.0, right: 12.0, bottom: 0.0)
        panel.minWidth = 70.0
        
        let iconText = TextBlock()
        iconText.text = icon
        iconText.fontSize = 24.0
        iconText.horizontalAlignment = .center
        iconText.foreground = SolidColorBrush(UWP.Color(a: 255, r: 255, g: 255, b: 255))
        panel.children.append(iconText)
        
        if !label.isEmpty {
            let labelText = TextBlock()
            labelText.text = label
            labelText.fontSize = 12.0
            labelText.horizontalAlignment = .center
            labelText.textAlignment = .center
            labelText.foreground = SolidColorBrush(UWP.Color(a: 255, r: 255, g: 255, b: 255))
            labelText.margin = Thickness(left: 0, top: 4.0, right: 0, bottom: 0)
            panel.children.append(labelText)
        }
        
        return panel
    }
    
    // MARK: - 创建分隔符
    private func createSeparator() -> Border {
        let separator = Border()
        separator.width = 1.0
        separator.height = 48.0
        separator.background = SolidColorBrush(borderColor)
        separator.margin = Thickness(left: 12.0, top: 0.0, right: 12.0, bottom: 0.0)
        return separator
    }
    
    // MARK: - Source Code 区域
    private func createSourceCodeContainer() -> Border {
        let border = Border()
        border.borderThickness = Thickness(left: 1.0, top: 0.0, right: 1.0, bottom: 1.0)
        border.borderBrush = SolidColorBrush(borderColor)
        border.background = SolidColorBrush(demoBackgroundColor)
        border.cornerRadius = CornerRadius(topLeft: 0.0, topRight: 0.0, bottomRight: 4.0, bottomLeft: 4.0)
        
        let panel = StackPanel()
        panel.spacing = 0.0
        
        // 标题栏
        let titleButton = Button()
        titleButton.horizontalAlignment = .stretch
        titleButton.height = 40.0
        titleButton.padding = Thickness(left: 12.0, top: 0.0, right: 12.0, bottom: 0.0)
        titleButton.background = SolidColorBrush(translucentBgColor)
        titleButton.borderThickness = Thickness(left: 0.0, top: 0.0, right: 0.0, bottom: 0.0)
        
        let titleGrid = Grid()
        let textCol = ColumnDefinition()
        textCol.width = GridLength(value: 1.0, gridUnitType: .star)
        titleGrid.columnDefinitions.append(textCol)
        
        let arrowCol = ColumnDefinition()
        arrowCol.width = GridLength(value: 30.0, gridUnitType: .pixel)
        titleGrid.columnDefinitions.append(arrowCol)
        
        let titleText = TextBlock()
        titleText.text = "Source code"
        titleText.fontSize = 14.0
        titleText.foreground = SolidColorBrush(textColor)
        titleText.verticalAlignment = .center
        try? Grid.setColumn(titleText, 0)
        titleGrid.children.append(titleText)
        
        arrowTextBlock = TextBlock()
        arrowTextBlock.text = "▼"
        arrowTextBlock.fontSize = 12.0
        arrowTextBlock.foreground = SolidColorBrush(textColor)
        arrowTextBlock.verticalAlignment = .center
        arrowTextBlock.horizontalAlignment = .right
        try? Grid.setColumn(arrowTextBlock, 1)
        titleGrid.children.append(arrowTextBlock)
        
        titleButton.content = titleGrid
        titleButton.click.addHandler { [weak self] _, _ in
            self?.toggleSourceCode()
        }
        panel.children.append(titleButton)
        
        // 代码内容区域
        sourceCodePanel = StackPanel()
        sourceCodePanel.visibility = .collapsed
        sourceCodePanel.padding = Thickness(left: 16.0, top: 16.0, right: 16.0, bottom: 16.0)
        sourceCodePanel.spacing = 6.0
        sourceCodePanel.borderThickness = Thickness(left: 0.0, top: 1.0, right: 0.0, bottom: 0.0)
        sourceCodePanel.borderBrush = SolidColorBrush(borderColor)
        
        let swiftCodeLines = [
            "// Swift WinUI 代码示例 - 实现按钮栏展开/收起",
            "",
            "// 使用 Grid 叠加两个面板",
            "let containerGrid = Grid()",
            "",
            "// 紧凑按钮栏（默认显示）",
            "let compactPanel = StackPanel()",
            "compactPanel.orientation = .horizontal",
            "compactPanel.children.append(createCompactButton(\"📷\"))",
            "compactPanel.children.append(createCompactButton(\"👍\"))",
            "containerGrid.children.append(compactPanel)",
            "",
            "// 展开按钮栏（覆盖显示）",
            "let expandedPanel = Border()",
            "expandedPanel.visibility = .collapsed",
            "expandedPanel.children.append(createLabeledButton(\"📷\", \"Attach Camera\"))",
            "containerGrid.children.append(expandedPanel)",
            "",
            "// 点击 More 按钮切换显示",
            "moreButton.click.addHandler { _, _ in",
            "    compactPanel.visibility = .collapsed",
            "    expandedPanel.visibility = .visible",
            "}"
        ]
        
        for codeLine in swiftCodeLines {
            let codeTextBlock = TextBlock()
            codeTextBlock.text = codeLine
            codeTextBlock.fontSize = 11.0
            codeTextBlock.fontFamily = FontFamily("Consolas")
            codeTextBlock.foreground = SolidColorBrush(textColor)
            sourceCodePanel.children.append(codeTextBlock)
        }
        
        panel.children.append(sourceCodePanel)
        border.child = panel
        return border
    }
    
    // MARK: - 切换源码区域展开/收起
    private func toggleSourceCode() {
        isCodeExpanded.toggle()
        sourceCodePanel.visibility = isCodeExpanded ? .visible : .collapsed
        arrowTextBlock.text = isCodeExpanded ? "▲" : "▼"
    }
}