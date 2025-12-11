import Foundation
import UWP
import WinAppSDK
import WindowsFoundation
import WinUI

class MainWindow: Window, @unchecked Sendable {
    // MARK: - Properties

    // ViewModel
    private let viewModel: MainWindowViewModel
    // UI
    private var rootGrid: Grid
    private var titleBar: TitleBar
    private var navigationView: NavigationView
    private var tabView: TabView                  // ✅ 使用 TabView 作为内容区域
    private var controlsSearchBox: AutoSuggestBox // 搜索功能
    private var currentPageTextBlock: TextBlock   // 动态显示
    private var forwardStack: [any Category] = []
    private var forwardButton: Button
    private var backButton: Button
    private var stack: [any Category] = []

    // MARK: - Initialization
    override init() {
        // 初始化 ViewModel
        self.viewModel = MainWindowViewModel()
        // 初始化 UI 元素
        self.rootGrid = Grid()
        self.navigationView = NavigationView()
        self.tabView = TabView()
        self.titleBar = TitleBar()
        self.controlsSearchBox = AutoSuggestBox()
        self.currentPageTextBlock = TextBlock()
        self.backButton = Button()
        self.forwardButton = Button()

        super.init()
        self.content = self.rootGrid

        self.setupUI()
        bindViewModel()
    }

    // MARK: - UI 搭建

    func setupUI() {
        self.title = "Swift WinUI3 Gallery"
        self.systemBackdrop = MicaBackdrop()
        self.extendsContentIntoTitleBar = true

        let micaBackdrop = MicaBackdrop()
        micaBackdrop.kind = .base
        self.systemBackdrop = micaBackdrop

        // windows taskbar icon
        if let appWindow = self.appWindow {
            if let iconPath = Bundle.module.path(
                forResource: "GalleryIcon",
                ofType: "ico",
                inDirectory: "Assets/Tiles"
            ) {
                do {
                    try appWindow.setIcon(iconPath)
                } catch {
                    debugPrint("Failed to set appWindow icon: \(error)")
                }
            }
        }

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

    private func createImage(
        height: Double,
        width: Double,
        imagePath: String,
        imageThickness: [Double]
    ) -> Image {
        let image = Image()
        image.height = height
        image.width = width
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
        let uri = Uri(imagePath)
        let bitmapImage = BitmapImage()
        bitmapImage.uriSource = uri
        image.source = bitmapImage

        return image
    }

    private func setupTitleBar() {
        titleBar.name = "TitleBar"
        titleBar.title = "Swift WinUI 3 Gallery"

        titleBar.isBackButtonVisible = false
        titleBar.isPaneToggleButtonVisible = true
        titleBar.paneToggleRequested.addHandler { [weak self] _, _ in
            guard let self = self else { return }
            self.navigationView.isPaneOpen.toggle()
        }
        // ---- App 图标 ----
        let appIcon = self.createImage(
            height: 16,
            width: 16,
            imagePath: Bundle.module.path(
                forResource: "GalleryIcon",
                ofType: "ico",
                inDirectory: "Assets/Tiles"
            )!,
            imageThickness: [8, 0, 8, 0]
        )

        // ---- 主标题 ----
        let titleText = TextBlock()
        titleText.text = "Swift WinUI 3 Gallery"
        titleText.fontSize = 14
        titleText.verticalAlignment = .center

        // ---- 副标题：显示当前 Page 的标题 ----
        currentPageTextBlock.fontSize = 12
        currentPageTextBlock.opacity = 0.75
        currentPageTextBlock.verticalAlignment = .center
        currentPageTextBlock.margin = Thickness(left: 8, top: 0, right: 16, bottom: 0)
        currentPageTextBlock.text = ""

        // ---- Back / Forward 按钮 ----
        let backText = TextBlock()
        backText.text = "←"
        backText.verticalAlignment = .center

        backButton.content = backText
        backButton.verticalAlignment = .center
        backButton.margin = Thickness(left: 0, top: 0, right: 4, bottom: 0)
        backButton.isEnabled = false
        backButton.click.addHandler { [weak self] _, _ in
            self?.navigateBack()
        }

        let forwardText = TextBlock()
        forwardText.text = "→"
        forwardText.verticalAlignment = .center

        forwardButton.content = forwardText
        forwardButton.verticalAlignment = .center
        forwardButton.margin = Thickness(left: 0, top: 0, right: 12, bottom: 0)
        forwardButton.isEnabled = false
        forwardButton.click.addHandler { [weak self] _, _ in
            self?.navigateForward()
        }

        // ---- Search 框 ----
        controlsSearchBox.name = "controlsSearchBox"
        controlsSearchBox.placeholderText = "Search controls and samples..."
        controlsSearchBox.verticalAlignment = .center
        controlsSearchBox.minWidth = 320

        // ---- 中间整体一条横向布局：Icon → Title → Subtitle → Back/Forward → Search ----
        let centerStack = StackPanel()
        centerStack.orientation = .horizontal
        centerStack.verticalAlignment = .center
        centerStack.spacing = 0

        centerStack.children.append(appIcon)
        centerStack.children.append(titleText)
        centerStack.children.append(currentPageTextBlock)
        centerStack.children.append(backButton)
        centerStack.children.append(forwardButton)
        centerStack.children.append(controlsSearchBox)

        titleBar.content = centerStack

        // ---- 右侧头像 ----
        let avatar = Border()
        avatar.width = 32
        avatar.height = 32
        avatar.cornerRadius = CornerRadius(
            topLeft: 16,
            topRight: 16,
            bottomRight: 16,
            bottomLeft: 16
        )
        avatar.verticalAlignment = .center
        avatar.background = SolidColorBrush(
            Color(a: 255, r: 240, g: 240, b: 240)
        )

        let avatarText = TextBlock()
        avatarText.text = "PP"
        avatarText.verticalAlignment = .center
        avatarText.horizontalAlignment = .center
        avatarText.fontSize = 12
        avatar.child = avatarText

        titleBar.rightHeader = avatar

        self.rootGrid.children.append(titleBar)
        try? Grid.setRow(titleBar, 0)
    }

    // MARK: - NavigationView + TabView

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
        self.navigationView.paneDisplayMode = .auto
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

        // 默认选中第一个
        self.navigationView.selectedItem = navigationView.menuItems[0]

        // ---- TabView 配置 ----
        tabView.tabWidthMode = .sizeToContent
        tabView.isAddTabButtonVisible = false
        tabView.canReorderTabs = true
        tabView.allowDrop = true

        // 关闭标签事件（按 TabViewPage 的思路）
        tabView.tabCloseRequested.addHandler { [weak tabView] sender, args in
            print("🔍 MainWindow TabCloseRequested event triggered")

            guard let tabView = tabView ?? sender else {
                print("❌ Failed to get tabView")
                return
            }
            guard let args = args else {
                print("❌ args is nil")
                return
            }
            guard let closingTab = args.tab else {
                print("❌ closingTab is nil")
                return
            }
            guard let items = tabView.tabItems else {
                print("❌ items is nil")
                return
            }

            print("✅ All guards passed")
            print("📊 Current item count: \(items.size)")

            // 1️⃣ 尝试用 indexOf
            var idx: UInt32 = 0
            if items.indexOf(closingTab, &idx) {
                print("  ✅ indexOf matched at \(idx)")
                items.removeAt(idx)
                print("✅ Item removed via indexOf")
                print("📊 New item count: \(items.size)")
                return
            }

            // 2️⃣ Fallback：按 header 文本匹配
            var indexToRemove: UInt32? = nil
            let itemCount = Int(items.size)
            print("🔍 Fallback scan, itemCount = \(itemCount)")

            var closingHeader: String? = nil
            if let headerStr = closingTab.header as? String {
                closingHeader = headerStr
            } else if let headerObj = closingTab.header {
                closingHeader = "\(headerObj)"
            }
            print("🏷️ Closing tab header: \(closingHeader ?? "nil")")

            for i in 0..<itemCount {
                if let item = items.getAt(UInt32(i)) as? TabViewItem {
                    var itemHeader: String? = nil
                    if let headerStr = item.header as? String {
                        itemHeader = headerStr
                    } else if let headerObj = item.header {
                        itemHeader = "\(headerObj)"
                    }

                    print("  Item \(i): header=\(itemHeader ?? "nil"), isClosable=\(item.isClosable)")

                    if let itemHeader,
                       let closingHeader,
                       itemHeader == closingHeader {
                        indexToRemove = UInt32(i)
                        print("  ✅ Found matching item at index \(i)")
                        break
                    }
                } else {
                    print("  Item \(i): Failed to cast to TabViewItem")
                }
            }

            if let index = indexToRemove {
                print("🗑️ Removing item at index \(index)")
                items.removeAt(index)
                print("✅ Item removed successfully")
                print("📊 New item count: \(items.size)")
            } else {
                print("⚠️ No matching item found to remove")
            }
        }

        self.navigationView.content = tabView
        rootGrid.children.append(self.navigationView)
        try? Grid.setRow(self.navigationView, 1)
    }

    // MARK: - Tab 辅助函数

    /// Tab 上显示关闭按钮
    private func attachCloseHandler(for tab: TabViewItem) {
        tab.isClosable = true
    }

    /// 根据 Category 生成页面
    private func createPage(for category: any Category) -> UIElement {
        switch category {
        case MainCategory.home:
            return HomePage()
        case MainCategory.all:
            return AllPage()

        case CollectionsCategory.listView:
            return ListViewPage()
        case CollectionsCategory.flipView:
            return FlipViewPage()
        case CollectionsCategory.gridView:
            return GridViewPage()
        case CollectionsCategory.listBox:
            return ListBoxPage()
        case CollectionsCategory.pullToRefresh:
            return PullToRefreshPage()
        case CollectionsCategory.treeView:
            return TreeViewPage()

        case ScrollingCategory.annotatedScrollBar:
            return AnnotatedScrollBarPage()
        case ScrollingCategory.pipsPager:
            return PipsPagerPage()
        case ScrollingCategory.scrollView:
            return ScrollViewPage()
        case ScrollingCategory.scrollViewer:
            return ScrollViewerPage()
        case ScrollingCategory.semanticZoom:
            return SemanticZoomPage()

        case LayoutCategory.grid:
            return GridPage()
        case LayoutCategory.border:
            return BorderPage()
        case LayoutCategory.canvas:
            return CanvasPage()
        case LayoutCategory.expander:
            return ExpanderPage()
        case LayoutCategory.radioButtons:
            return RadioButtonsPage()
        case LayoutCategory.relativePanel:
            return RelativePanelPage()
        case LayoutCategory.stackPanel:
            return StackPanelPage()
        case LayoutCategory.variableSizedWrapGrid:
            return variableGridPage()
        case LayoutCategory.viewBox:
            return ViewBoxPage()

        case NavigationViewCategory.breadcrumbBar:
            return BreadcrumbBarPage()
        case NavigationViewCategory.navigationView:
            return NavigationViewPage()
        case NavigationViewCategory.pivot:
            return PivotPage()
        case NavigationViewCategory.selectorBar:
            return SelectorBarPage()
        case NavigationViewCategory.tabView:
            return TabViewPage()

        case MenusToolbarsCategory.appBarButton:
            return AppBarButtonPage()
        case MenusToolbarsCategory.appBarSeparator:
            return AppBarSeparatorPage()
        case MenusToolbarsCategory.appBarToggleButton:
            return AppBarToggleButtonPage()
        case MenusToolbarsCategory.commandBar:
            return CommandBarPage()
        case MenusToolbarsCategory.commandBarFlyout:
            return CommandBarFlyoutPage()

        case MediaCategory.image:
            return ImagePage()
        case MediaCategory.personPicture:
            return PersonPicturePage()
        case MediaCategory.webView2:
            return WebView2Page()

        case WindowingCategory.titleBar:
            return TitlebarPage()

        case SystemCategory.filePicker:
            return StoragePickersPage()
        case SystemCategory.appNotifications:
            return AppNotificationsPage()
        case SystemCategory.badgeNotifications:
            return BadgeNotificationsPage()

        case DialogsFlyoutsCategory.contentDialog:
            return ContentDialogPage()
        case DialogsFlyoutsCategory.flyout:
            return FlyoutPage()
        case DialogsFlyoutsCategory.popup:
            return PopupPage()
        case DialogsFlyoutsCategory.teachingTip:
            return TeachingTipPage()

        default:
            // 没实现的页面先给个空 Grid，避免崩溃
            return Grid()
        }
    }

    /// 打开/激活某个 Category 对应的标签页
    private func openTab(for category: any Category) {
        let raw = category.rawValue
        let headerText = category.text

        // 如果已有同 rawValue 的 Tab，则只选中
        if let items = tabView.tabItems {
            let count = Int(items.size)
            for i in 0..<count {
                if let item = items.getAt(UInt32(i)) as? TabViewItem,
                   let tag = item.tag as? String,
                   tag == raw {
                    tabView.selectedItem = item
                    self.currentPageTextBlock.text = headerText
                    return
                }
            }
        }

        // 否则创建新 Tab
        let tab = TabViewItem()
        tab.header = headerText
        tab.tag = raw

        // 如果是主分类，给个图标
        if let main = category as? MainCategory {
            let iconSource = FontIconSource()
            iconSource.glyph = main.glyph
            tab.iconSource = iconSource
        }

        tab.content = createPage(for: category)

        attachCloseHandler(for: tab)

        tabView.tabItems.append(tab)
        tabView.selectedItem = tab
        self.currentPageTextBlock.text = headerText
    }

    // MARK: - Category 查找

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
        for categoryType in Self.categoryTypes {
            if let category = categoryType.init(rawValue: rawValue) {
                return category
            }
        }
        return nil
    }

    // MARK: - 导航历史（Back/Forward）

    private func updateNavButtonsState() {
        backButton.isEnabled = stack.count > 1
        forwardButton.isEnabled = !forwardStack.isEmpty
    }

    private func navigateBack() {
        guard stack.count > 1 else { return }

        let current = stack.removeLast()
        forwardStack.append(current)

        let previous = stack.last ?? MainCategory.home
        viewModel.navigateCommand.execute(parameter: previous)

        updateNavButtonsState()
    }

    private func navigateForward() {
        guard let next = forwardStack.popLast() else { return }

        stack.append(next)
        viewModel.navigateCommand.execute(parameter: next)

        updateNavButtonsState()
    }

    private func navigate() {
        guard
            let item = self.navigationView.selectedItem as? NavigationViewItem,
            let tag = (item.tag as? Uri)?.host,
            let category = self.findCategory(byRawValue: tag)
        else { return }

        if !category.canSelect { return }
        stack.append(category)
        self.viewModel.navigateCommand.execute(parameter: category)
    }

    // MARK: - ViewModel 绑定

    func bindViewModel() {
        // NavigationView 切换 View 事件
        navigationView.selectionChanged.addHandler { [unowned self] _, _ in
            guard
                let item = self.navigationView.selectedItem as? NavigationViewItem,
                let tag = (item.tag as? Uri)?.host,
                let category = self.findCategory(byRawValue: tag)
            else { return }

            if !category.canSelect { return }

            // 用户主动点菜单：清空“前进”历史
            self.forwardStack.removeAll()

            self.stack.append(category)
            self.viewModel.navigateCommand.execute(parameter: category)

            self.updateNavButtonsState()
        }

        // 默认选中第一个菜单项
        if let firstItem = navigationView.menuItems.first {
            navigationView.selectedItem = firstItem
        }

        // ViewModel 属性变化
        viewModel.propertyChanged = { [unowned self] propertyName in
            self.handlePropertyChanged(propertyName)
        }

        // 导航位置变化（左侧 / 顶部）
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("NaviPositionChanged"),
            object: nil,
            queue: .main
        ) { [weak self] notification in
            print("[MainWindow.swift--DEBUG] NaviPositionChanged: \(notification.object as? Int)")
            guard let self = self, let index = notification.object as? Int else { return }
            print("[MainWindow.swift--DEBUG] NaviPositionChanged: \(index)")
            switch index {
            case 0: // Left
                print("Left")
                self.navigationView.paneDisplayMode = .left
            case 1: // Top
                print("Top")
                self.navigationView.paneDisplayMode = .top
            default:
                break
            }
        }

        // 初始更新
        handlePropertyChanged("selectedCategory")
    }

    private func handlePropertyChanged(_ propertyName: String) {
        switch propertyName {
        case "selectedCategory":
            let item: any Category = viewModel.selectedCategory
            // 更新副标题 + 打开/激活标签页
            self.currentPageTextBlock.text = item.text
            self.openTab(for: item)
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
            case CollectionsCategory.listBox:
                rootFrame.content = ListBoxPage()
            case CollectionsCategory.pullToRefresh:
                rootFrame.content = PullToRefreshPage()
            case CollectionsCategory.treeView:
                rootFrame.content = TreeViewPage()
            case ScrollingCategory.annotatedScrollBar:
                rootFrame.content = AnnotatedScrollBarPage()
            case ScrollingCategory.pipsPager:
                rootFrame.content = PipsPagerPage()
            case ScrollingCategory.scrollView:
                rootFrame.content = ScrollViewPage()
            case ScrollingCategory.scrollViewer:
                rootFrame.content = ScrollViewerPage()
            case ScrollingCategory.semanticZoom:
                rootFrame.content = SemanticZoomPage()
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
            case LayoutCategory.stackPanel:
                rootFrame.content = StackPanelPage()
            case LayoutCategory.variableSizedWrapGrid:
                rootFrame.content = variableGridPage()
            case LayoutCategory.viewBox:
                rootFrame.content = ViewBoxPage()
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
            case MenusToolbarsCategory.appBarToggleButton:
                rootFrame.content = AppBarToggleButtonPage()
            case MenusToolbarsCategory.commandBar:
                rootFrame.content = CommandBarPage()
            case MenusToolbarsCategory.commandBarFlyout:
                rootFrame.content = CommandBarFlyoutPage()
            case MediaCategory.image:
                rootFrame.content = ImagePage()
            case MediaCategory.personPicture:
                rootFrame.content = PersonPicturePage()
            case MediaCategory.webView2:
                rootFrame.content = WebView2Page()
            case WindowingCategory.titleBar:
                rootFrame.content = TitlebarPage()
            case SystemCategory.filePicker:
                rootFrame.content = StoragePickersPage()
            case SystemCategory.appNotifications:
                rootFrame.content = AppNotificationsPage()
            case DialogsFlyoutsCategory.contentDialog:
                rootFrame.content = ContentDialogPage()
            case SystemCategory.badgeNotifications: 
                rootFrame.content = BadgeNotificationsPage()
            case DialogsFlyoutsCategory.flyout:
                rootFrame.content = FlyoutPage()
            case DialogsFlyoutsCategory.popup:
                rootFrame.content = PopupPage()
            case DialogsFlyoutsCategory.teachingTip:
                rootFrame.content = TeachingTipPage()
            case StatusInfoCategory.infoBadge:
                rootFrame.content = InfoBadgePage()
            case StatusInfoCategory.infoBar:
                rootFrame.content = InfoBarPage()
            case StatusInfoCategory.progressBar:
                rootFrame.content = ProgressBarPage()
            case StatusInfoCategory.progressRing:
                rootFrame.content = ProgressRingPage()
            case StatusInfoCategory.toolTip:
                rootFrame.content = ToolTipPage()
            default:
                break
            }
        default:
            break
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
