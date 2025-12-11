import WinUI
import Foundation
import WindowsFoundation
import WinAppSDK
import UWP

class InfoBadgePage: Grid {

    // Root layout
    private let pageGrid = Grid()
    private let headerGrid = Grid()
    private let exampleStackPanel = StackPanel()

    // Example 1
    private var navigationView: NavigationView?
    private var inboxInfoBadge: InfoBadge?

    // Example 2
    private var styleIconBadge: InfoBadge?
    private var styleValueBadge: InfoBadge?
    private var styleDotBadge: InfoBadge?

    // Example 4
    private var dynamicInfoBadge: InfoBadge?

    override init() {
        super.init()

        setupRootLayout()
        setupHeader()
        setupExample1_EmbeddedInNavigationView()
        setupExample2_DifferentStyles()
        setupExample3_InsideAnotherControl()
        setupExample4_DynamicValue()

        self.children.append(pageGrid)
    }

    private func fluentIcon(hex: UInt32, size: Double = 16.0) -> FontIcon {
        let icon = FontIcon()

        // 使用 WinUI 提供的 SymbolThemeFontFamily（会指向 Segoe Fluent Icons 或 MDL2）
        if let app = Application.current,
        let resources = app.resources,
        let symbolFont = resources["SymbolThemeFontFamily"] as? FontFamily {
            icon.fontFamily = symbolFont
        }

        if let scalar = UnicodeScalar(hex) {
            icon.glyph = String(scalar)
        }

        icon.fontSize = size
        return icon
    }

    // MARK: - Root Layout + Header

    private func setupRootLayout() {
        // 两行：Header + 内容
        let rowHeader = RowDefinition()
        rowHeader.height = GridLength(value: 1, gridUnitType: .auto)
        let rowBody = RowDefinition()
        rowBody.height = GridLength(value: 1, gridUnitType: .star)

        pageGrid.rowDefinitions.append(rowHeader)
        pageGrid.rowDefinitions.append(rowBody)

        // Header 行
        pageGrid.children.append(headerGrid)

        // 内容行：ScrollViewer + StackPanel
        let scrollViewer = ScrollViewer()
        try? Grid.setRow(scrollViewer, 1)
        scrollViewer.padding = Thickness(left: 36, top: 0, right: 36, bottom: 24)
        scrollViewer.verticalScrollBarVisibility = .auto

        exampleStackPanel.spacing = 8
        scrollViewer.content = exampleStackPanel

        pageGrid.children.append(scrollViewer)
    }

    private func setupHeader() {
        let controlInfo = ControlInfo(
            title: "InfoBadge",
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
                    title: "InfoBadge - API",
                    uri: "https://learn.microsoft.com/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.controls.infobadge"
                ),
                ControlInfoDocLink(
                    title: "InfoBadge - Guidelines",
                    uri: "https://learn.microsoft.com/windows/apps/design/controls/infobadge"
                )
            ]
        )

        let pageHeader = PageHeader(item: controlInfo)
        pageHeader.themeButtonVisibility = .visible
        pageHeader.margin = Thickness(left: 36, top: 36, right: 36, bottom: 0)

        headerGrid.children.append(pageHeader)
    }

    // MARK: - Example 1: InfoBadge embedded in NavigationView

    private func makeSymbolIcon(_ symbolName: String) -> IconElement? {
        // 用 XamlReader 生成 SymbolIcon，这样图标和 WinUI Gallery 一致
        let xaml = """
<SymbolIcon xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
            Symbol="\(symbolName)" />
"""
        do {
            if let icon = try XamlReader.load(xaml) as? IconElement {
                return icon
            }
        } catch {
            print("SymbolIcon load failed: \(error)")
        }
        return nil
    }

    private func setupExample1_EmbeddedInNavigationView() {
        let exampleGrid = Grid()

        let nav = NavigationView()
        nav.height = 300
        nav.paneDisplayMode = NavigationViewPaneDisplayMode.left
        nav.isPaneOpen = true
        nav.isSettingsVisible = false
        navigationView = nav

        // Home
        let homeItem = NavigationViewItem()
        homeItem.content = "Home"
        homeItem.icon = fluentIcon(hex: 0xE80F)        // Home

        let accountItem = NavigationViewItem()
        accountItem.content = "Account"
        accountItem.icon = fluentIcon(hex: 0xE716)     // User / Contact

        let inboxItem = NavigationViewItem()
        inboxItem.content = "Inbox"
        inboxItem.icon = fluentIcon(hex: 0xE715)       // Mail

        let settingsItem = NavigationViewItem()
        settingsItem.content = "Settings"
        settingsItem.icon = fluentIcon(hex: 0xE713)

        let badge = InfoBadge()
        badge.value = 5
        badge.opacity = 1.0
        inboxInfoBadge = badge
        inboxItem.infoBadge = badge

        nav.menuItems.append(homeItem)
        nav.menuItems.append(accountItem)
        nav.menuItems.append(inboxItem)
        nav.menuItems.append(settingsItem)

        exampleGrid.children.append(nav)

        // 右侧 options
        let optionsPanel = StackPanel()
        optionsPanel.width = 160

        // Opacity 开关
        let opacityToggle = ToggleSwitch()
        opacityToggle.header = "InfoBadge Opacity"
        opacityToggle.isOn = true
        opacityToggle.toggled.addHandler { [weak self] sender, _ in
            guard let self = self,
                  let toggle = sender as? ToggleSwitch,
                  let badge = self.inboxInfoBadge
            else { return }

            badge.opacity = toggle.isOn ? 1.0 : 0.0
        }
        optionsPanel.children.append(opacityToggle)

        // Display Mode 选择
        let modeCombo = ComboBox()
        modeCombo.header = "Display Mode"

        let modes = ["LeftExpanded", "LeftCompact", "Top"]
        for m in modes {
            let item = ComboBoxItem()
            item.content = m
            modeCombo.items.append(item)
        }
        modeCombo.selectedIndex = 0

        modeCombo.selectionChanged.addHandler { [weak self] sender, _ in
            guard let self = self,
                  let nav = self.navigationView,
                  let combo = sender as? ComboBox
            else { return }

            let index = Int(combo.selectedIndex)
            guard index >= 0 && index < modes.count else { return }
            let mode = modes[index]

            switch mode {
            case "LeftExpanded":
                nav.paneDisplayMode = NavigationViewPaneDisplayMode.left
                nav.isPaneOpen = true
            case "LeftCompact":
                nav.paneDisplayMode = NavigationViewPaneDisplayMode.leftCompact
                nav.isPaneOpen = false
            case "Top":
                nav.paneDisplayMode = NavigationViewPaneDisplayMode.top
                nav.isPaneOpen = true
            default:
                break
            }
        }
        optionsPanel.children.append(modeCombo)

        let example = ControlExample(
            headerText: "InfoBadge embedded in NavigationView",
            isOutputDisplay: false,
            isOptionsDisplay: true,
            contentPresenter: exampleGrid,
            optionsPresenter: optionsPanel
        ).controlExample

        exampleStackPanel.children.append(example)
    }

    // MARK: - Example 2: Different InfoBadge Styles

    private func setupExample2_DifferentStyles() {
        let badgesPanel = StackPanel()
        badgesPanel.orientation = .horizontal
        badgesPanel.spacing = 20
        badgesPanel.horizontalAlignment = HorizontalAlignment.center

        // Icon InfoBadge
        let iconBadge = InfoBadge()
        iconBadge.horizontalAlignment = HorizontalAlignment.right
        styleIconBadge = iconBadge

        // Value InfoBadge
        let valueBadge = InfoBadge()
        valueBadge.horizontalAlignment = HorizontalAlignment.right
        valueBadge.value = 10
        styleValueBadge = valueBadge

        // Dot InfoBadge（不设置 value / iconSource，保持默认圆点）
        let dotBadge = InfoBadge()
        dotBadge.verticalAlignment = VerticalAlignment.center
        styleDotBadge = dotBadge

        badgesPanel.children.append(iconBadge)
        badgesPanel.children.append(valueBadge)
        badgesPanel.children.append(dotBadge)

        // 右侧 Style ComboBox
        let optionsPanel = StackPanel()
        optionsPanel.width = 160

        let styleCombo = ComboBox()
        styleCombo.header = "Styles"

        let styles = ["Attention", "Informational", "Success", "Critical"]
        for s in styles {
            let item = ComboBoxItem()
            item.content = s
            styleCombo.items.append(item)
        }
        styleCombo.selectedIndex = 0

        // 初始化为 Attention 样式
        applyStyleToBadges(styleKey: "Attention")

        styleCombo.selectionChanged.addHandler { [weak self] sender, _ in
            guard let self = self,
                  let combo = sender as? ComboBox
            else { return }

            let index = Int(combo.selectedIndex)
            guard index >= 0 && index < styles.count else { return }
            let styleName = styles[index]
            self.applyStyleToBadges(styleKey: styleName)
        }

        optionsPanel.children.append(styleCombo)

        let example = ControlExample(
            headerText: "Different InfoBadge Styles",
            isOutputDisplay: false,
            isOptionsDisplay: true,
            contentPresenter: badgesPanel,
            optionsPresenter: optionsPanel
        ).controlExample

        exampleStackPanel.children.append(example)
    }

    /// 用简单的颜色 + 字符模拟 Attention / Informational / Success / Critical 四种样式
    private func applyStyleToBadges(styleKey: String) {
        guard let iconBadge = styleIconBadge,
              let valueBadge = styleValueBadge,
              let dotBadge = styleDotBadge
        else { return }

        func color(_ a: UInt8, _ r: UInt8, _ g: UInt8, _ b: UInt8) -> Color {
            return Color(a: a, r: r, g: g, b: b)
        }

        func apply(iconGlyph: String, bg: Color, fg: Color) {
            let fontSource = FontIconSource()
            fontSource.glyph = iconGlyph
            iconBadge.iconSource = fontSource
            iconBadge.background = SolidColorBrush(bg)
            iconBadge.foreground = SolidColorBrush(fg)

            valueBadge.background = SolidColorBrush(bg)
            valueBadge.foreground = SolidColorBrush(fg)

            dotBadge.background = SolidColorBrush(bg)
        }

        switch styleKey {
        case "Informational":
            // 灰色 info
            apply(
                iconGlyph: "i",
                bg: color(0xFF, 0x60, 0x60, 0x60),
                fg: color(0xFF, 0xFF, 0xFF, 0xFF)
            )
        case "Success":
            // 绿色 ✓
            apply(
                iconGlyph: "✓",
                bg: color(0xFF, 0x10, 0x7C, 0x10),
                fg: color(0xFF, 0xFF, 0xFF, 0xFF)
            )
        case "Critical":
            // 红色 ✕
            apply(
                iconGlyph: "✕",
                bg: color(0xFF, 0xC4, 0x2B, 0x1C),
                fg: color(0xFF, 0xFF, 0xFF, 0xFF)
            )
        default: // Attention（蓝色 ！）
            apply(
                iconGlyph: "!",
                bg: color(0xFF, 0x00, 0x78, 0xD4),
                fg: color(0xFF, 0xFF, 0xFF, 0xFF)
            )
        }
    }

    // MARK: - Example 3: InfoBadge inside another control

    private func setupExample3_InsideAnotherControl() {
        let button = Button()
        button.width = 200
        button.height = 60
        button.padding = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        button.horizontalAlignment = HorizontalAlignment.center
        button.horizontalContentAlignment = HorizontalAlignment.stretch
        button.verticalContentAlignment = VerticalAlignment.stretch

        let grid = Grid()

        // 中间的“刷新”符号（简单用文本代替）
        let iconText = TextBlock()
        iconText.text = "⟳"
        iconText.fontSize = 24
        iconText.horizontalAlignment = HorizontalAlignment.center
        iconText.verticalAlignment = VerticalAlignment.center
        grid.children.append(iconText)

        // 右上角红色 InfoBadge
        let badge = InfoBadge()
        badge.horizontalAlignment = HorizontalAlignment.right
        badge.verticalAlignment = VerticalAlignment.top
        badge.background = SolidColorBrush(Color(a: 0xFF, r: 0xC4, g: 0x2B, b: 0x1C))
        grid.children.append(badge)

        button.content = grid

        let example = ControlExample(
            headerText: "Placing an InfoBadge inside another control",
            isOutputDisplay: false,
            isOptionsDisplay: false,
            contentPresenter: button
        ).controlExample

        exampleStackPanel.children.append(example)
    }
    // MARK: - Example 4: InfoBadge with Dynamic Value
    private func setupExample4_DynamicValue() {
        // ===== 左侧要显示的 InfoBadge =====
        let badge = InfoBadge()
        badge.horizontalAlignment = .center
        badge.value = 1
        dynamicInfoBadge = badge

        // ===== 右侧 options 区域 =====
        let optionsPanel = StackPanel()
        optionsPanel.width = 180

        let headerText = TextBlock()
        headerText.text = "InfoBadge Value"
        optionsPanel.children.append(headerText)

        // ===== 一行：TextBox | Up/Down 按钮 =====
        let numberPanel = Grid()
        // 两列：左边 TextBox，右边按钮列
        let colText = ColumnDefinition()
        colText.width = GridLength(value: 1, gridUnitType: .star)
        let colButtons = ColumnDefinition()
        colButtons.width = GridLength(value: 32, gridUnitType: .auto)
        numberPanel.columnDefinitions.append(colText)
        numberPanel.columnDefinitions.append(colButtons)

        // ---- 左边 TextBox ----
        let valueTextBox = TextBox()
        valueTextBox.text = "1"
        valueTextBox.height = 32
        valueTextBox.horizontalAlignment = .stretch
        try? Grid.setColumn(valueTextBox, 0)

        func updateFromText() {
            guard let badge = self.dynamicInfoBadge else { return }
            let text = valueTextBox.text
            if let number = Int(text), number >= -1 {
                badge.value = Int32(number)
            }
        }

        valueTextBox.textChanged.addHandler { [weak self] _, _ in
            guard self != nil else { return }
            updateFromText()
        }

        numberPanel.children.append(valueTextBox)

        // ---- 右边上下两个按钮（堆成一列） ----
        let buttonsGrid = Grid()
        let rowUp = RowDefinition()
        rowUp.height = GridLength(value: 1, gridUnitType: .auto)
        let rowDown = RowDefinition()
        rowDown.height = GridLength(value: 1, gridUnitType: .auto)
        buttonsGrid.rowDefinitions.append(rowUp)
        buttonsGrid.rowDefinitions.append(rowDown)
        buttonsGrid.width = 40
        try? Grid.setColumn(buttonsGrid, 1)

        // 上箭头
        let upButton = Button()
        upButton.width = 40
        upButton.height = 16
        upButton.horizontalContentAlignment = .center
        upButton.verticalContentAlignment = .center
        upButton.content = fluentIcon(hex: 0xE70E, size: 10.0)   // ChevronUp
        try? Grid.setRow(upButton, 0)

        upButton.click.addHandler { [weak self] _, _ in
            guard let self = self else { return }
            let currentFromText = Int(valueTextBox.text) ?? Int(self.dynamicInfoBadge?.value ?? 0)
            let next = currentFromText + 1
            self.dynamicInfoBadge?.value = Int32(next)
            valueTextBox.text = String(next)
        }

        // 下箭头
        let downButton = Button()
        downButton.width = 40
        downButton.height = 16
        downButton.horizontalContentAlignment = .center
        downButton.verticalContentAlignment = .center
        downButton.content = fluentIcon(hex: 0xE70D, size: 10.0)  // ChevronDown
        try? Grid.setRow(downButton, 1)

        downButton.click.addHandler { [weak self] _, _ in
            guard let self = self else { return }
            let currentFromText = Int(valueTextBox.text) ?? Int(self.dynamicInfoBadge?.value ?? 0)
            let next = max(-1, currentFromText - 1)
            self.dynamicInfoBadge?.value = Int32(next)
            valueTextBox.text = String(next)
        }

        buttonsGrid.children.append(upButton)
        buttonsGrid.children.append(downButton)

        numberPanel.children.append(buttonsGrid)

        optionsPanel.children.append(numberPanel)

        // ===== 把左侧 InfoBadge + 右侧 options 打包成示例卡片 =====
        let example = ControlExample(
            headerText: "InfoBadge with Dynamic Value",
            isOutputDisplay: false,
            isOptionsDisplay: true,
            contentPresenter: badge,
            optionsPresenter: optionsPanel
        ).controlExample

        exampleStackPanel.children.append(example)
    }


}
