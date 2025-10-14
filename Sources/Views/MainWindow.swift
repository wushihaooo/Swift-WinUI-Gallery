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

    private func setupNavigationView() {
        self.navigationView.paneDisplayMode = .left
        self.navigationView.isSettingsVisible = true
        self.navigationView.openPaneLength = 220
        self.navigationView.isBackButtonVisible = .collapsed
        self.navigationView.isPaneToggleButtonVisible = false
        
        Category.allCases.forEach { c in
            let navigationViewItem = NavigationViewItem()
            navigationViewItem.tag = Uri("xca://\(c.rawValue)")
            let icon = FontIcon()
            icon.glyph = c.glyph
            navigationViewItem.icon = icon
            navigationViewItem.content = c.text
            if c.rawValue == "collections" {
                for collection in Fundamentals.allCases {
                    let collectionItem = NavigationViewItem()
                    collectionItem.tag = Uri("xca://\(c.rawValue)/\(collection.rawValue)")
                    collectionItem.content = collection.text
                    navigationViewItem.menuItems.append(collectionItem)
                }
            }
            navigationView.menuItems.append(navigationViewItem)
        }
        // self.navigationView.header = Category.allCases[0].text
        self.navigationView.selectedItem = navigationView.menuItems[0]
        self.navigationView.content = rootFrame
        rootGrid.children.append(self.navigationView)
        try? Grid.setRow(self.navigationView, 1)
    }

    func bindViewModel() {
        // NavigationView切换View事件
        navigationView.selectionChanged.addHandler { [unowned self] (_, _) in
            guard
                let item = self.navigationView.selectedItem as? NavigationViewItem,
                let tag = (item.tag as? Uri)?.host,
                let category = Category(rawValue: tag) else { return }
            self.viewModel.navigateCommand.execute(parameter: category)
        }
        if let firstItem = navigationView.menuItems.first {
            navigationView.selectedItem = firstItem
        }

        viewModel.propertyChanged = { [unowned self] propertyName in
            self.handlePropertyChanged(propertyName)
        }

        // 初始更新
        handlePropertyChanged("selectedCategory")

        rootFrame.navigated.addHandler { [unowned self] (_, _) in
            self.titleBar.isBackButtonVisible = self.rootFrame.canGoBack
        }
    }

    private func handlePropertyChanged(_ propertyName: String) {
        switch propertyName {
        case "selectedCategory":
            let item  = viewModel.selectedCategory
            // 需要切换页面的内容
            switch item {
            case .home:
                self.rootFrame.content = HomePage()
            case .fundamentals:
                self.rootFrame.content = FundamentalsPage()
            default:
                self.rootFrame.content = HomePage()
            }
        default:
            break
        }
    }
}