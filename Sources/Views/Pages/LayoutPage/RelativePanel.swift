import Foundation
import UWP
import WinAppSDK
import WindowsFoundation
import WinUI

class RelativePanelPage: Grid {
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
        descriptionTextBlock.text = "Use a RelativePanel to layout elements by defining the relationships between elements and in relation to the panel."
        descriptionTextBlock.fontSize = 16
        titleGrid.children.append(descriptionTextBlock)
        try? Grid.setRow(descriptionTextBlock, 1)

        titleGrid.margin = Thickness(left: 20, top: 10, right: 20, bottom: 10)

    }

    private func setMainPanel() {
        let descTextBlock = TextBlock()
        descTextBlock.text = "A RelativePanel control"
        descTextBlock.fontSize = 16
        descTextBlock.fontWeight = FontWeights.semiBold    // 半粗体
        descTextBlock.margin = Thickness(left: 20, top: 10, right: 20, bottom: 10)
        mainPanel.children.append(descTextBlock)

        let showGrid=Grid()
        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 1, gridUnitType: .auto)
        showGrid.columnDefinitions.append(col1)
        
        showGrid.margin=Thickness(left: 20, top: 10, right: 20, bottom: 10)

        let containPanel = StackPanel()
        containPanel.orientation = .horizontal
        containPanel.horizontalAlignment = .left
        containPanel.verticalAlignment = .top
        containPanel.width = 800
        containPanel.height = 300
        containPanel.background = SolidColorBrush(Colors.lightGray)

        // 创建相对面板容器
        let relativePanel = RelativePanel()
        relativePanel.width = 500
        relativePanel.height = 300
        relativePanel.background = SolidColorBrush(Colors.lightGray)


        // 创建四个色块作为子元素
        let redBlock = Rectangle()
        redBlock.width = 80
        redBlock.height = 80
        redBlock.fill = SolidColorBrush(Colors.red)
        redBlock.margin = Thickness(left: 10, top: 10, right: 10, bottom: 10)
        redBlock.name = "RedBlock"  // 命名用于关联其他元素

        let blueBlock = Rectangle()
        blueBlock.width = 80
        blueBlock.height = 80
        blueBlock.fill = SolidColorBrush(Colors.blue)
        blueBlock.margin = Thickness(left: 10, top: 10, right: 10, bottom: 10)
        blueBlock.name = "BlueBlock"

        let greenBlock = Rectangle()
        greenBlock.width = 80
        greenBlock.height = 80
        greenBlock.fill = SolidColorBrush(Colors.green)
        greenBlock.margin = Thickness(left: 10, top: 10, right: 10, bottom: 10)
        greenBlock.name = "GreenBlock"

        let yellowBlock = Rectangle()
        yellowBlock.width = 80
        yellowBlock.height = 80
        yellowBlock.fill = SolidColorBrush(Colors.yellow)
        yellowBlock.margin = Thickness(left: 10, top: 10, right: 10, bottom: 10)
        yellowBlock.name = "YellowBlock"


        // 添加子元素到面板
        relativePanel.children.append(redBlock)
        relativePanel.children.append(blueBlock)
        relativePanel.children.append(greenBlock)
        relativePanel.children.append(yellowBlock)


        // 定义相对位置关系
        // 1. 红色块：左上角对齐面板
        try? RelativePanel.setAlignLeftWithPanel(redBlock, true)
        try? RelativePanel.setAlignTopWithPanel(redBlock, true)

        // 2. 蓝色块：在红色块的右边，且顶部与红色块对齐
        try? RelativePanel.setRightOf(blueBlock, redBlock)
        try? RelativePanel.setAlignTopWith(blueBlock, redBlock)

        // 3. 绿色块：在红色块的下方，且左边缘与红色块对齐
        try? RelativePanel.setAlignRightWithPanel(greenBlock, true)
        try? RelativePanel.setAlignTopWithPanel(greenBlock, true)

        // 4. 黄色块：右下角对齐面板，且左边缘与绿色块右边缘对齐
        try? RelativePanel.setBelow(yellowBlock, greenBlock)  // 关键：设置在绿色块下方
        try? RelativePanel.setAlignLeftWith(yellowBlock, greenBlock)  // 左边缘与绿色块对齐
        
        containPanel.children.append(relativePanel)
        showGrid.children.append(containPanel)

        mainPanel.children.append(showGrid)

    }
   

}