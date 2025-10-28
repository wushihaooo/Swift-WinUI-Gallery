import WinUI
import WinAppSDK
import Foundation
import UWP

class PipsPagerPage: Grid {
    // MARK: - Properties
    private var mainScrollViewer: ScrollViewer!
    private var contentStackPanel: StackPanel!
    
    // Example 1
    private var flipView: FlipView!
    private var pipsPager1: PipsPager!
    
    // Example 2
    private var pipsPager2: PipsPager!
    private var orientationComboBox: ComboBox!
    private var previousButtonComboBox: ComboBox!
    private var nextButtonComboBox: ComboBox!
    
    private var sourceCodeToggleButton1: Button!
    private var sourceCodeContent1: Border!
    private var isSourceCodeVisible1 = false
    
    private var sourceCodeToggleButton2: Button!
    private var sourceCodeContent2: Border!
    private var isSourceCodeVisible2 = false
    
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
        
        mainScrollViewer.content = contentStackPanel
        self.children.append(mainScrollViewer)
    }
    
    private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 12
        
        let titleText = TextBlock()
        titleText.text = "PipsPager"
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
        descText.text = "The PipsPager control provides a visualization for navigating through a paginated collection."
        descText.fontSize = 14
        descText.textWrapping = .wrap
        descText.opacity = 0.8
        return descText
    }
    
    // MARK: - Example 1: Gallery with FlipView (8 pages)
    private func createExample1() -> StackPanel {
        let examplePanel = StackPanel()
        examplePanel.spacing = 12
        
        let titleText = TextBlock()
        titleText.text = "PipsPager in a gallery"
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
        
        let contentPanel = StackPanel()
        contentPanel.spacing = 16
        contentPanel.horizontalAlignment = .center
        
        // FlipView with 8 pages
        flipView = FlipView()
        flipView.width = 400
        flipView.height = 270
        
        // Create 8 items for FlipView
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
        
        for i in 0..<8 {
            let itemBorder = Border()
            itemBorder.cornerRadius = CornerRadius(topLeft: 4, topRight: 4, bottomRight: 4, bottomLeft: 4)
            
            let brush = SolidColorBrush()
            var color = UWP.Color()
            color.a = 255
            color.r = colors[i].r
            color.g = colors[i].g
            color.b = colors[i].b
            
            brush.color = color
            itemBorder.background = brush
            
            let pageText = TextBlock()
            pageText.text = "Page \(i + 1)"
            pageText.fontSize = 24
            pageText.fontWeight = FontWeights.semiBold
            pageText.horizontalAlignment = .center
            pageText.verticalAlignment = .center
            
            itemBorder.child = pageText
            
            flipView.items.append(itemBorder)
        }
        
        contentPanel.children.append(flipView)
        
        // PipsPager with 8 pages
        pipsPager1 = PipsPager()
        pipsPager1.numberOfPages = 8
        pipsPager1.horizontalAlignment = .center
        
        // Sync PipsPager with FlipView
        flipView.selectionChanged.addHandler { [weak self] sender, args in
            guard let self = self else { return }
            self.pipsPager1.selectedPageIndex = self.flipView.selectedIndex
        }
        
        pipsPager1.selectedIndexChanged.addHandler { [weak self] sender, args in
            guard let self = self else { return }
            self.flipView.selectedIndex = self.pipsPager1.selectedPageIndex
        }
        
        contentPanel.children.append(pipsPager1)
        
        demoBorder.child = contentPanel
        return demoBorder
    }
    
    // MARK: - Example 2: Configurable PipsPager
    private func createExample2() -> StackPanel {
        let examplePanel = StackPanel()
        examplePanel.spacing = 12
        
        let titleText = TextBlock()
        titleText.text = "PipsPager with options to change its orientation and button visibility."
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
        
        let mainGrid = Grid()
        
        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 1, gridUnitType: .star)
        mainGrid.columnDefinitions.append(col1)
        
        let col2 = ColumnDefinition()
        col2.width = GridLength(value: 300, gridUnitType: .pixel)
        mainGrid.columnDefinitions.append(col2)
        
        // Left: PipsPager demo
        let leftPanel = StackPanel()
        leftPanel.verticalAlignment = .center
        leftPanel.horizontalAlignment = .center
        
        pipsPager2 = PipsPager()
        pipsPager2.numberOfPages = 5
        pipsPager2.selectedPageIndex = 0
        pipsPager2.orientation = .horizontal // 默认横排
        pipsPager2.previousButtonVisibility = .visible // 默认可见
        pipsPager2.nextButtonVisibility = .visible // 默认可见
        
        leftPanel.children.append(pipsPager2)
        
        try? Grid.setColumn(leftPanel, 0)
        mainGrid.children.append(leftPanel)
        
        // Right: Controls
        let controlsPanel = createExample2Controls()
        try? Grid.setColumn(controlsPanel, 1)
        mainGrid.children.append(controlsPanel)
        
        demoBorder.child = mainGrid
        return demoBorder
    }
    
    private func createExample2Controls() -> StackPanel {
        let controlsPanel = StackPanel()
        controlsPanel.spacing = 16
        
        // Orientation
        let orientationLabel = TextBlock()
        orientationLabel.text = "Orientation"
        orientationLabel.fontSize = 14
        orientationLabel.fontWeight = FontWeights.semiBold
        controlsPanel.children.append(orientationLabel)
        
        orientationComboBox = ComboBox()
        orientationComboBox.horizontalAlignment = .stretch
        
        let horizontalItem = ComboBoxItem()
        horizontalItem.content = "Horizontal"
        orientationComboBox.items.append(horizontalItem)
        
        let verticalItem = ComboBoxItem()
        verticalItem.content = "Vertical"
        orientationComboBox.items.append(verticalItem)
        
        orientationComboBox.selectedIndex = 0 // Horizontal by default
        
        orientationComboBox.selectionChanged.addHandler { [weak self] sender, args in
            guard let self = self else { return }
            if self.orientationComboBox.selectedIndex == 0 {
                self.pipsPager2.orientation = .horizontal
            } else {
                self.pipsPager2.orientation = .vertical
            }
        }
        
        controlsPanel.children.append(orientationComboBox)
        
        // Previous Button Visibility
        let prevButtonLabel = TextBlock()
        prevButtonLabel.text = "Previous Button Visibility"
        prevButtonLabel.fontSize = 14
        prevButtonLabel.fontWeight = FontWeights.semiBold
        prevButtonLabel.margin = Thickness(left: 0, top: 8, right: 0, bottom: 0)
        controlsPanel.children.append(prevButtonLabel)
        
        previousButtonComboBox = ComboBox()
        previousButtonComboBox.horizontalAlignment = .stretch
        
        let prevVisible = ComboBoxItem()
        prevVisible.content = "Visible"
        previousButtonComboBox.items.append(prevVisible)
        
        let prevVisibleOnPointerOver = ComboBoxItem()
        prevVisibleOnPointerOver.content = "VisibleOnPointerOver"
        previousButtonComboBox.items.append(prevVisibleOnPointerOver)
        
        let prevCollapsed = ComboBoxItem()
        prevCollapsed.content = "Collapsed"
        previousButtonComboBox.items.append(prevCollapsed)
        
        previousButtonComboBox.selectedIndex = 0 // Visible by default
        
        previousButtonComboBox.selectionChanged.addHandler { [weak self] sender, args in
            guard let self = self else { return }
            switch self.previousButtonComboBox.selectedIndex {
            case 0:
                self.pipsPager2.previousButtonVisibility = .visible
            case 1:
                self.pipsPager2.previousButtonVisibility = .visibleOnPointerOver
            case 2:
                self.pipsPager2.previousButtonVisibility = .collapsed
            default:
                break
            }
        }
        
        controlsPanel.children.append(previousButtonComboBox)
        
        // Next Button Visibility
        let nextButtonLabel = TextBlock()
        nextButtonLabel.text = "Next Button Visibility"
        nextButtonLabel.fontSize = 14
        nextButtonLabel.fontWeight = FontWeights.semiBold
        nextButtonLabel.margin = Thickness(left: 0, top: 8, right: 0, bottom: 0)
        controlsPanel.children.append(nextButtonLabel)
        
        nextButtonComboBox = ComboBox()
        nextButtonComboBox.horizontalAlignment = .stretch
        
        let nextVisible = ComboBoxItem()
        nextVisible.content = "Visible"
        nextButtonComboBox.items.append(nextVisible)
        
        let nextVisibleOnPointerOver = ComboBoxItem()
        nextVisibleOnPointerOver.content = "VisibleOnPointerOver"
        nextButtonComboBox.items.append(nextVisibleOnPointerOver)
        
        let nextCollapsed = ComboBoxItem()
        nextCollapsed.content = "Collapsed"
        nextButtonComboBox.items.append(nextCollapsed)
        
        nextButtonComboBox.selectedIndex = 0 // Visible by default
        
        nextButtonComboBox.selectionChanged.addHandler { [weak self] sender, args in
            guard let self = self else { return }
            switch self.nextButtonComboBox.selectedIndex {
            case 0:
                self.pipsPager2.nextButtonVisibility = .visible
            case 1:
                self.pipsPager2.nextButtonVisibility = .visibleOnPointerOver
            case 2:
                self.pipsPager2.nextButtonVisibility = .collapsed
            default:
                break
            }
        }
        
        controlsPanel.children.append(nextButtonComboBox)
        
        return controlsPanel
    }
    
    // MARK: - Source Code Section 1 (Example 1)
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
        
        // Create FlipView with 8 pages
        let flipView = FlipView()
        flipView.width = 400
        flipView.height = 270
        
        for i in 0..<8 {
            let page = Border()
            page.background = createColorBrush(...)
            page.child = TextBlock(text: "Page \\(i + 1)")
            flipView.items.append(page)
        }
        
        // Create PipsPager with 8 pages
        let pipsPager = PipsPager()
        pipsPager.numberOfPages = 8
        
        // Sync FlipView with PipsPager
        flipView.selectionChanged.addHandler { sender, args in
            pipsPager.selectedPageIndex = flipView.selectedIndex
        }
        
        pipsPager.selectedIndexChanged.addHandler { sender, args in
            flipView.selectedIndex = pipsPager.selectedPageIndex
        }
        """
        codeText.fontSize = 12
        codeText.fontFamily = FontFamily("Consolas")
        codeText.textWrapping = .wrap
        
        sourceCodeContent1.child = codeText
        sourceCodePanel.children.append(sourceCodeContent1)
        
        outerBorder.child = sourceCodePanel
        
        return outerBorder
    }
    
    // MARK: - Source Code Section 2 (Example 2)
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
        
        // Create PipsPager
        let pipsPager = PipsPager()
        pipsPager.numberOfPages = 5
        pipsPager.selectedPageIndex = 0
        
        // Configure orientation
        pipsPager.orientation = .horizontal  // or .vertical
        
        // Configure button visibility
        pipsPager.previousButtonVisibility = .visible
        // Options: .visible, .visibleOnPointerOver, .collapsed
        
        pipsPager.nextButtonVisibility = .visible
        // Options: .visible, .visibleOnPointerOver, .collapsed
        
        // Handle page changes
        pipsPager.selectedIndexChanged.addHandler { sender, args in
            print("Current page: \\(pipsPager.selectedPageIndex)")
        }
        """
        codeText.fontSize = 12
        codeText.fontFamily = FontFamily("Consolas")
        codeText.textWrapping = .wrap
        
        sourceCodeContent2.child = codeText
        sourceCodePanel.children.append(sourceCodeContent2)
        
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