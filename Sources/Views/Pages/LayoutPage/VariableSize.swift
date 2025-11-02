import Foundation
import UWP
import WinAppSDK
import WindowsFoundation
import WinUI

class variableGridPage: Grid {
    private var titleGrid = Grid()//标题
    private var mainPanel = StackPanel() 
    private var wrapGrid: VariableSizedWrapGrid!

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
        let sectionTitle = TextBlock()
        sectionTitle.text = "A VariableSizedWrapGrid control."
        sectionTitle.fontSize = 16
        sectionTitle.margin = Thickness(left: 20, top: 10, right: 20, bottom: 10)
        mainPanel.children.append(sectionTitle)

        // 主布局 Grid
        let mainGrid = Grid()
        mainGrid.margin = Thickness(left: 20, top: 0, right: 20, bottom: 20)
        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 1, gridUnitType: .star)
        mainGrid.columnDefinitions.append(col1)
        let col2 = ColumnDefinition()
        col2.width = GridLength(value: 1, gridUnitType: .auto)
        mainGrid.columnDefinitions.append(col2)

        wrapGrid = VariableSizedWrapGrid()
        wrapGrid.itemWidth = 44  // 调整单个元素宽度，让布局更紧凑
        wrapGrid.itemHeight = 44 // 调整单个元素高度
        wrapGrid.maximumRowsOrColumns = 3 
        wrapGrid.orientation = .vertical // 垂直排列（先按行排，满行后换行）

        try?Grid.setColumn(wrapGrid, 0)
        wrapGrid.margin = Thickness(left: 10, top: 10, right: 10, bottom: 10)

        // 红色方块（占1行1列）
        let redRect = Rectangle()
        redRect.fill = SolidColorBrush(Colors.red)
        redRect.width = 44
        redRect.height = 44
        wrapGrid.children.append(redRect)

         // 蓝色方块（占2行1列）
        let blueRect = Rectangle()
        blueRect.fill = SolidColorBrush(Colors.blue)
        blueRect.height = 80
        try?VariableSizedWrapGrid.setRowSpan(blueRect, 2) // 跨2行

        wrapGrid.children.append(blueRect)

        // 绿色方块
        let greenRect = Rectangle()
        greenRect.fill = SolidColorBrush(Colors.green)
        greenRect.width = 80
        try?VariableSizedWrapGrid.setColumnSpan(greenRect, 2) // 跨2列
        wrapGrid.children.append(greenRect)


        // 黄色方块（占2行1列）
        let yellowRect = Rectangle()
        yellowRect.fill = SolidColorBrush(Colors.yellow)
        yellowRect.height = 80
        yellowRect.width = 80
        try?VariableSizedWrapGrid.setRowSpan(yellowRect, 2) // 跨2行
        try?VariableSizedWrapGrid.setColumnSpan(yellowRect, 2) // 跨2列
        wrapGrid.children.append(yellowRect)

        mainGrid.children.append(wrapGrid)

        // 右侧方向选择面板
        let rightPanel = StackPanel()
        rightPanel.verticalAlignment = .top
        try?Grid.setColumn(rightPanel, 1)

        let orientationLabel = TextBlock()
        orientationLabel.text = "Orientation"
        orientationLabel.fontSize = 16
        rightPanel.children.append(orientationLabel)

        // 水平方向单选按钮
        let horizontalRadio = RadioButton()
        horizontalRadio.content = "Horizontal"
        horizontalRadio.isChecked = false
        horizontalRadio.checked.addHandler { [weak self] sender, args in
            guard let self = self, let radio = sender as? RadioButton, radio.isChecked == true else { return }
            self.wrapGrid.orientation = .horizontal
        }
        rightPanel.children.append(horizontalRadio)

        // 垂直方向单选按钮（默认选中）
        let verticalRadio = RadioButton()
        verticalRadio.content = "Vertical"
        verticalRadio.isChecked = true
        verticalRadio.checked.addHandler { [weak self] sender, args in
            guard let self = self, let radio = sender as? RadioButton, radio.isChecked == true else { return }
            self.wrapGrid.orientation = .vertical
        }
        rightPanel.children.append(verticalRadio)

        mainGrid.children.append(rightPanel)

        mainPanel.children.append(mainGrid)

    }
   

}