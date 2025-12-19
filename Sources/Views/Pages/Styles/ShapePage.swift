import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

// WinUI 3 Gallery - Shape(s)
//
// IMPORTANT for this Swift/WinRT projection:
// - Microsoft.UI.Xaml.Shapes.Polygon wrapper is NOT generated (you only have Ellipse/Rectangle/Path/Shape).
// - So the "Polygon" demo is implemented using a Path with equivalent geometry data,
//   plus optional point markers (Ellipses) on a Canvas.
//
// This file matches the screenshots: Ellipse + Rectangle + Polygon sections,
// each with a preview area, a right-side control panel, and a "Source code" expander.

final class ShapePage: Grid {

    private var mainScrollViewer: ScrollViewer!
    private var contentStackPanel: StackPanel!

    // Demo elements updated from sliders/toggles
    private var ellipseShape: Ellipse?
    private var rectangleShape: Rectangle?
    private var polygonPath: Path?
    private var polygonPointMarkers: [Ellipse] = []

    override init() {
        super.init()
        setupUI()
    }

    private func setupUI() {
        mainScrollViewer = ScrollViewer()
        mainScrollViewer.horizontalScrollBarVisibility = .disabled
        mainScrollViewer.verticalScrollBarVisibility = .auto

        contentStackPanel = StackPanel()
        contentStackPanel.padding = Thickness(left: 40, top: 24, right: 40, bottom: 40)
        contentStackPanel.spacing = 20

        contentStackPanel.children.append(createHeader())

        let desc = TextBlock()
        desc.text = "Basic shapes are intended for decorative rendering or for compositing non-interactive parts of controls."
        desc.textWrapping = .wrap
        desc.opacity = 0.85
        contentStackPanel.children.append(desc)

        // Ellipse
        contentStackPanel.children.append(sectionTitle("Ellipse"))
        contentStackPanel.children.append(createEllipseCard())
        contentStackPanel.children.append(makeSourceCodeSection(tabs: [("XAML", ellipseXamlSource())]))

        // Rectangle
        contentStackPanel.children.append(sectionTitle("Rectangle"))
        contentStackPanel.children.append(createRectangleCard())
        contentStackPanel.children.append(makeSourceCodeSection(tabs: [("XAML", rectangleXamlSource())]))

        // Polygon (implemented with Path)
        contentStackPanel.children.append(sectionTitle("Polygon"))
        contentStackPanel.children.append(createPolygonCard())
        contentStackPanel.children.append(makeSourceCodeSection(tabs: [("XAML", polygonXamlSource())]))

        mainScrollViewer.content = contentStackPanel
        children.append(mainScrollViewer)
    }

    // MARK: - Header

    private func createHeader() -> StackPanel {
        let header = StackPanel()
        header.spacing = 10

        let titleRow = StackPanel()
        titleRow.orientation = .horizontal
        titleRow.spacing = 10

        let title = TextBlock()
        title.text = "Shape"
        title.fontSize = 32
        title.fontWeight = FontWeights.semiBold
        titleRow.children.append(title)

        let info = TextBlock()
        info.text = "ⓘ"
        info.fontSize = 14
        info.opacity = 0.6
        info.verticalAlignment = .center
        titleRow.children.append(info)

        header.children.append(titleRow)

        let tabs = StackPanel()
        tabs.orientation = .horizontal
        tabs.spacing = 16

        let doc = TextBlock()
        doc.text = "Documentation"
        doc.fontSize = 14
        doc.fontWeight = FontWeights.semiBold
        doc.foreground = createBrush(r: 0, g: 120, b: 215)
        doc.padding = Thickness(left: 12, top: 6, right: 12, bottom: 6)
        tabs.children.append(doc)

        let src = TextBlock()
        src.text = "Source"
        src.fontSize = 14
        src.opacity = 0.6
        src.padding = Thickness(left: 12, top: 6, right: 12, bottom: 6)
        tabs.children.append(src)

        header.children.append(tabs)
        return header
    }

    private func sectionTitle(_ text: String) -> TextBlock {
        let tb = TextBlock()
        tb.text = text
        tb.fontSize = 16
        tb.fontWeight = FontWeights.semiBold
        tb.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)
        return tb
    }

    // MARK: - Cards

    private func createEllipseCard() -> Border {
        let outer = createCardBorder(padding: Thickness(left: 0, top: 0, right: 0, bottom: 0))
        let grid = twoPaneGrid(rightWidth: 280)

        // Left preview
        let leftHost = Border()
        leftHost.background = createBrushHex("#202020")
        leftHost.padding = Thickness(left: 24, top: 24, right: 24, bottom: 24)
        leftHost.minHeight = 220

        let leftInner = Grid()
        let ellipse = Ellipse()
        ellipse.width = 100
        ellipse.height = 100
        ellipse.fill = createBrushHex("#4682B4") // SteelBlue
        ellipse.stroke = createBrushHex("#000000")
        ellipse.strokeThickness = 2
        ellipse.horizontalAlignment = .left
        ellipse.verticalAlignment = .top
        ellipse.margin = Thickness(left: 24, top: 24, right: 0, bottom: 0)
        self.ellipseShape = ellipse

        leftInner.children.append(ellipse)
        leftHost.child = leftInner
        try? Grid.setColumn(leftHost, 0)
        grid.children.append(leftHost)

        // Right controls
        let controls = createControlsHost()

        let stack = StackPanel()
        stack.spacing = 10

        // Height
        stack.children.append(controlLabel("Height"))
        let heightSlider = Slider()
        heightSlider.minimum = 20
        heightSlider.maximum = 200
        heightSlider.value = 100
        heightSlider.valueChanged.addHandler { [weak self] _, args in
            guard let self = self, let args = args else { return }
            self.ellipseShape?.height = args.newValue
        }
        stack.children.append(heightSlider)

        // Width
        stack.children.append(controlLabel("Width"))
        let widthSlider = Slider()
        widthSlider.minimum = 20
        widthSlider.maximum = 200
        widthSlider.value = 100
        widthSlider.valueChanged.addHandler { [weak self] _, args in
            guard let self = self, let args = args else { return }
            self.ellipseShape?.width = args.newValue
        }
        stack.children.append(widthSlider)

        // Stroke thickness
        stack.children.append(controlLabel("Stroke Thickness"))
        let strokeSlider = Slider()
        strokeSlider.minimum = 0
        strokeSlider.maximum = 10
        strokeSlider.value = 2
        strokeSlider.valueChanged.addHandler { [weak self] _, args in
            guard let self = self, let args = args else { return }
            self.ellipseShape?.strokeThickness = args.newValue
        }
        stack.children.append(strokeSlider)

        controls.child = stack
        try? Grid.setColumn(controls, 1)
        grid.children.append(controls)

        outer.child = grid
        return outer
    }

    private func createRectangleCard() -> Border {
        let outer = createCardBorder(padding: Thickness(left: 0, top: 0, right: 0, bottom: 0))
        let grid = twoPaneGrid(rightWidth: 280)

        // Left preview
        let leftHost = Border()
        leftHost.background = createBrushHex("#202020")
        leftHost.padding = Thickness(left: 24, top: 24, right: 24, bottom: 24)
        leftHost.minHeight = 220

        let leftInner = Grid()
        let rect = Rectangle()
        rect.width = 100
        rect.height = 100
        rect.radiusX = 0
        rect.radiusY = 0
        rect.fill = createBrushHex("#4682B4")
        rect.stroke = createBrushHex("#000000")
        rect.strokeThickness = 2
        rect.horizontalAlignment = .left
        rect.verticalAlignment = .top
        rect.margin = Thickness(left: 24, top: 24, right: 0, bottom: 0)
        self.rectangleShape = rect

        leftInner.children.append(rect)
        leftHost.child = leftInner
        try? Grid.setColumn(leftHost, 0)
        grid.children.append(leftHost)

        // Right controls
        let controls = createControlsHost()
        let stack = StackPanel()
        stack.spacing = 10

        // Height
        stack.children.append(controlLabel("Height"))
        let heightSlider = Slider()
        heightSlider.minimum = 20
        heightSlider.maximum = 200
        heightSlider.value = 100
        heightSlider.valueChanged.addHandler { [weak self] _, args in
            guard let self = self, let args = args else { return }
            self.rectangleShape?.height = args.newValue
        }
        stack.children.append(heightSlider)

        // Width
        stack.children.append(controlLabel("Width"))
        let widthSlider = Slider()
        widthSlider.minimum = 20
        widthSlider.maximum = 200
        widthSlider.value = 100
        widthSlider.valueChanged.addHandler { [weak self] _, args in
            guard let self = self, let args = args else { return }
            self.rectangleShape?.width = args.newValue
        }
        stack.children.append(widthSlider)

        // Stroke thickness
        stack.children.append(controlLabel("Stroke Thickness"))
        let strokeSlider = Slider()
        strokeSlider.minimum = 0
        strokeSlider.maximum = 10
        strokeSlider.value = 2
        strokeSlider.valueChanged.addHandler { [weak self] _, args in
            guard let self = self, let args = args else { return }
            self.rectangleShape?.strokeThickness = args.newValue
        }
        stack.children.append(strokeSlider)

        // Radius Y
        stack.children.append(controlLabel("Radius Y"))
        let radiusYSlider = Slider()
        radiusYSlider.minimum = 0
        radiusYSlider.maximum = 50
        radiusYSlider.value = 0
        radiusYSlider.valueChanged.addHandler { [weak self] _, args in
            guard let self = self, let args = args else { return }
            self.rectangleShape?.radiusY = args.newValue
        }
        stack.children.append(radiusYSlider)

        // Radius X
        stack.children.append(controlLabel("Radius X"))
        let radiusXSlider = Slider()
        radiusXSlider.minimum = 0
        radiusXSlider.maximum = 50
        radiusXSlider.value = 0
        radiusXSlider.valueChanged.addHandler { [weak self] _, args in
            guard let self = self, let args = args else { return }
            self.rectangleShape?.radiusX = args.newValue
        }
        stack.children.append(radiusXSlider)

        controls.child = stack
        try? Grid.setColumn(controls, 1)
        grid.children.append(controls)

        outer.child = grid
        return outer
    }

    private func createPolygonCard() -> Border {
        let outer = createCardBorder(padding: Thickness(left: 0, top: 0, right: 0, bottom: 0))
        let grid = twoPaneGrid(rightWidth: 280)

        // Left preview
        let leftHost = Border()
        leftHost.background = createBrushHex("#202020")
        leftHost.padding = Thickness(left: 24, top: 24, right: 24, bottom: 24)
        leftHost.minHeight = 220

        let canvas = Canvas()
        canvas.width = 320
        canvas.height = 160

        // Equivalent to Polygon Points="10,100 60,40 200,40 250,100"
        // using Path Data.
        let pathXaml = """
<Path xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
      Fill="SteelBlue"
      Stroke="Black"
      StrokeThickness="2"
      Data="M10,100 L60,40 L200,40 L250,100 Z"/>
"""
        if let p = try? XamlReader.load(pathXaml) as? Path {
            polygonPath = p
            canvas.children.append(p)
        }

        // Point markers (hidden by default)
        let pts: [(Double, Double)] = [(10, 100), (60, 40), (200, 40), (250, 100)]
        polygonPointMarkers = pts.map { (x, y) in
            let dot = Ellipse()
            dot.width = 8
            dot.height = 8
            dot.fill = createBrush(r: 0, g: 120, b: 215)
            dot.stroke = createBrushHex("#000000")
            dot.strokeThickness = 1
            dot.visibility = .collapsed
            try? Canvas.setLeft(dot, x - 4)
            try? Canvas.setTop(dot, y - 4)
            canvas.children.append(dot)
            return dot
        }

        leftHost.child = canvas
        try? Grid.setColumn(leftHost, 0)
        grid.children.append(leftHost)

        // Right controls
        let controls = createControlsHost()
        let stack = StackPanel()
        stack.spacing = 10

        let showLabel = controlLabel("Show points")
        stack.children.append(showLabel)

        let toggle = ToggleSwitch()
        toggle.offContent = "Off"
        toggle.onContent = "On"
        toggle.isOn = false
        toggle.toggled.addHandler { [weak self] _, _ in
            guard let self = self else { return }
            let show = toggle.isOn
            for m in self.polygonPointMarkers {
                m.visibility = show ? .visible : .collapsed
            }
        }
        stack.children.append(toggle)

        stack.children.append(controlLabel("Stroke Thickness"))
        let strokeSlider = Slider()
        strokeSlider.minimum = 0
        strokeSlider.maximum = 10
        strokeSlider.value = 2
        strokeSlider.valueChanged.addHandler { [weak self] _, args in
            guard let self = self, let args = args else { return }
            self.polygonPath?.strokeThickness = args.newValue
        }
        stack.children.append(strokeSlider)

        controls.child = stack
        try? Grid.setColumn(controls, 1)
        grid.children.append(controls)

        outer.child = grid
        return outer
    }

    // MARK: - Layout helpers

    private func twoPaneGrid(rightWidth: Double) -> Grid {
        let grid = Grid()

        let c0 = ColumnDefinition()
        c0.width = GridLength(value: 1, gridUnitType: .star)
        grid.columnDefinitions.append(c0)

        let c1 = ColumnDefinition()
        c1.width = GridLength(value: rightWidth, gridUnitType: .pixel)
        grid.columnDefinitions.append(c1)

        return grid
    }

    private func createControlsHost() -> Border {
        let controls = Border()
        controls.background = createBrushHex("#2B2B2B")
        controls.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        return controls
    }

    private func controlLabel(_ text: String) -> TextBlock {
        let tb = TextBlock()
        tb.text = text
        tb.fontSize = 14
        tb.fontWeight = FontWeights.semiBold
        return tb
    }

    // MARK: - Source code (expander-like)

    private func makeSourceCodeSection(tabs: [(String, String)]) -> Border {
        let outer = Border()
        outer.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        outer.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        outer.borderBrush = createBrush(r: 200, g: 200, b: 200)
        outer.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)

        let panel = StackPanel()
        panel.spacing = 8

        let toggle = Button()
        toggle.content = "▼ Source code"
        toggle.horizontalAlignment = .left
        toggle.padding = Thickness(left: 12, top: 8, right: 12, bottom: 8)
        toggle.background = nil
        toggle.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)

        let contentBorder = Border()
        contentBorder.padding = Thickness(left: 0, top: 8, right: 0, bottom: 0)
        contentBorder.visibility = .collapsed

        let tabView = TabView()
        tabView.tabWidthMode = .sizeToContent
        tabView.isAddTabButtonVisible = false
        tabView.canReorderTabs = false

        for (header, code) in tabs {
            let item = TabViewItem()
            item.header = header
            item.isClosable = false

            let tb = TextBox()
            tb.isReadOnly = true
            tb.acceptsReturn = true
            tb.textWrapping = .noWrap
            tb.fontFamily = FontFamily("Cascadia Code, Consolas, monospace")
            tb.fontSize = 12
            tb.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
            tb.background = nil
            tb.text = code

            item.content = tb
            tabView.tabItems.append(item)
        }

        contentBorder.child = tabView

        var visible = false
        toggle.click.addHandler { _, _ in
            visible.toggle()
            contentBorder.visibility = visible ? .visible : .collapsed
            toggle.content = visible ? "▲ Source code" : "▼ Source code"
        }

        panel.children.append(toggle)
        panel.children.append(contentBorder)
        outer.child = panel
        return outer
    }

    // MARK: - Card visuals

    private func createCardBorder(padding: Thickness = Thickness(left: 24, top: 24, right: 24, bottom: 24)) -> Border {
        let border = Border()
        border.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = createBrush(r: 200, g: 200, b: 200)
        border.padding = padding
        return border
    }

    // MARK: - Brushes

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

    private func createBrushHex(_ hex: String) -> SolidColorBrush {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("#") { s.removeFirst() }
        if s.count == 3 { s = s.map { "\($0)\($0)" }.joined() }

        func u8(_ i: Int) -> UInt8 {
            let start = s.index(s.startIndex, offsetBy: i)
            let end = s.index(start, offsetBy: 2)
            let part = String(s[start..<end])
            return UInt8(part, radix: 16) ?? 0
        }

        if s.count == 6 {
            return createBrush(r: u8(0), g: u8(2), b: u8(4), a: 255)
        } else if s.count == 8 {
            return createBrush(r: u8(2), g: u8(4), b: u8(6), a: u8(0))
        } else {
            return createBrush(r: 0, g: 0, b: 0, a: 0)
        }
    }

    // MARK: - Source strings

    private func ellipseXamlSource() -> String {
        #"<Ellipse Fill="SteelBlue" Height="100" Width="100" StrokeThickness="2" Stroke="Black"/>"#
    }

    private func rectangleXamlSource() -> String {
        """
<Rectangle Fill="SteelBlue" Height="100" Width="100"
           Stroke="Black" StrokeThickness="2"
           RadiusY="0" RadiusX="0"/>
"""
    }

    private func polygonXamlSource() -> String {
        // Keep the original WinUI Gallery snippet (even though we render it with Path in Swift).
        """
<Polygon Fill="SteelBlue" Points="10,100 60,40 200,40 250,100"
         StrokeThickness="2" Stroke="Black"/>
"""
    }
}
