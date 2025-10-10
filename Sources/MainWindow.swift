import Foundation
import UWP
import WinAppSDK
import WindowsFoundation
import WinUI

class MainWindow: Window {
    let categories = Category.allCases
    let collections: [Collections] = Collections.allCases

    //************************************************* START UI *************************************************
    lazy var rootGrid: Grid = {
        let rootGrid = Grid()
        rootGrid.name = "RootGrid"
        
        // RowDefinitions
        var rowDefinition1 = RowDefinition()
        rowDefinition1.height = GridLength(value: 1, gridUnitType: .auto)
        rootGrid.rowDefinitions.append(rowDefinition1)

        var rowDefinition2 = RowDefinition()
        rowDefinition2.height = GridLength(value: 1, gridUnitType: .star)
        rootGrid.rowDefinitions.append(rowDefinition2)
        
        // TitleBar - 第 0 行
        var titleBar = TitleBar()
        titleBar.name = "titleBar"
        titleBar.title = "WinUI 3 Gallery"
        // 这里要设置PaneToggleRequested事件
        titleBar.isBackButtonVisible = false
        titleBar.isPaneToggleButtonVisible = true

        let image = Image()
        image.height = 16
        image.width = 16
        image.stretch = .uniform
        let imagePath = Bundle.module.path(forResource: "GalleryIcon", ofType: "ico", inDirectory: "Assets")
        let bitmapImage = BitmapImage()
        guard let imagePath = imagePath else {
            fatalError("GalleryIcon.ico not found in Asssets directory!")
        }
        let uri = Uri(imagePath)
        bitmapImage.uriSource = uri
        image.margin = Thickness(left: 0, top: 0, right: 8, bottom: 0)
        image.source = bitmapImage
    
        titleBar.leftHeader = image

        // 添加搜索框
        let autoSuggestBox = AutoSuggestBox()
        autoSuggestBox.name = "controlsSearchBox"
        autoSuggestBox.width = 320
        autoSuggestBox.horizontalAlignment = .stretch
        autoSuggestBox.verticalAlignment = .center
        autoSuggestBox.placeholderText = "Search controls and samples..."
        // autoSuggestBox.queryIcon.fontGlyph = "Find"
        // 这里未设置事件
        // 这里未设置快捷键Ctrl + F
        titleBar.content = autoSuggestBox
        
        Grid.setRow(titleBar, 0)
        rootGrid.children.append(titleBar)
        
        // NavigationView - 第 1 行
        Grid.setRow(navigationView, 1)
        rootGrid.children.append(navigationView)
        
        return rootGrid
    }()
    lazy var homeView = HomePage()
    lazy var fundamentalsView = createFundamentalsPage()



    lazy var navigationView: NavigationView = {
        let navigationView = NavigationView()
        navigationView.paneTitle = "Swift WinUI3 Gallery"
        navigationView.paneDisplayMode = .left
        navigationView.isSettingsVisible = false
        navigationView.openPaneLength = 220
        navigationView.isBackButtonVisible = .collapsed

        self.categories.forEach { c in
            let navigationViewItem = NavigationViewItem()
            navigationViewItem.tag = Uri("xca://\(c.rawValue)")
            let icon = FontIcon()
            icon.glyph = c.glyph
            navigationViewItem.content = c.text
            if c.rawValue == "collections" {
                for collection in self.collections {
                    let collectionItem = NavigationViewItem()
                    collectionItem.tag = Uri("xca://\(c.rawValue)/\(collection.rawValue)")
                    collectionItem.content = collection.text
                    navigationViewItem.menuItems.append(collectionItem)
                }
            }
            navigationView.menuItems.append(navigationViewItem)
        }
        navigationView.header = self.categories[0].text
        navigationView.selectedItem = navigationView.menuItems[0]
        navigationView.selectionChanged.addHandler { [weak self] (_, _) in 
            self?.handleRefresh()
        }
        navigationView.content = self.homeView
        return navigationView
    }()

    lazy var gridView: GridView = {
        let gridView = GridView()
        gridView.margin = Thickness(left: 24, top: 16, right: 24, bottom: 0)
        let itemsPanelTemplate = XamlReader.load("""
            <ItemsPanelTemplate 
                xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
                xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
                <ItemsWrapGrid x:Name="MaxItemsWrapGrid"
                            ItemWidth="350"
                            ItemHeight="380"
                            Orientation="Horizontal" />
            </ItemsPanelTemplate>
        """) as! ItemsPanelTemplate
        gridView.itemsPanel = itemsPanelTemplate
        gridView.isItemClickEnabled = true
        // 设置点击事件
        gridView.itemClick.addHandler { [weak self] (_, args) in
            guard 
                let panel = args?.clickedItem as? StackPanel,
                let uri = panel.tag as? Uri
            else { return }            
        }
        gridView.sizeChanged.addHandler { [weak self] (_, args) in
            guard
                let self,
                let args,
                let itemsWrapGrid = self.gridView.itemsPanelRoot as? ItemsWrapGrid
            else { return }
            let columns = Double(ceil(args.newSize.width / 350.0))
            itemsWrapGrid.itemWidth = Double(args.newSize.width) / columns
        }
        return gridView
    }()
    //************************************************** END UI **************************************************

    private func createImageView() -> Grid {
        // 创建网格布局
        let grid = Grid()
        
        // 创建 StackPanel 用于垂直排列
        let stackPanel = StackPanel()
        stackPanel.orientation = .vertical
        stackPanel.horizontalAlignment = .center
        stackPanel.verticalAlignment = .center
        stackPanel.spacing = 20
        
        // 创建 Image 控件
        let image = Image()
        image.width = 400
        image.height = 300
        image.stretch = .uniform
        
        // 设置图片源 - 从本地文件加载
        // 方法1: 使用绝对路径
        let imagePath = "D:\\home\\wushihao\\code\\Swift-WinUI-Gallery\\Sources\\Assets\\GalleryIcon.ico"
        
        // 方法2: 使用相对路径(相对于可执行文件)
        // let imagePath = "images\\example.jpg"
        
        // 创建 BitmapImage
        let bitmapImage = BitmapImage()
        let uri = Uri(imagePath)
        bitmapImage.uriSource = uri
        
        image.source = bitmapImage
        
        // 创建标签
        let label = TextBlock()
        label.text = "本地图片显示"
        label.fontSize = 20
        label.horizontalAlignment = .center
        
        // 添加控件到 StackPanel
        stackPanel.children.append(label)
        stackPanel.children.append(image)
        
        // 将 StackPanel 添加到 Grid
        grid.children.append(stackPanel)
        
        return grid
    }


    override init() {
        super.init()
        self.systemBackdrop = MicaBackdrop()
        self.title = "MainWindow"
        self.setupWindow()
    }

    func setupWindow() {
        self.title = "Swift WinUI3 Gallery"    
        self.content = rootGrid
        self.extendsContentIntoTitleBar = true

        let micaBackdrop = MicaBackdrop()
        micaBackdrop.kind = .base
        self.systemBackdrop = micaBackdrop
    }

    func handleRefresh() {
        guard
            let item = self.navigationView.selectedItem as? NavigationViewItem,
            let tag = (item.tag as? Uri)?.host,
            let category = Category(rawValue: tag)
        else {return}
        self.navigationView.header = category.text

        // 需要切换页面的内容
        switch category {
        case .home:
            self.navigationView.content = self.homeView
        case .collections:
            self.navigationView.content = self.gridView
        case .fundamentals:
            self.navigationView.content = self.fundamentalsView
        default:
            self.navigationView.content = self.homeView
        }

        
        // // 清空并添加新数据
        // gridView.items.clear()
        // // 假设根据分类获取数据（示例数据）
        // let sampleData = (0..<5).map { index in
        //     let panel = StackPanel()
        //     panel.tag = Uri("xca://\(category.rawValue)/item\(index)")
        //     // 添加文本、图标等内容到面板
        //     let textBlock = TextBlock()
        //     textBlock.text = "\(category.text) 示例 \(index)"
        //     panel.children.append(textBlock)
        //     gridView.items.append(panel)
        //     return panel
        // }
    }
}