import WinUI
import WinAppSDK
import Foundation
import UWP
import WindowsFoundation

class ScrollViewerPage: Grid {
    // MARK: - Properties
    private var mainScrollViewer: ScrollViewer!
    private var contentStackPanel: StackPanel!
    private var demoGrid: Grid!
    private var demoScrollViewer: ScrollViewer!
    private var demoImage: Image!
    
    // 右侧控件
    private var zoomModeComboBox: ComboBox!
    private var zoomSlider: Slider!
    private var zoomValueText: TextBlock!
    private var horizontalScrollModeComboBox: ComboBox!
    private var verticalScrollModeComboBox: ComboBox!
    private var horizontalScrollBarVisibilityComboBox: ComboBox!
    private var verticalScrollBarVisibilityComboBox: ComboBox!
    
    // Source code section
    private var sourceCodePanel: StackPanel!
    private var sourceCodeToggleButton: Button!
    private var sourceCodeContent: Border!
    private var isSourceCodeVisible = false
    
    private var currentZoomFactor: Double = 1.0
    
    // MARK: - Initialization
    override init() {
        super.init()
        setupView()
    }
    
    private func setupView() {
        let rowDef = RowDefinition()
        rowDef.height = GridLength(value: 1, gridUnitType: .star)
        self.rowDefinitions.append(rowDef)
        
        mainScrollViewer = ScrollViewer()
        mainScrollViewer.verticalScrollBarVisibility = .auto
        mainScrollViewer.horizontalScrollBarVisibility = .disabled
        
        contentStackPanel = StackPanel()
        contentStackPanel.padding = Thickness(left: 40, top: 40, right: 40, bottom: 40)
        contentStackPanel.spacing = 24
        
        contentStackPanel.children.append(createHeader())
        contentStackPanel.children.append(createDescription())
        contentStackPanel.children.append(createSubtitle())
        contentStackPanel.children.append(createMainContent())
        contentStackPanel.children.append(createSourceCodeSection())
        
        mainScrollViewer.content = contentStackPanel
        self.children.append(mainScrollViewer)
    }
    
    private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 8
        
        let titleText = TextBlock()
        titleText.text = "ScrollViewer"
        titleText.fontSize = 32
        titleText.fontWeight = FontWeights.semiBold
        headerPanel.children.append(titleText)
        
        return headerPanel
    }
    
    private func createDescription() -> TextBlock {
        let descText = TextBlock()
        descText.text = "A ScrollViewer lets a user scroll, pan, and zoom to see content that's larger than the viewable area. Many content controls, like ListView, have ScrollViewers built into their control templates to provide automatic scrolling."
        descText.fontSize = 14
        descText.textWrapping = .wrap
        descText.opacity = 0.8
        return descText
    }
    
    private func createSubtitle() -> TextBlock {
        let subtitleText = TextBlock()
        subtitleText.text = "Content inside of a ScrollViewer."
        subtitleText.fontSize = 16
        subtitleText.fontWeight = FontWeights.semiBold
        subtitleText.margin = Thickness(left: 0, top: 8, right: 0, bottom: 0)
        return subtitleText
    }
    
    // MARK: - Create Main Content
    private func createMainContent() -> Border {
        let outerBorder = Border()
        outerBorder.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        outerBorder.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        
        let borderBrush = SolidColorBrush()
        var borderColor = UWP.Color()
        borderColor.a = 255
        borderColor.r = 200
        borderColor.g = 200
        borderColor.b = 200
        borderBrush.color = borderColor
        outerBorder.borderBrush = borderBrush
        
        outerBorder.margin = Thickness(left: 0, top: 16, right: 0, bottom: 16)
        
        demoGrid = Grid()
        
        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 1, gridUnitType: .star)
        demoGrid.columnDefinitions.append(col1)
        
        let col2 = ColumnDefinition()
        col2.width = GridLength(value: 450, gridUnitType: .pixel)
        demoGrid.columnDefinitions.append(col2)
        
        let leftSection = createLeftDemoSection()
        try? Grid.setColumn(leftSection, 0)
        demoGrid.children.append(leftSection)
        
        let rightSection = createRightControlSection()
        try? Grid.setColumn(rightSection, 1)
        demoGrid.children.append(rightSection)
        
        outerBorder.child = demoGrid
        return outerBorder
    }
    
    // MARK: - Create Left Demo Section (Image ScrollViewer)
    private func createLeftDemoSection() -> Border {
        let containerBorder = Border()
        containerBorder.padding = Thickness(left: 24, top: 24, right: 24, bottom: 24)
        
        demoScrollViewer = ScrollViewer()
        demoScrollViewer.height = 500
        demoScrollViewer.horizontalScrollBarVisibility = .auto
        demoScrollViewer.verticalScrollBarVisibility = .auto
        demoScrollViewer.zoomMode = .enabled
        demoScrollViewer.minZoomFactor = 0.5
        demoScrollViewer.maxZoomFactor = 4.0
        
        // 加载图片
        demoImage = Image()
        demoImage.stretch = .uniform
        
        // 尝试加载图片
        loadImage()
        
        demoScrollViewer.content = demoImage
        containerBorder.child = demoScrollViewer
        
        return containerBorder
    }
    
    private func loadImage() {
        // 使用 Bundle.module 加载资源
        if let imagePath = Bundle.module.path(forResource: "picture", ofType: "png", inDirectory: "Assets/Scrolling") {
            print("Loading image from: \(imagePath)")
            let uri = Uri(imagePath)
            let bitmapImage = BitmapImage()
            bitmapImage.uriSource = uri
            demoImage.source = bitmapImage
            print("Image loaded successfully")
        } else {
            print("Image file not found in Assets/Scrolling")
            showPlaceholder()
        }
    }
    
    private func showPlaceholder() {
        // 如果图片加载失败，显示占位符
        let placeholder = Border()
        placeholder.width = 800
        placeholder.height = 600
        
        let bgBrush = SolidColorBrush()
        var bgColor = UWP.Color()
        bgColor.a = 255
        bgColor.r = 135
        bgColor.g = 206
        bgColor.b = 235  // Sky blue
        bgBrush.color = bgColor
        placeholder.background = bgBrush
        
        let placeholderText = TextBlock()
        placeholderText.text = "Image Placeholder\n(picture.png not found)"
        placeholderText.fontSize = 20
        placeholderText.horizontalAlignment = .center
        placeholderText.verticalAlignment = .center
        placeholderText.textAlignment = .center
        
        let textBrush = SolidColorBrush()
        var textColor = UWP.Color()
        textColor.a = 255
        textColor.r = 255
        textColor.g = 255
        textColor.b = 255
        textBrush.color = textColor
        placeholderText.foreground = textBrush
        
        placeholder.child = placeholderText
        demoScrollViewer.content = placeholder
    }
    
    // MARK: - Create Right Control Section
    private func createRightControlSection() -> StackPanel {
        let controlPanel = StackPanel()
        controlPanel.spacing = 20
        controlPanel.padding = Thickness(left: 24, top: 24, right: 24, bottom: 24)
        
        // ZoomMode section
        controlPanel.children.append(createZoomModeSection())
        
        // Zoom slider section
        controlPanel.children.append(createZoomSection())
        
        // ScrollMode section
        controlPanel.children.append(createScrollModeSection())
        
        // ScrollbarVisibility section
        controlPanel.children.append(createScrollbarVisibilitySection())
        
        return controlPanel
    }
    
    // MARK: - ZoomMode Section
    private func createZoomModeSection() -> StackPanel {
        let section = StackPanel()
        section.spacing = 8
        
        let label = TextBlock()
        label.text = "ZoomMode"
        label.fontSize = 14
        label.fontWeight = FontWeights.semiBold
        section.children.append(label)
        
        zoomModeComboBox = ComboBox()
        zoomModeComboBox.horizontalAlignment = .stretch
        
        let enabledItem = ComboBoxItem()
        enabledItem.content = "Enabled"
        zoomModeComboBox.items.append(enabledItem)
        
        let disabledItem = ComboBoxItem()
        disabledItem.content = "Disabled"
        zoomModeComboBox.items.append(disabledItem)
        
        zoomModeComboBox.selectedIndex = 0
        
        zoomModeComboBox.selectionChanged.addHandler { [weak self] sender, args in
            guard let self = self else { return }
            let index = self.zoomModeComboBox.selectedIndex
            if index == 0 {
                self.demoScrollViewer.zoomMode = .enabled
                self.zoomSlider.isEnabled = true
            } else {
                self.demoScrollViewer.zoomMode = .disabled
                self.zoomSlider.isEnabled = false
            }
        }
        
        section.children.append(zoomModeComboBox)
        
        return section
    }
    
    // MARK: - Zoom Section
    private func createZoomSection() -> StackPanel {
        let section = StackPanel()
        section.spacing = 8
        
        let label = TextBlock()
        label.text = "Zoom"
        label.fontSize = 14
        label.fontWeight = FontWeights.semiBold
        section.children.append(label)
        
        zoomSlider = Slider()
        zoomSlider.minimum = 0.5
        zoomSlider.maximum = 4.0
        zoomSlider.value = 1.0
        zoomSlider.stepFrequency = 0.1
        zoomSlider.horizontalAlignment = .stretch
        
        zoomValueText = TextBlock()
        zoomValueText.text = "1.0x"
        zoomValueText.fontSize = 12
        zoomValueText.opacity = 0.7
        
        zoomSlider.valueChanged.addHandler { [weak self] sender, args in
            guard let self = self, let args = args else { return }
            let newZoom = args.newValue
            self.currentZoomFactor = newZoom
            self.zoomValueText.text = String(format: "%.1fx", newZoom)
            
            // 应用缩放
            _ = try? self.demoScrollViewer.changeView(
                nil,
                nil,
                Float(newZoom)
            )
        }
        
        section.children.append(zoomSlider)
        section.children.append(zoomValueText)
        
        return section
    }
    
    // MARK: - ScrollMode Section
    private func createScrollModeSection() -> StackPanel {
        let section = StackPanel()
        section.spacing = 12
        
        let label = TextBlock()
        label.text = "ScrollMode"
        label.fontSize = 14
        label.fontWeight = FontWeights.semiBold
        section.children.append(label)
        
        // Horizontal ScrollMode
        let hSection = createScrollModeControl(
            title: "Horizontal",
            isHorizontal: true
        )
        section.children.append(hSection)
        
        // Vertical ScrollMode
        let vSection = createScrollModeControl(
            title: "Vertical",
            isHorizontal: false
        )
        section.children.append(vSection)
        
        return section
    }
    
    private func createScrollModeControl(title: String, isHorizontal: Bool) -> StackPanel {
        let container = StackPanel()
        container.spacing = 6
        
        let label = TextBlock()
        label.text = title
        label.fontSize = 13
        label.opacity = 0.8
        container.children.append(label)
        
        let comboBox = ComboBox()
        comboBox.horizontalAlignment = .stretch
        
        let autoItem = ComboBoxItem()
        autoItem.content = "Auto"
        comboBox.items.append(autoItem)
        
        let enabledItem = ComboBoxItem()
        enabledItem.content = "Enabled"
        comboBox.items.append(enabledItem)
        
        let disabledItem = ComboBoxItem()
        disabledItem.content = "Disabled"
        comboBox.items.append(disabledItem)
        
        comboBox.selectedIndex = 1  // 默认选中 Enabled
        
        comboBox.selectionChanged.addHandler { [weak self] sender, args in
            guard let self = self else { return }
            let index = comboBox.selectedIndex
            var mode: ScrollMode
            
            switch index {
            case 0: mode = .auto
            case 1: mode = .enabled
            case 2: mode = .disabled
            default: mode = .enabled
            }
            
            if isHorizontal {
                self.demoScrollViewer.horizontalScrollMode = mode
            } else {
                self.demoScrollViewer.verticalScrollMode = mode
            }
        }
        
        if isHorizontal {
            horizontalScrollModeComboBox = comboBox
        } else {
            verticalScrollModeComboBox = comboBox
        }
        
        container.children.append(comboBox)
        
        return container
    }
    
    // MARK: - ScrollbarVisibility Section
    private func createScrollbarVisibilitySection() -> StackPanel {
        let section = StackPanel()
        section.spacing = 12
        
        let label = TextBlock()
        label.text = "ScrollbarVisibility"
        label.fontSize = 14
        label.fontWeight = FontWeights.semiBold
        section.children.append(label)
        
        // Horizontal ScrollbarVisibility
        let hSection = createScrollbarVisibilityControl(
            title: "Horizontal",
            isHorizontal: true
        )
        section.children.append(hSection)
        
        // Vertical ScrollbarVisibility
        let vSection = createScrollbarVisibilityControl(
            title: "Vertical",
            isHorizontal: false
        )
        section.children.append(vSection)
        
        return section
    }
    
    private func createScrollbarVisibilityControl(title: String, isHorizontal: Bool) -> StackPanel {
        let container = StackPanel()
        container.spacing = 6
        
        let label = TextBlock()
        label.text = title
        label.fontSize = 13
        label.opacity = 0.8
        container.children.append(label)
        
        let comboBox = ComboBox()
        comboBox.horizontalAlignment = .stretch
        
        let autoItem = ComboBoxItem()
        autoItem.content = "Auto"
        comboBox.items.append(autoItem)
        
        let visibleItem = ComboBoxItem()
        visibleItem.content = "Visible"
        comboBox.items.append(visibleItem)
        
        let hiddenItem = ComboBoxItem()
        hiddenItem.content = "Hidden"
        comboBox.items.append(hiddenItem)
        
        let disabledItem = ComboBoxItem()
        disabledItem.content = "Disabled"
        comboBox.items.append(disabledItem)
        
        comboBox.selectedIndex = 0
        
        comboBox.selectionChanged.addHandler { [weak self] sender, args in
            guard let self = self else { return }
            let index = comboBox.selectedIndex
            var visibility: ScrollBarVisibility = .auto
            
            switch index {
            case 0: visibility = .auto
            case 1: visibility = .visible
            case 2: visibility = .hidden
            case 3: visibility = .disabled
            default: visibility = .auto
            }
            
            if isHorizontal {
                self.demoScrollViewer.horizontalScrollBarVisibility = visibility
            } else {
                self.demoScrollViewer.verticalScrollBarVisibility = visibility
            }
        }
        
        if isHorizontal {
            horizontalScrollBarVisibilityComboBox = comboBox
        } else {
            verticalScrollBarVisibilityComboBox = comboBox
        }
        
        container.children.append(comboBox)
        
        return container
    }
    
    // MARK: - Create Source Code Section
    private func createSourceCodeSection() -> Border {
        let outerBorder = Border()
        outerBorder.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        outerBorder.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        
        let borderBrush = SolidColorBrush()
        var borderColor = UWP.Color()
        borderColor.a = 255
        borderColor.r = 200
        borderColor.g = 200
        borderColor.b = 200
        borderBrush.color = borderColor
        outerBorder.borderBrush = borderBrush
        
        outerBorder.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        
        sourceCodePanel = StackPanel()
        sourceCodePanel.spacing = 8
        
        // 创建标题栏（包含按钮和复制按钮）
        let headerGrid = Grid()
        
        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 1, gridUnitType: .star)
        headerGrid.columnDefinitions.append(col1)
        
        let col2 = ColumnDefinition()
        col2.width = GridLength(value: 0, gridUnitType: .auto)
        headerGrid.columnDefinitions.append(col2)
        
        sourceCodeToggleButton = Button()
        sourceCodeToggleButton.content = "▼ Source code"
        sourceCodeToggleButton.horizontalAlignment = .left
        sourceCodeToggleButton.padding = Thickness(left: 12, top: 8, right: 12, bottom: 8)
        sourceCodeToggleButton.background = nil
        sourceCodeToggleButton.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        
        sourceCodeToggleButton.click.addHandler { [weak self] sender, args in
            self?.toggleSourceCode()
        }
        
        try? Grid.setColumn(sourceCodeToggleButton, 0)
        headerGrid.children.append(sourceCodeToggleButton)
        
        sourceCodePanel.children.append(headerGrid)
        
        // 源代码内容
        sourceCodeContent = Border()
        sourceCodeContent.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        sourceCodeContent.cornerRadius = CornerRadius(topLeft: 4, topRight: 4, bottomRight: 4, bottomLeft: 4)
        sourceCodeContent.visibility = .collapsed
        
        let codeText = TextBlock()
        codeText.text = """
        // Swift WinUI Code Example
        
        let scrollViewer = ScrollViewer()
        scrollViewer.height = 500
        scrollViewer.horizontalScrollBarVisibility = .auto
        scrollViewer.verticalScrollBarVisibility = .auto
        
        // Enable zoom functionality
        scrollViewer.zoomMode = .enabled
        scrollViewer.minZoomFactor = 0.5
        scrollViewer.maxZoomFactor = 4.0
        
        // Load and display image
        let image = Image()
        image.stretch = .uniform
        
        let bitmap = BitmapImage()
        bitmap.uriSource = URI("ms-appx:///Assets/picture.png")
        image.source = bitmap
        
        scrollViewer.content = image
        
        // Apply zoom programmatically
        scrollViewer.changeView(nil, nil, Float(2.0))
        
        // Control scroll modes
        scrollViewer.horizontalScrollMode = .enabled
        scrollViewer.verticalScrollMode = .enabled
        """
        codeText.fontSize = 12
        codeText.fontFamily = FontFamily("Consolas")
        codeText.textWrapping = .wrap
        
        sourceCodeContent.child = codeText
        sourceCodePanel.children.append(sourceCodeContent)
        
        outerBorder.child = sourceCodePanel
        
        return outerBorder
    }
    
    private func toggleSourceCode() {
        isSourceCodeVisible = !isSourceCodeVisible
        
        if isSourceCodeVisible {
            sourceCodeContent.visibility = .visible
            sourceCodeToggleButton.content = "▲ Source code"
        } else {
            sourceCodeContent.visibility = .collapsed
            sourceCodeToggleButton.content = "▼ Source code"
        }
    }
}