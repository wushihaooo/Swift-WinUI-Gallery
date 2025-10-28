import WinUI
import WinAppSDK
import Foundation
import UWP
import WindowsFoundation

class ScrollViewPage: Grid {
    // MARK: - Properties
    private var mainScrollViewer: ScrollViewer!
    private var contentStackPanel: StackPanel!
    
    // Example 1: Content inside of a ScrollView
    private var example1ScrollViewer: ScrollViewer!
    private var example1Image: Image!
    private var zoomModeComboBox: ComboBox!
    private var zoomFactorSlider: Slider!
    private var zoomFactorText: TextBlock!
    private var horizontalScrollModeComboBox: ComboBox!
    private var verticalScrollModeComboBox: ComboBox!
    private var horizontalScrollBarVisibilityComboBox: ComboBox!
    private var verticalScrollBarVisibilityComboBox: ComboBox!
    
    // Example 2: Constant velocity scrolling
    private var example2ScrollViewer: ScrollViewer!
    private var verticalVelocitySlider: Slider!
    private var verticalVelocityText: TextBlock!
    private var scrollTimer: DispatchSourceTimer?
    private var currentVelocity: Double = 0
    
    // Example 3: Programmatic scroll with custom animation
    private var example3ScrollViewer: ScrollViewer!
    private var scrollAnimationComboBox: ComboBox!
    private var animationDurationSlider: Slider!
    private var animationDurationText: TextBlock!
    private var scrollWithAnimationButton: Button!
    
    private var sourceCodeToggleButton1: Button!
    private var sourceCodeContent1: Border!
    private var isSourceCodeVisible1 = false
    
    private var sourceCodeToggleButton2: Button!
    private var sourceCodeContent2: Border!
    private var isSourceCodeVisible2 = false
    
    private var sourceCodeToggleButton3: Button!
    private var sourceCodeContent3: Border!
    private var isSourceCodeVisible3 = false
    
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
        contentStackPanel.children.append(createExample1())
        contentStackPanel.children.append(createSourceCodeSection1())
        contentStackPanel.children.append(createExample2())
        contentStackPanel.children.append(createSourceCodeSection2())
        contentStackPanel.children.append(createExample3())
        contentStackPanel.children.append(createSourceCodeSection3())
        
        mainScrollViewer.content = contentStackPanel
        self.children.append(mainScrollViewer)
    }
    
    private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 12
        
        let titleText = TextBlock()
        titleText.text = "ScrollView"
        titleText.fontSize = 32
        titleText.fontWeight = FontWeights.semiBold
        headerPanel.children.append(titleText)
        
        // Documentation and Source tabs
        let tabsPanel = StackPanel()
        tabsPanel.orientation = .horizontal
        tabsPanel.spacing = 20
        
        let docText = TextBlock()
        docText.text = "Documentation"
        docText.fontSize = 14
        docText.foreground = createBrush(r: 0, g: 120, b: 212)
        docText.fontWeight = FontWeights.semiBold
        docText.padding = Thickness(left: 0, top: 4, right: 0, bottom: 4)
        tabsPanel.children.append(docText)
        
        let sourceText = TextBlock()
        sourceText.text = "Source"
        sourceText.fontSize = 14
        sourceText.opacity = 0.6
        sourceText.padding = Thickness(left: 0, top: 4, right: 0, bottom: 4)
        tabsPanel.children.append(sourceText)
        
        headerPanel.children.append(tabsPanel)
        
        return headerPanel
    }
    
    private func createDescription() -> TextBlock {
        let descText = TextBlock()
        descText.text = "A ScrollView lets a user scroll, pan, and zoom to see content that's larger than the viewable area. The ItemsView has a ScrollView built into its control template to provide automatic scrolling."
        descText.fontSize = 14
        descText.textWrapping = .wrap
        descText.opacity = 0.8
        return descText
    }
    
    // MARK: - Example 1: Content inside of a ScrollView
    private func createExample1() -> StackPanel {
        let examplePanel = StackPanel()
        examplePanel.spacing = 12
        
        let titleText = TextBlock()
        titleText.text = "Content inside of a ScrollView."
        titleText.fontSize = 18
        titleText.fontWeight = FontWeights.semiBold
        examplePanel.children.append(titleText)
        
        let demoContainer = createExample1Demo()
        examplePanel.children.append(demoContainer)
        
        return examplePanel
    }
    
    private func createExample1Demo() -> Border {
        let demoBorder = Border()
        demoBorder.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        demoBorder.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        demoBorder.borderBrush = createBrush(r: 200, g: 200, b: 200)
        demoBorder.padding = Thickness(left: 24, top: 24, right: 24, bottom: 24)
        
        let descText = TextBlock()
        descText.text = "This ScrollView allows horizontal and vertical scrolling, as well as zooming. Change the settings on the right to test those capabilities or the built-in scrollbars' visibility."
        descText.fontSize = 14
        descText.textWrapping = .wrap
        descText.margin = Thickness(left: 0, top: 0, right: 0, bottom: 16)
        
        let mainGrid = Grid()
        
        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 1, gridUnitType: .star)
        mainGrid.columnDefinitions.append(col1)
        
        let col2 = ColumnDefinition()
        col2.width = GridLength(value: 300, gridUnitType: .pixel)
        mainGrid.columnDefinitions.append(col2)
        
        // Left: ScrollViewer with Image
        example1ScrollViewer = ScrollViewer()
        example1ScrollViewer.width = 400
        example1ScrollViewer.height = 400
        example1ScrollViewer.horizontalScrollBarVisibility = .auto
        example1ScrollViewer.verticalScrollBarVisibility = .auto
        example1ScrollViewer.zoomMode = .enabled
        example1ScrollViewer.minZoomFactor = 0.5
        example1ScrollViewer.maxZoomFactor = 5.0
        
        example1Image = Image()
        example1Image.width = 800
        example1Image.height = 600
        example1Image.stretch = .uniform
        
        // Load image
        if let imagePath = Bundle.module.path(forResource: "picture", ofType: "png", inDirectory: "Assets/Scrolling") {
            let uri = Uri(imagePath)
            let bitmapImage = BitmapImage()
            bitmapImage.uriSource = uri
            example1Image.source = bitmapImage
        }
        
        example1ScrollViewer.content = example1Image
        
        try? Grid.setColumn(example1ScrollViewer, 0)
        mainGrid.children.append(example1ScrollViewer)
        
        // Right: Controls
        let controlsPanel = createExample1Controls()
        try? Grid.setColumn(controlsPanel, 1)
        mainGrid.children.append(controlsPanel)
        
        let contentStack = StackPanel()
        contentStack.spacing = 16
        contentStack.children.append(descText)
        contentStack.children.append(mainGrid)
        
        demoBorder.child = contentStack
        return demoBorder
    }
    
    private func createExample1Controls() -> StackPanel {
        let controlsPanel = StackPanel()
        controlsPanel.spacing = 16
        
        // ZoomMode
        let zoomModeLabel = TextBlock()
        zoomModeLabel.text = "ZoomMode"
        zoomModeLabel.fontSize = 14
        zoomModeLabel.fontWeight = FontWeights.semiBold
        controlsPanel.children.append(zoomModeLabel)
        
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
            if self.zoomModeComboBox.selectedIndex == 0 {
                self.example1ScrollViewer.zoomMode = .enabled
            } else {
                self.example1ScrollViewer.zoomMode = .disabled
            }
        }
        
        controlsPanel.children.append(zoomModeComboBox)
        
        // ZoomFactor
        let zoomFactorLabel = TextBlock()
        zoomFactorLabel.text = "ZoomFactor"
        zoomFactorLabel.fontSize = 14
        zoomFactorLabel.fontWeight = FontWeights.semiBold
        zoomFactorLabel.margin = Thickness(left: 0, top: 8, right: 0, bottom: 0)
        controlsPanel.children.append(zoomFactorLabel)
        
        zoomFactorSlider = Slider()
        zoomFactorSlider.horizontalAlignment = .stretch
        zoomFactorSlider.value = 1.0
        zoomFactorSlider.minimum = 0.5
        zoomFactorSlider.maximum = 5.0
        
        zoomFactorSlider.valueChanged.addHandler { [weak self] sender, args in
            guard let self = self, let args = args else { return }
            let newZoom = Float(args.newValue)
            _ = try? self.example1ScrollViewer.changeView(nil, nil, newZoom)
            self.zoomFactorText.text = String(format: "%.1f", args.newValue)
        }
        
        controlsPanel.children.append(zoomFactorSlider)
        
        zoomFactorText = TextBlock()
        zoomFactorText.text = "1.0"
        zoomFactorText.fontSize = 12
        zoomFactorText.opacity = 0.7
        controlsPanel.children.append(zoomFactorText)
        
        // ScrollMode Header
        let scrollModeHeader = TextBlock()
        scrollModeHeader.text = "ScrollMode"
        scrollModeHeader.fontSize = 14
        scrollModeHeader.fontWeight = FontWeights.semiBold
        scrollModeHeader.margin = Thickness(left: 0, top: 16, right: 0, bottom: 0)
        controlsPanel.children.append(scrollModeHeader)
        
        // Horizontal ScrollMode
        let horizontalLabel = TextBlock()
        horizontalLabel.text = "Horizontal"
        horizontalLabel.fontSize = 14
        horizontalLabel.margin = Thickness(left: 0, top: 8, right: 0, bottom: 0)
        controlsPanel.children.append(horizontalLabel)
        
        horizontalScrollModeComboBox = ComboBox()
        horizontalScrollModeComboBox.horizontalAlignment = .stretch
        
        let hAutoItem = ComboBoxItem()
        hAutoItem.content = "Auto"
        horizontalScrollModeComboBox.items.append(hAutoItem)
        
        let hEnabledItem = ComboBoxItem()
        hEnabledItem.content = "Enabled"
        horizontalScrollModeComboBox.items.append(hEnabledItem)
        
        let hDisabledItem = ComboBoxItem()
        hDisabledItem.content = "Disabled"
        horizontalScrollModeComboBox.items.append(hDisabledItem)
        
        horizontalScrollModeComboBox.selectedIndex = 0
        
        horizontalScrollModeComboBox.selectionChanged.addHandler { [weak self] sender, args in
            guard let self = self else { return }
            switch self.horizontalScrollModeComboBox.selectedIndex {
            case 0:
                self.example1ScrollViewer.horizontalScrollMode = .auto
            case 1:
                self.example1ScrollViewer.horizontalScrollMode = .enabled
            case 2:
                self.example1ScrollViewer.horizontalScrollMode = .disabled
            default:
                break
            }
        }
        
        controlsPanel.children.append(horizontalScrollModeComboBox)
        
        // Vertical ScrollMode
        let verticalLabel = TextBlock()
        verticalLabel.text = "Vertical"
        verticalLabel.fontSize = 14
        verticalLabel.margin = Thickness(left: 0, top: 8, right: 0, bottom: 0)
        controlsPanel.children.append(verticalLabel)
        
        verticalScrollModeComboBox = ComboBox()
        verticalScrollModeComboBox.horizontalAlignment = .stretch
        
        let vAutoItem = ComboBoxItem()
        vAutoItem.content = "Auto"
        verticalScrollModeComboBox.items.append(vAutoItem)
        
        let vEnabledItem = ComboBoxItem()
        vEnabledItem.content = "Enabled"
        verticalScrollModeComboBox.items.append(vEnabledItem)
        
        let vDisabledItem = ComboBoxItem()
        vDisabledItem.content = "Disabled"
        verticalScrollModeComboBox.items.append(vDisabledItem)
        
        verticalScrollModeComboBox.selectedIndex = 0
        
        verticalScrollModeComboBox.selectionChanged.addHandler { [weak self] sender, args in
            guard let self = self else { return }
            switch self.verticalScrollModeComboBox.selectedIndex {
            case 0:
                self.example1ScrollViewer.verticalScrollMode = .auto
            case 1:
                self.example1ScrollViewer.verticalScrollMode = .enabled
            case 2:
                self.example1ScrollViewer.verticalScrollMode = .disabled
            default:
                break
            }
        }
        
        controlsPanel.children.append(verticalScrollModeComboBox)
        
        // ScrollbarVisibility Header
        let scrollbarHeader = TextBlock()
        scrollbarHeader.text = "ScrollbarVisibility"
        scrollbarHeader.fontSize = 14
        scrollbarHeader.fontWeight = FontWeights.semiBold
        scrollbarHeader.margin = Thickness(left: 0, top: 16, right: 0, bottom: 0)
        controlsPanel.children.append(scrollbarHeader)
        
        // Horizontal ScrollbarVisibility
        let hScrollbarLabel = TextBlock()
        hScrollbarLabel.text = "Horizontal"
        hScrollbarLabel.fontSize = 14
        hScrollbarLabel.margin = Thickness(left: 0, top: 8, right: 0, bottom: 0)
        controlsPanel.children.append(hScrollbarLabel)
        
        horizontalScrollBarVisibilityComboBox = ComboBox()
        horizontalScrollBarVisibilityComboBox.horizontalAlignment = .stretch
        
        let hVAutoItem = ComboBoxItem()
        hVAutoItem.content = "Auto"
        horizontalScrollBarVisibilityComboBox.items.append(hVAutoItem)
        
        let hVVisibleItem = ComboBoxItem()
        hVVisibleItem.content = "Visible"
        horizontalScrollBarVisibilityComboBox.items.append(hVVisibleItem)
        
        let hVHiddenItem = ComboBoxItem()
        hVHiddenItem.content = "Hidden"
        horizontalScrollBarVisibilityComboBox.items.append(hVHiddenItem)
        
        horizontalScrollBarVisibilityComboBox.selectedIndex = 0
        
        horizontalScrollBarVisibilityComboBox.selectionChanged.addHandler { [weak self] sender, args in
            guard let self = self else { return }
            switch self.horizontalScrollBarVisibilityComboBox.selectedIndex {
            case 0:
                self.example1ScrollViewer.horizontalScrollBarVisibility = .auto
            case 1:
                self.example1ScrollViewer.horizontalScrollBarVisibility = .visible
            case 2:
                self.example1ScrollViewer.horizontalScrollBarVisibility = .hidden
            default:
                break
            }
        }
        
        controlsPanel.children.append(horizontalScrollBarVisibilityComboBox)
        
        // Vertical ScrollbarVisibility
        let vScrollbarLabel = TextBlock()
        vScrollbarLabel.text = "Vertical"
        vScrollbarLabel.fontSize = 14
        vScrollbarLabel.margin = Thickness(left: 0, top: 8, right: 0, bottom: 0)
        controlsPanel.children.append(vScrollbarLabel)
        
        verticalScrollBarVisibilityComboBox = ComboBox()
        verticalScrollBarVisibilityComboBox.horizontalAlignment = .stretch
        
        let vVAutoItem = ComboBoxItem()
        vVAutoItem.content = "Auto"
        verticalScrollBarVisibilityComboBox.items.append(vVAutoItem)
        
        let vVVisibleItem = ComboBoxItem()
        vVVisibleItem.content = "Visible"
        verticalScrollBarVisibilityComboBox.items.append(vVVisibleItem)
        
        let vVHiddenItem = ComboBoxItem()
        vVHiddenItem.content = "Hidden"
        verticalScrollBarVisibilityComboBox.items.append(vVHiddenItem)
        
        verticalScrollBarVisibilityComboBox.selectedIndex = 0
        
        verticalScrollBarVisibilityComboBox.selectionChanged.addHandler { [weak self] sender, args in
            guard let self = self else { return }
            switch self.verticalScrollBarVisibilityComboBox.selectedIndex {
            case 0:
                self.example1ScrollViewer.verticalScrollBarVisibility = .auto
            case 1:
                self.example1ScrollViewer.verticalScrollBarVisibility = .visible
            case 2:
                self.example1ScrollViewer.verticalScrollBarVisibility = .hidden
            default:
                break
            }
        }
        
        controlsPanel.children.append(verticalScrollBarVisibilityComboBox)
        
        return controlsPanel
    }
    
    // MARK: - Example 2: Constant velocity scrolling
    private func createExample2() -> StackPanel {
        let examplePanel = StackPanel()
        examplePanel.spacing = 12
        
        let titleText = TextBlock()
        titleText.text = "Constant velocity scrolling."
        titleText.fontSize = 18
        titleText.fontWeight = FontWeights.semiBold
        examplePanel.children.append(titleText)
        
        let demoContainer = createExample2Demo()
        examplePanel.children.append(demoContainer)
        
        return examplePanel
    }
    
    private func createExample2Demo() -> Border {
        let demoBorder = Border()
        demoBorder.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        demoBorder.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        demoBorder.borderBrush = createBrush(r: 200, g: 200, b: 200)
        demoBorder.padding = Thickness(left: 24, top: 24, right: 24, bottom: 24)
        
        let descText = TextBlock()
        descText.text = "Set the vertical velocity to a value greater than 30 to scroll down, or a value smaller than -30 to scroll up at a constant speed."
        descText.fontSize = 14
        descText.textWrapping = .wrap
        descText.margin = Thickness(left: 0, top: 0, right: 0, bottom: 16)
        
        let mainGrid = Grid()
        
        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 1, gridUnitType: .star)
        mainGrid.columnDefinitions.append(col1)
        
        let col2 = ColumnDefinition()
        col2.width = GridLength(value: 300, gridUnitType: .pixel)
        mainGrid.columnDefinitions.append(col2)
        
        // Left: ScrollViewer with color blocks
        example2ScrollViewer = ScrollViewer()
        example2ScrollViewer.width = 400
        example2ScrollViewer.height = 400
        example2ScrollViewer.horizontalScrollBarVisibility = .disabled
        example2ScrollViewer.verticalScrollBarVisibility = .auto
        
        let colorStack = createColorBlocks()
        example2ScrollViewer.content = colorStack
        
        try? Grid.setColumn(example2ScrollViewer, 0)
        mainGrid.children.append(example2ScrollViewer)
        
        // Right: Controls
        let controlsPanel = createExample2Controls()
        try? Grid.setColumn(controlsPanel, 1)
        mainGrid.children.append(controlsPanel)
        
        let contentStack = StackPanel()
        contentStack.spacing = 16
        contentStack.children.append(descText)
        contentStack.children.append(mainGrid)
        
        demoBorder.child = contentStack
        return demoBorder
    }
    
    private func createColorBlocks() -> StackPanel {
        let stackPanel = StackPanel()
        stackPanel.spacing = 0
        
        let colors: [(r: UInt8, g: UInt8, b: UInt8, name: String)] = [
            (255, 192, 203, "Pink"),
            (135, 206, 250, "Sky Blue"),
            (144, 238, 144, "Light Green"),
            (255, 218, 185, "Peach"),
            (221, 160, 221, "Plum"),
            (255, 255, 224, "Light Yellow"),
            (255, 182, 193, "Light Pink"),
            (176, 224, 230, "Powder Blue")
        ]
        
        for colorInfo in colors {
            let colorBorder = Border()
            colorBorder.height = 200
            colorBorder.cornerRadius = CornerRadius(topLeft: 4, topRight: 4, bottomRight: 4, bottomLeft: 4)
            colorBorder.margin = Thickness(left: 0, top: 0, right: 0, bottom: 4)
            
            let brush = SolidColorBrush()
            var color = UWP.Color()
            color.a = 255
            color.r = colorInfo.r
            color.g = colorInfo.g
            color.b = colorInfo.b
            brush.color = color
            colorBorder.background = brush
            
            let colorText = TextBlock()
            colorText.text = colorInfo.name
            colorText.fontSize = 24
            colorText.fontWeight = FontWeights.semiBold
            colorText.horizontalAlignment = .center
            colorText.verticalAlignment = .center
            
            colorBorder.child = colorText
            stackPanel.children.append(colorBorder)
        }
        
        return stackPanel
    }
    
    private func createExample2Controls() -> StackPanel {
        let controlsPanel = StackPanel()
        controlsPanel.spacing = 16
        
        let velocityLabel = TextBlock()
        velocityLabel.text = "Vertical velocity"
        velocityLabel.fontSize = 14
        velocityLabel.fontWeight = FontWeights.semiBold
        controlsPanel.children.append(velocityLabel)
        
        verticalVelocitySlider = Slider()
        verticalVelocitySlider.horizontalAlignment = .stretch
        verticalVelocitySlider.value = 30
        verticalVelocitySlider.minimum = -200
        verticalVelocitySlider.maximum = 200
        
        verticalVelocitySlider.valueChanged.addHandler { [weak self] sender, args in
            guard let self = self, let args = args else { return }
            let velocity = args.newValue
            
            self.currentVelocity = velocity
            self.verticalVelocityText.text = String(format: "%.0f", velocity)
            
            // 停止旧的定时器
            self.scrollTimer?.cancel()
            self.scrollTimer = nil
            
            // 如果速度超过阈值，启动自动滚动
            if abs(velocity) > 30 {
                self.startAutoScroll()
            }
        }
        
        controlsPanel.children.append(verticalVelocitySlider)
        
        verticalVelocityText = TextBlock()
        verticalVelocityText.text = "30"
        verticalVelocityText.fontSize = 12
        verticalVelocityText.opacity = 0.7
        controlsPanel.children.append(verticalVelocityText)
        
        return controlsPanel
    }
    
    private func startAutoScroll() {
        scrollTimer?.cancel()
        
        let timer = DispatchSource.makeTimerSource(queue: .main)
        timer.schedule(deadline: .now(), repeating: .milliseconds(50))
        
        timer.setEventHandler { [weak self] in
            guard let self = self else { return }
            
            if abs(self.currentVelocity) > 30 {
                let newOffset = self.example2ScrollViewer.verticalOffset + self.currentVelocity * 0.5
                
                // 检查边界
                if newOffset <= 0 {
                    try? self.example2ScrollViewer.scrollToVerticalOffset(0)
                    self.scrollTimer?.cancel()
                } else if newOffset >= self.example2ScrollViewer.scrollableHeight {
                    try? self.example2ScrollViewer.scrollToVerticalOffset(self.example2ScrollViewer.scrollableHeight)
                    self.scrollTimer?.cancel()
                } else {
                    try? self.example2ScrollViewer.scrollToVerticalOffset(newOffset)
                }
            } else {
                self.scrollTimer?.cancel()
            }
        }
        
        timer.resume()
        scrollTimer = timer
    }
    
    // MARK: - Example 3: Programmatic scroll with custom animation
    private func createExample3() -> StackPanel {
        let examplePanel = StackPanel()
        examplePanel.spacing = 12
        
        let titleText = TextBlock()
        titleText.text = "Programmatic scroll with custom animation."
        titleText.fontSize = 18
        titleText.fontWeight = FontWeights.semiBold
        examplePanel.children.append(titleText)
        
        let demoContainer = createExample3Demo()
        examplePanel.children.append(demoContainer)
        
        return examplePanel
    }
    
    private func createExample3Demo() -> Border {
        let demoBorder = Border()
        demoBorder.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        demoBorder.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        demoBorder.borderBrush = createBrush(r: 200, g: 200, b: 200)
        demoBorder.padding = Thickness(left: 24, top: 24, right: 24, bottom: 24)
        
        let descText = TextBlock()
        descText.text = "Pick an animation type and its duration and then click the button on the right to launch a programmatic scroll."
        descText.fontSize = 14
        descText.textWrapping = .wrap
        descText.margin = Thickness(left: 0, top: 0, right: 0, bottom: 16)
        
        let mainGrid = Grid()
        
        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 1, gridUnitType: .star)
        mainGrid.columnDefinitions.append(col1)
        
        let col2 = ColumnDefinition()
        col2.width = GridLength(value: 300, gridUnitType: .pixel)
        mainGrid.columnDefinitions.append(col2)
        
        // Left: ScrollViewer with color blocks
        example3ScrollViewer = ScrollViewer()
        example3ScrollViewer.width = 400
        example3ScrollViewer.height = 400
        example3ScrollViewer.horizontalScrollBarVisibility = .disabled
        example3ScrollViewer.verticalScrollBarVisibility = .auto
        
        let colorStack = createColorBlocks()
        example3ScrollViewer.content = colorStack
        
        try? Grid.setColumn(example3ScrollViewer, 0)
        mainGrid.children.append(example3ScrollViewer)
        
        // Right: Controls
        let controlsPanel = createExample3Controls()
        try? Grid.setColumn(controlsPanel, 1)
        mainGrid.children.append(controlsPanel)
        
        let contentStack = StackPanel()
        contentStack.spacing = 16
        contentStack.children.append(descText)
        contentStack.children.append(mainGrid)
        
        demoBorder.child = contentStack
        return demoBorder
    }
    
    private func createExample3Controls() -> StackPanel {
        let controlsPanel = StackPanel()
        controlsPanel.spacing = 16
        
        // Scroll with animation
        let animationLabel = TextBlock()
        animationLabel.text = "Scroll with animation"
        animationLabel.fontSize = 14
        animationLabel.fontWeight = FontWeights.semiBold
        controlsPanel.children.append(animationLabel)
        
        scrollAnimationComboBox = ComboBox()
        scrollAnimationComboBox.horizontalAlignment = .stretch
        
        let defaultItem = ComboBoxItem()
        defaultItem.content = "Default"
        scrollAnimationComboBox.items.append(defaultItem)
        
        let linearItem = ComboBoxItem()
        linearItem.content = "Linear"
        scrollAnimationComboBox.items.append(linearItem)
        
        scrollAnimationComboBox.selectedIndex = 0
        
        controlsPanel.children.append(scrollAnimationComboBox)
        // Animation duration
        let durationLabel = TextBlock()
        durationLabel.text = "Animation duration (msec)"
        durationLabel.fontSize = 14
        durationLabel.fontWeight = FontWeights.semiBold
        durationLabel.margin = Thickness(left: 0, top: 8, right: 0, bottom: 0)
        controlsPanel.children.append(durationLabel)
        
        animationDurationSlider = Slider()
        animationDurationSlider.horizontalAlignment = .stretch
        animationDurationSlider.value = 1500
        animationDurationSlider.minimum = 0
        animationDurationSlider.maximum = 5000
        
        animationDurationSlider.valueChanged.addHandler { [weak self] sender, args in
            guard let self = self, let args = args else { return }
            self.animationDurationText.text = String(format: "%.0f", args.newValue)
        }
        
        controlsPanel.children.append(animationDurationSlider)
        
        animationDurationText = TextBlock()
        animationDurationText.text = "1500"
        animationDurationText.fontSize = 12
        animationDurationText.opacity = 0.7
        controlsPanel.children.append(animationDurationText)
        
        // Scroll button
        scrollWithAnimationButton = Button()
        scrollWithAnimationButton.content = "Scroll with animation"
        scrollWithAnimationButton.horizontalAlignment = .stretch
        scrollWithAnimationButton.padding = Thickness(left: 12, top: 8, right: 12, bottom: 8)
        scrollWithAnimationButton.margin = Thickness(left: 0, top: 16, right: 0, bottom: 0)
        
        scrollWithAnimationButton.click.addHandler { [weak self] sender, args in
            self?.performAnimatedScroll()
        }
        
        controlsPanel.children.append(scrollWithAnimationButton)
        
        return controlsPanel
    }
    
private func performAnimatedScroll() {
    // 计算目标位置：如果当前在上半部分，跳到下半部分；反之亦然
    let currentOffset = example3ScrollViewer.verticalOffset
    let maxScroll = example3ScrollViewer.scrollableHeight
    let midPoint = maxScroll / 2
    
    let targetOffset: Double
    if currentOffset < midPoint {
        // 当前在上半部分，跳到下面
        targetOffset = maxScroll
    } else {
        // 当前在下半部分，跳到上面
        targetOffset = 0
    }
    
    // 根据动画类型选择不同的滚动方式
    if scrollAnimationComboBox.selectedIndex == 0 {
        // Default: 使用 changeView（平滑动画）
        _ = try? example3ScrollViewer.changeView(nil, targetOffset, nil)
    } else {
        // Linear: 使用自定义线性动画
        performLinearScroll(to: targetOffset)
    }
}

private func performLinearScroll(to targetOffset: Double) {
    let startOffset = example3ScrollViewer.verticalOffset
    let distance = targetOffset - startOffset
    let duration = animationDurationSlider.value // 毫秒
    let steps = Int(duration / 16) // 约 60fps
    let stepDistance = distance / Double(steps)
    
    var currentStep = 0
    let timer = DispatchSource.makeTimerSource(queue: .main)
    timer.schedule(deadline: .now(), repeating: .milliseconds(16))
    
    timer.setEventHandler { [weak self] in
        guard let self = self else { return }
        
        currentStep += 1
        
        if currentStep >= steps {
            try? self.example3ScrollViewer.scrollToVerticalOffset(targetOffset)
            timer.cancel()
        } else {
            let newOffset = startOffset + stepDistance * Double(currentStep)
            try? self.example3ScrollViewer.scrollToVerticalOffset(newOffset)
        }
    }
    
    timer.resume()
}
    
    // MARK: - Source Code Sections
    private func createSourceCodeSection1() -> Border {
        let outerBorder = Border()
        outerBorder.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        outerBorder.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        outerBorder.borderBrush = createBrush(r: 200, g: 200, b: 200)
        outerBorder.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        
        let sourceCodePanel = StackPanel()
        sourceCodePanel.spacing = 8
        
        sourceCodeToggleButton1 = Button()
        sourceCodeToggleButton1.content = "▼ Source code"
        sourceCodeToggleButton1.horizontalAlignment = .left
        sourceCodeToggleButton1.padding = Thickness(left: 12, top: 8, right: 12, bottom: 8)
        sourceCodeToggleButton1.background = nil
        sourceCodeToggleButton1.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        
        sourceCodeToggleButton1.click.addHandler { [weak self] sender, args in
            self?.toggleSourceCode1()
        }
        
        sourceCodePanel.children.append(sourceCodeToggleButton1)
        
        sourceCodeContent1 = Border()
        sourceCodeContent1.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        sourceCodeContent1.cornerRadius = CornerRadius(topLeft: 4, topRight: 4, bottomRight: 4, bottomLeft: 4)
        sourceCodeContent1.visibility = .collapsed
        
        let codeText = TextBlock()
        codeText.text = """
        // Swift WinUI Code Example
        
        // Create ScrollViewer
        let scrollViewer = ScrollViewer()
        scrollViewer.width = 400
        scrollViewer.height = 400
        scrollViewer.horizontalScrollBarVisibility = .auto
        scrollViewer.verticalScrollBarVisibility = .auto
        
        // Enable zooming
        scrollViewer.zoomMode = .enabled
        scrollViewer.minZoomFactor = 0.5
        scrollViewer.maxZoomFactor = 5.0
        
        // Add content (image)
        let image = Image()
        image.width = 800
        image.height = 600
        scrollViewer.content = image
        
        // Change zoom factor
        try? scrollViewer.changeView(nil, nil, 2.0)
        
        // Configure scroll modes
        scrollViewer.horizontalScrollMode = .auto
        scrollViewer.verticalScrollMode = .enabled
        """
        codeText.fontSize = 12
        codeText.fontFamily = FontFamily("Consolas")
        codeText.textWrapping = .wrap
        
        sourceCodeContent1.child = codeText
        sourceCodePanel.children.append(sourceCodeContent1)
        
        outerBorder.child = sourceCodePanel
        
        return outerBorder
    }
    
    private func createSourceCodeSection2() -> Border {
        let outerBorder = Border()
        outerBorder.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        outerBorder.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        outerBorder.borderBrush = createBrush(r: 200, g: 200, b: 200)
        outerBorder.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        
        let sourceCodePanel = StackPanel()
        sourceCodePanel.spacing = 8
        
        sourceCodeToggleButton2 = Button()
        sourceCodeToggleButton2.content = "▼ Source code"
        sourceCodeToggleButton2.horizontalAlignment = .left
        sourceCodeToggleButton2.padding = Thickness(left: 12, top: 8, right: 12, bottom: 8)
        sourceCodeToggleButton2.background = nil
        sourceCodeToggleButton2.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        
        sourceCodeToggleButton2.click.addHandler { [weak self] sender, args in
            self?.toggleSourceCode2()
        }
        
        sourceCodePanel.children.append(sourceCodeToggleButton2)
        
        sourceCodeContent2 = Border()
        sourceCodeContent2.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        sourceCodeContent2.cornerRadius = CornerRadius(topLeft: 4, topRight: 4, bottomRight: 4, bottomLeft: 4)
        sourceCodeContent2.visibility = .collapsed
        
        let codeText = TextBlock()
        codeText.text = """
        // Swift WinUI Code Example
        
        // Create ScrollViewer
        let scrollViewer = ScrollViewer()
        scrollViewer.width = 400
        scrollViewer.height = 400
        
        // Create color blocks content
        let stackPanel = StackPanel()
        for color in colors {
            let colorBorder = Border()
            colorBorder.height = 200
            colorBorder.background = createBrush(color)
            stackPanel.children.append(colorBorder)
        }
        scrollViewer.content = stackPanel
        
        // Auto-scrolling with timer
        var currentVelocity: Double = 50.0
        let timer = DispatchSource.makeTimerSource(queue: .main)
        timer.schedule(deadline: .now(), repeating: .milliseconds(50))
        
        timer.setEventHandler {
            if abs(currentVelocity) > 30 {
                let newOffset = scrollViewer.verticalOffset + currentVelocity * 0.5
                try? scrollViewer.scrollToVerticalOffset(newOffset)
            }
        }
        timer.resume()
        """
        codeText.fontSize = 12
        codeText.fontFamily = FontFamily("Consolas")
        codeText.textWrapping = .wrap
        
        sourceCodeContent2.child = codeText
        sourceCodePanel.children.append(sourceCodeContent2)
        
        outerBorder.child = sourceCodePanel
        
        return outerBorder
    }
    
    private func createSourceCodeSection3() -> Border {
        let outerBorder = Border()
        outerBorder.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        outerBorder.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        outerBorder.borderBrush = createBrush(r: 200, g: 200, b: 200)
        outerBorder.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        
        let sourceCodePanel = StackPanel()
        sourceCodePanel.spacing = 8
        
        sourceCodeToggleButton3 = Button()
        sourceCodeToggleButton3.content = "▼ Source code"
        sourceCodeToggleButton3.horizontalAlignment = .left
        sourceCodeToggleButton3.padding = Thickness(left: 12, top: 8, right: 12, bottom: 8)
        sourceCodeToggleButton3.background = nil
        sourceCodeToggleButton3.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        
        sourceCodeToggleButton3.click.addHandler { [weak self] sender, args in
            self?.toggleSourceCode3()
        }
        
        sourceCodePanel.children.append(sourceCodeToggleButton3)
        
        sourceCodeContent3 = Border()
        sourceCodeContent3.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        sourceCodeContent3.cornerRadius = CornerRadius(topLeft: 4, topRight: 4, bottomRight: 4, bottomLeft: 4)
        sourceCodeContent3.visibility = .collapsed
        
        let codeText = TextBlock()
codeText.text = """
// Swift WinUI Code Example

// Create ScrollViewer
let scrollViewer = ScrollViewer()
scrollViewer.width = 400
scrollViewer.height = 400

// Create color blocks content
let stackPanel = StackPanel()
for color in colors {
    let colorBorder = Border()
    colorBorder.height = 200
    colorBorder.background = createBrush(color)
    stackPanel.children.append(colorBorder)
}
scrollViewer.content = stackPanel

// Programmatic scroll with animation
let currentOffset = scrollViewer.verticalOffset
let maxScroll = scrollViewer.scrollableHeight
let midPoint = maxScroll / 2

let targetOffset = currentOffset < midPoint ? maxScroll : 0

// Default animation: smooth
try? scrollViewer.changeView(nil, targetOffset, nil)

// Linear animation: custom with timer
let duration = 1500.0 // milliseconds
let steps = Int(duration / 16)
// ... implement linear animation with timer
"""
        codeText.fontSize = 12
        codeText.fontFamily = FontFamily("Consolas")
        codeText.textWrapping = .wrap
        
        sourceCodeContent3.child = codeText
        sourceCodePanel.children.append(sourceCodeContent3)
        
        outerBorder.child = sourceCodePanel
        
        return outerBorder
    }
    
    private func toggleSourceCode1() {
        isSourceCodeVisible1 = !isSourceCodeVisible1
        
        if isSourceCodeVisible1 {
            sourceCodeContent1.visibility = .visible
            sourceCodeToggleButton1.content = "▲ Source code"
        } else {
            sourceCodeContent1.visibility = .collapsed
            sourceCodeToggleButton1.content = "▼ Source code"
        }
    }
    
    private func toggleSourceCode2() {
        isSourceCodeVisible2 = !isSourceCodeVisible2
        
        if isSourceCodeVisible2 {
            sourceCodeContent2.visibility = .visible
            sourceCodeToggleButton2.content = "▲ Source code"
        } else {
            sourceCodeContent2.visibility = .collapsed
            sourceCodeToggleButton2.content = "▼ Source code"
        }
    }
    
    private func toggleSourceCode3() {
        isSourceCodeVisible3 = !isSourceCodeVisible3
        
        if isSourceCodeVisible3 {
            sourceCodeContent3.visibility = .visible
            sourceCodeToggleButton3.content = "▲ Source code"
        } else {
            sourceCodeContent3.visibility = .collapsed
            sourceCodeToggleButton3.content = "▼ Source code"
        }
    }
    
    // MARK: - Helper Methods
    private func createBrush(r: UInt8, g: UInt8, b: UInt8, a: UInt8 = 255) -> SolidColorBrush {
        let brush = SolidColorBrush()
        var color = UWP.Color()
        color.a = a
        color.r = r
        color.g = g
        color.b = b
        brush.color = color
        return brush
    }
}