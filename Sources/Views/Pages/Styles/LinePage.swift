import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

// ✅ 文件名请用：Shapes_LinePage.swift（避免 SwiftPM Windows 下同名 .o 冲突）
final class LinePage: Grid {

    // MARK: - UI
    private var mainScrollViewer: ScrollViewer!
    private var contentStack: StackPanel!

    // MARK: - Line state
    private var lineX1: Double = 40
    private var lineY1: Double = 80
    private var lineX2: Double = 320
    private var lineY2: Double = 80
    private var lineThickness: Double = 5

    private var linePreviewHost: Grid!
    private var lineX1Value: TextBlock!
    private var lineY1Value: TextBlock!
    private var lineX2Value: TextBlock!
    private var lineY2Value: TextBlock!
    private var lineThValue: TextBlock!

    // MARK: - Polyline state
    private var polyShowPoints: Bool = false
    private var polyThickness: Double = 2
    private var polyPreviewHost: Grid!
    private var polyThicknessValue: TextBlock!

    // MARK: - Path state
    private var pathShowPoints: Bool = false
    private var pathThickness: Double = 2
    private var pathPreviewHost: Grid!
    private var pathThicknessValue: TextBlock!

    // MARK: - GeometryGroup state
    private var geoRadiusX: Double = 30
    private var geoRadiusY: Double = 30
    private var geoPreviewHost: Grid!
    private var geoRadiusXValue: TextBlock!
    private var geoRadiusYValue: TextBlock!

    override init() {
        super.init()
        buildUI()
        refreshAllPreviews()
    }

    // MARK: - Build UI

    private func buildUI() {
        mainScrollViewer = ScrollViewer()
        mainScrollViewer.verticalScrollBarVisibility = .auto
        mainScrollViewer.horizontalScrollBarVisibility = .disabled

        contentStack = StackPanel()
        contentStack.padding = Thickness(left: 40, top: 24, right: 40, bottom: 40)
        contentStack.spacing = 18

        contentStack.children.append(makeHeader())
        contentStack.children.append(makeDescription())

        // Sections
        contentStack.children.append(makeSectionTitle("Line"))
        contentStack.children.append(makeLineCard())

        contentStack.children.append(makeSectionTitle("Polyline"))
        contentStack.children.append(makePolylineCard())

        contentStack.children.append(makeSectionTitle("Path"))
        contentStack.children.append(makePathCard())

        contentStack.children.append(makeSectionTitle("GeometryGroup"))
        contentStack.children.append(makeGeometryGroupCard())

        mainScrollViewer.content = contentStack
        children.append(mainScrollViewer)
    }

    private func makeHeader() -> StackPanel {
        let header = StackPanel()
        header.spacing = 10

        let titleRow = StackPanel()
        titleRow.orientation = .horizontal
        titleRow.spacing = 10

        let title = TextBlock()
        title.text = "Line"
        title.fontSize = 32
        title.fontWeight = FontWeights.semiBold
        titleRow.children.append(title)

        header.children.append(titleRow)

        // “Documentation / Source” 只是视觉占位（不做跳转）
        let tabs = StackPanel()
        tabs.orientation = .horizontal
        tabs.spacing = 14

        let doc = Border()
        doc.cornerRadius = CornerRadius(topLeft: 6, topRight: 6, bottomRight: 6, bottomLeft: 6)
        doc.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        doc.borderBrush = createBrushGray(90)
        doc.padding = Thickness(left: 12, top: 6, right: 12, bottom: 6)

        let docText = TextBlock()
        docText.text = "Documentation"
        docText.fontSize = 13
        docText.fontWeight = FontWeights.semiBold
        docText.foreground = createBrush(r: 0, g: 120, b: 215)
        doc.child = docText

        let src = Border()
        src.cornerRadius = CornerRadius(topLeft: 6, topRight: 6, bottomRight: 6, bottomLeft: 6)
        src.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        src.borderBrush = createBrushGray(90)
        src.padding = Thickness(left: 12, top: 6, right: 12, bottom: 6)

        let srcText = TextBlock()
        srcText.text = "Source"
        srcText.fontSize = 13
        srcText.opacity = 0.8
        src.child = srcText

        tabs.children.append(doc)
        tabs.children.append(src)

        header.children.append(tabs)
        return header
    }

    private func makeDescription() -> TextBlock {
        let tb = TextBlock()
        tb.text = "Draws a straight line between two points."
        tb.fontSize = 14
        tb.opacity = 0.85
        tb.textWrapping = .wrap
        return tb
    }

    private func makeSectionTitle(_ text: String) -> TextBlock {
        let tb = TextBlock()
        tb.text = text
        tb.fontSize = 16
        tb.fontWeight = FontWeights.semiBold
        tb.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)
        return tb
    }

    // MARK: - Cards

    private func makeLineCard() -> Border {
        linePreviewHost = Grid()
        linePreviewHost.height = 220

        let controls = makeControlsPanel(width: 300)

        controls.children.append(makeSliderRow(
            title: "Start point X",
            min: 0, max: 520, value: lineX1,
            valueTextOut: { self.lineX1Value = $0 }
        ) { [weak self] v in self?.lineX1 = v; self?.updateLinePreview() })

        controls.children.append(makeSliderRow(
            title: "Start point Y",
            min: 0, max: 200, value: lineY1,
            valueTextOut: { self.lineY1Value = $0 }
        ) { [weak self] v in self?.lineY1 = v; self?.updateLinePreview() })

        controls.children.append(makeSliderRow(
            title: "End point X",
            min: 0, max: 520, value: lineX2,
            valueTextOut: { self.lineX2Value = $0 }
        ) { [weak self] v in self?.lineX2 = v; self?.updateLinePreview() })

        controls.children.append(makeSliderRow(
            title: "End point Y",
            min: 0, max: 200, value: lineY2,
            valueTextOut: { self.lineY2Value = $0 }
        ) { [weak self] v in self?.lineY2 = v; self?.updateLinePreview() })

        controls.children.append(makeSliderRow(
            title: "Stroke Thickness",
            min: 1, max: 20, value: lineThickness,
            valueTextOut: { self.lineThValue = $0 }
        ) { [weak self] v in self?.lineThickness = v; self?.updateLinePreview() })

        let xaml = lineXamlSource()
        return makeDemoCard(previewHost: linePreviewHost, controlsPanel: controls, xamlSource: xaml)
    }

    private func makePolylineCard() -> Border {
        polyPreviewHost = Grid()
        polyPreviewHost.height = 220

        let controls = makeControlsPanel(width: 300)

        // Show points (用 CheckBox，兼容性更稳)
        let showRow = StackPanel()
        showRow.spacing = 6

        let showLabel = TextBlock()
        showLabel.text = "Show points"
        showLabel.fontSize = 13
        showLabel.opacity = 0.9
        showRow.children.append(showLabel)

        let cb = CheckBox()
        cb.content = "Off"
        cb.isChecked = false
        cb.checked.addHandler { [weak self] _, _ in
            self?.polyShowPoints = true
            cb.content = "On"
            self?.updatePolylinePreview()
        }
        cb.unchecked.addHandler { [weak self] _, _ in
            self?.polyShowPoints = false
            cb.content = "Off"
            self?.updatePolylinePreview()
        }
        showRow.children.append(cb)
        controls.children.append(showRow)

        controls.children.append(makeSliderRow(
            title: "Stroke Thickness",
            min: 1, max: 12, value: polyThickness,
            valueTextOut: { self.polyThicknessValue = $0 }
        ) { [weak self] v in self?.polyThickness = v; self?.updatePolylinePreview() })

        let xaml = polylineXamlSource()
        return makeDemoCard(previewHost: polyPreviewHost, controlsPanel: controls, xamlSource: xaml)
    }

    private func makePathCard() -> Border {
        pathPreviewHost = Grid()
        pathPreviewHost.height = 220

        let controls = makeControlsPanel(width: 300)

        let showRow = StackPanel()
        showRow.spacing = 6

        let showLabel = TextBlock()
        showLabel.text = "Show points"
        showLabel.fontSize = 13
        showLabel.opacity = 0.9
        showRow.children.append(showLabel)

        let cb = CheckBox()
        cb.content = "Off"
        cb.isChecked = false
        cb.checked.addHandler { [weak self] _, _ in
            self?.pathShowPoints = true
            cb.content = "On"
            self?.updatePathPreview()
        }
        cb.unchecked.addHandler { [weak self] _, _ in
            self?.pathShowPoints = false
            cb.content = "Off"
            self?.updatePathPreview()
        }
        showRow.children.append(cb)
        controls.children.append(showRow)

        controls.children.append(makeSliderRow(
            title: "Stroke Thickness",
            min: 1, max: 12, value: pathThickness,
            valueTextOut: { self.pathThicknessValue = $0 }
        ) { [weak self] v in self?.pathThickness = v; self?.updatePathPreview() })

        let xaml = pathXamlSource()
        return makeDemoCard(previewHost: pathPreviewHost, controlsPanel: controls, xamlSource: xaml)
    }

    private func makeGeometryGroupCard() -> Border {
        geoPreviewHost = Grid()
        geoPreviewHost.height = 220

        let controls = makeControlsPanel(width: 300)

        controls.children.append(makeSliderRow(
            title: "RadiusX",
            min: 5, max: 80, value: geoRadiusX,
            valueTextOut: { self.geoRadiusXValue = $0 }
        ) { [weak self] v in self?.geoRadiusX = v; self?.updateGeometryGroupPreview() })

        controls.children.append(makeSliderRow(
            title: "RadiusY",
            min: 5, max: 80, value: geoRadiusY,
            valueTextOut: { self.geoRadiusYValue = $0 }
        ) { [weak self] v in self?.geoRadiusY = v; self?.updateGeometryGroupPreview() })

        let xaml = geometryGroupXamlSource()
        return makeDemoCard(previewHost: geoPreviewHost, controlsPanel: controls, xamlSource: xaml)
    }

    // MARK: - Demo Card template

    private func makeDemoCard(previewHost: Grid, controlsPanel: StackPanel, xamlSource: String) -> Border {
        let outer = Border()
        outer.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        outer.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        outer.borderBrush = createBrushGray(70)
        outer.background = createBrushGray(35)

        let stack = StackPanel()
        stack.spacing = 0

        // top demo grid
        let demoGrid = Grid()
        demoGrid.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)

        let c0 = ColumnDefinition()
        c0.width = GridLength(value: 1, gridUnitType: .star)
        let c1 = ColumnDefinition()
        c1.width = GridLength(value: 300, gridUnitType: .pixel)
        demoGrid.columnDefinitions.append(c0)
        demoGrid.columnDefinitions.append(c1)

        let previewBorder = Border()
        previewBorder.cornerRadius = CornerRadius(topLeft: 6, topRight: 6, bottomRight: 6, bottomLeft: 6)
        previewBorder.background = createBrushGray(28)
        previewBorder.padding = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        previewBorder.child = previewHost

        try? Grid.setColumn(previewBorder, 0)
        demoGrid.children.append(previewBorder)

        let controlsBorder = Border()
        controlsBorder.cornerRadius = CornerRadius(topLeft: 6, topRight: 6, bottomRight: 6, bottomLeft: 6)
        controlsBorder.background = createBrushGray(40)
        controlsBorder.padding = Thickness(left: 14, top: 14, right: 14, bottom: 14)
        controlsBorder.child = controlsPanel

        try? Grid.setColumn(controlsBorder, 1)
        demoGrid.children.append(controlsBorder)

        stack.children.append(demoGrid)

        // source code (collapsible)
        let source = makeSourceCodeSection(tabs: [("XAML", xamlSource)])
        stack.children.append(source)

        outer.child = stack
        return outer
    }

    private func makeControlsPanel(width: Double) -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12
        panel.width = width
        return panel
    }

    private func makeSliderRow(
        title: String,
        min: Double,
        max: Double,
        value: Double,
        valueTextOut: (TextBlock) -> Void,
        onChanged: @escaping (Double) -> Void
    ) -> StackPanel {
        let row = StackPanel()
        row.spacing = 6

        let titleTb = TextBlock()
        titleTb.text = title
        titleTb.fontSize = 13
        titleTb.opacity = 0.9
        row.children.append(titleTb)

        let slider = Slider()
        slider.minimum = min
        slider.maximum = max
        slider.value = value
        slider.stepFrequency = 1
        slider.horizontalAlignment = .stretch

        let valueTb = TextBlock()
        valueTb.text = "\(Int(value.rounded()))"
        valueTb.fontSize = 12
        valueTb.opacity = 0.75

        valueTextOut(valueTb)

        slider.valueChanged.addHandler { _, args in
            guard let args = args else { return }
            let v = args.newValue
            valueTb.text = "\(Int(v.rounded()))"
            onChanged(v)
        }

        row.children.append(slider)
        row.children.append(valueTb)
        return row
    }

    // MARK: - Preview rendering (XamlReader)

    private func refreshAllPreviews() {
        updateLinePreview()
        updatePolylinePreview()
        updatePathPreview()
        updateGeometryGroupPreview()
    }

    private func updateLinePreview() {
        let xaml = linePreviewXaml(
            x1: lineX1, y1: lineY1,
            x2: lineX2, y2: lineY2,
            thickness: lineThickness
        )
        setPreview(linePreviewHost, xaml: xaml)
    }

    private func updatePolylinePreview() {
        let xaml = polylinePreviewXaml(showPoints: polyShowPoints, thickness: polyThickness)
        setPreview(polyPreviewHost, xaml: xaml)
    }

    private func updatePathPreview() {
        let xaml = pathPreviewXaml(showPoints: pathShowPoints, thickness: pathThickness)
        setPreview(pathPreviewHost, xaml: xaml)
    }

    private func updateGeometryGroupPreview() {
        let xaml = geometryGroupPreviewXaml(radiusX: geoRadiusX, radiusY: geoRadiusY)
        setPreview(geoPreviewHost, xaml: xaml)
    }

    private func setPreview(_ host: Grid, xaml: String) {
        // clear
        while host.children.size > 0 {
            host.children.removeAt(0)
        }

        if let el = try? XamlReader.load(xaml) as? UIElement {
            host.children.append(el)
        } else {
            let tb = TextBlock()
            tb.text = "XAML load failed"
            tb.opacity = 0.7
            tb.horizontalAlignment = .center
            tb.verticalAlignment = .center
            host.children.append(tb)
        }
    }

    // MARK: - XAML builders

    private func linePreviewXaml(x1: Double, y1: Double, x2: Double, y2: Double, thickness: Double) -> String {
        let ix1 = Int(x1.rounded())
        let iy1 = Int(y1.rounded())
        let ix2 = Int(x2.rounded())
        let iy2 = Int(y2.rounded())
        let th = Int(thickness.rounded())

        return """
<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
      xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
  <Canvas Width="560" Height="220">
    <Line Stroke="SteelBlue"
          X1="\(ix1)" Y1="\(iy1)"
          X2="\(ix2)" Y2="\(iy2)"
          StrokeThickness="\(th)"/>
  </Canvas>
</Grid>
"""
    }

    private func polylinePreviewXaml(showPoints: Bool, thickness: Double) -> String {
        let th = Int(thickness.rounded())
        // Points: 10,100 60,40 200,40 250,100
        let points: [(Int, Int)] = [(10,100), (60,40), (200,40), (250,100)]

        var markers = ""
        if showPoints {
            for (x, y) in points {
                let left = x - 4
                let top = y - 4
                markers += """
    <Ellipse Width="8" Height="8" Fill="White" Stroke="Black" StrokeThickness="1"
             Canvas.Left="\(left)" Canvas.Top="\(top)"/>
"""
            }
        }

        return """
<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
      xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
  <Canvas Width="560" Height="220">
    <Polyline Stroke="Black" StrokeThickness="\(th)"
              Points="10,100 60,40 200,40 250,100"/>
\(markers)  </Canvas>
</Grid>
"""
    }

    private func pathPreviewXaml(showPoints: Bool, thickness: Double) -> String {
        let th = Int(thickness.rounded())
        // Data sample (和你截图一致的那条)
        let data = "M 10,100 C 100,25 300,250 400,75 H 200"

        // points overlay：起点、控制点、终点（简单示意）
        var markers = ""
        if showPoints {
            let pts: [(Int, Int)] = [(10,100), (100,25), (300,250), (400,75)]
            for (x, y) in pts {
                markers += """
    <Ellipse Width="8" Height="8" Fill="White" Stroke="Black" StrokeThickness="1"
             Canvas.Left="\(x - 4)" Canvas.Top="\(y - 4)"/>
"""
            }
        }

        return """
<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
      xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
  <Canvas Width="560" Height="220">
    <Path Stroke="DarkGoldenrod" StrokeThickness="\(th)" Data="\(data)"/>
\(markers)  </Canvas>
</Grid>
"""
    }

    private func geometryGroupPreviewXaml(radiusX: Double, radiusY: Double) -> String {
        let rx = Int(radiusX.rounded())
        let ry = Int(radiusY.rounded())

        return """
<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
      xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
  <Canvas Width="560" Height="220">
    <Path Stroke="Black" StrokeThickness="4" Fill="#CCCCFF">
      <Path.Data>
        <GeometryGroup FillRule="EvenOdd">
          <LineGeometry StartPoint="10,10" EndPoint="50,30"/>
          <EllipseGeometry Center="40,70" RadiusX="\(rx)" RadiusY="\(ry)"/>
          <RectangleGeometry Rect="30,55 100 30"/>
        </GeometryGroup>
      </Path.Data>
    </Path>
  </Canvas>
</Grid>
"""
    }

    // MARK: - Source code text

    private func lineXamlSource() -> String {
        return """
<Line Stroke="SteelBlue"
      X1="0" Y1="0"
      X2="200" Y2="0"
      StrokeThickness="5"/>
"""
    }

    private func polylineXamlSource() -> String {
        return """
<Polyline Stroke="Black" StrokeThickness="2"
          Points="10,100 60,40 200,40 250,100"/>
"""
    }

    private func pathXamlSource() -> String {
        return """
<!-- The first segment is a cubic Bezier curve -->
<!-- The second segment begins with an absolute horizontal line command "H" -->
<Path Stroke="DarkGoldenrod" StrokeThickness="2"
      Data="M 10,100 C 100,25 300,250 400,75 H 200"/>
"""
    }

    private func geometryGroupXamlSource() -> String {
        return """
<Path Stroke="Black" StrokeThickness="4" Fill="#CCCCFF">
  <Path.Data>
    <GeometryGroup FillRule="EvenOdd">
      <LineGeometry StartPoint="10,10" EndPoint="50,30"/>
      <EllipseGeometry Center="40,70" RadiusX="30" RadiusY="30"/>
      <RectangleGeometry Rect="30,55 100 30"/>
    </GeometryGroup>
  </Path.Data>
</Path>
"""
    }

    // MARK: - Source code section (collapsible)

    private func makeSourceCodeSection(tabs: [(String, String)]) -> Border {
        let outer = Border()
        outer.borderThickness = Thickness(left: 0, top: 1, right: 0, bottom: 0)
        outer.borderBrush = createBrushGray(70)
        outer.padding = Thickness(left: 16, top: 10, right: 16, bottom: 12)

        let panel = StackPanel()
        panel.spacing = 8

        let toggle = Button()
        toggle.content = "▼ Source code"
        toggle.horizontalAlignment = .left
        toggle.padding = Thickness(left: 10, top: 6, right: 10, bottom: 6)
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

    // MARK: - Brushes

    private func createBrush(r: UInt8, g: UInt8, b: UInt8, a: UInt8 = 255) -> SolidColorBrush {
        let brush = SolidColorBrush()
        var c = UWP.Color()
        c.a = a
        c.r = r
        c.g = g
        c.b = b
        brush.color = c
        return brush
    }

    private func createBrushGray(_ v: UInt8, a: UInt8 = 255) -> SolidColorBrush {
        return createBrush(r: v, g: v, b: v, a: a)
    }
}
