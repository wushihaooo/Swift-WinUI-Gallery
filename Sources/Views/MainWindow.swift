import Foundation
import UWP
import WinAppSDK
import WindowsFoundation
import WinUI

class MainWindow: Window {
    // MARK: -Properties

    // ViewModel
    private let viewModel: MainWindowViewModel
    // UI
    private var rootGrid: Grid
    private var titleBar: TitleBar
    private var navigationView: NavigationView
    private var rootFrame: Frame
    private var controlsSearchBox: AutoSuggestBox // 搜索功能
    private var currentPageTextBlock: TextBlock // 动态显示

    private var stack: [any Category] = [any Category]()

    // MARK: -Initialization
    override init() {
        // 初始化ViewModel
        self.viewModel = MainWindowViewModel()
        // 初始化UI元素
        self.rootGrid = Grid()
        self.navigationView = NavigationView()
        self.rootFrame = Frame()
        self.titleBar = TitleBar()
        self.controlsSearchBox = AutoSuggestBox()
        self.currentPageTextBlock = TextBlock()

        super.init()
        self.content = self.rootGrid

        self.setupUI()
        bindViewModel()
    }

    func setupUI() {
        self.title = "Swift WinUI3 Gallery"
        self.systemBackdrop = MicaBackdrop()
        self.extendsContentIntoTitleBar = true
        let micaBackdrop = MicaBackdrop()
        micaBackdrop.kind = .base
        self.systemBackdrop = micaBackdrop

        self.setupRootGrid()
        self.setupTitleBar()
        self.setupNavigationView()
    }

    private func setupRootGrid() {
        self.rootGrid.name = "RootGrid"

        // RowDefinitions
        let rowDefinition1 = RowDefinition()
        rowDefinition1.height = GridLength(value: 1, gridUnitType: .auto)
        rootGrid.rowDefinitions.append(rowDefinition1)
        let rowDefinition2 = RowDefinition()
        rowDefinition2.height = GridLength(value: 1, gridUnitType: .star)
        rootGrid.rowDefinitions.append(rowDefinition2)
    }

    private func createImage(height: Double, width: Double, imagePath: String, imageThickness: [Double]) -> Image{
        let image: Image = Image()
        image.height = 16
        image.width = 16
        image.margin = Thickness(
            left: imageThickness[0], 
            top: imageThickness[1], 
            right: imageThickness[2], 
            bottom: imageThickness[3]
        )
        image.stretch = .uniform

        if imagePath.isEmpty {
            fatalError("imagePath is empty!")
        }
        let uri: Uri = Uri(imagePath)
        let bitmapImage = BitmapImage()
        bitmapImage.uriSource = uri
        image.source = bitmapImage

        return image
    }

    private func setupTitleBar() {
        // TitleBar
        titleBar.name = "TitleBar"
        titleBar.title = "Swift WinUI 3 Gallery"
        titleBar.isBackButtonVisible = self.rootFrame.canGoBack
        titleBar.isPaneToggleButtonVisible = true
        // 添加Back按钮和Pane Toggle按钮的事件处理
        titleBar.backRequested.addHandler { [weak self] (_, _) in
            guard let self = self else { return }
            if self.rootFrame.canGoBack {
                try? self.rootFrame.goBack()
            }
        }
        titleBar.paneToggleRequested.addHandler { [weak self] (_, _) in
            guard let self = self else { return }
            self.navigationView.isPaneOpen = !self.navigationView.isPaneOpen
        }
        titleBar.leftHeader = self.createImage(
            height: 16, 
            width: 16, 
            imagePath: Bundle.module.path(
                forResource: "GalleryIcon", 
                ofType: "ico", 
                inDirectory: "Assets/Tiles"
            )!, 
            imageThickness: [0, 0, 8, 0]
        )

        self.controlsSearchBox.name = "controlsSearchBox"
        self.controlsSearchBox.horizontalAlignment = .stretch
        self.controlsSearchBox.placeholderText = "Search controls and samples..."
        self.controlsSearchBox.verticalAlignment = .center
        self.titleBar.content = self.controlsSearchBox

        self.rootGrid.children.append(titleBar)
        try? Grid.setRow(titleBar, 0) // 告诉titleBar它应该在第0行，所以这里是类方法。
    }

    private func setupSubCategories(category: any Category, navigationViewItem: NavigationViewItem) {
        if category.subCategories.isEmpty { return }
        for subCategory: any Category in category.subCategories {
            let subCategoryItem = NavigationViewItem()
            subCategoryItem.tag = Uri("xca://\(subCategory.rawValue)")
            subCategoryItem.content = subCategory.text
            navigationViewItem.menuItems.append(subCategoryItem)
        }
    }

    private func setupNavigationView() {
        self.navigationView.paneDisplayMode = .left
        self.navigationView.isSettingsVisible = true
        self.navigationView.openPaneLength = 320
        self.navigationView.isBackButtonVisible = .collapsed
        self.navigationView.isPaneToggleButtonVisible = false
        
        MainCategory.allCases.forEach { c in
            let navigationViewItem = NavigationViewItem()
            navigationViewItem.tag = Uri("xca://\(c.rawValue)")
            let icon = FontIcon()
            icon.glyph = c.glyph
            navigationViewItem.icon = icon
            navigationViewItem.content = c.text
            setupSubCategories(category: c, navigationViewItem: navigationViewItem)
            navigationView.menuItems.append(navigationViewItem)
        }
        // self.navigationView.header = Category.allCases[0].text
        self.navigationView.selectedItem = navigationView.menuItems[0]
        self.navigationView.content = rootFrame
        rootGrid.children.append(self.navigationView)
        try? Grid.setRow(self.navigationView, 1)
    }

    // 辅助函数：根据 rawValue 查找任意类型的 Category
    // 所有 Category 类型的注册表
    private nonisolated(unsafe) static let categoryTypes: [any (RawRepresentable & Category).Type] = [
        MainCategory.self,
        FundamentalsCategory.self,
        DesignCategory.self,
        AccessibilityCategory.self,
        BasicInputCategory.self,
        CollectionsCategory.self,
        DataTimeCategory.self,
        DialogsFlyoutsCategory.self,
        LayoutCategory.self,
        MediaCategory.self,
        MenusToolbarsCategory.self,
        MotionCategory.self,
        NavigationViewCategory.self,
        ScrollingCategory.self,
        StatusInfoCategory.self,
        StylesCategory.self,
        SystemCategory.self,
        TextCategory.self,
        WindowingCategory.self
    ]
    
    private func findCategory(byRawValue rawValue: String) -> (any Category)? {
        // 遍历所有注册的 Category 类型,尝试用 rawValue 初始化
        for categoryType in Self.categoryTypes {
            if let category = categoryType.init(rawValue: rawValue) {
                return category
            }
        }
        return nil
    }

    func bindViewModel() {
        // NavigationView切换View事件
        navigationView.selectionChanged.addHandler { [unowned self] (_, _) in
            guard
                let item = self.navigationView.selectedItem as? NavigationViewItem,
                let tag = (item.tag as? Uri)?.host,
                let category = self.findCategory(byRawValue: tag) else { return }
            if (!category.canSelect) { return }
            stack.append(category)
            self.titleBar.isBackButtonVisible = !stack.isEmpty
            self.viewModel.navigateCommand.execute(parameter: category)
        }
        titleBar.backRequested.addHandler { [unowned self] (_, _) in
            if !stack.isEmpty {
                _ = stack.popLast()
                let previousCategory = stack.last ?? MainCategory.home
                self.viewModel.navigateCommand.execute(parameter: previousCategory)
            }
            self.titleBar.isBackButtonVisible = !stack.isEmpty
        }
        if let firstItem = navigationView.menuItems.first {
            navigationView.selectedItem = firstItem
        }

        viewModel.propertyChanged = { [unowned self] propertyName in
            self.handlePropertyChanged(propertyName)
        }

        // 初始更新
        handlePropertyChanged("selectedCategory")
    }

    private func handlePropertyChanged(_ propertyName: String) {
        switch propertyName {
        case "selectedCategory":
            let item: any Category = viewModel.selectedCategory
            switch item {
            case MainCategory.home:
                rootFrame.content = HomePage()
            case MainCategory.all:
                rootFrame.content = AllPage()
            case CollectionsCategory.listView:
                rootFrame.content = ListViewPage()
            case CollectionsCategory.flipView:
                rootFrame.content = FlipViewPage()
            case CollectionsCategory.gridView:
                rootFrame.content = GridViewPage()
            case ScrollingCategory.annotatedScrollBar:
                rootFrame.content = AnnotatedScrollBarPage()
            case LayoutCategory.grid:
                rootFrame.content = GridPage()
            case LayoutCategory.border:
                rootFrame.content = BorderPage()
            case LayoutCategory.canvas:
                rootFrame.content = CanvasPage()
            case LayoutCategory.expander:
                rootFrame.content = ExpanderPage()
            case LayoutCategory.radioButtons:
                rootFrame.content = RadioButtonsPage()
            case LayoutCategory.relativePanel:
                rootFrame.content = RelativePanelPage()
            case NavigationViewCategory.breadcrumbBar:
                rootFrame.content = BreadcrumbBarPage()
            case NavigationViewCategory.navigationView:
                rootFrame.content = NavigationViewPage()
            case NavigationViewCategory.pivot:
                rootFrame.content = PivotPage()
            case NavigationViewCategory.selectorBar:
                rootFrame.content = SelectorBarPage()
            case NavigationViewCategory.tabView:
                rootFrame.content = TabViewPage()
            case MenusToolbarsCategory.appBarButton:
                rootFrame.content = AppBarButtonPage()
            case MenusToolbarsCategory.appBarSeparator:
                rootFrame.content = AppBarSeparatorPage()
            default:
                break
            }
        default:
            break
        }
    }
}