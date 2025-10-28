import WinUI
import UWP

class AppBarButtonPage: Grid {
    // MARK: - 颜色常量定义
    private let demoBackgroundColor = UWP.Color(a: 255, r: 30, g: 30, b: 30)      // 演示区域背景色
    private let borderColor = UWP.Color(a: 255, r: 60, g: 60, b: 60)            // 边框颜色
    private let textColor = UWP.Color(a: 255, r: 200, g: 200, b: 200)           // 普通文本/代码颜色（统一，去掉高亮）
    private let translucentBgColor = UWP.Color(a: 80, r: 50, g: 50, b: 50)      // 标题栏半透明背景（alpha=80，不透明度~30%）
    
    // MARK: - 控件属性
    private var clickMessageTextBlock: TextBlock!
    private var sourceCodePanel: StackPanel!
    private var arrowTextBlock: TextBlock!
    private var isCodeExpanded: Bool = false
    
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
        
        // 标题
        let titleTextBlock = TextBlock()
        titleTextBlock.text = "AppBarButton"
        titleTextBlock.fontSize = 32.0
        mainPanel.children.append(titleTextBlock)
        
        // 功能按钮栏
        let buttonPanel = StackPanel()
        buttonPanel.orientation = .horizontal
        buttonPanel.spacing = 12.0
        
        // Documentation 按钮
        let docButton = Button()
        docButton.content = "📚 Documentation"
        docButton.padding = Thickness(left: 12.0, top: 8.0, right: 12.0, bottom: 8.0)
        docButton.click.addHandler { _, _ in
            print("Documentation clicked")
        }
        buttonPanel.children.append(docButton)
        
        // Source 按钮
        let sourceButton = Button()
        sourceButton.content = "🐙 Source"
        sourceButton.padding = Thickness(left: 12.0, top: 8.0, right: 12.0, bottom: 8.0)
        sourceButton.click.addHandler { _, _ in
            print("Source clicked")
        }
        buttonPanel.children.append(sourceButton)
        
        mainPanel.children.append(buttonPanel)
        
        // 说明文本
        let descriptionPanel = StackPanel()
        descriptionPanel.spacing = 8.0
        
        let descLines = [
            "AppBarButton differs from standard buttons in several ways:",
            "- Their default appearance is a transparent background with a smaller size.",
            "- You use the Label and Icon properties to set the content instead of the Content property. The Content property is ignored.",
            "- The button's IsCompact property controls its size."
        ]
        
        for line in descLines {
            let textBlock = TextBlock()
            textBlock.text = line
            textBlock.textWrapping = .wrap
            textBlock.fontSize = 14.0
            descriptionPanel.children.append(textBlock)
        }
        
        mainPanel.children.append(descriptionPanel)
        
        // 示例部分（演示+源码）
        mainPanel.children.append(createExampleSection())
        
        scrollViewer.content = mainPanel
        self.children.append(scrollViewer)
    }
    
    // MARK: - 示例区域整体布局（演示区+源码区）
    private func createExampleSection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 0.0  // 消除区域间间隙，确保演示区和源码区粘连
        panel.margin = Thickness(left: 0.0, top: 24.0, right: 0.0, bottom: 0.0)
        
        // 示例标题
        let exampleTitle = TextBlock()
        exampleTitle.text = "An AppBarButton with a symbol icon."
        exampleTitle.fontSize = 18.0
        panel.children.append(exampleTitle)
        
        // 演示区域（用普通Button模拟AppBarButton视觉效果）
        let demoContainer = createDemoArea()
        panel.children.append(demoContainer)
        
        // Source Code 区域（核心：Swift定义AppBarButton+半透明+整行点击）
        let sourceCodeContainer = createSourceCodeContainer()
        panel.children.append(sourceCodeContainer)
        
        return panel
    }
    
    // MARK: - 演示区域（模拟AppBarButton视觉效果）
    private func createDemoArea() -> Border {
        let border = Border()
        border.borderThickness = Thickness(left: 1.0, top: 1.0, right: 1.0, bottom: 1.0)
        border.borderBrush = SolidColorBrush(borderColor)
        border.background = SolidColorBrush(demoBackgroundColor)
        border.cornerRadius = CornerRadius(topLeft: 4.0, topRight: 4.0, bottomRight: 0.0, bottomLeft: 0.0)
        border.padding = Thickness(left: 16.0, top: 16.0, right: 16.0, bottom: 16.0)
        border.minHeight = 120.0
        
        let demoGrid = Grid()
        // 列定义：先创建实例再赋值
        let leftCol = ColumnDefinition()
        leftCol.width = GridLength(value: 120.0, gridUnitType: .pixel)
        demoGrid.columnDefinitions.append(leftCol)
        
        let rightCol = ColumnDefinition()
        rightCol.width = GridLength(value: 1.0, gridUnitType: .star)
        demoGrid.columnDefinitions.append(rightCol)
        
        // 左侧：模拟AppBarButton的按钮
        let buttonPanel = StackPanel()
        buttonPanel.horizontalAlignment = .center
        buttonPanel.verticalAlignment = .center
        buttonPanel.spacing = 8.0
        
        let demoBtn = Button()
        demoBtn.content = "👍"  // 用表情模拟点赞图标
        demoBtn.width = 80.0
        demoBtn.height = 80.0
        demoBtn.fontSize = 48.0
        // 点击事件（2个参数，适配当前版本）
        demoBtn.click.addHandler { [weak self] _, _ in
            self?.onDemoButtonClicked()
        }
        buttonPanel.children.append(demoBtn)
        
        let btnLabel = TextBlock()
        btnLabel.text = "Symbolic\non"
        btnLabel.textAlignment = .center
        btnLabel.fontSize = 12.0
        buttonPanel.children.append(btnLabel)
        
        try? Grid.setColumn(buttonPanel, 0)
        demoGrid.children.append(buttonPanel)
        
        // 右侧：点击消息提示
        let messagePanel = StackPanel()
        messagePanel.verticalAlignment = .center
        messagePanel.padding = Thickness(left: 16.0, top: 0.0, right: 0.0, bottom: 0.0)
        
        clickMessageTextBlock = TextBlock()
        clickMessageTextBlock.text = "Click the button to see feedback"
        clickMessageTextBlock.fontSize = 14.0
        clickMessageTextBlock.foreground = SolidColorBrush(textColor)
        messagePanel.children.append(clickMessageTextBlock)
        
        try? Grid.setColumn(messagePanel, 1)
        demoGrid.children.append(messagePanel)
        
        border.child = demoGrid
        return border
    }
    
    // MARK: - Source Code 区域（核心：Swift定义AppBarButton代码，无高亮）
    private func createSourceCodeContainer() -> Border {
        // 外层边框（与演示区粘连）
        let border = Border()
        border.borderThickness = Thickness(left: 1.0, top: 0.0, right: 1.0, bottom: 1.0)
        border.borderBrush = SolidColorBrush(borderColor)
        border.background = SolidColorBrush(demoBackgroundColor)
        border.cornerRadius = CornerRadius(topLeft: 0.0, topRight: 0.0, bottomRight: 4.0, bottomLeft: 4.0)
        
        let panel = StackPanel()
        panel.spacing = 0.0
        
        // 1. 标题栏（整行点击+半透明背景）
        let titleButton = Button()
        titleButton.horizontalAlignment = .stretch  // 占满宽度，整行可点击
        titleButton.height = 40.0
        titleButton.padding = Thickness(left: 12.0, top: 0.0, right: 12.0, bottom: 0.0)
        titleButton.background = SolidColorBrush(translucentBgColor)  // 半透明背景
        titleButton.borderThickness = Thickness(left: 0.0, top: 0.0, right: 0.0, bottom: 0.0)  // 隐藏默认边框
        
        // 标题栏内部布局（文字左+箭头右）
        let titleGrid = Grid()
        // 列定义
        let textCol = ColumnDefinition()
        textCol.width = GridLength(value: 1.0, gridUnitType: .star)
        titleGrid.columnDefinitions.append(textCol)
        
        let arrowCol = ColumnDefinition()
        arrowCol.width = GridLength(value: 30.0, gridUnitType: .pixel)
        titleGrid.columnDefinitions.append(arrowCol)
        
        // 左侧：Source code 文字
        let titleText = TextBlock()
        titleText.text = "Source code"
        titleText.fontSize = 14.0
        titleText.foreground = SolidColorBrush(textColor)
        titleText.verticalAlignment = .center
        try? Grid.setColumn(titleText, 0)
        titleGrid.children.append(titleText)
        
        // 右侧：展开/收起箭头
        arrowTextBlock = TextBlock()
        arrowTextBlock.text = "▼"
        arrowTextBlock.fontSize = 12.0
        arrowTextBlock.foreground = SolidColorBrush(textColor)
        arrowTextBlock.verticalAlignment = .center
        arrowTextBlock.horizontalAlignment = .right
        try? Grid.setColumn(arrowTextBlock, 1)
        titleGrid.children.append(arrowTextBlock)
        
        // 标题按钮内容设为Grid，确保整行可点击
        titleButton.content = titleGrid
        // 点击事件（2个参数，适配当前版本）
        titleButton.click.addHandler { [weak self] _, _ in
            self?.toggleSourceCode()
        }
        panel.children.append(titleButton)
        
        // 2. 下拉代码区域（核心：Swift定义AppBarButton，无语法高亮）
        sourceCodePanel = StackPanel()
        sourceCodePanel.visibility = .collapsed  // 默认收起
        sourceCodePanel.padding = Thickness(left: 16.0, top: 16.0, right: 16.0, bottom: 16.0)
        sourceCodePanel.spacing = 6.0  // 代码行间距
        sourceCodePanel.borderThickness = Thickness(left: 0.0, top: 1.0, right: 0.0, bottom: 0.0)
        sourceCodePanel.borderBrush = SolidColorBrush(borderColor)  // 分隔线
        
        // 代码标题
        let codeTitle = TextBlock()
        codeTitle.text = "Swift 定义 AppBarButton 控件："
        codeTitle.fontSize = 12.0
        codeTitle.foreground = SolidColorBrush(textColor)
        sourceCodePanel.children.append(codeTitle)
        
        // Swift 定义 AppBarButton 的核心代码（无高亮，统一文本颜色）
        let swiftCodeLines = [
            "// 1. 创建 AppBarButton 实例",
            "let appBarButton = AppBarButton()",
            "",
            "// 2. 设置按钮图标",
            "let likeIcon = SymbolIcon()",
            "likeIcon.symbol = .like",
            "appBarButton.icon = likeIcon",
            "",
            "// 3. 设置按钮标签",
            "appBarButton.label = \"Symbolic on\"",
            "",
            "// 4. 设置按钮大小",
            "appBarButton.width = 80.0",
            "appBarButton.height = 80.0",
            "",
            "// 5. 设置点击事件",
            "appBarButton.click.addHandler { _, _ in",
            "    // 点击反馈逻辑",
            "    print(\"AppBarButton 被点击\")",
            "}",
            "",
            "// 6. 将按钮添加到父容器",
            "let parentPanel = StackPanel()",
            "parentPanel.children.append(appBarButton)"
        ]
        
        // 渲染Swift代码
        for codeLine in swiftCodeLines {
            let codeTextBlock = TextBlock()
            codeTextBlock.text = codeLine
            codeTextBlock.fontSize = 11.0
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
    
    // MARK: - 演示按钮点击事件
    private func onDemoButtonClicked() {
        clickMessageTextBlock.text = "You clicked: AppBar-style Button (Like)"
    }
}