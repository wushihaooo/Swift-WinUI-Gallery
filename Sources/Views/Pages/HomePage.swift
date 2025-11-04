import WinUI
import WinAppSDK

open class HomePage: Grid {
    // MARK: - Properties
    private var scrollViewer: ScrollViewer!
    private var rootGrid: Grid!
    
    // 数据源
    private var recentlyVisitedSamplesList: [Any] = []
    private var recentlyAddedOrUpdatedSamplesList: [Any] = []
    private var favoriteSamplesList: [Any] = []
    
    // UI 组件
    private var recentSamplesPanel: StackPanel!
    private var favoriteSamplesPanel: StackPanel!
    private var tabContainer: StackPanel!
    
    // MARK: - Initialization
    override init() {
        super.init()
        setupView()
    }
    
    private func setupView() {
        // 设置当前 Grid 的行定义
        let rowDef = RowDefinition()
        rowDef.height.value = 1
        rowDef.height.gridUnitType = .star
        self.rowDefinitions.append(rowDef)
        
        // 创建并添加内容
        let content = createScrollViewer()
        self.children.append(content)
    }
    
    // MARK: - Create Main View
    private func createScrollViewer() -> ScrollViewer {
        scrollViewer = ScrollViewer()
        scrollViewer.cornerRadius = CornerRadius(
            topLeft: 0,
            topRight: 0,
            bottomRight: 0,
            bottomLeft: 0
        )
        scrollViewer.verticalScrollBarVisibility = .auto
        
        rootGrid = createRootGrid()
        scrollViewer.content = rootGrid
        
        return scrollViewer
    }
    
    private func createRootGrid() -> Grid {
        let grid = Grid()
        
        // 定义一行用于主内容
        let row1 = RowDefinition()
        row1.height.value = 1
        row1.height.gridUnitType = .star
        grid.rowDefinitions.append(row1)
        
        // 创建主面板
        let mainPanel = createMainPanel()
        try? Grid.setRow(mainPanel, 0)
        grid.children.append(mainPanel)
        
        return grid
    }
    
    // MARK: - Create Main Panel
    private func createMainPanel() -> StackPanel {
        let panel = StackPanel()
        panel.padding = Thickness(left: 40, top: 40, right: 40, bottom: 40)
        panel.spacing = 24
        
        // 添加各个部分
        panel.children.append(createHeader())
        panel.children.append(createSearchBox())
        panel.children.append(createCardsGrid())
        panel.children.append(createTabButtons())
        panel.children.append(createRecentSection())
        panel.children.append(createUpdatedSection())
        
        return panel
    }
    
    // MARK: - Create Header
    private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 8
        
        let sdkText = TextBlock()
        sdkText.text = "Windows App SDK \(ReleaseInfo.asString)"
        sdkText.fontSize = 14
        sdkText.opacity = 0.6
        headerPanel.children.append(sdkText)
        
        let titleText = TextBlock()
        titleText.text = "Swift WinUI 3 Gallery"
        titleText.fontSize = 40
        headerPanel.children.append(titleText)
        
        return headerPanel
    }
    
    // MARK: - Create Search Box
    private func createSearchBox() -> AutoSuggestBox {
        let searchBox = AutoSuggestBox()
        searchBox.placeholderText = "Search controls and samples..."
        searchBox.width = 320
        searchBox.horizontalAlignment = .left
        searchBox.margin = Thickness(left: 0, top: 20, right: 0, bottom: 20)
        
        return searchBox
    }
    
    // MARK: - Create Cards Grid
    private func createCardsGrid() -> Grid {
        let grid = Grid()
        grid.margin = Thickness(left: 0, top: 0, right: 0, bottom: 32)
        
        // 定义列
        for _ in 0..<4 {
            let colDef = ColumnDefinition()
            colDef.width.value = 1
            colDef.width.gridUnitType = .star
            grid.columnDefinitions.append(colDef)
        }
        
        // 定义行
        let rowDef = RowDefinition()
        rowDef.height.value = 160
        rowDef.height.gridUnitType = .pixel
        grid.rowDefinitions.append(rowDef)
        
        // 创建卡片数据
        let cards = [
            ("Getting started", "Get started with WinUI and explore detailed documentation.", "📘"),
            ("Design", "Guidelines and toolkits for creating stunning WinUI experiences.", "🪟"),
            ("WinUI on GitHub", "Explore the WinUI source code and repository.", "🐙"),
            ("Community Toolkit", "A collection of helper functions, controls, and app services.", "🧰"),
        ]
        
        for (index, card) in cards.enumerated() {
            let cardButton = createCard(title: card.0, description: card.1, icon: card.2)
            try? Grid.setColumn(cardButton, Int32(index))
            try? Grid.setRow(cardButton, 0)
            grid.children.append(cardButton)
        }
        
        return grid
    }
    
    private func createCard(title: String, description: String, icon: String) -> Button {
        let button = Button()
        button.horizontalAlignment = .stretch
        button.verticalAlignment = .stretch
        button.margin = Thickness(left: 0, top: 0, right: 12, bottom: 0)
        button.padding = Thickness(left: 20, top: 20, right: 20, bottom: 20)
        
        let panel = StackPanel()
        panel.spacing = 12
        
        let iconText = TextBlock()
        iconText.text = icon
        iconText.fontSize = 32
        panel.children.append(iconText)
        
        let titleText = TextBlock()
        titleText.text = title
        titleText.fontSize = 16
        panel.children.append(titleText)
        
        let descText = TextBlock()
        descText.text = description
        descText.fontSize = 12
        descText.textWrapping = .wrap
        descText.opacity = 0.6
        panel.children.append(descText)
        
        button.content = panel
        return button
    }
    
    // MARK: - Create Tab Buttons
    private func createTabButtons() -> StackPanel {
        let panel = StackPanel()
        panel.orientation = .horizontal
        panel.spacing = 12
        panel.margin = Thickness(left: 0, top: 0, right: 0, bottom: 16)
        panel.horizontalAlignment = .center  // 设置水平居中
        
        let recentButton = Button()
        recentButton.content = "Recent"
        recentButton.padding = Thickness(left: 16, top: 8, right: 16, bottom: 8)
        recentButton.cornerRadius = CornerRadius(
            topLeft: 16,
            topRight: 16,
            bottomRight: 16,
            bottomLeft: 16
        )  // 设置圆角
        recentButton.click.addHandler { [weak self] sender, args in
            self?.showRecentContent()
        }
        panel.children.append(recentButton)
        
        let favoritesButton = Button()
        favoritesButton.content = "Favorites"
        favoritesButton.padding = Thickness(left: 16, top: 8, right: 16, bottom: 8)
        favoritesButton.cornerRadius = CornerRadius(
            topLeft: 16,
            topRight: 16,
            bottomRight: 16,
            bottomLeft: 16
        )  // 设置圆角
        favoritesButton.click.addHandler { [weak self] sender, args in
            self?.showFavoritesContent()
        }
        panel.children.append(favoritesButton)
        
        return panel
    }
    
    // MARK: - Create Recent Section
    private func createRecentSection() -> StackPanel {
        let section = StackPanel()
        section.spacing = 16
        section.margin = Thickness(left: 0, top: 0, right: 0, bottom: 32)
        
        let header = TextBlock()
        header.text = "Recently visited"
        header.fontSize = 20
        section.children.append(header)
        
        let itemsPanel = StackPanel()
        itemsPanel.orientation = .horizontal
        itemsPanel.spacing = 12
        
        let colorItem = createRecentItem(
            title: "Color",
            description: "Balanced color design creates clarity and aesthetic harmony.",
            icon: "🎨"
        )
        itemsPanel.children.append(colorItem)
        
        let resourcesItem = createRecentItem(
            title: "Resources",
            description: "Reusable definitions for shared values to ensure consistency.",
            icon: "💾"
        )
        itemsPanel.children.append(resourcesItem)
        
        section.children.append(itemsPanel)
        
        return section
    }
    
    private func createRecentItem(title: String, description: String, icon: String) -> Border {
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
        headerPanel.children.append(iconText)
        
        let titleText = TextBlock()
        titleText.text = title
        titleText.fontSize = 16
        headerPanel.children.append(titleText)
        
        panel.children.append(headerPanel)
        
        let descText = TextBlock()
        descText.text = description
        descText.fontSize = 12
        descText.textWrapping = .wrap
        descText.opacity = 0.6
        panel.children.append(descText)
        
        border.child = panel
        return border
    }
    
    // MARK: - Create Updated Section
    private func createUpdatedSection() -> StackPanel {
        let section = StackPanel()
        section.spacing = 16
        
        let header = TextBlock()
        header.text = "Recently added or updated"
        header.fontSize = 20
        section.children.append(header)
        
        // 创建网格视图
        let gridView = createSamplesGridView()
        section.children.append(gridView)
        
        return section
    }
    
    private func createSamplesGridView() -> GridView {
        let gridView = GridView()
        gridView.isItemClickEnabled = true
        gridView.selectionMode = .none
        
        gridView.itemClick.addHandler { [weak self] sender, args in
            guard let args = args else { return }
            self?.onItemClick(sender, args)
        }
        
        return gridView
    }
    
    // MARK: - Event Handlers
    private func showRecentContent() {
        print("Show recent content")
        // 实现切换到 Recent 内容的逻辑
    }
    
    private func showFavoritesContent() {
        print("Show favorites content")
        // 实现切换到 Favorites 内容的逻辑
    }
    
    private func onItemClick(_ sender: Any?, _ args: ItemClickEventArgs) {
        print("Item clicked")
        // 处理项点击事件
    }
}