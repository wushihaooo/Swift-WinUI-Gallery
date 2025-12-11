import WinUI
import UWP
import Foundation

class CommandBarPage: Grid {
    private var page: Page = Page()
    private var commandBar: Grid!
    private var addButton: Button!
    private var editButton: Button!
    private var shareButton: Button!
    private var settingsButton: Button!
    private var moreButton: Button!
    private var selectedOptionText: TextBlock!
    private var secondaryCommandsPanel: StackPanel!
    private var dismissLayer: Border!
    private var isCommandBarOpen: Bool = false
    private var hasMultipleSecondaryCommands: Bool = false
    
    // Secondary command buttons (for dynamic add/remove)
    private var button1: Button?
    private var button2: Button?
    private var separator: Border?
    private var button3: Button?
    private var button4: Button?
    
    override init() {
        super.init()
        loadXamlFromFile(
            filePath: Bundle.module.path(
                forResource: "CommandBarPage", 
                ofType: "xaml", 
                inDirectory: "Assets/xaml") ?? ""
        )
        setupHeader()
        setupExample()
        self.children.append(page)
    }
    
    private func setupHeader() {
        let headerGrid = try! page.findName("headerGrid") as! Grid
        let controlInfo = ControlInfo(
            title: "CommandBar",
            apiNamespace: "Microsoft.UI.Xaml.Controls",
            baseClasses: [
                "Object",
                "DependencyObject",
                "UIElement",
                "FrameworkElement",
                "Control",
                "ContentControl",
                "AppBar",
                "CommandBar"
            ],
            docs: [
                ControlInfoDocLink(
                    title: "CommandBar API",
                    uri: "https://learn.microsoft.com/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.controls.commandbar"
                ),
                ControlInfoDocLink(
                    title: "Guidelines",
                    uri: "https://learn.microsoft.com/windows/apps/design/controls/app-bars"
                )
            ]
        )
        let pageHeader = PageHeader(item: controlInfo)
        pageHeader.themeButtonVisibility = .visible
        pageHeader.margin = Thickness(left: 36, top: 36, right: 36, bottom: 0)
        headerGrid.children.append(pageHeader)
    }
    
    private func setupExample() {
        let exampleStackPanel = try! page.findName("exampleStackPanel") as! StackPanel
        
        let example3: Grid = try! page.findName("Example3") as! Grid
        let demo = createCommandBarDemo()
        example3.children.append(demo)
        
        let _ = exampleStackPanel.children.remove(at: exampleStackPanel.children.index(of: example3)!)
        let controlExample = ControlExample()
        controlExample.headerText = "A command bar with labels on the side free floating in a page" 
        controlExample.example = example3
        controlExample.options = createOptionsPanel()
        exampleStackPanel.children.append(controlExample.view)
        // exampleStackPanel.children.append(ControlExample(
        //     headerText: "A command bar with labels on the side free floating in a page",
        //     isOutputDisplay: false,
        //     isOptionsDisplay: true,
        //     contentPresenter: example3,
        //     optionsPresenter: createOptionsPanel()
        // ).controlExample)
    }
    
    private func createCommandBarDemo() -> Grid {
        let containerGrid = Grid()
        
        let panel = StackPanel()
        panel.spacing = 8
        
        // Create CommandBar container (整个 CommandBar 的背景)
        commandBar = Grid()
        commandBar.background = SolidColorBrush(Color(a: 30, r: 0, g: 0, b: 0))
        commandBar.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        commandBar.padding = Thickness(left: 4, top: 0, right: 0, bottom: 0) // 左侧 padding: 4
        commandBar.height = 48  // AppBarThemeCompactHeight
        
        // 主按钮容器 (水平布局)
        let commandBarContent = StackPanel()
        commandBarContent.orientation = .horizontal
        commandBarContent.spacing = 0  // 按钮之间无间距
        commandBarContent.verticalAlignment = .stretch
        commandBarContent.horizontalAlignment = .left
        
        // Primary commands - 按照原版图标和布局
        addButton = createAppBarButton(icon: "\u{E710}", label: "Add")
        editButton = createAppBarButton(icon: "\u{E70F}", label: "Edit")
        shareButton = createAppBarButton(icon: "\u{E72D}", label: "Share")
        
        commandBarContent.children.append(addButton)
        commandBarContent.children.append(editButton)
        commandBarContent.children.append(shareButton)
        
        // More button (ellipsis) for secondary commands
        moreButton = createMoreButton()
        commandBarContent.children.append(moreButton)
        
        // 将按钮容器添加到 CommandBar
        commandBar.children.append(commandBarContent)
        
        // Secondary commands panel (initially hidden)
        secondaryCommandsPanel = StackPanel()
        secondaryCommandsPanel.background = SolidColorBrush(Color(a: 230, r: 45, g: 45, b: 45)) // AcrylicInAppFillColorDefaultBrush 近似
        secondaryCommandsPanel.borderBrush = SolidColorBrush(Color(a: 100, r: 120, g: 120, b: 120))
        secondaryCommandsPanel.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        secondaryCommandsPanel.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        secondaryCommandsPanel.padding = Thickness(left: 0, top: 4, right: 0, bottom: 4) // CommandBarOverflowPresenterMargin
        secondaryCommandsPanel.margin = Thickness(left: 0, top: 4, right: 0, bottom: 0)
        secondaryCommandsPanel.visibility = .collapsed
        secondaryCommandsPanel.minWidth = 160  // CommandBarOverflowMinWidth
        secondaryCommandsPanel.maxWidth = 480  // CommandBarOverflowMaxWidth
        
        // Settings button (always in secondary commands)
        settingsButton = createSecondaryCommandButton("\u{E713}", "Settings", "Ctrl+I")
        secondaryCommandsPanel.children.append(settingsButton)
        
        panel.children.append(commandBar)
        panel.children.append(secondaryCommandsPanel)
        
        // Selected option text
        selectedOptionText = TextBlock()
        selectedOptionText.padding = Thickness(left: 0, top: 8, right: 0, bottom: 0)
        selectedOptionText.foreground = SolidColorBrush(Color(a: 255, r: 180, g: 180, b: 180))
        panel.children.append(selectedOptionText)
        
        containerGrid.children.append(panel)
        
        // 添加透明遮罩层（用于捕获外部点击）
        dismissLayer = Border()
        dismissLayer.background = SolidColorBrush(Color(a: 1, r: 0, g: 0, b: 0))
        dismissLayer.visibility = .collapsed
        dismissLayer.horizontalAlignment = .stretch
        dismissLayer.verticalAlignment = .stretch
        
        dismissLayer.pointerPressed.addHandler { [weak self] _, args in
            self?.closeCommandBar()
            if let args = args {
                args.handled = true
            }
        }
        
        containerGrid.children.append(dismissLayer)
        
        return containerGrid
    }
    
    // 创建主按钮 (AppBarButton 样式) - 按照原版布局
    private func createAppBarButton(icon: String, label: String) -> Button {
        let button = Button()
        
        // 内容容器: 图标在左,标签在右
        let content = StackPanel()
        content.orientation = .horizontal
        content.spacing = 8  // 图标和标签之间的间距
        content.horizontalAlignment = .left
        content.verticalAlignment = .center
        
        // 图标 (使用 Segoe MDL2 Assets)
        let iconText = TextBlock()
        iconText.text = icon
        iconText.fontSize = 16  // 图标大小
        iconText.fontFamily = FontFamily("Segoe MDL2 Assets")
        iconText.verticalAlignment = .center
        iconText.horizontalAlignment = .center
        iconText.width = 20  // 固定图标宽度
        content.children.append(iconText)
        
        // 标签文字
        let labelText = TextBlock()
        labelText.text = label
        labelText.fontSize = 14  // ControlContentThemeFontSize
        labelText.verticalAlignment = .center
        content.children.append(labelText)
        
        button.content = content
        button.height = 48  // AppBarThemeCompactHeight
        button.minWidth = 68  // 最小宽度保证按钮大小
        button.padding = Thickness(left: 12, top: 0, right: 12, bottom: 0)  // 按钮内边距
        button.background = nil  // 透明背景
        button.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        button.horizontalContentAlignment = .left
        button.verticalContentAlignment = .center
        button.cornerRadius = CornerRadius(topLeft: 4, topRight: 4, bottomRight: 4, bottomLeft: 4)
        
        // 点击事件
        button.click.addHandler { [weak self, label] _, _ in
            self?.onElementClicked(label)
        }
        
        return button
    }
    
    // 创建更多按钮 (省略号按钮)
    private func createMoreButton() -> Button {
        let button = Button()
        
        // 使用 Segoe MDL2 Assets 的省略号图标
        let iconText = TextBlock()
        iconText.text = "\u{E712}"  // More 图标
        iconText.fontSize = 16
        iconText.fontFamily = FontFamily("Segoe MDL2 Assets")
        iconText.verticalAlignment = .center
        iconText.horizontalAlignment = .center
        
        button.content = iconText
        button.width = 40  // AppBarExpandButtonThemeWidth
        button.height = 48  // AppBarThemeCompactHeight
        button.background = nil
        button.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        button.horizontalContentAlignment = .center
        button.verticalContentAlignment = .center
        button.cornerRadius = CornerRadius(topLeft: 4, topRight: 4, bottomRight: 4, bottomLeft: 4)
        button.margin = Thickness(left: 0, top: 0, right: 6, bottom: 0)  // 右边距
        
        button.click.addHandler { [weak self] _, _ in
            self?.toggleCommandBar()
        }
        
        return button
    }
    
    // 创建二级命令按钮
    private func createSecondaryCommandButton(_ icon: String, _ label: String, _ shortcut: String = "") -> Button {
        let button = Button()
        
        let content = Grid()
        
        // 图标列 - 固定宽度 40
        let iconColumn = ColumnDefinition()
        iconColumn.width = GridLength(value: 40, gridUnitType: .pixel)
        content.columnDefinitions.append(iconColumn)
        
        // 标签列 - 自动填充
        let labelColumn = ColumnDefinition()
        labelColumn.width = GridLength(value: 1, gridUnitType: .star)
        content.columnDefinitions.append(labelColumn)
        
        // 快捷键列 - 固定宽度 80 (如果有快捷键)
        if !shortcut.isEmpty {
            let shortcutColumn = ColumnDefinition()
            shortcutColumn.width = GridLength(value: 80, gridUnitType: .pixel)
            content.columnDefinitions.append(shortcutColumn)
        }
        
        // 图标
        let iconText = TextBlock()
        iconText.text = icon
        iconText.fontSize = 16
        iconText.fontFamily = FontFamily("Segoe MDL2 Assets")
        iconText.verticalAlignment = .center
        iconText.horizontalAlignment = .center
        iconText.margin = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        try! Grid.setColumn(iconText, 0)
        
        // 标签
        let labelText = TextBlock()
        labelText.text = label
        labelText.fontSize = 14
        labelText.verticalAlignment = .center
        labelText.horizontalAlignment = .left
        try! Grid.setColumn(labelText, 1)
        
        content.children.append(iconText)
        content.children.append(labelText)
        
        // 快捷键文字
        if !shortcut.isEmpty {
            let shortcutText = TextBlock()
            shortcutText.text = shortcut
            shortcutText.fontSize = 12
            shortcutText.verticalAlignment = .center
            shortcutText.horizontalAlignment = .right
            shortcutText.foreground = SolidColorBrush(Color(a: 255, r: 150, g: 150, b: 150))
            shortcutText.margin = Thickness(left: 0, top: 0, right: 8, bottom: 0)
            try! Grid.setColumn(shortcutText, 2)
            content.children.append(shortcutText)
        }
        
        button.content = content
        button.height = 40  // 二级按钮高度
        button.minWidth = 160  // CommandBarOverflowMinWidth
        button.padding = Thickness(left: 12, top: 0, right: 12, bottom: 0)
        button.background = nil
        button.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        button.horizontalContentAlignment = .stretch
        button.horizontalAlignment = .stretch
        
        button.click.addHandler { [weak self, label] _, _ in
            self?.onElementClicked(label)
        }
        
        return button
    }
    
    private func createOptionsPanel() -> Grid {
        let panel = StackPanel()
        panel.spacing = 12
        
        // Show or hide section
        let showHideText = TextBlock()
        showHideText.text = "Show or hide"
        showHideText.fontSize = 14
        panel.children.append(showHideText)
        
        let openButton = Button()
        openButton.content = "Open command bar"
        openButton.margin = Thickness(left: 0, top: 12, right: 0, bottom: 0)
        openButton.click.addHandler { [weak self] _, _ in
            self?.openCommandBar()
        }
        panel.children.append(openButton)
        
        let closeButton = Button()
        closeButton.content = "Close command bar"
        closeButton.margin = Thickness(left: 0, top: 12, right: 0, bottom: 0)
        closeButton.click.addHandler { [weak self] _, _ in
            self?.closeCommandBar()
        }
        panel.children.append(closeButton)
        
        // Modify content section
        let modifyText = TextBlock()
        modifyText.text = "Modify content"
        modifyText.fontSize = 14
        modifyText.margin = Thickness(left: 0, top: 16, right: 0, bottom: 0)
        panel.children.append(modifyText)
        
        let addCommandsButton = Button()
        addCommandsButton.content = "Add secondary commands"
        addCommandsButton.margin = Thickness(left: 0, top: 12, right: 0, bottom: 0)
        addCommandsButton.click.addHandler { [weak self] _, _ in
            self?.addSecondaryCommands()
        }
        panel.children.append(addCommandsButton)
        
        let removeCommandsButton = Button()
        removeCommandsButton.content = "Remove secondary commands"
        removeCommandsButton.margin = Thickness(left: 0, top: 12, right: 0, bottom: 0)
        removeCommandsButton.click.addHandler { [weak self] _, _ in
            self?.removeSecondaryCommands()
        }
        panel.children.append(removeCommandsButton)
        
        let container = Grid()
        container.children.append(panel)
        return container
    }
    
    // Event handlers
    private func onElementClicked(_ elementName: String) {
        selectedOptionText.text = "You clicked: \(elementName)"
    }
    
    private func toggleCommandBar() {
        isCommandBarOpen.toggle()
        secondaryCommandsPanel.visibility = isCommandBarOpen ? .visible : .collapsed
        dismissLayer.visibility = isCommandBarOpen ? .visible : .collapsed
    }
    
    private func openCommandBar() {
        isCommandBarOpen = true
        secondaryCommandsPanel.visibility = .visible
        dismissLayer.visibility = .visible
    }
    
    private func closeCommandBar() {
        isCommandBarOpen = false
        secondaryCommandsPanel.visibility = .collapsed
        dismissLayer.visibility = .collapsed
    }
    
    private func addSecondaryCommands() {
        guard !hasMultipleSecondaryCommands else { return }
        hasMultipleSecondaryCommands = true
        
        // Add Button 1 with Ctrl+N (Add icon)
        button1 = createSecondaryCommandButton("\u{E710}", "Button 1", "Ctrl+N")
        secondaryCommandsPanel.children.append(button1!)
        
        // Add Button 2 with Delete (Delete icon)
        button2 = createSecondaryCommandButton("\u{E74D}", "Button 2", "Delete")
        secondaryCommandsPanel.children.append(button2!)
        
        // Add separator
        separator = Border()
        separator!.height = 1
        separator!.background = SolidColorBrush(Color(a: 50, r: 200, g: 200, b: 200))
        separator!.margin = Thickness(left: 12, top: 4, right: 12, bottom: 4)
        secondaryCommandsPanel.children.append(separator!)
        
        // Add Button 3 with Ctrl+- (FontDecrease icon)
        button3 = createSecondaryCommandButton("\u{E8E7}", "Button 3", "Ctrl+-")
        secondaryCommandsPanel.children.append(button3!)
        
        // Add Button 4 with Ctrl++ (FontIncrease icon)
        button4 = createSecondaryCommandButton("\u{E8E8}", "Button 4", "Ctrl++")
        secondaryCommandsPanel.children.append(button4!)
    }
    
    private func removeSecondaryCommands() {
        guard hasMultipleSecondaryCommands else { return }
        hasMultipleSecondaryCommands = false
        
        // Remove the additional buttons
        if let btn1 = button1, let index = secondaryCommandsPanel.children.index(of: btn1) {
            _ = secondaryCommandsPanel.children.remove(at: index)
            button1 = nil
        }
        
        if let btn2 = button2, let index = secondaryCommandsPanel.children.index(of: btn2) {
            _ = secondaryCommandsPanel.children.remove(at: index)
            button2 = nil
        }
        
        if let sep = separator, let index = secondaryCommandsPanel.children.index(of: sep) {
            _ = secondaryCommandsPanel.children.remove(at: index)
            separator = nil
        }
        
        if let btn3 = button3, let index = secondaryCommandsPanel.children.index(of: btn3) {
            _ = secondaryCommandsPanel.children.remove(at: index)
            button3 = nil
        }
        
        if let btn4 = button4, let index = secondaryCommandsPanel.children.index(of: btn4) {
            _ = secondaryCommandsPanel.children.remove(at: index)
            button4 = nil
        }
    }
    
    private func loadXamlFromFile(filePath: String) {
        do {
            let root = try XamlReader.load(FileReader.readFileFromPath(filePath) ?? "")
            if let page = root as? Page {
                self.page = page
            } else {
                print("XAML根元素类型转换失败, 实际类型: \(type(of: root))")
            }
        } catch {
            print("XAML 加载失败: \(error)")
        }
    }
}