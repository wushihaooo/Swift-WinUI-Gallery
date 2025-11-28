import WinUI
import WinAppSDK
import Foundation
import UWP
import WindowsFoundation

class SemanticZoomPage: Grid {
    // MARK: - Properties
    private var mainScrollViewer: ScrollViewer!
    private var contentStackPanel: StackPanel!
    
    // Zoomed In View (详细视图)
    private var zoomedInListView: ListView!
    private var currentHeaderText: TextBlock!
    private var zoomedInViewContainer: Grid!
    
    // Zoomed Out View (索引视图)
    private var zoomedOutGridView: GridView!
    private var zoomedOutViewContainer: Grid!
    
    private var isZoomedIn: Bool = true
    private var currentDisplayedGroup: String = "A"
    
    // 颜色数据 - 按首字母分组
    private let colorGroups: [(header: String, colors: [(name: String, r: UInt8, g: UInt8, b: UInt8)])] = [
        ("A", [
            ("AliceBlue", 240, 248, 255),
            ("AntiqueWhite", 250, 235, 215),
            ("Aqua", 0, 255, 255),
            ("Aquamarine", 127, 255, 212),
            ("Azure", 240, 255, 255)
        ]),
        ("B", [
            ("Beige", 245, 245, 220),
            ("Bisque", 255, 228, 196),
            ("Black", 0, 0, 0),
            ("BlanchedAlmond", 255, 235, 205),
            ("Blue", 0, 0, 255),
            ("BlueViolet", 138, 43, 226),
            ("Brown", 165, 42, 42),
            ("BurlyWood", 222, 184, 135)
        ]),
        ("C", [
            ("CadetBlue", 95, 158, 160),
            ("Chartreuse", 127, 255, 0),
            ("Chocolate", 210, 105, 30),
            ("Coral", 255, 127, 80),
            ("CornflowerBlue", 100, 149, 237),
            ("Cornsilk", 255, 248, 220),
            ("Crimson", 220, 20, 60),
            ("Cyan", 0, 255, 255)
        ]),
        ("D", [
            ("DarkBlue", 0, 0, 139),
            ("DarkCyan", 0, 139, 139),
            ("DarkGoldenrod", 184, 134, 11),
            ("DarkGray", 169, 169, 169),
            ("DarkGreen", 0, 100, 0),
            ("DarkKhaki", 189, 183, 107),
            ("DarkMagenta", 139, 0, 139),
            ("DarkOliveGreen", 85, 107, 47)
        ]),
        ("F", [
            ("FireBrick", 178, 34, 34),
            ("FloralWhite", 255, 250, 240),
            ("ForestGreen", 34, 139, 34),
            ("Fuchsia", 255, 0, 255)
        ]),
        ("G", [
            ("Gainsboro", 220, 220, 220),
            ("GhostWhite", 248, 248, 255),
            ("Gold", 255, 215, 0),
            ("Goldenrod", 218, 165, 32),
            ("Gray", 128, 128, 128),
            ("Green", 0, 128, 0),
            ("GreenYellow", 173, 255, 47)
        ]),
        ("I", [
            ("IndianRed", 205, 92, 92),
            ("Indigo", 75, 0, 130),
            ("Ivory", 255, 255, 240)
        ]),
        ("L", [
            ("Lavender", 230, 230, 250),
            ("LavenderBlush", 255, 240, 245),
            ("LawnGreen", 124, 252, 0),
            ("LemonChiffon", 255, 250, 205),
            ("LightBlue", 173, 216, 230),
            ("LightCoral", 240, 128, 128),
            ("LightCyan", 224, 255, 255),
            ("Lime", 0, 255, 0)
        ]),
        ("M", [
            ("Magenta", 255, 0, 255),
            ("Maroon", 128, 0, 0),
            ("MediumBlue", 0, 0, 205),
            ("MidnightBlue", 25, 25, 112),
            ("MintCream", 245, 255, 250),
            ("MistyRose", 255, 228, 225),
            ("Moccasin", 255, 228, 181)
        ]),
        ("O", [
            ("Orange", 255, 165, 0),
            ("OrangeRed", 255, 69, 0),
            ("Orchid", 218, 112, 214)
        ]),
        ("P", [
            ("PaleGreen", 152, 251, 152),
            ("PaleTurquoise", 175, 238, 238),
            ("PaleVioletRed", 219, 112, 147),
            ("PapayaWhip", 255, 239, 213),
            ("PeachPuff", 255, 218, 185),
            ("Peru", 205, 133, 63),
            ("Pink", 255, 192, 203),
            ("Plum", 221, 160, 221),
            ("Purple", 128, 0, 128)
        ]),
        ("R", [
            ("Red", 255, 0, 0),
            ("RosyBrown", 188, 143, 143),
            ("RoyalBlue", 65, 105, 225)
        ]),
        ("S", [
            ("SaddleBrown", 139, 69, 19),
            ("Salmon", 250, 128, 114),
            ("SandyBrown", 244, 164, 96),
            ("SeaGreen", 46, 139, 87),
            ("SeaShell", 255, 245, 238),
            ("Sienna", 160, 82, 45),
            ("Silver", 192, 192, 192),
            ("SkyBlue", 135, 206, 235),
            ("SlateBlue", 106, 90, 205),
            ("Snow", 255, 250, 250),
            ("SpringGreen", 0, 255, 127),
            ("SteelBlue", 70, 130, 180)
        ]),
        ("T", [
            ("Tan", 210, 180, 140),
            ("Teal", 0, 128, 128),
            ("Thistle", 216, 191, 216),
            ("Tomato", 255, 99, 71),
            ("Turquoise", 64, 224, 208)
        ]),
        ("V", [
            ("Violet", 238, 130, 238)
        ]),
        ("W", [
            ("Wheat", 245, 222, 179),
            ("White", 255, 255, 255),
            ("WhiteSmoke", 245, 245, 245)
        ]),
        ("Y", [
            ("Yellow", 255, 255, 0),
            ("YellowGreen", 154, 205, 50)
        ])
    ]
    
    // MARK: - Initialization
    nonisolated(unsafe) override init() {
        super.init()
        setupView()
    }
    
    nonisolated(unsafe) private func setupView() {
        let rowDef = RowDefinition()
        rowDef.height = GridLength(value: 1, gridUnitType: .star)
        self.rowDefinitions.append(rowDef)
        
        mainScrollViewer = ScrollViewer()
        mainScrollViewer.verticalScrollBarVisibility = .auto
        mainScrollViewer.horizontalScrollBarVisibility = .disabled
        
        contentStackPanel = StackPanel()
        contentStackPanel.padding = Thickness(left: 40, top: 40, right: 40, bottom: 40)
        contentStackPanel.spacing = 24
        
        contentStackPanel.children.append(createHeader())
        contentStackPanel.children.append(createDescription())
        contentStackPanel.children.append(createSubtitle())
        contentStackPanel.children.append(createMainContent())
        
        mainScrollViewer.content = contentStackPanel
        self.children.append(mainScrollViewer)
    }
    
    nonisolated(unsafe) private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 8
        
        let titleText = TextBlock()
        titleText.text = "SemanticZoom"
        titleText.fontSize = 32
        titleText.fontWeight = FontWeights.semiBold
        headerPanel.children.append(titleText)
        
        return headerPanel
    }
    
    nonisolated(unsafe) private func createDescription() -> TextBlock {
        let descText = TextBlock()
        descText.text = "The SemanticZoom lets you show grouped data in two different ways, and is useful for quickly navigating through large sets of data."
        descText.fontSize = 14
        descText.textWrapping = .wrap
        descText.opacity = 0.8
        return descText
    }
    
    nonisolated(unsafe) private func createSubtitle() -> TextBlock {
        let subtitleText = TextBlock()
        subtitleText.text = "A simple SemanticZoom"
        subtitleText.fontSize = 16
        subtitleText.fontWeight = FontWeights.semiBold
        subtitleText.margin = Thickness(left: 0, top: 8, right: 0, bottom: 0)
        return subtitleText
    }
    
    // MARK: - Create Main Content
    nonisolated(unsafe) private func createMainContent() -> Border {
        let outerBorder = Border()
        outerBorder.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        outerBorder.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        
        let borderBrush = SolidColorBrush()
        var borderColor = UWP.Color()
        borderColor.a = 255
        borderColor.r = 200
        borderColor.g = 200
        borderColor.b = 200
        borderBrush.color = borderColor
        outerBorder.borderBrush = borderBrush
        
        outerBorder.margin = Thickness(left: 0, top: 16, right: 0, bottom: 16)
        outerBorder.padding = Thickness(left: 24, top: 24, right: 24, bottom: 24)
        
        let contentPanel = createSemanticZoomControl()
        outerBorder.child = contentPanel
        
        return outerBorder
    }
    
    // MARK: - Create SemanticZoom Control
    nonisolated(unsafe) private func createSemanticZoomControl() -> StackPanel {
        let container = StackPanel()
        container.spacing = 16
        
        // 说明文字
        let instructionText = TextBlock()
        instructionText.text = "Scroll to browse colors. Tap the header to switch to group view."
        instructionText.fontSize = 14
        instructionText.textWrapping = .wrap
        instructionText.opacity = 0.7
        container.children.append(instructionText)
        
        // 主容器
        let mainContainer = Grid()
        mainContainer.height = 500
        
        // 放大视图（详细视图）
        let zoomedInView = createZoomedInViewWithHeader()
        mainContainer.children.append(zoomedInView)
        
        // 缩小视图（索引视图）
        let zoomedOutView = createZoomedOutViewSimple()
        zoomedOutView.visibility = .collapsed
        mainContainer.children.append(zoomedOutView)
        
        container.children.append(mainContainer)
        
        return container
    }
    
    // MARK: - Create Zoomed In View with Fixed Header (详细视图带固定表头)
    nonisolated(unsafe) private func createZoomedInViewWithHeader() -> Grid {
        zoomedInViewContainer = Grid()
        
        // 定义行：Header + Content
        let row1 = RowDefinition()
        row1.height = GridLength(value: 0, gridUnitType: .auto)
        zoomedInViewContainer.rowDefinitions.append(row1)
        
        let row2 = RowDefinition()
        row2.height = GridLength(value: 1, gridUnitType: .star)
        zoomedInViewContainer.rowDefinitions.append(row2)
        
        // 固定表头 - 可点击
        let headerButton = Button()
        headerButton.horizontalAlignment = .stretch
        headerButton.horizontalContentAlignment = .left
        headerButton.padding = Thickness(left: 16, top: 12, right: 16, bottom: 12)
        headerButton.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 1)
        
        let borderBrush = SolidColorBrush()
        var borderColor = UWP.Color()
        borderColor.a = 255
        borderColor.r = 200
        borderColor.g = 200
        borderColor.b = 200
        borderBrush.color = borderColor
        headerButton.borderBrush = borderBrush
        
        currentHeaderText = TextBlock()
        currentHeaderText.text = "A"
        currentHeaderText.fontSize = 24
        currentHeaderText.fontWeight = FontWeights.semiBold
        headerButton.content = currentHeaderText
        
        // 点击表头切换到缩小视图
        headerButton.click.addHandler { [weak self] sender, args in
            self?.switchToZoomedOut()
        }
        
        try? Grid.setRow(headerButton, 0)
        zoomedInViewContainer.children.append(headerButton)
        
        // 创建 ListView
        zoomedInListView = ListView()
        zoomedInListView.selectionMode = .none
        
        // 填充所有颜色项，并添加组分隔线
        for group in colorGroups {
            // 添加组分隔线
            let separator = createGroupSeparator(header: group.header)
            zoomedInListView.items.append(separator)
            
            // 添加颜色项
            for color in group.colors {
                let item = createColorListItem(
                    colorName: color.name,
                    r: color.r,
                    g: color.g,
                    b: color.b,
                    header: group.header
                )
                zoomedInListView.items.append(item)
            }
        }
        
        // 监听容器加载完成后获取 ScrollViewer
        zoomedInListView.loaded.addHandler { [weak self] sender, args in
            self?.setupScrollViewerMonitoring()
        }
        
        try? Grid.setRow(zoomedInListView, 1)
        zoomedInViewContainer.children.append(zoomedInListView)
        
        return zoomedInViewContainer
    }
    
    // MARK: - Create Zoomed Out View Simple (缩小视图)
    nonisolated(unsafe) private func createZoomedOutViewSimple() -> Grid {
        zoomedOutViewContainer = Grid()
        zoomedOutViewContainer.padding = Thickness(left: 20, top: 20, right: 20, bottom: 20)
        
        zoomedOutGridView = GridView()
        zoomedOutGridView.isItemClickEnabled = true
        
        // 添加所有组的首字母
        for (index, group) in colorGroups.enumerated() {
            let headerButton = createGroupHeaderButton(header: group.header, index: index)
            zoomedOutGridView.items.append(headerButton)
        }
        
        zoomedOutViewContainer.children.append(zoomedOutGridView)
        
        return zoomedOutViewContainer
    }
    
    // 切换到缩小视图
    nonisolated(unsafe) private func switchToZoomedOut() {
        isZoomedIn = false
        zoomedInViewContainer.visibility = .collapsed
        zoomedOutViewContainer.visibility = .visible
    }
    
    // 切换到放大视图
    nonisolated(unsafe) private func switchToZoomedIn() {
        isZoomedIn = true
        zoomedInViewContainer.visibility = .visible
        zoomedOutViewContainer.visibility = .collapsed
    }
    
    // 创建组分隔线
    nonisolated(unsafe) private func createGroupSeparator(header: String) -> Button {
        let separator = Button()
        separator.height = 36
        separator.padding = Thickness(left: 16, top: 8, right: 16, bottom: 8)
        separator.horizontalAlignment = .stretch
        separator.horizontalContentAlignment = .left
        separator.background = nil
        separator.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        
        let headerText = TextBlock()
        headerText.text = header
        headerText.fontSize = 16
        headerText.fontWeight = FontWeights.semiBold
        headerText.verticalAlignment = .center
        headerText.opacity = 0.7
        
        separator.content = headerText
        separator.tag = header as AnyObject
        
        // 点击分隔线时切换到缩小视图
        separator.click.addHandler { [weak self] sender, args in
            guard let self = self else { return }
            self.currentDisplayedGroup = header
            self.currentHeaderText.text = header
            self.switchToZoomedOut()
        }
        
        return separator
    }
    
    // 创建颜色列表项
    nonisolated(unsafe) private func createColorListItem(colorName: String, r: UInt8, g: UInt8, b: UInt8, header: String) -> Grid {
        let itemGrid = Grid()
        itemGrid.height = 90
        itemGrid.padding = Thickness(left: 16, top: 8, right: 16, bottom: 8)
        
        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 100, gridUnitType: .pixel)
        itemGrid.columnDefinitions.append(col1)
        
        let col2 = ColumnDefinition()
        col2.width = GridLength(value: 1, gridUnitType: .star)
        itemGrid.columnDefinitions.append(col2)
        
        // 颜色方块 - 调大尺寸
        let colorBlock = Border()
        colorBlock.width = 80
        colorBlock.height = 70
        colorBlock.cornerRadius = CornerRadius(topLeft: 4, topRight: 4, bottomRight: 4, bottomLeft: 4)
        
        let colorBrush = SolidColorBrush()
        var color = UWP.Color()
        color.a = 255
        color.r = r
        color.g = g
        color.b = b
        colorBrush.color = color
        colorBlock.background = colorBrush
        
        try? Grid.setColumn(colorBlock, 0)
        itemGrid.children.append(colorBlock)
        
        // 颜色名称 - 增大字体
        let nameText = TextBlock()
        nameText.text = colorName
        nameText.fontSize = 18
        nameText.verticalAlignment = .center
        nameText.margin = Thickness(left: 16, top: 0, right: 0, bottom: 0)
        
        try? Grid.setColumn(nameText, 1)
        itemGrid.children.append(nameText)
        
        return itemGrid
    }
    
    // 创建组标题按钮
    nonisolated(unsafe) private func createGroupHeaderButton(header: String, index: Int) -> Button {
        let button = Button()
        button.width = 100
        button.height = 100
        button.horizontalContentAlignment = .center
        button.verticalContentAlignment = .center
        
        let buttonText = TextBlock()
        buttonText.text = header
        buttonText.fontSize = 32
        buttonText.fontWeight = FontWeights.semiBold
        buttonText.horizontalAlignment = .center
        buttonText.verticalAlignment = .center
        
        button.content = buttonText
        
        // 点击跳转到对应组
        button.click.addHandler { [weak self] sender, args in
            self?.jumpToGroup(index: index)
        }
        
        return button
    }
    
    // 设置 ScrollViewer 监听
    nonisolated(unsafe) private func setupScrollViewerMonitoring() {
        // 获取 ListView 内部的 ScrollViewer
        guard let scrollViewer = findScrollViewer(zoomedInListView) else { return }
        
        // 监听滚动事件
        scrollViewer.viewChanged.addHandler { [weak self] sender, args in
            self?.updateHeaderBasedOnScrollPosition()
        }
    }
    
    // 查找 ScrollViewer
    nonisolated(unsafe) private func findScrollViewer(_ element: DependencyObject) -> ScrollViewer? {
        guard let childCount = try? VisualTreeHelper.getChildrenCount(element) else { return nil }
        
        for i in 0..<childCount {
            if let child = try? VisualTreeHelper.getChild(element, Int32(i)) {
                if let scrollViewer = child as? ScrollViewer {
                    return scrollViewer
                }
                if let found = findScrollViewer(child) {
                    return found
                }
            }
        }
        return nil
    }
    
    // 根据滚动位置更新表头
    nonisolated(unsafe) private func updateHeaderBasedOnScrollPosition() {
        guard let scrollViewer = findScrollViewer(zoomedInListView) else { return }
        
        let verticalOffset = scrollViewer.verticalOffset
        
        var accumulatedHeight: Double = 0
        var lastSeenGroup: String = "A"
        
        for i in 0..<zoomedInListView.items.count {
            guard let item = zoomedInListView.items.getAt(UInt32(i)) else { continue }
            
            var itemHeight: Double = 0
            
            // 判断是否为分隔线：Button 且高度为 36
            if let button = item as? Button, button.height == 36 {
                itemHeight = button.height
                // 从 content 读取组名
                if let textBlock = button.content as? TextBlock {
                    let group = textBlock.text
                    print("[Header] 索引 \(i): 找到分隔线 '\(group)'")
                    lastSeenGroup = group
                }
            } else if let grid = item as? Grid {
                itemHeight = grid.height
            }
            
            // 找到当前可见的项
            if accumulatedHeight + itemHeight > verticalOffset {
                if lastSeenGroup != currentDisplayedGroup {
                    print("[Header] ✅ 更新表头: \(currentDisplayedGroup) -> \(lastSeenGroup)")
                    currentDisplayedGroup = lastSeenGroup
                    currentHeaderText.text = lastSeenGroup
                }
                break
            }
            
            accumulatedHeight += itemHeight
        }
    }
    
    // 跳转到指定组
    nonisolated(unsafe) private func jumpToGroup(index: Int) {
        guard index >= 0 && index < colorGroups.count else { return }
        
        let targetGroup = colorGroups[index]
        
        // 计算目标位置（包括组分隔线）
        var calculatedIndex = 0
        for i in 0..<index {
            calculatedIndex += 1 + colorGroups[i].colors.count
        }
        
        let targetIndex = calculatedIndex
        
        // 先更新表头
        currentHeaderText.text = targetGroup.header
        currentDisplayedGroup = targetGroup.header
        
        // 切换回放大视图
        switchToZoomedIn()
        
        guard targetIndex < zoomedInListView.items.count else { return }
        
        // 延迟
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.15))
        
        // 关键：先滚动到后面一个位置，再滚动回来，确保总是从下往上滚动（对齐顶部）
        if targetIndex + 5 < zoomedInListView.items.count {
            let afterItem = zoomedInListView.items.getAt(UInt32(targetIndex + 5))
            try? zoomedInListView.scrollIntoView(afterItem)
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.05))
        }
        
        // 再滚动到目标位置
        let item = zoomedInListView.items.getAt(UInt32(targetIndex))
        try? zoomedInListView.scrollIntoView(item)
    }
    
}