@preconcurrency import WinUI
import WinAppSDK
import Foundation
import UWP
import WindowsFoundation

@MainActor
class BadgeNotificationsPage: Page {
    private var badgeCountTextBox: TextBox?
    private var badgeGlyphComboBox: ComboBox?
    private var currentBadgeCount: Int = 5
    
    override init() {
        super.init()
        
        nonisolated(unsafe) let unsafeSelf = self
        
        Task { @MainActor in
            await unsafeSelf.initializeUI()
        }
    }
    
    @MainActor
    private func initializeUI() async {
        let mainStack = StackPanel()
        mainStack.margin = Thickness(left: 36, top: 0, right: 36, bottom: 0)
        mainStack.spacing = 16
        
        // 标题
        let titleText = TextBlock()
        titleText.text = "Badge notifications"
        titleText.fontSize = 28
        titleText.fontWeight = FontWeights.semiBold
        titleText.margin = Thickness(left: 0, top: 12, right: 0, bottom: 4)
        mainStack.children.append(titleText)
        
        // 描述
        let descText = TextBlock()
        descText.text = "Badge notifications provide a lightweight way to convey status or alerts through small overlays on your app's icon."
        descText.textWrapping = .wrap
        descText.foreground = createSecondaryBrush()
        descText.margin = Thickness(left: 0, top: 0, right: 0, bottom: 16)
        mainStack.children.append(descText)
        
        // Warning InfoBar
        let warningBar = InfoBar()
        warningBar.isOpen = true
        warningBar.severity = .warning
        warningBar.isClosable = false
        warningBar.title = "BadgeNotificationManager is not available in unpackaged mode."
        warningBar.message = "This API requires the app to be running in packaged mode (MSIX)."
        mainStack.children.append(warningBar)
        
        // 分隔线
        let separator = Border()
        separator.height = 1
        separator.background = SolidColorBrush(Color(a: 255, r: 230, g: 230, b: 230))
        separator.margin = Thickness(left: 0, top: 16, right: 0, bottom: 16)
        mainStack.children.append(separator)
        
        // Section 1: Setting badge notifications with count
        mainStack.children.append(createBadgeCountSection())
        
        // Section 2: Setting badge notifications with Glyph
        mainStack.children.append(createBadgeGlyphSection())
        
        let scrollViewer = ScrollViewer()
        scrollViewer.content = mainStack
        
        self.content = scrollViewer
    }
    
    @MainActor
    private func createBadgeCountSection() -> Border {
        let border = Border()
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = SolidColorBrush(Color(a: 255, r: 230, g: 230, b: 230))
        border.cornerRadius = CornerRadius(topLeft: 4, topRight: 4, bottomRight: 4, bottomLeft: 4)
        border.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        border.margin = Thickness(left: 0, top: 0, right: 0, bottom: 16)
        
        let contentStack = StackPanel()
        contentStack.spacing = 12
        
        // 标题
        let header = TextBlock()
        header.text = "Setting badge notifications with count"
        header.fontSize = 16
        header.fontWeight = FontWeights.semiBold
        contentStack.children.append(header)
        
        // 创建左右布局
        let grid = Grid()
        
        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 1, gridUnitType: .star)
        grid.columnDefinitions.append(col1)
        
        let col2 = ColumnDefinition()
        col2.width = GridLength(value: 300, gridUnitType: .pixel)
        grid.columnDefinitions.append(col2)
        
        // 左侧按钮区域
        let leftStack = StackPanel()
        leftStack.spacing = 8
        
        let setBadgeButton = Button()
        setBadgeButton.content = "Set badge as count"
        setBadgeButton.click.addHandler { [weak self] _, _ in
            self?.setBadgeAsCount()
        }
        leftStack.children.append(setBadgeButton)
        
        let clearBadgeButton1 = Button()
        clearBadgeButton1.content = "Clear badge"
        clearBadgeButton1.click.addHandler { [weak self] _, _ in
            self?.clearBadge()
        }
        leftStack.children.append(clearBadgeButton1)
        
        grid.children.append(leftStack)
        try? Grid.setColumn(leftStack, 0)
        
        // 右侧选项区域
        let rightStack = StackPanel()
        rightStack.spacing = 8
        rightStack.horizontalAlignment = .right
        
        let label = TextBlock()
        label.text = "Badge count"
        label.fontSize = 14
        label.margin = Thickness(left: 0, top: 0, right: 0, bottom: 4)
        rightStack.children.append(label)
        
        // 创建 NumberBox 样式的输入框
        let inputGrid = Grid()
        inputGrid.width = 200
        inputGrid.height = 32
        
        let inputCol1 = ColumnDefinition()
        inputCol1.width = GridLength(value: 1, gridUnitType: .star)
        inputGrid.columnDefinitions.append(inputCol1)
        
        let inputCol2 = ColumnDefinition()
        inputCol2.width = GridLength(value: 32, gridUnitType: .pixel)
        inputGrid.columnDefinitions.append(inputCol2)
        
        let inputRow1 = RowDefinition()
        inputRow1.height = GridLength(value: 1, gridUnitType: .star)
        inputGrid.rowDefinitions.append(inputRow1)
        
        let inputRow2 = RowDefinition()
        inputRow2.height = GridLength(value: 1, gridUnitType: .star)
        inputGrid.rowDefinitions.append(inputRow2)
        
        // TextBox
        badgeCountTextBox = TextBox()
        badgeCountTextBox?.text = "5"
        badgeCountTextBox?.horizontalAlignment = .stretch
        badgeCountTextBox?.verticalAlignment = .stretch
        badgeCountTextBox?.textAlignment = .center
        
        if let textBox = badgeCountTextBox {
            inputGrid.children.append(textBox)
            try? Grid.setColumn(textBox, 0)
            try? Grid.setRowSpan(textBox, 2)
        }
        
        // 增加按钮
        let increaseButton = Button()
        increaseButton.content = "▲"
        increaseButton.fontSize = 8
        increaseButton.horizontalAlignment = .stretch
        increaseButton.verticalAlignment = .stretch
        increaseButton.padding = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        increaseButton.click.addHandler { [weak self] _, _ in
            self?.increaseBadgeCount()
        }
        inputGrid.children.append(increaseButton)
        try? Grid.setColumn(increaseButton, 1)
        try? Grid.setRow(increaseButton, 0)
        
        // 减少按钮
        let decreaseButton = Button()
        decreaseButton.content = "▼"
        decreaseButton.fontSize = 8
        decreaseButton.horizontalAlignment = .stretch
        decreaseButton.verticalAlignment = .stretch
        decreaseButton.padding = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        decreaseButton.click.addHandler { [weak self] _, _ in
            self?.decreaseBadgeCount()
        }
        inputGrid.children.append(decreaseButton)
        try? Grid.setColumn(decreaseButton, 1)
        try? Grid.setRow(decreaseButton, 1)
        
        rightStack.children.append(inputGrid)
        
        grid.children.append(rightStack)
        try? Grid.setColumn(rightStack, 1)
        
        contentStack.children.append(grid)
        border.child = contentStack
        return border
    }
    
    @MainActor
    private func createBadgeGlyphSection() -> Border {
        let border = Border()
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = SolidColorBrush(Color(a: 255, r: 230, g: 230, b: 230))
        border.cornerRadius = CornerRadius(topLeft: 4, topRight: 4, bottomRight: 4, bottomLeft: 4)
        border.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        border.margin = Thickness(left: 0, top: 0, right: 0, bottom: 16)
        
        let contentStack = StackPanel()
        contentStack.spacing = 12
        
        // 标题
        let header = TextBlock()
        header.text = "Setting badge notifications with Glyph"
        header.fontSize = 16
        header.fontWeight = FontWeights.semiBold
        contentStack.children.append(header)
        
        // 创建左右布局
        let grid = Grid()
        
        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 1, gridUnitType: .star)
        grid.columnDefinitions.append(col1)
        
        let col2 = ColumnDefinition()
        col2.width = GridLength(value: 300, gridUnitType: .pixel)
        grid.columnDefinitions.append(col2)
        
        // 左侧按钮区域
        let leftStack = StackPanel()
        leftStack.spacing = 8
        
        let setGlyphButton = Button()
        setGlyphButton.content = "Set badge glyph"
        setGlyphButton.click.addHandler { [weak self] _, _ in
            self?.setBadgeGlyph()
        }
        leftStack.children.append(setGlyphButton)
        
        let clearBadgeButton2 = Button()
        clearBadgeButton2.content = "Clear badge"
        clearBadgeButton2.click.addHandler { [weak self] _, _ in
            self?.clearBadge()
        }
        leftStack.children.append(clearBadgeButton2)
        
        grid.children.append(leftStack)
        try? Grid.setColumn(leftStack, 0)
        
        // 右侧选项区域
        let rightStack = StackPanel()
        rightStack.spacing = 8
        rightStack.horizontalAlignment = .right
        
        let label = TextBlock()
        label.text = "BadgeNotificationGlyph"
        label.fontSize = 14
        label.margin = Thickness(left: 0, top: 0, right: 0, bottom: 4)
        rightStack.children.append(label)
        
        badgeGlyphComboBox = ComboBox()
        badgeGlyphComboBox?.width = 200
        
        let glyphs = [
            "None", "Activity", "Alarm", "Alert", "Attention",
            "Available", "Away", "Busy", "Error", "NewMessage",
            "Paused", "Playing", "Unavailable"
        ]
        
        for glyph in glyphs {
            let item = ComboBoxItem()
            item.content = glyph
            badgeGlyphComboBox?.items.append(item)
        }
        badgeGlyphComboBox?.selectedIndex = 1  // Activity
        
        if let comboBox = badgeGlyphComboBox {
            rightStack.children.append(comboBox)
        }
        
        grid.children.append(rightStack)
        try? Grid.setColumn(rightStack, 1)
        
        contentStack.children.append(grid)
        border.child = contentStack
        return border
    }
    
    private func createSecondaryBrush() -> Brush {
        let brush = SolidColorBrush()
        var color = UWP.Color()
        color.a = 255
        color.r = 128
        color.g = 128
        color.b = 128
        brush.color = color
        return brush
    }
    
    private func increaseBadgeCount() {
        if currentBadgeCount < 99 {
            currentBadgeCount += 1
            badgeCountTextBox?.text = "\(currentBadgeCount)"
        }
    }
    
    private func decreaseBadgeCount() {
        if currentBadgeCount > 0 {
            currentBadgeCount -= 1
            badgeCountTextBox?.text = "\(currentBadgeCount)"
        }
    }
    
    private func setBadgeAsCount() {
        // 从 TextBox 读取值
        if let text = badgeCountTextBox?.text, let count = Int(text) {
            currentBadgeCount = min(max(count, 0), 99)  // 限制在 0-99
            badgeCountTextBox?.text = "\(currentBadgeCount)"
            print("🔔 Setting badge count to: \(currentBadgeCount)")
        } else {
            print("🔔 Setting badge count to: \(currentBadgeCount)")
        }
        print("⚠️ Badge notifications require packaged mode (MSIX)")
    }
    
    private func setBadgeGlyph() {
        let glyphs = [
            "None", "Activity", "Alarm", "Alert", "Attention",
            "Available", "Away", "Busy", "Error", "NewMessage",
            "Paused", "Playing", "Unavailable"
        ]
        
        guard let comboBox = badgeGlyphComboBox else { return }
        let index = Int(comboBox.selectedIndex)
        
        if index >= 0 && index < glyphs.count {
            let glyph = glyphs[index]
            print("🔔 Setting badge glyph to: \(glyph)")
            print("⚠️ Badge notifications require packaged mode (MSIX)")
        }
    }
    
    private func clearBadge() {
        print("🔔 Clearing badge")
        print("⚠️ Badge notifications require packaged mode (MSIX)")
    }
}