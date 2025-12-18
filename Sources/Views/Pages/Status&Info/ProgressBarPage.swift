import WinUI
import Foundation
import WindowsFoundation
import WinAppSDK
import UWP

class ProgressBarPage: Grid {

    private let exampleStackPanel = StackPanel()

    override init() {
        super.init()
        setupLayout()
        setupExample1_Indeterminate()
        setupExample2_Determinate()
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

        // Header 区域
        let headerGrid = Grid()
        try? Grid.setRow(headerGrid, 0)
        self.children.append(headerGrid)

        let controlInfo = ControlInfo(
            title: "ProgressBar",
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
                    title: "ProgressBar - API",
                    uri: "https://learn.microsoft.com/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.controls.progressbar"
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

        // Content：ScrollViewer + StackPanel
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

    // MARK: - Example 1: An indeterminate progress bar.

    private func setupExample1_Indeterminate() {
        // 左侧内容：不确定型 ProgressBar
        let progressBar = ProgressBar()
        progressBar.isIndeterminate = true
        progressBar.showPaused = false
        progressBar.showError = false
        progressBar.horizontalAlignment = .stretch

        // 右侧选项
        let optionsPanel = StackPanel()
        optionsPanel.orientation = .vertical
        optionsPanel.spacing = 8
        optionsPanel.width = 220

        let stateLabel = TextBlock()
        stateLabel.text = "Progress state"
        optionsPanel.children.append(stateLabel)

        // 使用 RadioButtons 作为状态选择器
        let stateRadios = RadioButtons()
        stateRadios.items.append("Running")
        stateRadios.items.append("Paused")
        stateRadios.items.append("Error")
        stateRadios.selectedIndex = 0
        optionsPanel.children.append(stateRadios)

        stateRadios.selectionChanged.addHandler { _, _ in
            let index = Int(stateRadios.selectedIndex)

            switch index {
            case 1: // Paused
                progressBar.showPaused = true
                progressBar.showError = false
            case 2: // Error
                progressBar.showPaused = false
                progressBar.showError = true
            default: // Running
                progressBar.showPaused = false
                progressBar.showError = false
            }
        }

        let example = ControlExample()
        example.headerText = "An indeterminate progress bar."
        example.example = progressBar
        example.options = optionsPanel

        exampleStackPanel.children.append(example.view)
    }

    // MARK: - Example 2: A determinate progress bar.

    private func setupExample2_Determinate() {
        // 整个内容区域用 Grid：左边 ProgressBar，右边 Progress+值控件
        let contentGrid = Grid()

        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 1, gridUnitType: .star)
        let col2 = ColumnDefinition()
        col2.width = GridLength(value: 240, gridUnitType: .auto)
        contentGrid.columnDefinitions.append(col1)
        contentGrid.columnDefinitions.append(col2)

        // 左：确定型 ProgressBar
        let progressBar = ProgressBar()
        progressBar.isIndeterminate = false
        progressBar.minimum = 0
        progressBar.maximum = 100
        progressBar.value = 0
        progressBar.horizontalAlignment = .stretch
        progressBar.margin = Thickness(left: 0, top: 12, right: 24, bottom: 12)
        try? Grid.setColumn(progressBar, 0)
        contentGrid.children.append(progressBar)

        // 右：Progress + 伪 NumberBox
        let rightPanel = StackPanel()
        rightPanel.orientation = .horizontal
        rightPanel.spacing = 8
        rightPanel.verticalAlignment = .center
        try? Grid.setColumn(rightPanel, 1)
        contentGrid.children.append(rightPanel)

        let label = TextBlock()
        label.text = "Progress"
        rightPanel.children.append(label)

        // 数值编辑区域（TextBox + 上/下按钮）
        let numberGrid = Grid()
        numberGrid.margin = Thickness(left: 4, top: 0, right: 0, bottom: 0)

        let numCol1 = ColumnDefinition()
        numCol1.width = GridLength(value: 1, gridUnitType: .star)
        let numCol2 = ColumnDefinition()
        numCol2.width = GridLength(value: 32, gridUnitType: .auto)
        numberGrid.columnDefinitions.append(numCol1)
        numberGrid.columnDefinitions.append(numCol2)

        // 左边 TextBox
        let valueTextBox = TextBox()
        valueTextBox.text = "0"
        valueTextBox.width = 80
        valueTextBox.height = 32
        valueTextBox.horizontalAlignment = .stretch
        try? Grid.setColumn(valueTextBox, 0)
        numberGrid.children.append(valueTextBox)

        // 右边上下两个按钮
        let buttonsGrid = Grid()
        let btnRowUp = RowDefinition()
        btnRowUp.height = GridLength(value: 1, gridUnitType: .auto)
        let btnRowDown = RowDefinition()
        btnRowDown.height = GridLength(value: 1, gridUnitType: .auto)
        buttonsGrid.rowDefinitions.append(btnRowUp)
        buttonsGrid.rowDefinitions.append(btnRowDown)
        buttonsGrid.width = 40
        try? Grid.setColumn(buttonsGrid, 1)
        numberGrid.children.append(buttonsGrid)

        func clampValue(_ v: Int) -> Int {
            if v < 0 { return 0 }
            if v > 100 { return 100 }
            return v
        }

        func applyTextBoxValue() {
            let text = valueTextBox.text
            if let number = Int(text) {
                let clamped = clampValue(number)
                progressBar.value = Double(clamped)
                valueTextBox.text = String(clamped)
            } else {
                // 模仿原 C#：NaN / 非数字时强制重置为 0
                progressBar.value = 0
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
            let current = Int(valueTextBox.text) ?? Int(progressBar.value)
            let next = clampValue(current + 1)
            progressBar.value = Double(next)
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
            let current = Int(valueTextBox.text) ?? Int(progressBar.value)
            let next = clampValue(current - 1)
            progressBar.value = Double(next)
            valueTextBox.text = String(next)
        }
        buttonsGrid.children.append(downButton)

        // 文本改动时，同步到进度条
        valueTextBox.textChanged.addHandler { _, _ in
            applyTextBoxValue()
        }

        numberGrid.height = 32
        rightPanel.children.append(numberGrid)

        let example = ControlExample()
        example.headerText = "A determinate progress bar."
        example.example = contentGrid

        exampleStackPanel.children.append(example.view)
    }

    // MARK: - Fluent Icon helpers

    /// 用 Fluent 字体画一个向上尖角（类似 NumberBox 的上箭头）
    private func fluentChevronUpIcon() -> FontIcon {
        let icon = FontIcon()

        if let app = Application.current,
           let resources = app.resources,
           let font = resources["SymbolThemeFontFamily"] as? FontFamily {
            icon.fontFamily = font
        }

        // 0xE70E = ChevronUp
        if let scalar = UnicodeScalar(0xE70E) {
            icon.glyph = String(scalar)
        }
        icon.fontSize = 10.0
        return icon
    }

    /// 用 Fluent 字体画一个向下尖角
    private func fluentChevronDownIcon() -> FontIcon {
        let icon = FontIcon()

        if let app = Application.current,
           let resources = app.resources,
           let font = resources["SymbolThemeFontFamily"] as? FontFamily {
            icon.fontFamily = font
        }

        // 0xE70D = ChevronDown
        if let scalar = UnicodeScalar(0xE70D) {
            icon.glyph = String(scalar)
        }
        icon.fontSize = 10.0
        return icon
    }
}
