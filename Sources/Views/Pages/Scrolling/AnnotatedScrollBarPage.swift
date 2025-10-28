import WinUI
import WinAppSDK
import Foundation
import UWP

class AnnotatedScrollBarPage: Grid {
    // MARK: - Properties
    private var mainScrollViewer: ScrollViewer!
    private var contentStackPanel: StackPanel!
    private var demoGrid: Grid!
    private var demoScrollViewer: ScrollViewer!
    private var annotatedScrollBar: Grid!
    private var scrollIndicator: Border!
    private var labelsCanvas: Canvas!
    private var heightSlider: Slider!
    private var currentHeightText: TextBlock!
    private var sourceCodePanel: StackPanel!
    private var sourceCodeToggleButton: Button!
    private var sourceCodeContent: Border!
    
    private let colorData: [(name: String, r: UInt8, g: UInt8, b: UInt8)] = [
        ("Azure", 240, 255, 255),
        ("Crimson", 220, 20, 60),
        ("Cyan", 0, 255, 255),
        ("Fuchsia", 255, 0, 255),
        ("Gold", 255, 215, 0),
        ("Lime", 0, 255, 0),
        ("Magenta", 255, 0, 255),
        ("Orange", 255, 165, 0),
        ("Pink", 255, 192, 203),
        ("Purple", 128, 0, 128),
        ("Red", 255, 0, 0),
        ("Silver", 192, 192, 192),
        ("Teal", 0, 128, 128),
        ("Violet", 238, 130, 238),
        ("Yellow", 255, 255, 0)
    ]
    
    private var currentColorIndex: Int = 0
    private var isUpdatingScroll = false
    private var isSourceCodeVisible = false
    
    private var scrollBarHeight: Double = 400
    
    // MARK: - Initialization
    override init() {
        super.init()
        setupView()
    }
    
    private func setupView() {
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
        contentStackPanel.children.append(createSourceCodeSection())
        
        mainScrollViewer.content = contentStackPanel
        self.children.append(mainScrollViewer)
    }
    
    private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 8
        
        let titleText = TextBlock()
        titleText.text = "AnnotatedScrollBar"
        titleText.fontSize = 32
        titleText.fontWeight = FontWeights.semiBold
        headerPanel.children.append(titleText)
        
        return headerPanel
    }
    
    private func createDescription() -> TextBlock {
        let descText = TextBlock()
        descText.text = "The AnnotatedScrollBar lets you navigate through a large collection of items via a clickable rail with labels which act as markers."
        descText.fontSize = 14
        descText.textWrapping = .wrap
        descText.opacity = 0.8
        return descText
    }
    
    private func createSubtitle() -> TextBlock {
        let subtitleText = TextBlock()
        subtitleText.text = "AnnotatedScrollBar linked to a ScrollView."
        subtitleText.fontSize = 16
        subtitleText.fontWeight = FontWeights.semiBold
        subtitleText.margin = Thickness(left: 0, top: 8, right: 0, bottom: 0)
        return subtitleText
    }
    
    // MARK: - Create Main Content
    private func createMainContent() -> Border {
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
        
        demoGrid = Grid()
        
        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 1, gridUnitType: .star)
        demoGrid.columnDefinitions.append(col1)
        
        let col2 = ColumnDefinition()
        col2.width = GridLength(value: 450, gridUnitType: .pixel)
        demoGrid.columnDefinitions.append(col2)
        
        let leftSection = createLeftDemoSection()
        try? Grid.setColumn(leftSection, 0)
        demoGrid.children.append(leftSection)
        
        let rightSection = createRightControlSection()
        try? Grid.setColumn(rightSection, 1)
        demoGrid.children.append(rightSection)
        
        outerBorder.child = demoGrid
        return outerBorder
    }
    
    // MARK: - Create Left Demo Section
    private func createLeftDemoSection() -> Grid {
        let leftGrid = Grid()
        leftGrid.padding = Thickness(left: 24, top: 24, right: 24, bottom: 24)
        
        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 1, gridUnitType: .star)
        leftGrid.columnDefinitions.append(col1)
        
        let col2 = ColumnDefinition()
        col2.width = GridLength(value: 150, gridUnitType: .pixel)
        leftGrid.columnDefinitions.append(col2)
        
        let colorBlocks = createColorBlocksArea()
        try? Grid.setColumn(colorBlocks, 0)
        leftGrid.children.append(colorBlocks)
        
        let annotatedBar = createAnnotatedScrollBar()
        try? Grid.setColumn(annotatedBar, 1)
        leftGrid.children.append(annotatedBar)
        
        return leftGrid
    }
    
    // MARK: - Create Color Blocks Area
    private func createColorBlocksArea() -> ScrollViewer {
        demoScrollViewer = ScrollViewer()
        demoScrollViewer.height = scrollBarHeight
        demoScrollViewer.verticalScrollBarVisibility = .hidden
        demoScrollViewer.horizontalScrollBarVisibility = .disabled
        
        let itemsPanel = StackPanel()
        itemsPanel.spacing = 0
        
        for (index, colorItem) in colorData.enumerated() {
            let rowContainer = createColorRow(colorItem: colorItem, index: index)
            itemsPanel.children.append(rowContainer)
        }
        
        demoScrollViewer.viewChanged.addHandler { [weak self] sender, args in
            guard let self = self, !self.isUpdatingScroll else { return }
            self.updateScrollIndicator()
            self.updateCurrentColor()
        }
        
        demoScrollViewer.content = itemsPanel
        return demoScrollViewer
    }
    
    // MARK: - Create Color Row（2x8 = 16 个块，宽度 x3）
    private func createColorRow(colorItem: (name: String, r: UInt8, g: UInt8, b: UInt8), index: Int) -> Grid {
        let rowGrid = Grid()
        rowGrid.height = 600  // 200 * 3 = 600
        rowGrid.margin = Thickness(left: 0, top: 0, right: 0, bottom: 4)
        
        // 定义 2 列
        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 1, gridUnitType: .star)
        rowGrid.columnDefinitions.append(col1)
        
        let col2 = ColumnDefinition()
        col2.width = GridLength(value: 1, gridUnitType: .star)
        rowGrid.columnDefinitions.append(col2)
        
        // 定义 8 行
        for _ in 0..<8 {
            let row = RowDefinition()
            row.height = GridLength(value: 1, gridUnitType: .star)
            rowGrid.rowDefinitions.append(row)
        }
        
        rowGrid.columnSpacing = 4
        rowGrid.rowSpacing = 4
        
        // 创建 16 个彩色方块（2 列 x 8 行）
        for row in 0..<8 {
            for col in 0..<2 {
                let box = Border()
                box.cornerRadius = CornerRadius(topLeft: 4, topRight: 4, bottomRight: 4, bottomLeft: 4)
                
                let brush = SolidColorBrush()
                var color = UWP.Color()
                color.a = 255
                color.r = colorItem.r
                color.g = colorItem.g
                color.b = colorItem.b
                brush.color = color
                box.background = brush
                
                try? Grid.setColumn(box, Int32(col))
                try? Grid.setRow(box, Int32(row))
                rowGrid.children.append(box)
            }
        }
        
        return rowGrid
    }
    
    // MARK: - Create Annotated ScrollBar
    private func createAnnotatedScrollBar() -> Grid {
        annotatedScrollBar = Grid()
        annotatedScrollBar.height = scrollBarHeight
        annotatedScrollBar.background = nil
        
        // 底层：Canvas 放置标签
        labelsCanvas = Canvas()
        labelsCanvas.height = scrollBarHeight
        labelsCanvas.background = nil
        
        // 按比例分布标签
        let totalColors = Double(colorData.count)
        for (index, colorItem) in colorData.enumerated() {
            let ratio = Double(index) / (totalColors - 1)
            let yPosition = ratio * (scrollBarHeight - 30)
            
            let labelText = TextBlock()
            labelText.text = colorItem.name
            labelText.fontSize = 14
            labelText.padding = Thickness(left: 8, top: 4, right: 8, bottom: 4)
            
            try? Canvas.setTop(labelText, yPosition)
            try? Canvas.setLeft(labelText, 0)
            
            labelsCanvas.children.append(labelText)
        }
        
        annotatedScrollBar.children.append(labelsCanvas)
        
        // 中层：蓝色指示器
        scrollIndicator = Border()
        scrollIndicator.width = 40
        scrollIndicator.height = 3
        scrollIndicator.verticalAlignment = .top
        scrollIndicator.horizontalAlignment = .left
        scrollIndicator.cornerRadius = CornerRadius(topLeft: 2, topRight: 2, bottomRight: 2, bottomLeft: 2)
        scrollIndicator.margin = Thickness(left: 8, top: 0, right: 0, bottom: 0)
        scrollIndicator.isHitTestVisible = false
        
        let brush = SolidColorBrush()
        var indicatorColor = UWP.Color()
        indicatorColor.a = 255
        indicatorColor.r = 0
        indicatorColor.g = 120
        indicatorColor.b = 215
        brush.color = indicatorColor
        scrollIndicator.background = brush
        
        annotatedScrollBar.children.append(scrollIndicator)
        
        // 添加 Tapped 事件处理
        annotatedScrollBar.tapped.addHandler { [weak self] sender, args in
            self?.handleScrollBarTapped(args)
        }
        
        return annotatedScrollBar
    }
    
    // MARK: - Handle ScrollBar Tapped
    private func handleScrollBarTapped(_ args: TappedRoutedEventArgs?) {
        guard let args = args, let annotatedScrollBar = annotatedScrollBar else { return }
        
        // 获取点击位置
        guard let pointerPoint = try? args.getPosition(annotatedScrollBar) else {
            print("Failed to get tap position")
            return
        }
        
        let clickY = pointerPoint.y
        
        // 计算点击位置对应的滚动比例
        let ratio = Double(clickY) / scrollBarHeight
        
        print("Tapped at Y: \(clickY), Ratio: \(ratio)")
        
        // 滚动到对应位置
        isUpdatingScroll = true
        
        let maxScroll = demoScrollViewer.scrollableHeight
        let targetOffset = ratio * maxScroll
        
        print("Scrolling to offset: \(targetOffset) / \(maxScroll)")
        
        try? demoScrollViewer.scrollToVerticalOffset(targetOffset)
        
        updateScrollIndicator()
        
        isUpdatingScroll = false
    }
    
    // MARK: - Update Scroll Indicator Position
    private func updateScrollIndicator() {
        guard let scrollIndicator = scrollIndicator else { return }
        
        // 计算当前滚动比例
        let scrollRatio = demoScrollViewer.verticalOffset / max(demoScrollViewer.scrollableHeight, 1)
        
        // 计算指示器位置
        let indicatorY = scrollRatio * (scrollBarHeight - 20)
        
        scrollIndicator.margin = Thickness(
            left: 8,
            top: indicatorY,
            right: 0,
            bottom: 0
        )
    }
    
    private func updateCurrentColor() {
        let offset = demoScrollViewer.verticalOffset
        let itemHeight: Double = 604  // 600 + 4 (margin)
        let index = Int(offset / itemHeight)
        
        if index >= 0 && index < colorData.count && index != currentColorIndex {
            currentColorIndex = index
            print("Current color: \(colorData[index].name)")
        }
    }
    
    private func updateScrollBarHeight(_ newHeight: Double) {
        scrollBarHeight = newHeight
        
        // 更新滚动条高度
        demoScrollViewer.height = newHeight
        annotatedScrollBar.height = newHeight
        labelsCanvas.height = newHeight
        
        // 重新布局标签
        labelsCanvas.children.clear()
        
        let totalColors = Double(colorData.count)
        for (index, colorItem) in colorData.enumerated() {
            let ratio = Double(index) / (totalColors - 1)
            let yPosition = ratio * (newHeight - 30)
            
            let labelText = TextBlock()
            labelText.text = colorItem.name
            labelText.fontSize = 14
            labelText.padding = Thickness(left: 8, top: 4, right: 8, bottom: 4)
            
            try? Canvas.setTop(labelText, yPosition)
            try? Canvas.setLeft(labelText, 0)
            
            labelsCanvas.children.append(labelText)
        }
        
        // 更新指示器位置
        updateScrollIndicator()
    }
    
    // MARK: - Create Right Control Section
    private func createRightControlSection() -> StackPanel {
        let controlPanel = StackPanel()
        controlPanel.spacing = 16
        controlPanel.padding = Thickness(left: 24, top: 24, right: 24, bottom: 24)
        
        let titleText = TextBlock()
        titleText.text = "Changing the AnnotatedScrollBar height refreshes its Labels layout."
        titleText.fontSize = 14
        titleText.textWrapping = .wrap
        controlPanel.children.append(titleText)
        
        let info2 = TextBlock()
        info2.text = "AnnotatedScrollBar maximum height:"
        info2.fontSize = 14
        info2.fontWeight = FontWeights.semiBold
        info2.margin = Thickness(left: 0, top: 8, right: 0, bottom: 0)
        controlPanel.children.append(info2)
        
        let sliderPanel = createHeightSlider()
        controlPanel.children.append(sliderPanel)
        
        return controlPanel
    }
    
    private func createHeightSlider() -> StackPanel {
        let sliderPanel = StackPanel()
        sliderPanel.spacing = 12
        
        heightSlider = Slider()
        heightSlider.minimum = 200
        heightSlider.maximum = 600
        heightSlider.value = scrollBarHeight
        heightSlider.horizontalAlignment = .stretch
        
        currentHeightText = TextBlock()
        currentHeightText.text = "Current height: \(Int(scrollBarHeight))"
        currentHeightText.fontSize = 12
        currentHeightText.opacity = 0.7
        
        heightSlider.valueChanged.addHandler { [weak self] sender, args in
            guard let self = self, let args = args else { return }
            let newHeight = args.newValue
            
            self.updateScrollBarHeight(newHeight)
            self.currentHeightText.text = "Current height: \(Int(newHeight))"
        }
        
        sliderPanel.children.append(heightSlider)
        sliderPanel.children.append(currentHeightText)
        
        return sliderPanel
    }
    
    // MARK: - Create Source Code Section
    private func createSourceCodeSection() -> Border {
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
        
        outerBorder.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        
        sourceCodePanel = StackPanel()
        sourceCodePanel.spacing = 8
        
        sourceCodeToggleButton = Button()
        sourceCodeToggleButton.content = "▼ Source code"
        sourceCodeToggleButton.horizontalAlignment = .left
        sourceCodeToggleButton.padding = Thickness(left: 12, top: 8, right: 12, bottom: 8)
        sourceCodeToggleButton.background = nil
        sourceCodeToggleButton.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        
        sourceCodeToggleButton.click.addHandler { [weak self] sender, args in
            self?.toggleSourceCode()
        }
        
        sourceCodePanel.children.append(sourceCodeToggleButton)
        
        sourceCodeContent = Border()
        sourceCodeContent.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        sourceCodeContent.cornerRadius = CornerRadius(topLeft: 4, topRight: 4, bottomRight: 4, bottomLeft: 4)
        sourceCodeContent.visibility = .collapsed
        
        let codeText = TextBlock()
        codeText.text = """
        // Swift WinUI Code Example
        
        let scrollViewer = ScrollViewer()
        scrollViewer.height = 400
        scrollViewer.verticalScrollBarVisibility = .hidden
        
        // Create annotated scroll bar with labels
        let canvas = Canvas()
        for (index, colorItem) in colorData.enumerated() {
            let ratio = Double(index) / Double(colorData.count - 1)
            let yPosition = ratio * scrollBarHeight
            
            let label = TextBlock()
            label.text = colorItem.name
            Canvas.setTop(label, yPosition)
            canvas.children.append(label)
        }
        
        // Handle tapped event
        annotatedScrollBar.tapped.addHandler { sender, args in
            let position = args.getPosition(annotatedScrollBar)
            let ratio = position.y / scrollBarHeight
            scrollViewer.scrollToVerticalOffset(ratio * maxScroll)
        }
        """
        codeText.fontSize = 12
        codeText.fontFamily = FontFamily("Consolas")
        codeText.textWrapping = .wrap
        
        sourceCodeContent.child = codeText
        sourceCodePanel.children.append(sourceCodeContent)
        
        outerBorder.child = sourceCodePanel
        
        return outerBorder
    }
    
    private func toggleSourceCode() {
        isSourceCodeVisible = !isSourceCodeVisible
        
        if isSourceCodeVisible {
            sourceCodeContent.visibility = .visible
            sourceCodeToggleButton.content = "▲ Source code"
        } else {
            sourceCodeContent.visibility = .collapsed
            sourceCodeToggleButton.content = "▼ Source code"
        }
    }
}