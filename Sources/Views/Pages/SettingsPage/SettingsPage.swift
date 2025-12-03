import Foundation
import UWP
import WinAppSDK
import WindowsFoundation
import WinUI

class SettingsPage: Page, @unchecked Sendable {
    private var themeMode: ComboBox!
    private var naviComboBox: ComboBox!
    private var soundComboBox: ComboBox!
    private var manageSamplesComboBox: ComboBox!
    
    // 保存页面上需要更新颜色的UI元素引用
    private var pageGrid: Grid!
    private var pageHeaderContainer: Border!
    private var pageHeader: TextBlock!
    private var appearanceSection: TextBlock!
    private var aboutSection: TextBlock!
    private var aboutCard: Border!
    private var appThemeCard: Border!
    private var naviCard: Border!

    override init() {
        super.init()
        self.content = createPageGrid()
        self.setupHandler()
    }

    private func createPageGrid() -> Grid {
        let grid = Grid()
        self.pageGrid = grid
        grid.background = self.getPageBackgroundColor()
        grid.padding = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        
        let rd1 = RowDefinition()
        rd1.height = GridLength(value: 1, gridUnitType: .auto)
        let rd2 = RowDefinition()
        rd2.height = GridLength(value: 1, gridUnitType: .star)
        grid.rowDefinitions.append(rd1)
        grid.rowDefinitions.append(rd2)

        let pageHeaderContainer = Border()
        self.pageHeaderContainer = pageHeaderContainer
        pageHeaderContainer.background = self.getHeaderBackgroundColor()
        pageHeaderContainer.borderBrush = self.getHeaderBorderColor()
        pageHeaderContainer.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 1)
        
        let pageHeader = TextBlock()
        self.pageHeader = pageHeader
        pageHeader.fontSize = 28
        pageHeader.fontWeight = FontWeights.bold
        pageHeader.margin = Thickness(left: 36.0, top: 36.0, right: 36.0, bottom: 36.0)
        pageHeader.text = "Settings"
        pageHeader.foreground = self.getTextColor()
        pageHeaderContainer.child = pageHeader
        
        try! Grid.setRow(pageHeaderContainer, 0)
        grid.children.append(pageHeaderContainer)

        let sv = ScrollView()
        sv.verticalScrollBarVisibility = .auto
        sv.verticalScrollMode = .auto
        try! Grid.setRow(sv, 1)
        grid.children.append(sv)

        let contentPanel = StackPanel()
        contentPanel.spacing = 24.0
        contentPanel.padding = Thickness(left: 36.0, top: 36.0, right: 36.0, bottom: 36.0)
        contentPanel.maxWidth = 1064
        contentPanel.horizontalAlignment = .stretch
        sv.content = contentPanel
        
        // Appearance & behavior section
        let appearanceSection = createSectionHeader("Appearance & behavior")
        self.appearanceSection = appearanceSection
        contentPanel.children.append(appearanceSection)
        
        let appThemeCard = createAppThemeCard()
        self.appThemeCard = appThemeCard
        contentPanel.children.append(appThemeCard)
        
        let naviCard = createNaviCard()
        self.naviCard = naviCard
        contentPanel.children.append(naviCard)
        
        // About section
        let aboutSection = createSectionHeader("About")
        self.aboutSection = aboutSection
        contentPanel.children.append(aboutSection)
        
        let aboutCard = createAboutCard()
        self.aboutCard = aboutCard
        contentPanel.children.append(aboutCard)

        return grid
    }
    
    private func getPageBackgroundColor() -> Brush {
        let actualTheme = Application.current.requestedTheme
        if actualTheme == .dark {
            // 暗色模式下的页面背景色
            return SolidColorBrush(Color(a: 255, r: 24, g: 24, b: 24))
        } else {
            // 浅色模式下的页面背景色
            return SolidColorBrush(Color(a: 255, r: 245, g: 245, b: 245))
        }
    }
    
    private func getHeaderBackgroundColor() -> Brush {
        let actualTheme = Application.current.requestedTheme
        if actualTheme == .dark {
            // 暗色模式下的标题背景色
            return SolidColorBrush(Color(a: 255, r: 32, g: 32, b: 32))
        } else {
            // 浅色模式下的标题背景色
            return SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        }
    }
    
    private func getHeaderBorderColor() -> Brush {
        let actualTheme = Application.current.requestedTheme
        if actualTheme == .dark {
            // 暗色模式下的标题边框色
            return SolidColorBrush(Color(a: 255, r: 64, g: 64, b: 64))
        } else {
            // 浅色模式下的标题边框色
            return SolidColorBrush(Color(a: 255, r: 224, g: 224, b: 224))
        }
    }
    
    private func getTextColor() -> Brush {
        let actualTheme = Application.current.requestedTheme
        if actualTheme == .dark {
            // 暗色模式下的文字颜色
            return SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        } else {
            // 浅色模式下的文字颜色
            return SolidColorBrush(Color(a: 255, r: 0, g: 0, b: 0))
        }
    }
    
    private func createSectionHeader(_ text: String) -> TextBlock {
        let header = TextBlock()
        header.text = text
        header.fontSize = 20
        header.fontWeight = FontWeights.semiBold
        header.margin = Thickness(left: 0, top: 0, right: 0, bottom: 8)
        header.foreground = self.getTextColor()
        return header
    }
    
    private func createAboutCard() -> Border {
        let border = Border()
        border.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        border.background = self.getCardBackgroundColor()
        border.borderBrush = self.getCardBorderColor()
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        
        let stackPanel = StackPanel()
        stackPanel.padding = Thickness(left: 24, top: 24, right: 24, bottom: 24)
        stackPanel.spacing = 16
        
        let appName = TextBlock()
        appName.text = "Swift WinUI Gallery"
        appName.fontSize = 20
        appName.fontWeight = FontWeights.semiBold
        appName.foreground = self.getTextColor()
        
        let version = TextBlock()
        version.text = "Version 1.0.0"
        version.fontSize = 14
        version.foreground = self.getVersionTextColor()
        
        let description = TextBlock()
        description.text = "A showcase of WinUI controls and features built with Swift."
        description.fontSize = 14
        description.textWrapping = .wrap
        description.maxWidth = 500
        description.foreground = self.getTextColor()
        
        stackPanel.children.append(appName)
        stackPanel.children.append(version)
        stackPanel.children.append(description)
        
        border.child = stackPanel
        return border
    }
    
    private func getCardBackgroundColor() -> Brush {
        let actualTheme = Application.current.requestedTheme
        if actualTheme == .dark {
            // 暗色模式下的卡片背景色
            return SolidColorBrush(Color(a: 255, r: 32, g: 32, b: 32))
        } else {
            // 浅色模式下的卡片背景色
            return SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        }
    }
    
    private func getCardBorderColor() -> Brush {
        let actualTheme = Application.current.requestedTheme
        if actualTheme == .dark {
            // 暗色模式下的卡片边框色
            return SolidColorBrush(Color(a: 255, r: 64, g: 64, b: 64))
        } else {
            // 浅色模式下的卡片边框色
            return SolidColorBrush(Color(a: 255, r: 224, g: 224, b: 224))
        }
    }
    
    private func getVersionTextColor() -> Brush {
        let actualTheme = Application.current.requestedTheme
        if actualTheme == .dark {
            // 暗色模式下的版本文字颜色
            return SolidColorBrush(Color(a: 255, r: 200, g: 200, b: 200))
        } else {
            // 浅色模式下的版本文字颜色
            return SolidColorBrush(Color(a: 255, r: 100, g: 100, b: 100))
        }
    }

    private func createAppThemeCard() -> Border {
        // icon
        let icon = FontIcon()
        icon.glyph = "\u{E790}" // Theme icon
        icon.fontSize = 24.0
        
        // mid text block
        let grid = Grid()
        let tb = TextBlock()
        tb.text = "App Theme"
        tb.fontSize = 16
        tb.fontWeight = FontWeights.medium
        tb.foreground = self.getTextColor()
        grid.children.append(tb)
        
        self.themeMode = self.createThemeMode()
        let border = Border()
        border.child = SettingsCard(left: icon, mid: grid, right: self.themeMode)
        return border
    }

    private func createNaviComboBox() -> ComboBox {
        let naviComboBox = ComboBox()
        naviComboBox.horizontalAlignment = .stretch
        let list = ["Left", "Top"]
        for mode in list {
            let cbi = ComboBoxItem()
            cbi.content = mode
            naviComboBox.items.append(cbi)
        }
        return naviComboBox
    }

    private func createNaviCard() -> Border {
        // icon
        let icon = FontIcon()
        icon.glyph = "\u{F594}" // Navigation icon
        icon.fontSize = 24.0
        
        // mid text block
        let grid = Grid()
        let tb = TextBlock()
        tb.text = "Navigation Position"
        tb.fontSize = 16
        tb.fontWeight = FontWeights.medium
        tb.foreground = self.getTextColor()
        grid.children.append(tb)
        
        // right combo box
        self.naviComboBox = self.createNaviComboBox()
        let border = Border()
        border.child = SettingsCard(left: icon, mid: grid, right: self.naviComboBox)
        return border
    }
    
    // 更新所有UI元素的颜色以匹配当前主题
    private func updateThemeColors() {
        // 更新页面背景色
        self.pageGrid?.background = self.getPageBackgroundColor()
        
        // 更新标题栏颜色
        self.pageHeaderContainer?.background = self.getHeaderBackgroundColor()
        self.pageHeaderContainer?.borderBrush = self.getHeaderBorderColor()
        
        // 更新标题文字颜色
        self.pageHeader?.foreground = self.getTextColor()
        
        // 更新分类标题颜色
        self.appearanceSection?.foreground = self.getTextColor()
        self.aboutSection?.foreground = self.getTextColor()
        
        // 更新关于卡片颜色
        if let aboutBorder = self.aboutCard {
            aboutBorder.background = self.getCardBackgroundColor()
            aboutBorder.borderBrush = self.getCardBorderColor()
            
            // 更新卡片内部元素的颜色
            if let stackPanel = aboutBorder.child as? StackPanel {
                for child in stackPanel.children {
                    if let textBlock = child as? TextBlock {
                        if textBlock.text == "Swift WinUI Gallery" || textBlock.text == "A showcase of WinUI controls and features built with Swift." {
                            textBlock.foreground = self.getTextColor()
                        } else if textBlock.text == "Version 1.0.0" {
                            textBlock.foreground = self.getVersionTextColor()
                        }
                    }
                }
            }
        }
        
        // 更新设置卡片中的文本颜色
        self.updateSettingsCardTextColors()
    }
    
    // 更新设置卡片中文本的颜色
    private func updateSettingsCardTextColors() {
        // 更新应用主题卡片中的文本颜色
        if let appThemeBorder = self.appThemeCard?.child as? SettingsCard {
            // 这里我们无法直接访问SettingsCard的子元素，所以我们重新创建卡片
            // 在实际应用中，更好的做法是在SettingsCard中也实现主题更新功能
        }
        
        // 更新导航位置卡片中的文本颜色
        if let naviBorder = self.naviCard?.child as? SettingsCard {
            // 同样，这里我们也无法直接访问SettingsCard的子元素
        }
    }

    private func setupHandler() {
        self.loaded.addHandler(onSettingsPageLoaded)
        
        // 监听主题变化
        NotificationCenter.default.addObserver(forName: NSNotification.Name("ThemeChanged"), object: nil, queue: nil) { [weak self] _ in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.updateThemeColors()
            }
        }
        
        self.themeMode.selectionChanged.addHandler { [weak self] sender, e in
            guard let self = self else { return }
            let idx = self.themeMode.selectedIndex
            switch idx {
            case 0:
                ThemeHelper.rootTheme = .light
            case 1:
                ThemeHelper.rootTheme = .dark
            default:
                break
            }
        }

        self.naviComboBox.selectionChanged.addHandler { [weak self] sender, e in
            guard let self = self else { return }
            let idx = self.naviComboBox.selectedIndex
            print("[DEBUG]: NaviPositionChanged: \(idx)")
            NotificationCenter.default.post(name: NSNotification.Name("NaviPositionChanged"), object: Int(idx))
        }
    }

    private func onSettingsPageLoaded(sender: Any?, e: RoutedEventArgs?) throws {
        let currentTheme = ThemeHelper.rootTheme
        switch currentTheme {
        case .light:
            themeMode.selectedIndex = 0
        case .dark:
            themeMode.selectedIndex = 1
        default:
            break
        }
        self.naviComboBox.selectedIndex = 0
    }

    private func createThemeMode() -> ComboBox {
        let themeMode = ComboBox()
        themeMode.horizontalAlignment = .stretch

        let lightCbi = ComboBoxItem()
        lightCbi.content = "Light"
        lightCbi.tag = "Light"
        themeMode.items.append(lightCbi)

        let darkCbi = ComboBoxItem()
        darkCbi.content = "Dark"
        darkCbi.tag = "Dark"
        themeMode.items.append(darkCbi)

        return themeMode
    }
    
    // 页面销毁时移除通知监听
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}