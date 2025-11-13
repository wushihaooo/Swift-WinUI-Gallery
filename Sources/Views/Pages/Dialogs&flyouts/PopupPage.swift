@preconcurrency import WinUI
import WinAppSDK
import Foundation
import UWP

// 使用完整命名空间引用 Popup
typealias Popup = WinUI.Popup

class PopupPage: Grid {
    private var mainScrollViewer: ScrollViewer!
    private var contentStackPanel: StackPanel!
    
    // Popup 控件和控制元素
    private var popup: Popup!
    private var showButton: Button!
    private var lightDismissToggle: ToggleSwitch!
    private var verticalOffsetBox: TextBox!
    private var horizontalOffsetBox: TextBox!
    
    override init() {
        super.init()
        setupView()
    }
    
    private func setupView() {
        let rowDef = RowDefinition()
        rowDef.height = GridLength(value: 1, gridUnitType: .star)
        self.rowDefinitions.append(rowDef)
        
        mainScrollViewer = ScrollViewer()
        mainScrollViewer.verticalScrollBarVisibility = .auto
        mainScrollViewer.horizontalScrollBarVisibility = .disabled
        
        contentStackPanel = StackPanel()
        contentStackPanel.padding = Thickness(left: 40, top: 40, right: 40, bottom: 40)
        contentStackPanel.spacing = 24
        
        contentStackPanel.children.append(createHeader())
        contentStackPanel.children.append(createDescription())
        contentStackPanel.children.append(createPopupSection())
        
        mainScrollViewer.content = contentStackPanel
        self.children.append(mainScrollViewer)
    }
    
    private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 8
        
        let titleText = TextBlock()
        titleText.text = "Popup"
        titleText.fontSize = 32
        titleText.fontWeight = FontWeights.semiBold
        headerPanel.children.append(titleText)
        
        return headerPanel
    }
    
    private func createDescription() -> TextBlock {
        let descText = TextBlock()
        descText.text = "The Popup Control allows your app to display temporary content above other UI elements. It can be used for lightweight interactions such as tooltips, notifications, or custom floating panels to enhance user workflows or highlight specific parts of the interface."
        descText.fontSize = 14
        descText.textWrapping = .wrap
        descText.opacity = 0.8
        return descText
    }
    
    // MARK: - Popup Section
    private func createPopupSection() -> Border {
        let outerBorder = Border()
        outerBorder.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        outerBorder.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        
        let borderBrush = SolidColorBrush()
        var borderColor = UWP.Color()
        borderColor.a = 255
        borderColor.r = 200
        borderColor.g = 200
        borderColor.b = 200
        borderBrush.color = borderColor
        outerBorder.borderBrush = borderBrush
        
        outerBorder.padding = Thickness(left: 24, top: 24, right: 24, bottom: 24)
        
        // 使用 Grid 布局：左边示例，右边控制面板
        let mainGrid = Grid()
        
        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 1, gridUnitType: .star)
        mainGrid.columnDefinitions.append(col1)
        
        let col2 = ColumnDefinition()
        col2.width = GridLength(value: 300, gridUnitType: .pixel)
        mainGrid.columnDefinitions.append(col2)
        
        // 左侧内容
        let leftPanel = createLeftPanel()
        try? Grid.setColumn(leftPanel, 0)
        mainGrid.children.append(leftPanel)
        
        // 右侧控制面板
        let rightPanel = createRightPanel()
        try? Grid.setColumn(rightPanel, 1)
        mainGrid.children.append(rightPanel)
        
        outerBorder.child = mainGrid
        return outerBorder
    }
    
    private func createLeftPanel() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12
        
        // 标题
        let titleText = TextBlock()
        titleText.text = "Popup with Offset Positioning"
        titleText.fontSize = 16
        titleText.fontWeight = FontWeights.semiBold
        panel.children.append(titleText)
        
        // 显示 Popup 的按钮
        showButton = Button()
        showButton.content = "Show Popup (using Offset)"
        
        // 创建 Popup 并附加到按钮
        createPopup()
        
        showButton.click.addHandler { [weak self] sender, args in
            self?.showPopup()
        }
        
        panel.children.append(showButton)
        
        // 将 Popup 添加到面板（重要！Popup 需要在视觉树中）
        if let popup = popup {
            panel.children.append(popup)
        }
        
        return panel
    }
    
    private func createRightPanel() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 16
        panel.padding = Thickness(left: 20, top: 0, right: 0, bottom: 0)
        
        // IsLightDismissEnabled 开关
        lightDismissToggle = ToggleSwitch()
        lightDismissToggle.header = "IsLightDismissEnabled"
        lightDismissToggle.isOn = true
        panel.children.append(lightDismissToggle)
        
        // VerticalOffset
        panel.children.append(createOffsetControl(
            label: "VerticalOffset",
            initialValue: "0",
            onValueChanged: { [weak self] newValue in
                self?.verticalOffsetBox.text = newValue
            },
            textBoxOut: { [weak self] textBox in
                self?.verticalOffsetBox = textBox
            }
        ))
        
        // HorizontalOffset
        panel.children.append(createOffsetControl(
            label: "HorizontalOffset",
            initialValue: "200",
            onValueChanged: { [weak self] newValue in
                self?.horizontalOffsetBox.text = newValue
            },
            textBoxOut: { [weak self] textBox in
                self?.horizontalOffsetBox = textBox
            }
        ))
        
        return panel
    }
    
    private func createOffsetControl(label: String, initialValue: String, onValueChanged: @escaping (String) -> Void, textBoxOut: @escaping (TextBox) -> Void) -> StackPanel {
        let container = StackPanel()
        container.spacing = 4
        container.margin = Thickness(left: 0, top: 12, right: 0, bottom: 0)
        
        let labelText = TextBlock()
        labelText.text = label
        container.children.append(labelText)
        
        // Grid 包含 TextBox 和两个按钮
        let controlGrid = Grid()
        
        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 1, gridUnitType: .star)
        controlGrid.columnDefinitions.append(col1)
        
        let col2 = ColumnDefinition()
        col2.width = GridLength(value: 32, gridUnitType: .pixel)
        controlGrid.columnDefinitions.append(col2)
        
        // TextBox
        let textBox = TextBox()
        textBox.text = initialValue
        textBox.horizontalAlignment = .stretch
        try? Grid.setColumn(textBox, 0)
        controlGrid.children.append(textBox)
        textBoxOut(textBox)
        
        // 按钮容器
        let buttonStack = StackPanel()
        buttonStack.orientation = .vertical
        buttonStack.spacing = 0
        try? Grid.setColumn(buttonStack, 1)
        
        // 增加按钮
        let upButton = Button()
        upButton.content = "▲"
        upButton.fontSize = 8
        upButton.height = 16
        upButton.horizontalAlignment = .stretch
        upButton.padding = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        upButton.click.addHandler { [weak textBox] sender, args in
            if let currentValue = Double(textBox?.text ?? "0") {
                let newValue = String(Int(currentValue) + 10)
                textBox?.text = newValue
                onValueChanged(newValue)
            }
        }
        buttonStack.children.append(upButton)
        
        // 减少按钮
        let downButton = Button()
        downButton.content = "▼"
        downButton.fontSize = 8
        downButton.height = 16
        downButton.horizontalAlignment = .stretch
        downButton.padding = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        downButton.click.addHandler { [weak textBox] sender, args in
            if let currentValue = Double(textBox?.text ?? "0") {
                let newValue = String(Int(currentValue) - 10)
                textBox?.text = newValue
                onValueChanged(newValue)
            }
        }
        buttonStack.children.append(downButton)
        
        controlGrid.children.append(buttonStack)
        container.children.append(controlGrid)
        
        return container
    }
    
    // MARK: - Create Popup
    private func createPopup() {
        // 创建 Popup
        popup = Popup()
        
        // 创建 Popup 内容的 Border
        let popupBorder = Border()
        popupBorder.minWidth = 200
        popupBorder.padding = Thickness(left: 20, top: 20, right: 20, bottom: 20)
        popupBorder.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        popupBorder.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        
        // 设置背景色为白色
        let bgBrush = SolidColorBrush()
        var bgColor = UWP.Color()
        bgColor.a = 255
        bgColor.r = 255
        bgColor.g = 255
        bgColor.b = 255
        bgBrush.color = bgColor
        popupBorder.background = bgBrush
        
        // 设置边框颜色为灰色
        let borderBrush = SolidColorBrush()
        var borderColor = UWP.Color()
        borderColor.a = 255
        borderColor.r = 200
        borderColor.g = 200
        borderColor.b = 200
        borderBrush.color = borderColor
        popupBorder.borderBrush = borderBrush
        
        // 内容面板
        let contentPanel = StackPanel()
        contentPanel.spacing = 12
        contentPanel.horizontalAlignment = .stretch
        
        // 标题 TextBlock
        let titleText = TextBlock()
        titleText.text = "Simple Popup"
        titleText.fontSize = 16
        titleText.fontWeight = FontWeights.semiBold
        
        // 设置文字颜色为黑色
        let textBrush = SolidColorBrush()
        var textColor = UWP.Color()
        textColor.a = 255
        textColor.r = 0
        textColor.g = 0
        textColor.b = 0
        textBrush.color = textColor
        titleText.foreground = textBrush
        
        contentPanel.children.append(titleText)
        
        // 关闭按钮 - 使用 TextBlock 作为内容以控制文字颜色
        let closeButton = Button()
        closeButton.horizontalAlignment = .left
        closeButton.padding = Thickness(left: 12, top: 6, right: 12, bottom: 6)
        closeButton.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        
        // 设置按钮边框颜色
        let buttonBorderBrush = SolidColorBrush()
        var buttonBorderColor = UWP.Color()
        buttonBorderColor.a = 255
        buttonBorderColor.r = 150
        buttonBorderColor.g = 150
        buttonBorderColor.b = 150
        buttonBorderBrush.color = buttonBorderColor
        closeButton.borderBrush = buttonBorderBrush
        
        // 设置按钮背景（可选）
        let buttonBgBrush = SolidColorBrush()
        var buttonBgColor = UWP.Color()
        buttonBgColor.a = 255
        buttonBgColor.r = 240
        buttonBgColor.g = 240
        buttonBgColor.b = 240
        buttonBgBrush.color = buttonBgColor
        closeButton.background = buttonBgBrush
        
        // 创建按钮内容 TextBlock
        let buttonText = TextBlock()
        buttonText.text = "Close"
        
        // 设置按钮文字颜色为黑色
        let buttonTextBrush = SolidColorBrush()
        var buttonTextColor = UWP.Color()
        buttonTextColor.a = 255
        buttonTextColor.r = 0
        buttonTextColor.g = 0
        buttonTextColor.b = 0
        buttonTextBrush.color = buttonTextColor
        buttonText.foreground = buttonTextBrush
        
        closeButton.content = buttonText
        closeButton.click.addHandler { [weak self] sender, args in
            self?.popup?.isOpen = false
        }
        contentPanel.children.append(closeButton)
        
        popupBorder.child = contentPanel
        popup.child = popupBorder
    }
    
    private func showPopup() {
        guard let popup = popup else { return }
        
        // 更新设置
        popup.isLightDismissEnabled = lightDismissToggle.isOn
        
        // 设置偏移量
        let horizontalValue = Double(horizontalOffsetBox.text) ?? 200
        let verticalValue = Double(verticalOffsetBox.text) ?? 0
        
        popup.horizontalOffset = horizontalValue
        popup.verticalOffset = verticalValue
        
        // 显示 Popup
        popup.isOpen = true
    }
}