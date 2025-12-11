import WinUI
import Foundation
import WindowsFoundation
import WinAppSDK
import UWP

class ProgressRingPage: Grid {

    private let exampleStackPanel = StackPanel()

    override init() {
        super.init()
        setupLayout()
        setupExample1_Indeterminate()
        setupExample2_Determinate()
    }

    // MARK: - 基础布局：Header + ScrollViewer + StackPanel

    private func setupLayout() {
        let headerRow = RowDefinition()
        headerRow.height = GridLength(value: 1, gridUnitType: .auto)
        let contentRow = RowDefinition()
        contentRow.height = GridLength(value: 1, gridUnitType: .star)
        rowDefinitions.append(headerRow)
        rowDefinitions.append(contentRow)

        // Header
        let headerGrid = Grid()
        try? Grid.setRow(headerGrid, 0)
        children.append(headerGrid)

        let controlInfo = ControlInfo(
            title: "ProgressRing",
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
                    title: "ProgressRing - API",
                    uri: "https://learn.microsoft.com/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.controls.progressring"
                ),
                ControlInfoDocLink(
                    title: "Guidelines",
                    uri: "https://learn.microsoft.com/windows/apps/design/controls/progress-controls"
                )
            ]
        )

        let pageHeader = PageHeader(item: controlInfo)
        pageHeader.themeButtonVisibility = .visible
        pageHeader.margin = Thickness(left: 36, top: 36, right: 36, bottom: 0)
        headerGrid.children.append(pageHeader)

        // Content
        let scrollViewer = ScrollViewer()
        scrollViewer.verticalScrollMode = .auto
        scrollViewer.verticalScrollBarVisibility = .auto
        try? Grid.setRow(scrollViewer, 1)
        children.append(scrollViewer)

        exampleStackPanel.orientation = .vertical
        exampleStackPanel.spacing = 24
        exampleStackPanel.margin = Thickness(left: 36, top: 24, right: 36, bottom: 36)
        scrollViewer.content = exampleStackPanel
    }

    // MARK: - 示例 1：不确定型 ProgressRing

    private func setupExample1_Indeterminate() {
        // 左侧 ProgressRing
        let ring = ProgressRing()
        ring.isActive = true
        ring.isIndeterminate = true
        ring.horizontalAlignment = .left
        ring.verticalAlignment = .center
        ring.width = 40
        ring.height = 40

        // 右侧 Options
        let optionsPanel = StackPanel()
        optionsPanel.orientation = .vertical
        optionsPanel.spacing = 8
        optionsPanel.width = 240

        let optionsLabel = TextBlock()
        optionsLabel.text = "Progress Options"
        optionsPanel.children.append(optionsLabel)

        // Working Toggle
        let workingSwitch = ToggleSwitch()
        workingSwitch.header = "Working"
        workingSwitch.isOn = true
        workingSwitch.toggled.addHandler { [weak ring] _, _ in
            ring?.isActive = workingSwitch.isOn
        }
        optionsPanel.children.append(workingSwitch)

        // Background color
        let bgLabel = TextBlock()
        bgLabel.text = "Background color"
        bgLabel.margin = Thickness(left: 0, top: 12, right: 0, bottom: 0)
        optionsPanel.children.append(bgLabel)

        let bgCombo = ComboBox()
        bgCombo.placeholderText = "Pick a color"
        bgCombo.horizontalAlignment = .stretch

        for name in ["Transparent", "LightGray"] {
            let item = ComboBoxItem()
            item.content = name
            bgCombo.items.append(item)
        }

        bgCombo.selectionChanged.addHandler { _, _ in
            guard let item = bgCombo.selectedItem as? ComboBoxItem,
                  let name = item.content as? String
            else { return }

            ring.background = self.backgroundBrush(for: name)
        }

        optionsPanel.children.append(bgCombo)

        let example = ControlExample(
            headerText: "An indeterminate progress ring.",
            isOutputDisplay: false,
            isOptionsDisplay: true,
            contentPresenter: ring,
            optionsPresenter: optionsPanel
        ).controlExample

        exampleStackPanel.children.append(example)
    }

    // MARK: - 示例 2：确定型 ProgressRing

    private func setupExample2_Determinate() {
        // 左侧：ring + “Progress” 伪 NumberBox
        let leftPanel = StackPanel()
        leftPanel.orientation = .horizontal
        leftPanel.spacing = 12
        leftPanel.verticalAlignment = .center

        let ring = ProgressRing()
        ring.isActive = true
        ring.isIndeterminate = false
        ring.minimum = 0
        ring.maximum = 100
        ring.value = 0
        ring.width = 40
        ring.height = 40
        leftPanel.children.append(ring)

        let valuePanel = StackPanel()
        valuePanel.orientation = .vertical
        valuePanel.spacing = 4

        let label = TextBlock()
        label.text = "Progress"
        valuePanel.children.append(label)

        // 伪 NumberBox：TextBox + 上/下按钮
        let numberGrid = Grid()
        let colText = ColumnDefinition()
        colText.width = GridLength(value: 1, gridUnitType: .star)
        let colButtons = ColumnDefinition()
        colButtons.width = GridLength(value: 32, gridUnitType: .auto)
        numberGrid.columnDefinitions.append(colText)
        numberGrid.columnDefinitions.append(colButtons)

        let valueTextBox = TextBox()
        valueTextBox.text = "0"
        valueTextBox.width = 80
        valueTextBox.height = 32
        valueTextBox.horizontalAlignment = .stretch
        try? Grid.setColumn(valueTextBox, 0)
        numberGrid.children.append(valueTextBox)

        let buttonsGrid = Grid()
        let rowUp = RowDefinition()
        rowUp.height = GridLength(value: 1, gridUnitType: .auto)
        let rowDown = RowDefinition()
        rowDown.height = GridLength(value: 1, gridUnitType: .auto)
        buttonsGrid.rowDefinitions.append(rowUp)
        buttonsGrid.rowDefinitions.append(rowDown)
        buttonsGrid.width = 40
        try? Grid.setColumn(buttonsGrid, 1)
        numberGrid.children.append(buttonsGrid)

        func clamp(_ v: Int) -> Int {
            if v < 0 { return 0 }
            if v > 100 { return 100 }
            return v
        }

        func applyTextBoxValue() {
            let text = valueTextBox.text
            if let number = Int(text) {
                let c = clamp(number)
                ring.value = Double(c)
                valueTextBox.text = String(c)
            } else {
                // 对应原 C#：NaN 时重置为 0
                ring.value = 0
                valueTextBox.text = "0"
            }
        }

        // 上按钮
        let upButton = Button()
        upButton.width = 40
        upButton.height = 16
        upButton.horizontalContentAlignment = .center
        upButton.verticalContentAlignment = .center
        upButton.content = fluentChevronUpIcon()
        try? Grid.setRow(upButton, 0)
        upButton.click.addHandler { _, _ in
            let current = Int(valueTextBox.text) ?? Int(ring.value)
            let next = clamp(current + 1)
            ring.value = Double(next)
            valueTextBox.text = String(next)
        }
        buttonsGrid.children.append(upButton)

        // 下按钮
        let downButton = Button()
        downButton.width = 40
        downButton.height = 16
        downButton.horizontalContentAlignment = .center
        downButton.verticalContentAlignment = .center
        downButton.content = fluentChevronDownIcon()
        try? Grid.setRow(downButton, 1)
        downButton.click.addHandler { _, _ in
            let current = Int(valueTextBox.text) ?? Int(ring.value)
            let next = clamp(current - 1)
            ring.value = Double(next)
            valueTextBox.text = String(next)
        }
        buttonsGrid.children.append(downButton)

        valueTextBox.textChanged.addHandler { _, _ in
            applyTextBoxValue()
        }

        numberGrid.height = 32
        valuePanel.children.append(numberGrid)

        leftPanel.children.append(valuePanel)

        // 右侧：Background color 选项
        let optionsPanel = StackPanel()
        optionsPanel.orientation = .vertical
        optionsPanel.spacing = 8
        optionsPanel.width = 220

        let bgLabel = TextBlock()
        bgLabel.text = "Background color"
        optionsPanel.children.append(bgLabel)

        let bgCombo = ComboBox()
        bgCombo.placeholderText = "Pick a color"
        bgCombo.horizontalAlignment = .stretch

        for name in ["Transparent", "LightGray"] {
            let item = ComboBoxItem()
            item.content = name
            bgCombo.items.append(item)
        }

        bgCombo.selectionChanged.addHandler { _, _ in
            guard let item = bgCombo.selectedItem as? ComboBoxItem,
                  let name = item.content as? String
            else { return }
            ring.background = self.backgroundBrush(for: name)
        }

        optionsPanel.children.append(bgCombo)

        let example = ControlExample(
            headerText: "A determinate progress ring.",
            isOutputDisplay: false,
            isOptionsDisplay: true,
            contentPresenter: leftPanel,
            optionsPresenter: optionsPanel
        ).controlExample

        exampleStackPanel.children.append(example)
    }

    // MARK: - 背景颜色辅助

    private func backgroundBrush(for name: String) -> SolidColorBrush {
        switch name {
        case "LightGray":
            // ARGB(255, 211, 211, 211)
            return SolidColorBrush(Color(a: 0xFF, r: 0xD3, g: 0xD3, b: 0xD3))
        default: // "Transparent" 或其他
            return SolidColorBrush(Color(a: 0x00, r: 0x00, g: 0x00, b: 0x00))
        }
    }

    // MARK: - Fluent Icon helpers（复用 ProgressBarPage 的做法）

    private func fluentChevronUpIcon() -> FontIcon {
        let icon = FontIcon()

        if let app = Application.current,
           let resources = app.resources,
           let font = resources["SymbolThemeFontFamily"] as? FontFamily {
            icon.fontFamily = font
        }

        if let scalar = UnicodeScalar(0xE70E) { // ChevronUp
            icon.glyph = String(scalar)
        }
        icon.fontSize = 10.0
        return icon
    }

    private func fluentChevronDownIcon() -> FontIcon {
        let icon = FontIcon()

        if let app = Application.current,
           let resources = app.resources,
           let font = resources["SymbolThemeFontFamily"] as? FontFamily {
            icon.fontFamily = font
        }

        if let scalar = UnicodeScalar(0xE70D) { // ChevronDown
            icon.glyph = String(scalar)
        }
        icon.fontSize = 10.0
        return icon
    }
}
