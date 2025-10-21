import Foundation
import UWP
import WinAppSDK
import WindowsFoundation
import WinUI

class CanvasPage: Grid {
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
        titleTextBlock.text = "Canvas"
        titleTextBlock.fontSize = 30
        titleTextBlock.fontWeight = FontWeights.bold
        titleGrid.children.append(titleTextBlock)
        try? Grid.setRow(titleTextBlock, 0)

        let descriptionTextBlock = TextBlock()
        descriptionTextBlock.text = "The Canvas provides absolute positioning of controls or content. Content is positioned relative to the Canvas using the Canvas.Top and Canvas.Left attached properties."
        descriptionTextBlock.fontSize = 16
        titleGrid.children.append(descriptionTextBlock)
        try? Grid.setRow(descriptionTextBlock, 1)

        titleGrid.margin = Thickness(left: 20, top: 10, right: 20, bottom: 10)

    }

    private func setMainPanel() {
        let descTextBlock = TextBlock()
        descTextBlock.text = "A Canvas control"
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

        let canvas = Canvas()
        canvas.width = 350  // 设置 Canvas 宽度
        canvas.height = 350  // 设置 Canvas 高度
        canvas.background = SolidColorBrush(Colors.white) 
        canvas.margin=Thickness(left: 20, top: 10, right: 20, bottom: 10)
        
        let rect1 = Rectangle()
        rect1.width = 100  // 宽 = 高，确保是正方形
        rect1.height = 100
        rect1.fill = SolidColorBrush(Colors.red)  // 填充色
        // 设置在 Canvas 中的位置
        try! Canvas.setTop(rect1, 0)  
        try! Canvas.setLeft(rect1, 0)  
        try! Canvas.setZIndex(rect1, 1) 
        canvas.children.append(rect1)

        let rect2 = Rectangle()
        rect2.width = 100  // 宽 = 高，确保是正方形
        rect2.height = 100
        rect2.fill = SolidColorBrush(Colors.blue)  // 填充色
        // 设置在 Canvas 中的位置
        try! Canvas.setTop(rect2, 40)  
        try! Canvas.setLeft(rect2, 40)  
        try! Canvas.setZIndex(rect2, 2) 
        canvas.children.append(rect2)

        let rect3 = Rectangle()
        rect3.width = 100  // 宽 = 高，确保是正方形
        rect3.height = 100
        rect3.fill = SolidColorBrush(Colors.green)  // 填充色
        // 设置在 Canvas 中的位置
        try! Canvas.setTop(rect3, 80)  
        try! Canvas.setLeft(rect3, 80)  
        try! Canvas.setZIndex(rect3, 3) 
        canvas.children.append(rect3)

        let rect4 = Rectangle()
        rect4.width = 100  // 宽 = 高，确保是正方形
        rect4.height = 100
        rect4.fill = SolidColorBrush(Colors.yellow)  // 填充色
        // 设置在 Canvas 中的位置
        try! Canvas.setTop(rect4, 120)  
        try! Canvas.setLeft(rect4, 120)  
        try! Canvas.setZIndex(rect4, 4) 
        canvas.children.append(rect4)

        leftPanel.children.append(canvas)

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
        rightPanel.orientation = Orientation.horizontal

        //滑动条
        let topGroup = StackPanel()
        topGroup.orientation = .vertical
        topGroup.horizontalAlignment = .center
        topGroup.margin = Thickness(left: 0, top: 0, right: 20, bottom: 0)

        let topLabel = TextBlock()
        topLabel.text = "Canvas.Top"
        topLabel.foreground = SolidColorBrush(Colors.black)
        topLabel.fontSize = 16
        let topSlider = Slider()
        topSlider.orientation = .vertical
        topSlider.height = 100  // 滑块宽度
        topSlider.minimum = 0
        topSlider.maximum = 250 
        topSlider.isDirectionReversed = true  // 默认是 false，设置为 true 即可反转
        topSlider.requestedTheme=ElementTheme.light  // 设置为浅色主题

        topGroup.children.append(topLabel)
        topGroup.children.append(topSlider)

        let rightGroup = StackPanel()
        rightGroup.orientation = .vertical
        rightGroup.spacing = 10  // 两个滑块组的垂直间距

        // Canvas.Left 子组
        let leftSubGroup = StackPanel()
        leftSubGroup.orientation = .vertical
        leftSubGroup.verticalAlignment = .center

        let leftLabel = TextBlock()
        leftLabel.text = "Canvas.Left"
        leftLabel.foreground = SolidColorBrush(Colors.black)
        leftLabel.fontSize = 16

        let leftSlider = Slider()
        leftSlider.width = 100
        leftSlider.minimum = 0
        leftSlider.maximum = 250
        leftSlider.requestedTheme=ElementTheme.light  // 设置为浅色主题

        leftSubGroup.children.append(leftLabel)
        leftSubGroup.children.append(leftSlider)

        // Canvas.ZIndex 子组
        let zIndexSubGroup = StackPanel()
        zIndexSubGroup.orientation = .vertical
        zIndexSubGroup.verticalAlignment = .center

        let zIndexLabel = TextBlock()
        zIndexLabel.text = "Canvas.ZIndex"
        zIndexLabel.foreground = SolidColorBrush(Colors.black)
        zIndexLabel.fontSize = 16

        let zIndexSlider = Slider()
        zIndexSlider.width = 100
        zIndexSlider.minimum = 0
        zIndexSlider.maximum = 10  // ZIndex 范围通常较小
        zIndexSlider.requestedTheme=ElementTheme.light  // 设置为浅色主题

        zIndexSubGroup.children.append(zIndexLabel)
        zIndexSubGroup.children.append(zIndexSlider)

        rightGroup.children.append(leftSubGroup)
        rightGroup.children.append(zIndexSubGroup)

       
        rightPanel.children.append(topGroup)
        rightPanel.children.append(rightGroup)





        showGrid.children.append(rightPanel)
        try? Grid.setColumn(rightPanel, 1)
        showGrid.children.append(leftPanel)
        try? Grid.setColumn(leftPanel, 0)

        mainPanel.children.append(showGrid)

    }
   

}