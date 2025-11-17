import Foundation
import UWP
import WinAppSDK
import WindowsFoundation
import WinUI

class GridPage: Grid {
    private var titleGrid = Grid()//标题
    private var mainPanel = StackPanel() 
    private var grid: Grid!  // 3*3 Grid 容器
    private var rect1: Rectangle!  // 红色矩形（需控制位置）

    override init() {
        super.init()
        setTitle()
        setMainPanel()
        setUpView()
    }

    private func setUpView() {
        let titleBarRow = RowDefinition()
        titleBarRow.height = GridLength(value: 1, gridUnitType: .auto)
        self.rowDefinitions.append(titleBarRow)

        let mainRow = RowDefinition()
        mainRow.height = GridLength(value: 1, gridUnitType: .star)
        self.rowDefinitions.append(mainRow)
        
        self.children.append(titleGrid)
        try? Grid.setRow(titleGrid, 0)

        self.children.append(mainPanel)
        try? Grid.setRow(mainPanel, 1)

    }


    private func setTitle() {
        let titleRow = RowDefinition()
        titleRow.height = GridLength(value: 1, gridUnitType: .auto)
        titleGrid.rowDefinitions.append(titleRow)
        
        let descriptionRow = RowDefinition()
        descriptionRow.height = GridLength(value: 1, gridUnitType: .auto)
        titleGrid.rowDefinitions.append(descriptionRow)

        let titleTextBlock = TextBlock()
        titleTextBlock.text = "Grid"
        titleTextBlock.fontSize = 30
        titleTextBlock.fontWeight = FontWeights.bold
        titleGrid.children.append(titleTextBlock)
        try? Grid.setRow(titleTextBlock, 0)

        let descriptionTextBlock = TextBlock()
        descriptionTextBlock.text = "The Grid is used to arrange controls and content in rows and columns. Content is positioned in the grid using Grid.Row and Grid.Column attached properties."
        descriptionTextBlock.fontSize = 16
        titleGrid.children.append(descriptionTextBlock)
        try? Grid.setRow(descriptionTextBlock, 1)

        titleGrid.margin = Thickness(left: 20, top: 10, right: 20, bottom: 10)

    }

    private func setMainPanel() {
        let descTextBlock = TextBlock()
        descTextBlock.text = "A 3*3 Grid control"
        descTextBlock.fontSize = 16
        descTextBlock.fontWeight = FontWeights.semiBold
        descTextBlock.margin = Thickness(left: 20, top: 10, right: 20, bottom: 10)
        mainPanel.children.append(descTextBlock)

        let showGrid = Grid()
        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 1, gridUnitType: .auto)
        showGrid.columnDefinitions.append(col1)

        let col2 = ColumnDefinition()
        col2.width = GridLength(value: 1, gridUnitType: .auto)
        showGrid.columnDefinitions.append(col2)
        
        showGrid.margin = Thickness(left: 20, top: 10, right: 20, bottom: 10)

        // 内容展示布局
        let leftPanel = StackPanel()
        leftPanel.height = Double(400)
        leftPanel.width = Double(800)
        leftPanel.background = SolidColorBrush(Colors.lightGray)
        leftPanel.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        leftPanel.borderBrush = SolidColorBrush(Colors.gray)
        leftPanel.orientation = Orientation.horizontal
        leftPanel.horizontalAlignment = HorizontalAlignment.left
        leftPanel.verticalAlignment = VerticalAlignment.top
        leftPanel.cornerRadius = CornerRadius(
            topLeft: 10, 
            topRight: 0, 
            bottomRight: 0, 
            bottomLeft: 10
        )

        // 初始化 Grid 容器（类属性）
        grid = Grid()
        grid.background = SolidColorBrush(Colors.white) 
        grid.width = Double(500)
        grid.height = Double(400)
        grid.margin = Thickness(left: 20, top: 10, right: 20, bottom: 10)
       
        
        // 添加 3 行（等比例分配）
        for _ in 0..<3 {
            let row = RowDefinition()
            row.height = GridLength(value: 1, gridUnitType: .star)
            grid.rowDefinitions.append(row)
        }

        // 添加 3 列（等比例分配）
        for _ in 0..<3 {
            let col = ColumnDefinition()
            col.width = GridLength(value: 1, gridUnitType: .star)
            grid.columnDefinitions.append(col)
        }

        // 初始化红色矩形（类属性）
        rect1 = Rectangle()
        rect1.width = 80
        rect1.height = 80
        rect1.horizontalAlignment = .center
        rect1.verticalAlignment = .center
        rect1.fill = SolidColorBrush(Colors.red)
        try? Grid.setRow(rect1, 0)  // 初始行：0
        try? Grid.setColumn(rect1, 0)  // 初始列：0
        rect1.margin = Thickness(left: 10, top: 10, right: 10, bottom: 10)
        grid.children.append(rect1)

        // 其他矩形（保持不变）
        let rect2 = Rectangle()
        rect2.width = 80
        rect2.height = 80
        rect2.horizontalAlignment = .center
        rect2.verticalAlignment = .center
        rect2.fill = SolidColorBrush(Colors.blue)
        try? Grid.setRow(rect2, 0)
        try? Grid.setColumn(rect2, 1)
        rect2.margin = Thickness(left: 10, top: 10, right: 10, bottom: 10)
        grid.children.append(rect2)

        let rect3 = Rectangle()
        rect3.width = 80
        rect3.height = 80
        rect3.horizontalAlignment = .center
        rect3.verticalAlignment = .center
        rect3.fill = SolidColorBrush(Colors.green)
        try? Grid.setRow(rect3, 1)
        try? Grid.setColumn(rect3, 0)
        rect3.margin = Thickness(left: 10, top: 10, right: 10, bottom: 10)
        grid.children.append(rect3)

        let rect4 = Rectangle()
        rect4.width = 80
        rect4.height = 80
        rect4.horizontalAlignment = .center
        rect4.verticalAlignment = .center
        rect4.fill = SolidColorBrush(Colors.yellow)
        try? Grid.setRow(rect4, 1)
        try? Grid.setColumn(rect4, 1)
        rect4.margin = Thickness(left: 10, top: 10, right: 10, bottom: 10)
        grid.children.append(rect4)

        leftPanel.children.append(grid)

        // 右边容器布局
        let rightPanel = StackPanel()
        rightPanel.height = Double(400)
        rightPanel.background = SolidColorBrush(Colors.white)
        rightPanel.borderThickness = Thickness(left: 0, top: 1, right: 1, bottom: 1)
        rightPanel.borderBrush = SolidColorBrush(Colors.gray)
        rightPanel.cornerRadius = CornerRadius(
            topLeft: 0, 
            topRight: 10, 
            bottomRight: 10, 
            bottomLeft: 0
        )
        rightPanel.padding = Thickness(left: 10, top: 10, right: 10, bottom: 10)
        rightPanel.orientation = Orientation.vertical

        // -------------------------- 上组：控制 Grid 行列间距 --------------------------
        let topGroup = StackPanel()
        topGroup.orientation = .vertical
        topGroup.horizontalAlignment = .left
        topGroup.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)

        let topLabel = TextBlock()
        topLabel.text = "Grid"
        topLabel.foreground = SolidColorBrush(Colors.black)
        topLabel.fontSize = 16


        // 列间距（ColumnSpacing）滑动条
        let topColText = TextBlock()
        topColText.text = "ColumnSpacing"
        topColText.foreground = SolidColorBrush(Colors.black)
        topColText.fontSize = 16
        let topColumn = StackPanel()
        topColumn.orientation = .vertical
        topColumn.horizontalAlignment = .left
        topColumn.margin = Thickness(left: 5, top: 5, right: 5, bottom: 5)
        let topColSlider = Slider()
        topColSlider.width = 100
        topColSlider.minimum = 0
        topColSlider.maximum = 50
        topColSlider.requestedTheme = ElementTheme.light
        topColSlider.value = 0  // 初始间距：0
        // 绑定事件：更新 Grid 列间距
        topColSlider.valueChanged.addHandler { [weak self] sender, args in
            guard let self = self, let args = args, let grid = self.grid else { return }
            grid.columnSpacing = args.newValue
        }

        // 行间距（RowSpacing）滑动条
        let topRowText = TextBlock()
        topRowText.text = "RowSpacing"
        topRowText.foreground = SolidColorBrush(Colors.black)
        topRowText.fontSize = 16
        let topRow = StackPanel()
        topRow.orientation = .vertical
        topRow.horizontalAlignment = .left
        topRow.margin = Thickness(left: 5, top: 5, right: 5, bottom: 5)
        let topRowSlider = Slider()
        topRowSlider.orientation = .vertical
        topRowSlider.height = 100
        topRowSlider.minimum = 0
        topRowSlider.maximum = 50
        topRowSlider.isDirectionReversed = true
        topRowSlider.requestedTheme = ElementTheme.light
        topRowSlider.value = 0  // 初始间距：0
        // 绑定事件：更新 Grid 行间距
        topRowSlider.valueChanged.addHandler { [weak self] sender, args in
            guard let self = self, let args = args, let grid = self.grid else { return }
            grid.rowSpacing = args.newValue
        }

        // 组装上组布局
        topColumn.children.append(topColText)
        topColumn.children.append(topColSlider)
        topRow.children.append(topRowText)
        topRow.children.append(topRowSlider)
        let top = StackPanel()
        top.orientation = .horizontal
        top.horizontalAlignment = .left
        top.children.append(topColumn)
        top.children.append(topRow)
        topGroup.children.append(topLabel)
        topGroup.children.append(top)

        // -------------------------- 下组：控制红色矩形位置 --------------------------
        let bottomGroup = StackPanel()
        bottomGroup.orientation = .vertical
        bottomGroup.horizontalAlignment = .left
        bottomGroup.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)

        let bottomLabel = TextBlock()
        bottomLabel.text = "Red Block"
        bottomLabel.foreground = SolidColorBrush(Colors.black)
        bottomLabel.fontSize = 16

        // 红色矩形列位置（Grid.Column）滑动条
        let bottomColText = TextBlock()
        bottomColText.text = "Grid.Column"
        bottomColText.foreground = SolidColorBrush(Colors.black)
        bottomColText.fontSize = 16
        let bottomColumn = StackPanel()
        bottomColumn.orientation = .vertical
        bottomColumn.horizontalAlignment = .left
        bottomColumn.margin = Thickness(left: 5, top: 5, right: 5, bottom: 5)
        let bottomColSlider = Slider()
        bottomColSlider.width = 100
        bottomColSlider.minimum = 0
        bottomColSlider.maximum = 2  // Grid 共 3 列（0/1/2），最大值设为 2
        bottomColSlider.tickFrequency = 1  // 刻度间隔 1
        bottomColSlider.requestedTheme = ElementTheme.light
        bottomColSlider.value = 0  // 初始列：0（与 rect1 初始位置一致）
        // 绑定事件：更新红色矩形的列位置
        bottomColSlider.valueChanged.addHandler { [weak self] sender, args in
            guard let self = self, let args = args, let rect = self.rect1 else { return }
            try? Grid.setColumn(rect, Int32(args.newValue))
        }

        // 红色矩形行位置（Grid.Row）滑动条
        let bottomRowText = TextBlock()
        bottomRowText.text = "Grid.Row"
        bottomRowText.foreground = SolidColorBrush(Colors.black)
        bottomRowText.fontSize = 16
        let bottomRow = StackPanel()
        bottomRow.orientation = .vertical
        bottomRow.horizontalAlignment = .center
        bottomRow.margin = Thickness(left: 5, top: 5, right: 5, bottom: 5)
        let bottomRowSlider = Slider()
        bottomRowSlider.orientation = .vertical
        bottomRowSlider.height = 100
        bottomRowSlider.minimum = 0
        bottomRowSlider.maximum = 2  // Grid 共 3 行（0/1/2），最大值设为 2
        bottomRowSlider.tickFrequency = 1  // 刻度间隔 1
        bottomRowSlider.isDirectionReversed = true
        bottomRowSlider.requestedTheme = ElementTheme.light
        bottomRowSlider.value = 0  // 初始行：0（与 rect1 初始位置一致）
        // 绑定事件：更新红色矩形的行位置
        bottomRowSlider.valueChanged.addHandler { [weak self] sender, args in
            guard let self = self, let args = args, let rect = self.rect1 else { return }
            try? Grid.setRow(rect, Int32(args.newValue))
        }

        // 组装下组布局
        bottomColumn.children.append(bottomColText)
        bottomColumn.children.append(bottomColSlider)
        bottomRow.children.append(bottomRowText)
        bottomRow.children.append(bottomRowSlider)
        let bottom = StackPanel()
        bottom.orientation = .horizontal
        bottom.horizontalAlignment = .left
        bottom.children.append(bottomColumn)
        bottom.children.append(bottomRow)
        bottomGroup.children.append(bottomLabel)
        bottomGroup.children.append(bottom)

        // 组装右侧面板
        rightPanel.children.append(topGroup)
        rightPanel.children.append(bottomGroup)

        // 组装主布局
        showGrid.children.append(rightPanel)
        try? Grid.setColumn(rightPanel, 1)
        showGrid.children.append(leftPanel)
        try? Grid.setColumn(leftPanel, 0)

        mainPanel.children.append(showGrid)
    }
   

}