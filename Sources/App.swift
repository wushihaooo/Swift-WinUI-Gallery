import WinAppSDK
import WinUI

@main
class App: SwiftApplication {
    required init() {
        super.init()
        self.requestedTheme = ApplicationTheme.light
    }
    
    override func onLaunched(_ args: WinUI.LaunchActivatedEventArgs) {
        let window = Window()
        window.title = "WinUI 3 Gallery"
        window.content = createMainPage()
        window.extendsContentIntoTitleBar = true
        
        try! window.activate()
    }
    
    func createMainPage() -> NavigationView {
        let navigationView = NavigationView()
        navigationView.paneDisplayMode = .left
        navigationView.isSettingsVisible = true
        navigationView.openPaneLength = 220
        navigationView.isBackButtonVisible = .auto
        
        // 创建导航菜单项
        let menuItems = createNavigationMenuItems()
        for item in menuItems {
            navigationView.menuItems.append(item)
        }
        
        // 设置主内容
        navigationView.content = createHomePage()
        
        return navigationView
    }
    
    func createNavigationMenuItems() -> [NavigationViewItem] {
        var items: [NavigationViewItem] = []
        
        // Home
        let homeItem = NavigationViewItem()
        homeItem.content = "Home"
        homeItem.tag = "home"
        items.append(homeItem)
        
        // Fundamentals
        let fundamentalsItem = NavigationViewItem()
        fundamentalsItem.content = "Fundamentals"
        items.append(fundamentalsItem)
        
        // Design
        let designItem = NavigationViewItem()
        designItem.content = "Design"
        items.append(designItem)
        
        // Accessibility
        let accessibilityItem = NavigationViewItem()
        accessibilityItem.content = "Accessibility"
        items.append(accessibilityItem)
        
        // All
        let allItem = NavigationViewItem()
        allItem.content = "All"
        items.append(allItem)
        
        return items
    }
    
    func createHomePage() -> ScrollViewer {
        let scrollViewer = ScrollViewer()
        
        let mainPanel = StackPanel()
        mainPanel.padding = Thickness(left: 40, top: 40, right: 40, bottom: 40)
        mainPanel.spacing = 24
        
        // 标题区域
        let headerPanel = StackPanel()
        headerPanel.spacing = 8
        
        let sdkText = TextBlock()
        sdkText.text = "Windows App SDK 1.8"
        sdkText.fontSize = 14
        sdkText.opacity = 0.6
        
        let titleText = TextBlock()
        titleText.text = "WinUI 3 Gallery"
        titleText.fontSize = 40
        
        headerPanel.children.append(sdkText)
        headerPanel.children.append(titleText)
        
        // 搜索框
        let searchBox = AutoSuggestBox()
        searchBox.placeholderText = "Search controls and samples..."
        searchBox.width = 320
        searchBox.horizontalAlignment = .left
        searchBox.margin = Thickness(left: 0, top: 20, right: 0, bottom: 20)
        
        // 卡片网格
        let cardsGrid = createCardsGrid()
        
        // Recent/Favorites 选项卡
        let tabPanel = createTabPanel()
        
        // 最近访问区域
        let recentSection = createRecentSection()
        
        // 最近添加或更新区域
        let updatedSection = createUpdatedSection()
        
        mainPanel.children.append(headerPanel)
        mainPanel.children.append(searchBox)
        mainPanel.children.append(cardsGrid)
        mainPanel.children.append(tabPanel)
        mainPanel.children.append(recentSection)
        mainPanel.children.append(updatedSection)
        
        scrollViewer.content = mainPanel
        return scrollViewer
    }
    
    func createCardsGrid() -> Grid {
        let grid = Grid()
        grid.margin = Thickness(left: 0, top: 0, right: 0, bottom: 32)
        
        // 定义列
        for _ in 0..<4 {
            let colDef = ColumnDefinition()
            colDef.width = GridLength(value: 1, gridUnitType: .star)
            grid.columnDefinitions.append(colDef)
        }
        
        // 定义行
        let rowDef = RowDefinition()
        rowDef.height = GridLength(value: 160, gridUnitType: .pixel)
        grid.rowDefinitions.append(rowDef)
        
        // 创建卡片
        let cards = [
            ("Getting started", "Get started with WinUI and explore detailed documentation.", "📘"),
            ("Design", "Guidelines and toolkits for creating stunning WinUI experiences.", "🪟"),
            ("WinUI on GitHub", "Explore the WinUI source code and repository.", "🐙"),
            ("Community Toolkit", "A collection of helper functions, controls, and app services.", "🧰")
        ]
        
        for (index, card) in cards.enumerated() {
            let cardButton = createCard(title: card.0, description: card.1, icon: card.2)
            Grid.setColumn(cardButton, Int32(index))
            Grid.setRow(cardButton, 0)
            grid.children.append(cardButton)
        }
        
        return grid
    }
    
    func createCard(title: String, description: String, icon: String) -> Button {
        let button = Button()
        button.horizontalAlignment = .stretch
        button.verticalAlignment = .stretch
        button.margin = Thickness(left: 0, top: 0, right: 12, bottom: 12)
        button.padding = Thickness(left: 20, top: 20, right: 20, bottom: 20)
        
        let panel = StackPanel()
        panel.spacing = 12
        
        let iconText = TextBlock()
        iconText.text = icon
        iconText.fontSize = 32
        
        let titleText = TextBlock()
        titleText.text = title
        titleText.fontSize = 16
        
        let descText = TextBlock()
        descText.text = description
        descText.fontSize = 12
        descText.textWrapping = .wrap
        descText.opacity = 0.6
        
        panel.children.append(iconText)
        panel.children.append(titleText)
        panel.children.append(descText)
        
        button.content = panel
        return button
    }
    
    func createTabPanel() -> StackPanel {
        let panel = StackPanel()
        panel.orientation = .horizontal
        panel.spacing = 12
        panel.margin = Thickness(left: 0, top: 0, right: 0, bottom: 16)
        
        let recentButton = Button()
        recentButton.content = "Recent"
        recentButton.padding = Thickness(left: 16, top: 8, right: 16, bottom: 8)
        
        let favoritesButton = Button()
        favoritesButton.content = "Favorites"
        favoritesButton.padding = Thickness(left: 16, top: 8, right: 16, bottom: 8)
        
        panel.children.append(recentButton)
        panel.children.append(favoritesButton)
        
        return panel
    }
    
    func createRecentSection() -> StackPanel {
        let section = StackPanel()
        section.spacing = 16
        section.margin = Thickness(left: 0, top: 0, right: 0, bottom: 32)
        
        let header = TextBlock()
        header.text = "Recently visited"
        header.fontSize = 20
        
        let itemsPanel = StackPanel()
        itemsPanel.orientation = .horizontal
        itemsPanel.spacing = 12
        
        let colorItem = createRecentItem(title: "Color", description: "Balanced color design creates clarity and aesthetic harmony.", icon: "🎨")
        let resourcesItem = createRecentItem(title: "Resources", description: "Reusable definitions for shared values to ensure consistency and maintainability.", icon: "💾")
        
        itemsPanel.children.append(colorItem)
        itemsPanel.children.append(resourcesItem)
        
        section.children.append(header)
        section.children.append(itemsPanel)
        
        return section
    }
    
    func createRecentItem(title: String, description: String, icon: String) -> Border {
        let border = Border()
        border.width = 280
        border.height = 100
        border.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        
        let panel = StackPanel()
        panel.spacing = 8
        
        let headerPanel = StackPanel()
        headerPanel.orientation = .horizontal
        headerPanel.spacing = 12
        
        let iconText = TextBlock()
        iconText.text = icon
        iconText.fontSize = 24
        
        let titleText = TextBlock()
        titleText.text = title
        titleText.fontSize = 16
        
        headerPanel.children.append(iconText)
        headerPanel.children.append(titleText)
        
        let descText = TextBlock()
        descText.text = description
        descText.fontSize = 12
        descText.textWrapping = .wrap
        descText.opacity = 0.6
        
        panel.children.append(headerPanel)
        panel.children.append(descText)
        
        border.child = panel
        return border
    }
    
    func createUpdatedSection() -> StackPanel {
        let section = StackPanel()
        section.spacing = 16
        
        let header = TextBlock()
        header.text = "Recently added or updated"
        header.fontSize = 20
        
        section.children.append(header)
        
        return section
    }
}