import WinUI
import Foundation
import WindowsFoundation
import WinAppSDK
import UWP

/// InfoBar 示例页
class InfoBarPage: Grid {
    
    private let exampleStackPanel = StackPanel()
    
    override init() {
        super.init()
        setupLayout()
        setupExample1()
        setupExample2()
        setupExample3()
    }
    
    // MARK: - 基础布局：Header + ScrollViewer + StackPanel
    
    private func setupLayout() {
        // 行：0 = Header, 1 = Content
        let headerRow = RowDefinition()
        headerRow.height = GridLength(value: 1, gridUnitType: .auto)
        let contentRow = RowDefinition()
        contentRow.height = GridLength(value: 1, gridUnitType: .star)
        self.rowDefinitions.append(headerRow)
        self.rowDefinitions.append(contentRow)
        
        // Header
        let headerGrid = Grid()
        try? Grid.setRow(headerGrid, 0)
        self.children.append(headerGrid)
        
        let controlInfo = ControlInfo(
            title: "InfoBar",
            apiNamespace: "Microsoft.UI.Xaml.Controls",
            baseClasses: [
                "Object",
                "DependencyObject",
                "UIElement",
                "FrameworkElement",
                "Control"
            ],
            docs: [
                ControlInfoDocLink(
                    title: "InfoBar - API",
                    uri: "https://learn.microsoft.com/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.controls.infobar"
                ),
                ControlInfoDocLink(
                    title: "Guidelines",
                    uri: "https://learn.microsoft.com/windows/apps/design/controls/infobar"
                )
            ]
        )
        
        let pageHeader = PageHeader(item: controlInfo)
        pageHeader.themeButtonVisibility = .visible
        pageHeader.margin = Thickness(left: 36, top: 36, right: 36, bottom: 0)
        headerGrid.children.append(pageHeader)
        
        // Content（ScrollViewer + StackPanel）
        let scrollViewer = ScrollViewer()
        scrollViewer.verticalScrollMode = .auto
        scrollViewer.verticalScrollBarVisibility = .auto
        try? Grid.setRow(scrollViewer, 1)
        self.children.append(scrollViewer)
        
        exampleStackPanel.orientation = .vertical
        exampleStackPanel.spacing = 24
        exampleStackPanel.margin = Thickness(left: 36, top: 24, right: 36, bottom: 36)
        scrollViewer.content = exampleStackPanel
    }
    
    /// 双向绑定 InfoBar.isOpen 和 CheckBox.isChecked
    private func bindIsOpen(infoBar: InfoBar, checkBox: CheckBox) {
        // 1) CheckBox -> InfoBar
        checkBox.checked.addHandler { [weak infoBar] _, _ in
            infoBar?.isOpen = true
        }
        checkBox.unchecked.addHandler { [weak infoBar] _, _ in
            infoBar?.isOpen = false
        }

        // 2) InfoBar -> CheckBox：监听 IsOpen 依赖属性变化
        do {
            _ = try infoBar.registerPropertyChangedCallback(InfoBar.isOpenProperty) {
                [weak infoBar, weak checkBox] _, _ in
                guard let bar = infoBar, let cb = checkBox else { return }
                if cb.isChecked != bar.isOpen {
                    cb.isChecked = bar.isOpen
                }
            }
        } catch {
            print("Failed to register IsOpen property callback on InfoBar: \(error)")
        }
    }


    // MARK: - Example 1
    // A closable InfoBar with options to change its Severity.
    
    private func setupExample1() {
        let infoBar = InfoBar()
        infoBar.isOpen = true
        infoBar.severity = InfoBarSeverity.informational
        infoBar.isIconVisible = true
        infoBar.isClosable = true
        infoBar.title = "Title"
        infoBar.message = "Essential app message for your users to be informed of, acknowledge, or take action on."
        
        // 右侧选项
        let optionsPanel = StackPanel()
        optionsPanel.orientation = .vertical
        optionsPanel.spacing = 8
        optionsPanel.width = 220
        
        // Is Open
        let isOpenCheck = CheckBox()
        isOpenCheck.content = "Is Open"
        isOpenCheck.isChecked = true
        optionsPanel.children.append(isOpenCheck)
        bindIsOpen(infoBar: infoBar, checkBox: isOpenCheck)
        
        // “Severity” 标题
        let severityLabel = TextBlock()
        severityLabel.text = "Severity"
        severityLabel.margin = Thickness(left: 0, top: 12, right: 0, bottom: 0)
        optionsPanel.children.append(severityLabel)
        
        // Severity 下拉框
        let severityCombo = ComboBox()
        severityCombo.horizontalAlignment = .stretch
        
        let severities = ["Informational", "Success", "Warning", "Error"]
        for name in severities {
            let item = ComboBoxItem()
            item.content = name
            severityCombo.items.append(item)
        }
        severityCombo.selectedIndex = 0
        
        severityCombo.selectionChanged.addHandler { _, _ in
            let index = Int(severityCombo.selectedIndex)
            switch index {
            case 1:
                infoBar.severity = InfoBarSeverity.success
            case 2:
                infoBar.severity = InfoBarSeverity.warning
            case 3:
                infoBar.severity = InfoBarSeverity.error
            default:
                infoBar.severity = InfoBarSeverity.informational
            }
        }
        optionsPanel.children.append(severityCombo)
        
        // 放进 ControlExample
        let example = ControlExample()
        example.headerText = "A closable InfoBar with options to change its Severity."
        example.example = infoBar
        example.options = optionsPanel
        
        exampleStackPanel.children.append(example.view)
    }
    
    // MARK: - Example 2
    // A closable InfoBar with a long or short message and various buttons.
    
    private func setupExample2() {
        let infoBar = InfoBar()
        infoBar.isOpen = true
        infoBar.severity = InfoBarSeverity.informational
        infoBar.isIconVisible = true
        infoBar.isClosable = true
        infoBar.title = "Title"
        infoBar.message = "A long essential app message for your users to be informed of, acknowledge, or take action on. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dapibus dolor vitae justo rutrum, ut lobortis nibh mattis. Aenean id elit commodo, semper felis nec."
        
        // 右侧选项
        let optionsPanel = StackPanel()
        optionsPanel.orientation = .vertical
        optionsPanel.spacing = 8
        optionsPanel.width = 260
        
        // Is Open
        let isOpenCheck = CheckBox()
        isOpenCheck.content = "Is Open"
        isOpenCheck.isChecked = true
        optionsPanel.children.append(isOpenCheck)
        bindIsOpen(infoBar: infoBar, checkBox: isOpenCheck)
        
        // Message Length
        let messageLengthLabel = TextBlock()
        messageLengthLabel.text = "Message Length"
        messageLengthLabel.margin = Thickness(left: 0, top: 12, right: 0, bottom: 0)
        optionsPanel.children.append(messageLengthLabel)
        
        let messageCombo = ComboBox()
        messageCombo.horizontalAlignment = .stretch
        
        let shortItem = ComboBoxItem()
        shortItem.content = "Short"
        messageCombo.items.append(shortItem)
        
        let longItem = ComboBoxItem()
        longItem.content = "Long"
        messageCombo.items.append(longItem)
        
        messageCombo.selectedIndex = 1 // 默认 Long
        messageCombo.selectionChanged.addHandler { _, _ in
            let index = Int(messageCombo.selectedIndex)
            if index == 0 {
                let shortMessage = "A short essential app message."
                infoBar.message = shortMessage
            } else {
                infoBar.message = "A long essential app message for your users to be informed of, acknowledge, or take action on. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dapibus dolor vitae justo rutrum, ut lobortis nibh mattis. Aenean id elit commodo, semper felis nec."
            }
        }
        optionsPanel.children.append(messageCombo)
        
        // Action Button
        let actionLabel = TextBlock()
        actionLabel.text = "Action Button"
        actionLabel.margin = Thickness(left: 0, top: 12, right: 0, bottom: 0)
        optionsPanel.children.append(actionLabel)
        
        let actionCombo = ComboBox()
        actionCombo.horizontalAlignment = .stretch
        
        let noneItem = ComboBoxItem()
        noneItem.content = "None"
        actionCombo.items.append(noneItem)
        
        let buttonItem = ComboBoxItem()
        buttonItem.content = "Button"
        actionCombo.items.append(buttonItem)
        
        let hyperlinkItem = ComboBoxItem()
        hyperlinkItem.content = "Hyperlink"
        actionCombo.items.append(hyperlinkItem)
        
        actionCombo.selectedIndex = 0
        
        actionCombo.selectionChanged.addHandler { _, _ in
            let index = Int(actionCombo.selectedIndex)
            switch index {
            case 1: // Button
                let button = Button()
                button.content = "Action"
                infoBar.actionButton = button
            case 2: // Hyperlink
                let link = HyperlinkButton()
                link.content = "Informational link"
                link.navigateUri = Uri("https://www.microsoft.com")
                infoBar.actionButton = link
            default: // None
                infoBar.actionButton = nil
            }
        }
        optionsPanel.children.append(actionCombo)
        
        let example = ControlExample()
        example.headerText = "A closable InfoBar with a long or short message and various buttons"
        example.example = infoBar
        example.options = optionsPanel
        
        exampleStackPanel.children.append(example.view)
    }
    
    // MARK: - Example 3
    // A closable InfoBar with options to display the close button and icon.
    
    private func setupExample3() {
        let infoBar = InfoBar()
        infoBar.isOpen = true
        infoBar.severity = InfoBarSeverity.informational
        infoBar.isIconVisible = true
        infoBar.isClosable = true
        infoBar.title = "Title"
        infoBar.message = "Essential app message for your users to be informed of, acknowledge, or take action on."
        
        // 右侧选项
        let optionsPanel = StackPanel()
        optionsPanel.orientation = .vertical
        optionsPanel.spacing = 8
        optionsPanel.width = 220
        
        // Is Open
        let isOpenCheck = CheckBox()
        isOpenCheck.content = "Is Open"
        isOpenCheck.isChecked = true
        optionsPanel.children.append(isOpenCheck)
        bindIsOpen(infoBar: infoBar, checkBox: isOpenCheck)

        // Is Icon Visible
        let iconCheck = CheckBox()
        iconCheck.content = "Is Icon Visible"
        iconCheck.isChecked = true
        iconCheck.checked.addHandler { [weak infoBar] _, _ in
            infoBar?.isIconVisible = true
        }
        iconCheck.unchecked.addHandler { [weak infoBar] _, _ in
            infoBar?.isIconVisible = false
        }
        optionsPanel.children.append(iconCheck)
        
        // Is Closable
        let closableCheck = CheckBox()
        closableCheck.content = "Is Closable"
        closableCheck.isChecked = true
        closableCheck.checked.addHandler { [weak infoBar] _, _ in
            infoBar?.isClosable = true
        }
        closableCheck.unchecked.addHandler { [weak infoBar] _, _ in
            infoBar?.isClosable = false
        }
        optionsPanel.children.append(closableCheck)
        
        let example = ControlExample()
        example.headerText = "A closable InfoBar with options to display the close button and icon"
        example.example = infoBar
        example.options = optionsPanel
        
        exampleStackPanel.children.append(example.view)
    }
}
