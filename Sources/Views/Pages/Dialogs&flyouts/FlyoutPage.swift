@preconcurrency import WinUI
import WinAppSDK
import Foundation
import UWP

class FlyoutPage: Grid {
    private var mainScrollViewer: ScrollViewer!
    private var contentStackPanel: StackPanel!
    
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
        contentStackPanel.children.append(createButtonWithFlyoutSection())
        
        mainScrollViewer.content = contentStackPanel
        self.children.append(mainScrollViewer)
    }
    
    private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 8
        
        let titleText = TextBlock()
        titleText.text = "Flyout"
        titleText.fontSize = 32
        titleText.fontWeight = FontWeights.semiBold
        headerPanel.children.append(titleText)
        
        return headerPanel
    }
    
    private func createDescription() -> TextBlock {
        let descText = TextBlock()
        descText.text = "A Flyout displays lightweight UI that is either information, or requires user interaction. Unlike a dialog, a Flyout can be light dismissed by clicking or tapping off of it. Use it to collect input from the user, show more details about an item, or ask the user to confirm an action."
        descText.fontSize = 14
        descText.textWrapping = .wrap
        descText.opacity = 0.8
        return descText
    }
    
    // MARK: - Button with Flyout Section
    private func createButtonWithFlyoutSection() -> Border {
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
        
        let contentPanel = StackPanel()
        contentPanel.spacing = 12
        
        // 标题
        let titleText = TextBlock()
        titleText.text = "A button with a flyout"
        titleText.fontSize = 16
        titleText.fontWeight = FontWeights.semiBold
        contentPanel.children.append(titleText)
        
        // 创建按钮和 Flyout
        let emptyCartButton = Button()
        emptyCartButton.content = "Empty cart"
        
        // 创建 Flyout
        let flyout = Flyout()
        
        // Flyout 内容
        let flyoutContent = StackPanel()
        flyoutContent.spacing = 12
        flyoutContent.padding = Thickness(left: 12, top: 12, right: 12, bottom: 12)
        
        let flyoutText = TextBlock()
        flyoutText.text = "All items will be removed. Do you want to continue?"
        flyoutText.textWrapping = .wrap
        flyoutText.maxWidth = 200
        flyoutContent.children.append(flyoutText)
        
        let confirmButton = Button()
        confirmButton.content = "Yes, empty my cart"
        confirmButton.horizontalAlignment = .left
        
        // 保存 flyout 引用以便关闭
        var flyoutRef: Flyout? = flyout
        
        // 点击确认按钮后关闭 Flyout
        confirmButton.click.addHandler { sender, args in
            // 尝试关闭 flyout
            if let f = flyoutRef {
                try? f.hide()
            }
        }
        
        flyoutContent.children.append(confirmButton)
        flyout.content = flyoutContent
        
        // 将 Flyout 附加到按钮
        emptyCartButton.flyout = flyout
        
        contentPanel.children.append(emptyCartButton)
        
        outerBorder.child = contentPanel
        return outerBorder
    }
}