import Foundation
import UWP
import WinAppSDK
import WindowsFoundation
import WinUI

class variableGridPage: Grid {
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
        titleTextBlock.text = "VariableSizedWrapGrid"
        titleTextBlock.fontSize = 30
        titleTextBlock.fontWeight = FontWeights.bold
        titleGrid.children.append(titleTextBlock)
        try? Grid.setRow(titleTextBlock, 0)

        let descriptionTextBlock = TextBlock()
        descriptionTextBlock.text = "A VariableSizedWrapGrip is used to create grid layouts where content can span multiple rows and columns."
        descriptionTextBlock.fontSize = 16
        titleGrid.children.append(descriptionTextBlock)
        try? Grid.setRow(descriptionTextBlock, 1)

        titleGrid.margin = Thickness(left: 20, top: 10, right: 20, bottom: 10)

    }

    private func setMainPanel() {
        let descTextBlock = TextBlock()
        descTextBlock.text = "A VariableSizedWrapGrid control"
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

        // let wrapGrid = VariableSizedWrapGrid()
        // wrapGrid.width = 200
        // wrapGrid.height = 200
        // wrapGrid.orientation = .vertical // 垂直方向布局（也可设为 Horizontal）
        // wrapGrid.itemWidth = 80
        // wrapGrid.itemHeight = 80


        // // 创建四个色块元素
        // let redRect = Rectangle()
        // redRect.fill = SolidColorBrush(Colors.red)

        // let greenRect = Rectangle()
        // greenRect.fill = SolidColorBrush(Colors.green)
        // // 绿色块跨 2 列
        // try? VariableSizedWrapGrid.setColumnSpan(greenRect, 2)

        // let blueRect = Rectangle()
        // blueRect.fill = SolidColorBrush(Colors.blue)
        // // 蓝色块跨 2 行
        // try? VariableSizedWrapGrid.setRowSpan(blueRect, 2)

        // let yellowRect = Rectangle()
        // yellowRect.fill = SolidColorBrush(Colors.yellow)
        // // 黄色块跨 2 行 2 列
        // try? VariableSizedWrapGrid.setRowSpan(yellowRect, 2)
        // try? VariableSizedWrapGrid.setColumnSpan(yellowRect, 2)


        // // 将元素添加到布局
        // wrapGrid.children.append(redRect)
        // wrapGrid.children.append(greenRect)
        // wrapGrid.children.append(blueRect)
        // wrapGrid.children.append(yellowRect)

        // leftPanel.children.append(wrapGrid)

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
        rightPanel.horizontalAlignment = HorizontalAlignment.center

        let leftTextBlock = TextBlock()
        leftTextBlock.text = "Orientation"
        leftTextBlock.fontSize = 20
        let HradioButton = RadioButton()
        let htextBlock = TextBlock()
        htextBlock.text = "Horizontal"
        htextBlock.fontSize = 16
        HradioButton.content = htextBlock
        HradioButton.isChecked = true
        let VradioButton = RadioButton()
        let vtextBlock = TextBlock()
        vtextBlock.text = "Vertical"
        vtextBlock.fontSize = 16
        VradioButton.content = vtextBlock

        rightPanel.children.append(leftTextBlock)
        rightPanel.children.append(HradioButton)
        rightPanel.children.append(VradioButton)
       

        showGrid.children.append(rightPanel)
        try? Grid.setColumn(rightPanel, 1)
        showGrid.children.append(leftPanel)
        try? Grid.setColumn(leftPanel, 0)

        mainPanel.children.append(showGrid)

    }
   

}