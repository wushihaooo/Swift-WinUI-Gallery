import Foundation
import UWP
import WinAppSDK
import WindowsFoundation
import WinUI

class GridPage: Grid {
    private var titleGrid = Grid()//标题
    private var mainPanel = StackPanel() 

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
        descTextBlock.fontWeight = FontWeights.semiBold    // 半粗体
        descTextBlock.margin = Thickness(left: 20, top: 10, right: 20, bottom: 10)
        mainPanel.children.append(descTextBlock)

        let showGrid=Grid()
        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 1, gridUnitType: .auto)
        showGrid.columnDefinitions.append(col1)

        let col2 = ColumnDefinition()
        col2.width = GridLength(value:1, gridUnitType: .auto)
        showGrid.columnDefinitions.append(col2)
        
        showGrid.margin=Thickness(left: 20, top: 10, right: 20, bottom: 10)

        //内容展示布局
        let leftPanel=StackPanel()
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

        let grid = Grid()
        grid.width = 350 
        grid.height = 350  
        grid.background = SolidColorBrush(Colors.white) 
        grid.margin=Thickness(left: 20, top: 10, right: 20, bottom: 10)
        
        for _ in 0..<3 {
            let row = RowDefinition()
            row.height = GridLength(value: 1, gridUnitType: .star)  // 1* 比例分配高度
            grid.rowDefinitions.append(row)
        }

        // 2. 设置三列（列宽同样等比例分配）
        for _ in 0..<3 {
            let col = ColumnDefinition()
            col.width = GridLength(value: 1, gridUnitType: .star)  // 1* 比例分配宽度
            grid.columnDefinitions.append(col)
        }

        let rect1 = Rectangle()
        rect1.horizontalAlignment = .stretch
        rect1.verticalAlignment = .stretch
        rect1.fill = SolidColorBrush(Colors.red)  // 填充色
        try?Grid.setRow(rect1, 0)        // 放在第 0 行（首行）
        try?Grid.setColumn(rect1, 0)
        rect1.margin = Thickness(left: 10, top: 10, right: 10, bottom: 10)
        grid.children.append(rect1)
        

        let rect2 = Rectangle()
        rect2.horizontalAlignment = .stretch
        rect2.verticalAlignment = .stretch
        rect2.fill = SolidColorBrush(Colors.blue)  // 填充色
        try?Grid.setRow(rect2, 0)        // 放在第 0 行（首行）
        try?Grid.setColumn(rect2, 1)
        rect2.margin = Thickness(left: 10, top: 10, right: 10, bottom: 10)

        grid.children.append(rect2)

       

        let rect3 = Rectangle()
        rect3.horizontalAlignment = .stretch
        rect3.verticalAlignment = .stretch
        rect3.fill = SolidColorBrush(Colors.green)  // 填充色
        try?Grid.setRow(rect3, 1)        // 放在第 0 行（首行）
        try?Grid.setColumn(rect3, 0)
        rect3.margin = Thickness(left: 10, top: 10, right: 10, bottom: 10)
        grid.children.append(rect3)

        let rect4 = Rectangle()
        rect4.horizontalAlignment = .stretch
        rect4.verticalAlignment = .stretch
        rect4.fill = SolidColorBrush(Colors.yellow)  // 填充色
        try?Grid.setRow(rect4, 1)        // 放在第 0 行（首行）
        try?Grid.setColumn(rect4, 1)
        rect4.margin = Thickness(left: 10, top: 10, right: 10, bottom: 10)
        grid.children.append(rect4)


        leftPanel.children.append(grid)

        let rightPanel = StackPanel()//右边容器布局
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

        //Grid滑动条
        let topGroup = StackPanel()
        topGroup.orientation = .vertical
        topGroup.horizontalAlignment = .left
        topGroup.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)

        let topLabel = TextBlock()
        topLabel.text = "Grid"
        topLabel.fontSize = 16
        let topColText = TextBlock()
        topColText.text = "ColumnSpacing"
        topColText.foreground = SolidColorBrush(Colors.black)
        topColText.fontSize = 16
        let topColumn = StackPanel()
        topColumn.orientation = .vertical
        topColumn.horizontalAlignment = .left
        topColumn.margin = Thickness(left: 5, top: 5, right: 5, bottom: 5)
        let topRowText = TextBlock()
        topRowText.text = "RowSpacing"
        topRowText.foreground = SolidColorBrush(Colors.black)
        topRowText.fontSize = 16
        let topRow = StackPanel()
        topRow.orientation = .vertical
        topRow.horizontalAlignment = .left
        topRow.margin = Thickness(left: 5, top: 5, right: 5, bottom: 5)
        let topColSlider = Slider()
        topColSlider.width = 100  // 滑块宽度swift run
        topColSlider.minimum = 0
        topColSlider.maximum = 50 
        topColSlider.requestedTheme = ElementTheme.light
        let topRowSlider = Slider()
        topRowSlider.orientation = .vertical
        topRowSlider.height = 100  // 滑块宽度
        topRowSlider.minimum = 0
        topRowSlider.maximum = 50 
        topRowSlider.isDirectionReversed = true  // 默认是 false，设置为 true 即可反转
        topRowSlider.requestedTheme = ElementTheme.light

        let top = StackPanel()
        top.orientation = .horizontal
        top.horizontalAlignment = .left

        topColumn.children.append(topColText)
        topColumn.children.append(topColSlider)
        topRow.children.append(topRowText)
        topRow.children.append(topRowSlider)
        top.children.append(topColumn)
        top.children.append(topRow)
        topGroup.children.append(topLabel)
        topGroup.children.append(top)

        let bottomGroup = StackPanel()
        bottomGroup.orientation = .vertical
        bottomGroup.horizontalAlignment = .left
        bottomGroup.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)

        let bottomLabel = TextBlock()
        bottomLabel.text = "Red Block"
        bottomLabel.foreground = SolidColorBrush(Colors.black)
        bottomLabel.fontSize = 16
        let bottomColText = TextBlock()
        bottomColText.text = "Grid.Column"
        bottomColText.foreground = SolidColorBrush(Colors.black)
        bottomColText.fontSize = 16
        let bottomColumn = StackPanel()
        bottomColumn.orientation = .vertical
        bottomColumn.horizontalAlignment = .left
        bottomColumn.margin = Thickness(left: 5, top: 5, right: 5, bottom: 5)
        let bottomRowText = TextBlock()
        bottomRowText.text = "Grid.Row"
        bottomRowText.foreground = SolidColorBrush(Colors.black)
        bottomRowText.fontSize = 16
        let bottomRow = StackPanel()
        bottomRow.orientation = .vertical
        bottomRow.horizontalAlignment = .center
        bottomRow.margin = Thickness(left: 5, top: 5, right: 5, bottom: 5)
        let bottomColSlider = Slider()
        bottomColSlider.width = 100  // 滑块宽度
        bottomColSlider.minimum = 0
        bottomColSlider.maximum = 50 
        bottomColSlider.requestedTheme = ElementTheme.light
        let bottomRowSlider = Slider()
        bottomRowSlider.orientation = .vertical
        bottomRowSlider.height = 100  // 滑块宽度
        bottomRowSlider.minimum = 0
        bottomRowSlider.maximum = 50 
        bottomRowSlider.isDirectionReversed = true  // 默认是 false，设置为 true 即可反转
        bottomRowSlider.requestedTheme = ElementTheme.light

        let bottom = StackPanel()
        bottom.orientation = .horizontal
        bottom.horizontalAlignment = .left

        bottomColumn.children.append(bottomColText)
        bottomColumn.children.append(bottomColSlider)
        bottomRow.children.append(bottomRowText)
        bottomRow.children.append(bottomRowSlider)
        bottom.children.append(bottomColumn)
        bottom.children.append(bottomRow)
        bottomGroup.children.append(bottomLabel)
        bottomGroup.children.append(bottom)

        rightPanel.children.append(topGroup)
        rightPanel.children.append(bottomGroup)


        showGrid.children.append(rightPanel)
        try? Grid.setColumn(rightPanel, 1)
        showGrid.children.append(leftPanel)
        try? Grid.setColumn(leftPanel, 0)

        mainPanel.children.append(showGrid)

    }
   

}