import Foundation
import UWP
import WinAppSDK
import WindowsFoundation
import WinUI

class RadioButtonsPage: Grid {
    private var titleGrid = Grid()//标题
    private var mainPanel = StackPanel() 
    private var preview: Rectangle!

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
        titleTextBlock.text = "RadioButtons"
        titleTextBlock.fontSize = 30
        titleTextBlock.fontWeight = FontWeights.bold
        titleGrid.children.append(titleTextBlock)
        try? Grid.setRow(titleTextBlock, 0)

        let descriptionTextBlock = TextBlock()
        descriptionTextBlock.text = "A control that displays a group of mutually exclusive options with keyboarding and accessibility support."
        descriptionTextBlock.fontSize = 16
        titleGrid.children.append(descriptionTextBlock)
        try? Grid.setRow(descriptionTextBlock, 1)

        titleGrid.margin = Thickness(left: 20, top: 10, right: 20, bottom: 10)

    }

    private func setMainPanel() {
        let descTextBlock = TextBlock()
        descTextBlock.text = "Two RadioButtons controls with strings as options."
        descTextBlock.fontSize = 16
        descTextBlock.fontWeight = FontWeights.semiBold    // 半粗体
        descTextBlock.margin = Thickness(left: 20, top: 10, right: 20, bottom: 10)
        mainPanel.children.append(descTextBlock)

        let showGrid=Grid()
        let row1 = RowDefinition()
        row1.height = GridLength(value: 1, gridUnitType: .auto)
        showGrid.rowDefinitions.append(row1)
        let row2 = RowDefinition()
        row2.height = GridLength(value: 1, gridUnitType: .auto)
        showGrid.rowDefinitions.append(row2)
        let row3 = RowDefinition()
        row3.height = GridLength(value: 1, gridUnitType: .auto)
        showGrid.rowDefinitions.append(row3)

        showGrid.margin=Thickness(left: 20, top: 10, right: 20, bottom: 10)

        //内容展示布局
        let topPanel = StackPanel()
        topPanel.height = 80
        topPanel.width = 800
        topPanel.background = SolidColorBrush(Colors.lightGray)
        topPanel.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        topPanel.borderBrush = SolidColorBrush(Colors.gray)
        topPanel.orientation = .vertical // 垂直排列子元素
        topPanel.horizontalAlignment = .left
        topPanel.verticalAlignment = .center
        topPanel.cornerRadius = CornerRadius(topLeft: 10, topRight: 10, bottomRight: 0, bottomLeft: 0)
        topPanel.padding = Thickness(left: 20, top: 20, right: 20, bottom: 20) // 内边距，避免内容贴边

        let backgroundLabel = TextBlock()
        backgroundLabel.text = "Background"
        backgroundLabel.fontWeight = FontWeights.bold
        backgroundLabel.foreground = SolidColorBrush(Colors.black)
        topPanel.children.append(backgroundLabel)

        let backgroundGroup = StackPanel()
        backgroundGroup.orientation = .horizontal

        let bgGreen = RadioButton()
        let greenText = TextBlock()
        greenText.text = "Green"
        greenText.foreground = SolidColorBrush(Colors.black)
        bgGreen.content = greenText
        bgGreen.isChecked = true // 默认选中
        bgGreen.checked.addHandler { [weak self] sender, args in
            guard let self = self, let radio = sender as? RadioButton, radio.isChecked == true else { return }
            self.preview.fill = SolidColorBrush(Colors.green)
        }
        backgroundGroup.children.append(bgGreen)


        let bgYellow = RadioButton()
        let yellowText = TextBlock()
        yellowText.text = "Yellow"
        yellowText.foreground = SolidColorBrush(Colors.black)
        bgYellow.content = yellowText
        bgYellow.checked.addHandler { [weak self] sender, args in
            guard let self = self, let radio = sender as? RadioButton, radio.isChecked == true else { return }
            self.preview.fill = SolidColorBrush(Colors.yellow)
        }
        backgroundGroup.children.append(bgYellow)

        let bgWhite = RadioButton()
        let whiteText = TextBlock()
        whiteText.text = "White"
        whiteText.foreground = SolidColorBrush(Colors.black)
        bgWhite.content = whiteText
        bgWhite.checked.addHandler { [weak self] sender, args in
            guard let self = self, let radio = sender as? RadioButton, radio.isChecked == true else { return }
            self.preview.fill = SolidColorBrush(Colors.white)
        }
        backgroundGroup.children.append(bgWhite)

        topPanel.children.append(backgroundGroup)


       // 边框选择布局（centerPanel）
        let centerPanel = StackPanel()
        centerPanel.height = 80
        centerPanel.width = 800
        centerPanel.background = SolidColorBrush(Colors.lightGray)
        centerPanel.borderThickness = Thickness(left: 1, top: 0, right: 1, bottom: 0)
        centerPanel.borderBrush = SolidColorBrush(Colors.gray)
        centerPanel.orientation = .vertical // 垂直排列子元素
        centerPanel.horizontalAlignment = .left
        centerPanel.verticalAlignment = .center
        centerPanel.padding = Thickness(left: 20, top: 20, right: 20, bottom: 20) // 内边距，避免内容贴边

        // 边框标题
        let borderLabel = TextBlock()
        borderLabel.text = "Border"
        borderLabel.fontWeight = FontWeights.bold
        borderLabel.foreground = SolidColorBrush(Colors.black)
        centerPanel.children.append(borderLabel)

        // 边框选项组
        let borderGroup = StackPanel()
        borderGroup.orientation = .horizontal

        // 边框绿色选项
        let bdGreen = RadioButton()
        let bdGreenText = TextBlock()
        bdGreenText.text = "Green"
        bdGreenText.foreground = SolidColorBrush(Colors.black)
        bdGreen.content = bdGreenText
        bdGreen.isChecked = true // 默认选中
        bdGreen.checked.addHandler { [weak self] sender, args in
            guard let self = self, let radio = sender as? RadioButton, radio.isChecked == true else { return }
            self.preview.stroke = SolidColorBrush(Colors.darkGreen)
        }
        borderGroup.children.append(bdGreen)

        // 边框黄色选项
        let bdYellow = RadioButton()
        let bdYellowText = TextBlock()
        bdYellowText.text = "Yellow"
        bdYellowText.foreground = SolidColorBrush(Colors.black)
        bdYellow.content = bdYellowText
        bdYellow.checked.addHandler { [weak self] sender, args in
            guard let self = self, let radio = sender as? RadioButton, radio.isChecked == true else { return }
            self.preview.stroke = SolidColorBrush(Colors.darkGoldenrod)
        }
        borderGroup.children.append(bdYellow)

        // 边框白色选项
        let bdWhite = RadioButton()
        let bdWhiteText = TextBlock()
        bdWhiteText.text = "White"
        bdWhiteText.foreground = SolidColorBrush(Colors.black)
        bdWhite.content = bdWhiteText
        bdWhite.checked.addHandler { [weak self] sender, args in
            guard let self = self, let radio = sender as? RadioButton, radio.isChecked == true else { return }
            self.preview.stroke = SolidColorBrush(Colors.white)
        }
        borderGroup.children.append(bdWhite)

        centerPanel.children.append(borderGroup)


        // 第三层：预览区域（带背景和边框的容器）
        let previewPanel = StackPanel()
        previewPanel.height = 150
        previewPanel.width = 800
        previewPanel.background = SolidColorBrush(Colors.lightGray)
        previewPanel.cornerRadius = CornerRadius(topLeft: 0, topRight: 0, bottomRight: 10, bottomLeft: 10)
        previewPanel.borderThickness = Thickness(left: 1, top: 0, right: 1, bottom: 0)
        previewPanel.borderBrush = SolidColorBrush(Colors.gray)
        previewPanel.orientation = .horizontal
        previewPanel.horizontalAlignment = .left
        previewPanel.verticalAlignment = .top

        preview = Rectangle()
        preview.height = 80
        preview.width = 400
        preview.fill = SolidColorBrush(Colors.green)
        preview.strokeThickness = 20 // 边框厚度（数值越大边框越粗）
        preview.stroke = SolidColorBrush(Colors.darkGreen) // 边框颜色（这里设为灰色）
        previewPanel.children.append(preview)
        previewPanel.padding = Thickness(left: 20, top: 0, right: 0, bottom: 0) // 内边距，避免内容贴边


        showGrid.children.append(topPanel)
        try? Grid.setRow(topPanel, 0)

        showGrid.children.append(centerPanel)
        try? Grid.setRow(centerPanel, 1)

        showGrid.children.append(previewPanel)
        try? Grid.setRow(previewPanel, 2)

        mainPanel.children.append(showGrid)

    }
   

}