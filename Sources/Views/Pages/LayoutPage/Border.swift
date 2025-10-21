import Foundation
import UWP
import WinAppSDK
import WindowsFoundation
import WinUI

class BorderPage: Grid {
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
        titleTextBlock.text = "Border"
        titleTextBlock.fontSize = 30
        titleTextBlock.fontWeight = FontWeights.bold
        titleGrid.children.append(titleTextBlock)
        try? Grid.setRow(titleTextBlock, 0)

        let descriptionTextBlock = TextBlock()
        descriptionTextBlock.text = "Border is a container control that can be used to add a border to any other control."
        descriptionTextBlock.fontSize = 16
        titleGrid.children.append(descriptionTextBlock)
        try? Grid.setRow(descriptionTextBlock, 1)

        titleGrid.margin = Thickness(left: 20, top: 10, right: 20, bottom: 10)

    }

    private func setMainPanel() {
        let descTextBlock = TextBlock()
        descTextBlock.text = "A Border around a TextBlock"
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
        let showBorder = Border()
        showBorder.padding = Thickness(left: 10, top: 10, right: 10, bottom: 10)
        showBorder.margin = Thickness(left: 10, top: 10, right: 10, bottom: 10)
        showBorder.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        showBorder.verticalAlignment = VerticalAlignment.top
        showBorder.borderBrush = SolidColorBrush(Colors.gray)
        showBorder.background = SolidColorBrush(Colors.white)
        let innertext = TextBlock()
        innertext.text = "Text inside a border"
        innertext.foreground = SolidColorBrush(Colors.black)
        showBorder.child = innertext
        leftPanel.children.append(showBorder)

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
        //滑动条
        let sliderText = TextBlock()
        sliderText.text = "BorderThickness"
        sliderText.foreground = SolidColorBrush(Colors.black)
        sliderText.fontSize = 16
        let slider = Slider()
        slider.minimum = 0
        slider.maximum = 10
        slider.value = 5

        rightPanel.children.append(sliderText)
        rightPanel.children.append(slider)

        //设置背景颜色和边框颜色
        let backAndBorder = StackPanel()
        backAndBorder.orientation = Orientation.horizontal
        backAndBorder.horizontalAlignment = .center 

        let Background = StackPanel()
        let backgroundText = TextBlock()
        backgroundText.text = "Background"
        backgroundText.foreground = SolidColorBrush(Colors.black)
        backgroundText.fontSize = 16
        // 第一个单选按钮
        let radioGreen = RadioButton()
        let radioGreenText = TextBlock()
        radioGreenText.text = "Green"  // 设置文本
        radioGreenText.foreground = SolidColorBrush(Colors.black)  // 设置文本颜色为黑色
        radioGreen.content = radioGreenText  // 将 TextBlock 作为 content 赋值
        radioGreen.isChecked = true // 默认选中
        // 第二个单选按钮
        let radioYellow = RadioButton()
        let radioYellowText = TextBlock()
        radioYellowText.text = "Yellow"
        radioYellowText.foreground = SolidColorBrush(Colors.black)
        radioYellow.content = radioYellowText
        // 第三个单选按钮
        let radioBlue = RadioButton()
        let radioBlueText = TextBlock()
        radioBlueText.text = "Blue"
        radioBlueText.foreground = SolidColorBrush(Colors.black)
        radioBlue.content = radioBlueText
        // 第四个单选按钮
        let radioWhite = RadioButton()
        let radioWhiteText = TextBlock()
        radioWhiteText.text = "White"
        radioWhiteText.foreground = SolidColorBrush(Colors.black)
        radioWhite.content = radioWhiteText

        // 将单选按钮添加到容器
        Background.children.append(backgroundText)
        Background.children.append(radioGreen)
        Background.children.append(radioYellow)
        Background.children.append(radioBlue)
        Background.children.append(radioWhite)

        let Border = StackPanel()
        let borderText = TextBlock()
        borderText.text = "BorderBrush"
        borderText.foreground = SolidColorBrush(Colors.black)
        borderText.fontSize = 16
        // 第一个单选按钮
        let borderGreen = RadioButton()
        let borderGreenText = TextBlock()
        borderGreenText.text = "Green"  // 设置文本
        borderGreenText.foreground = SolidColorBrush(Colors.black)  // 设置文本颜色为黑色
        borderGreen.content = borderGreenText  // 将 TextBlock 作为 content 赋值
        borderGreen.isChecked = true // 默认选中
        // 第二个单选按钮
        let borderYellow = RadioButton()
        let borderYellowText = TextBlock()
        borderYellowText.text = "Yellow"
        borderYellowText.foreground = SolidColorBrush(Colors.black)
        borderYellow.content = borderYellowText
        // 第三个单选按钮
        let borderBlue = RadioButton()
        let borderBlueText = TextBlock()
        borderBlueText.text = "Blue"
        borderBlueText.foreground = SolidColorBrush(Colors.black)
        borderBlue.content = borderBlueText
        // 第四个单选按钮
        let borderWhite = RadioButton()
        let borderWhiteText = TextBlock()
        borderWhiteText.text = "White"
        borderWhiteText.foreground = SolidColorBrush(Colors.black)
        borderWhite.content = borderWhiteText
        // 将单选按钮添加到容器
        Border.children.append(borderText)
        Border.children.append(borderGreen)
        Border.children.append(borderYellow)
        Border.children.append(borderBlue)
        Border.children.append(borderWhite)

        Border.horizontalAlignment = .center 
        Background.horizontalAlignment = .center 

        backAndBorder.children.append(Background)
        backAndBorder.children.append(Border)

        rightPanel.children.append(backAndBorder)





        showGrid.children.append(rightPanel)
        try? Grid.setColumn(rightPanel, 1)
        showGrid.children.append(leftPanel)
        try? Grid.setColumn(leftPanel, 0)

        mainPanel.children.append(showGrid)

    }
   

}