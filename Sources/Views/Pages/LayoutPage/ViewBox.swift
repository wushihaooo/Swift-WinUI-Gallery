import Foundation
import UWP
import WinAppSDK
import WindowsFoundation
import WinUI

class ViewBoxPage: Grid {
    private var titleGrid = Grid()//标题
    private var mainPanel = StackPanel() 
    private var viewbox: Viewbox!
    private var controlPanel = StackPanel()

    override init() {
        super.init()
        setTitle()
        setMainPanel()
        setUpView()
    }

    private func setUpView() {
        // 页面布局 rows
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
        titleTextBlock.text = "ViewBox"
        titleTextBlock.fontSize = 30
        titleTextBlock.fontWeight = FontWeights.bold
        titleGrid.children.append(titleTextBlock)
        try? Grid.setRow(titleTextBlock, 0)

        let descriptionTextBlock = TextBlock()
        descriptionTextBlock.text = "Use the ViewBox control to create a custom view that can be used to zoom and pan its contents."
        descriptionTextBlock.fontSize = 16
        titleGrid.children.append(descriptionTextBlock)
        try? Grid.setRow(descriptionTextBlock, 1)

        titleGrid.margin = Thickness(left: 20, top: 10, right: 20, bottom: 10)
    }

    private func setMainPanel() {
        // 标题区域
        let sectionTitle = TextBlock()
        sectionTitle.text = "Content inside of a Viewbox."
        sectionTitle.fontSize = 16
        sectionTitle.margin = Thickness(left: 20, top: 10, right: 20, bottom: 10)
        mainPanel.children.append(sectionTitle)

        // 主布局 Grid（包含 Viewbox 和控制面板）
        let mainGrid = Grid()
        mainGrid.margin = Thickness(left: 20, top: 0, right: 20, bottom: 20)
        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 1, gridUnitType: .star)
        mainGrid.columnDefinitions.append(col1)
        let col2 = ColumnDefinition()
        col2.width = GridLength(value: 1, gridUnitType: .auto)
        mainGrid.columnDefinitions.append(col2)

        // Viewbox 控件（匹配C#的初始尺寸和拉伸属性）
        viewbox = Viewbox()
        viewbox.height = 229
        viewbox.width = 229
        viewbox.stretch = .uniformToFill  // 初始拉伸方式与C#一致
        viewbox.stretchDirection = .both  // 拉伸方向与C#一致
        try? Grid.setColumn(viewbox, 0)

        // Viewbox 内部内容（完全匹配C#的布局结构）
        // 外层Border（带灰色边框）
        let border = Border()
        border.borderBrush = SolidColorBrush(Colors.gray)
        border.borderThickness = Thickness(left: 15, top: 15, right: 15, bottom: 15)

        // 内部StackPanel（深灰色背景）
        let contentStack = StackPanel()
        contentStack.background = SolidColorBrush(Colors.darkGray)

        // 顶部彩色条（水平排列的矩形，与C#完全一致）
        let colorStrip = StackPanel()
        colorStrip.orientation = .horizontal
        let blueRect = Rectangle()
        blueRect.fill = SolidColorBrush(Colors.blue)
        blueRect.height = 10
        blueRect.width = 40
        let greenRect = Rectangle()
        greenRect.fill = SolidColorBrush(Colors.green)
        greenRect.height = 10
        greenRect.width = 40
        let redRect = Rectangle()
        redRect.fill = SolidColorBrush(Colors.red)
        redRect.height = 10
        redRect.width = 40
        let yellowRect = Rectangle()
        yellowRect.fill = SolidColorBrush(Colors.yellow)
        yellowRect.height = 10
        yellowRect.width = 40
        colorStrip.children.append(blueRect)
        colorStrip.children.append(greenRect)
        colorStrip.children.append(redRect)
        colorStrip.children.append(yellowRect)
        contentStack.children.append(colorStrip)

        // 中间矩形（替代C#中的Image，保持布局位置）
        let centerRect = Rectangle()
        centerRect.fill = SolidColorBrush(Colors.lightBlue)  // 浅蓝色填充
        centerRect.stroke = SolidColorBrush(Colors.blue)     // 蓝色边框
        centerRect.strokeThickness = 2                       // 边框厚度
        centerRect.width = 150                               // 适当宽度
        centerRect.height = 100                              // 适当高度
        centerRect.margin = Thickness(left: 10, top: 10, right: 10, bottom: 10)   // 上下边距
        contentStack.children.append(centerRect)

        // 底部文字（与C#一致）
        let textBlock = TextBlock()
        textBlock.text = "This is text."
        textBlock.horizontalAlignment = .center
        contentStack.children.append(textBlock)

        // 组装布局
        border.child = contentStack
        viewbox.child = border
        mainGrid.children.append(viewbox)

        // 右侧控制面板（保留原有交互功能）
        controlPanel.verticalAlignment = .top
        controlPanel.background = SolidColorBrush(Colors.darkGray)
        controlPanel.borderThickness = Thickness(left: 1, top: 0, right: 0, bottom: 0)
        controlPanel.borderBrush = SolidColorBrush(Colors.darkGray)
        controlPanel.padding = Thickness(left: 10, top: 10, right: 10, bottom: 10)
        try? Grid.setColumn(controlPanel, 1)

        // Width/Height 滑块
        let widthHeightLabel = TextBlock()
        widthHeightLabel.text = "Width/Height"
        widthHeightLabel.fontSize = 16
        controlPanel.children.append(widthHeightLabel)
        let widthHeightSlider = Slider()
        widthHeightSlider.minimum = 50
        widthHeightSlider.maximum = 300
        widthHeightSlider.value = 229  // 初始值匹配C#的229
        widthHeightSlider.valueChanged.addHandler { [weak self] sender, args in
            guard let self = self, let slider = sender as? Slider else { return }
            self.viewbox.width = slider.value
            self.viewbox.height = slider.value
        }
        controlPanel.children.append(widthHeightSlider)

        // Stretch 选项
        let stretchLabel = TextBlock()
        stretchLabel.text = "Stretch"
        stretchLabel.fontSize = 16
        controlPanel.children.append(stretchLabel)
        let noneRadio = RadioButton()
        noneRadio.content = "None"
        noneRadio.isChecked = false
        noneRadio.checked.addHandler { [weak self] sender, args in
            guard let self = self, let radio = sender as? RadioButton, radio.isChecked == true else { return }
            self.viewbox.stretch = .none
        }
        controlPanel.children.append(noneRadio)
        let fillRadio = RadioButton()
        fillRadio.content = "Fill"
        fillRadio.isChecked = false
        fillRadio.checked.addHandler { [weak self] sender, args in
            guard let self = self, let radio = sender as? RadioButton, radio.isChecked == true else { return }
            self.viewbox.stretch = .fill
        }
        controlPanel.children.append(fillRadio)
        let uniformRadio = RadioButton()
        uniformRadio.content = "Uniform"
        uniformRadio.isChecked = false
        uniformRadio.checked.addHandler { [weak self] sender, args in
            guard let self = self, let radio = sender as? RadioButton, radio.isChecked == true else { return }
            self.viewbox.stretch = .uniform
        }
        controlPanel.children.append(uniformRadio)
        let uniformToFillRadio = RadioButton()
        uniformToFillRadio.content = "UniformToFill"
        uniformToFillRadio.isChecked = true  // 初始值匹配C#
        uniformToFillRadio.checked.addHandler { [weak self] sender, args in
            guard let self = self, let radio = sender as? RadioButton, radio.isChecked == true else { return }
            self.viewbox.stretch = .uniformToFill
        }
        controlPanel.children.append(uniformToFillRadio)

        // StretchDirection 选项
        let stretchDirectionLabel = TextBlock()
        stretchDirectionLabel.text = "StretchDirection"
        stretchDirectionLabel.fontSize = 16
        controlPanel.children.append(stretchDirectionLabel)
        let upOnlyRadio = RadioButton()
        upOnlyRadio.content = "UpOnly"
        upOnlyRadio.isChecked = false
        upOnlyRadio.checked.addHandler { [weak self] sender, args in
            guard let self = self, let radio = sender as? RadioButton, radio.isChecked == true else { return }
            self.viewbox.stretchDirection = .upOnly
        }
        controlPanel.children.append(upOnlyRadio)
        let downOnlyRadio = RadioButton()
        downOnlyRadio.content = "DownOnly"
        downOnlyRadio.isChecked = false
        downOnlyRadio.checked.addHandler { [weak self] sender, args in
            guard let self = self, let radio = sender as? RadioButton, radio.isChecked == true else { return }
            self.viewbox.stretchDirection = .downOnly
        }
        controlPanel.children.append(downOnlyRadio)
        let bothRadio = RadioButton()
        bothRadio.content = "Both"
        bothRadio.isChecked = true  // 初始值匹配C#
        bothRadio.checked.addHandler { [weak self] sender, args in
            guard let self = self, let radio = sender as? RadioButton, radio.isChecked == true else { return }
            self.viewbox.stretchDirection = .both
        }
        controlPanel.children.append(bothRadio)

        mainGrid.children.append(controlPanel)

        mainPanel.children.append(mainGrid)
    }
}