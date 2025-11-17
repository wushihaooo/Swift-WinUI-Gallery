import Foundation
import UWP
import WinAppSDK
import WindowsFoundation
import WinUI

class StackPanelPage: Grid {
    private var titleGrid = Grid()//标题
    private var mainPanel = StackPanel() 
    private var innerPanel: StackPanel!

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
        titleTextBlock.text = "StackPanel"
        titleTextBlock.fontSize = 30
        titleTextBlock.fontWeight = FontWeights.bold
        titleGrid.children.append(titleTextBlock)
        try? Grid.setRow(titleTextBlock, 0)

        let descriptionTextBlock = TextBlock()
        descriptionTextBlock.text = "A StackPanel control is used to arrange child elements in a single line or stacked vertically or horizontally. The StackPanel control can be used to create a layout of controls or to align child elements relat."
        descriptionTextBlock.fontSize = 16
        titleGrid.children.append(descriptionTextBlock)
        try? Grid.setRow(descriptionTextBlock, 1)

        titleGrid.margin = Thickness(left: 20, top: 10, right: 20, bottom: 10)

    }

    private func setMainPanel() {
        let descTextBlock = TextBlock()
        descTextBlock.text = "A StackPanel control"
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
        
        innerPanel = StackPanel()
        innerPanel.orientation = Orientation.horizontal
        innerPanel.verticalAlignment = VerticalAlignment.top
        innerPanel.padding = Thickness(left: 10, top: 10, right: 10, bottom: 10)
        let rect1 = Rectangle()
        rect1.width = 100  // 宽 = 高，确保是正方形
        rect1.height = 100
        rect1.fill = SolidColorBrush(Colors.red)  // 填充色

        let rect2 = Rectangle()
        rect2.width = 100  // 宽 = 高，确保是正方形
        rect2.height = 100
        rect2.fill = SolidColorBrush(Colors.blue)  // 填充色
    
        let rect3 = Rectangle()
        rect3.width = 100  // 宽 = 高，确保是正方形
        rect3.height = 100
        rect3.fill = SolidColorBrush(Colors.green)  // 填充色

        let rect4 = Rectangle()
        rect4.width = 100  // 宽 = 高，确保是正方形
        rect4.height = 100
        rect4.fill = SolidColorBrush(Colors.yellow)  // 填充色

        innerPanel.children.append(rect1)
        innerPanel.children.append(rect2)
        innerPanel.children.append(rect3)
        innerPanel.children.append(rect4)

        leftPanel.children.append(innerPanel)

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

        let radioText = TextBlock()
        radioText.text = "Orientation"
        radioText.foreground = SolidColorBrush(Colors.black)
        radioText.fontSize = 16

        // 第一个单选按钮
        let radioHorizontal = RadioButton()
        let radioHorizontalText = TextBlock()
        radioHorizontalText.text = "Horizontal"
        radioHorizontalText.foreground = SolidColorBrush(Colors.black)
        radioHorizontal.content = radioHorizontalText
        radioHorizontal.isChecked = true
        // 绑定事件：选中时将 innerPanel 设为水平排列
        radioHorizontal.checked.addHandler { [weak self] sender, args in
            guard let self = self, let radio = sender as? RadioButton, radio.isChecked == true else { return }
            self.innerPanel.orientation = .horizontal
        }
        // 第二个单选按钮
        let radioVertical = RadioButton()
        let radioVerticalText = TextBlock()
        radioVerticalText.text = "Vertical"
        radioVerticalText.foreground = SolidColorBrush(Colors.black)
        radioVertical.content = radioVerticalText
        radioVertical.checked.addHandler { [weak self] sender, args in
            guard let self = self, let radio = sender as? RadioButton, radio.isChecked == true else { return }
            self.innerPanel.orientation = .vertical
        }
        
        let sliderText = TextBlock()
        sliderText.text = "Spacing"
        sliderText.foreground = SolidColorBrush(Colors.black)
        sliderText.fontSize = 16

        let slider = Slider()
        slider.minimum = 0
        slider.maximum = 16
        slider.value = 0
        slider.stepFrequency = 1
        slider.requestedTheme = ElementTheme.light
        // 绑定事件：实时调整 innerPanel 的子元素间距
        slider.valueChanged.addHandler { [weak self] sender, args in
            guard let self = self, let args = args else { return }
            self.innerPanel.spacing = args.newValue
        }
        
        rightPanel.children.append(radioText)
        rightPanel.children.append(radioHorizontal)
        rightPanel.children.append(radioVertical)
        rightPanel.children.append(sliderText)
        rightPanel.children.append(slider)

        showGrid.children.append(rightPanel)
        try? Grid.setColumn(rightPanel, 1)
        showGrid.children.append(leftPanel)
        try? Grid.setColumn(leftPanel, 0)

        mainPanel.children.append(showGrid)

    }
   

}