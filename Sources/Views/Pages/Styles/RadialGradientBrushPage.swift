import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

// WinUI 3 Gallery - RadialGradientBrush (Swift)
// This implementation avoids referencing RadialGradientBrush type directly (some Swift WinUI projections
// don't expose it). Instead, it uses XamlReader to create a UIElement that contains a RadialGradientBrush.
final class RadialGradientBrushPage: Grid {

    private let previewSize: Double = 200

    private var mainScrollViewer: ScrollViewer!
    private var contentStackPanel: StackPanel!

    // Preview
    private var previewPanelBackground: Border!
    private var previewSquareHost: Border!   // 200x200 host where we inject XAML-created element

    // Controls
    private var mappingModeComboBox: ComboBox!
    private var spreadMethodComboBox: ComboBox!

    private var centerXSlider: Slider!
    private var centerYSlider: Slider!
    private var radiusXSlider: Slider!
    private var radiusYSlider: Slider!
    private var originXSlider: Slider!
    private var originYSlider: Slider!

    // Source code
    private var xamlBox: TextBox!

    // State
    private var isRelativeMode: Bool = true

    override init() {
        super.init()
        setupUI()
        updatePreviewAndSource()
    }

    // MARK: - UI

    private func setupUI() {
        mainScrollViewer = ScrollViewer()
        mainScrollViewer.horizontalScrollBarVisibility = .disabled
        mainScrollViewer.verticalScrollBarVisibility = .auto

        contentStackPanel = StackPanel()
        contentStackPanel.padding = Thickness(left: 40, top: 24, right: 40, bottom: 40)
        contentStackPanel.spacing = 24

        contentStackPanel.children.append(createHeader())
        contentStackPanel.children.append(createIntro())
        contentStackPanel.children.append(createSampleSection())

        mainScrollViewer.content = contentStackPanel
        children.append(mainScrollViewer)
    }

    private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 12

        let titleText = TextBlock()
        titleText.text = "RadialGradientBrush"
        titleText.fontSize = 32
        titleText.fontWeight = FontWeights.semiBold
        headerPanel.children.append(titleText)

        let tabsPanel = StackPanel()
        tabsPanel.orientation = .horizontal
        tabsPanel.spacing = 16

        let docText = TextBlock()
        docText.text = "Documentation"
        docText.fontSize = 14
        docText.fontWeight = FontWeights.semiBold
        docText.foreground = createBrush(r: 0, g: 120, b: 215)
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

    private func createIntro() -> TextBlock {
        let desc = TextBlock()
        desc.text = "Paints an area with a radial gradient. A center point defines the beginning of the gradient, and a radius defines the end point of the gradient."
        desc.fontSize = 14
        desc.textWrapping = .wrap
        desc.opacity = 0.85
        return desc
    }

    private func createSampleSection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12

        let title = TextBlock()
        title.text = "RadialGradientBrush Sample"
        title.fontSize = 14
        title.fontWeight = FontWeights.semiBold
        panel.children.append(title)

        panel.children.append(createSampleCard())

        let (codeBorder, boxes) = makeSourceCodeSectionWithRefs(tabs: [
            ("XAML", buildSourceXaml())
        ])
        xamlBox = boxes[0]
        panel.children.append(codeBorder)

        return panel
    }

    private func createSampleCard() -> Border {
        let outer = createCardBorder()

        let grid = Grid()
        grid.columnSpacing = 24

        let leftCol = ColumnDefinition()
        leftCol.width = GridLength(value: 1, gridUnitType: .star)
        grid.columnDefinitions.append(leftCol)

        let rightCol = ColumnDefinition()
        rightCol.width = GridLength(value: 280, gridUnitType: .pixel)
        grid.columnDefinitions.append(rightCol)

        // Left: preview area background + injected 200x200 square
        previewPanelBackground = Border()
        previewPanelBackground.horizontalAlignment = .stretch
        previewPanelBackground.verticalAlignment = .stretch
        previewPanelBackground.background = createBrush(r: 0, g: 0, b: 0, a: 25)

        previewSquareHost = Border()
        previewSquareHost.width = previewSize
        previewSquareHost.height = previewSize
        previewSquareHost.horizontalAlignment = .left
        previewSquareHost.verticalAlignment = .top
        previewSquareHost.margin = Thickness(left: 24, top: 24, right: 0, bottom: 24)

        previewPanelBackground.child = previewSquareHost

        try? Grid.setColumn(previewPanelBackground, 0)
        grid.children.append(previewPanelBackground)

        // Right: control panel
        let controls = StackPanel()
        controls.spacing = 10
        controls.horizontalAlignment = .stretch
        controls.verticalAlignment = .top

        // MappingMode
        controls.children.append(smallLabel("MappingMode"))
        mappingModeComboBox = ComboBox()
        mappingModeComboBox.horizontalAlignment = .stretch
        mappingModeComboBox.minWidth = 260

        let mm1 = ComboBoxItem(); mm1.content = "RelativeToBoundingBox"
        let mm2 = ComboBoxItem(); mm2.content = "Absolute"
        mappingModeComboBox.items.append(mm1)
        mappingModeComboBox.items.append(mm2)
        mappingModeComboBox.selectedIndex = 0

        mappingModeComboBox.selectionChanged.addHandler { [weak self] _, _ in
            self?.onMappingModeChanged()
        }
        controls.children.append(mappingModeComboBox)

        // Center.X / Center.Y
        controls.children.append(smallLabel("Center.X            Center.Y"))
        let centerRow = makeTwoColumnRow()
        centerXSlider = makeSlider(min: 0, max: 1, step: 0.01, initial: 0.5)
        centerYSlider = makeSlider(min: 0, max: 1, step: 0.01, initial: 0.5)
        wireSlider(centerXSlider); wireSlider(centerYSlider)
        try? Grid.setColumn(centerXSlider, 0)
        try? Grid.setColumn(centerYSlider, 1)
        centerRow.children.append(centerXSlider)
        centerRow.children.append(centerYSlider)
        controls.children.append(centerRow)

        // RadiusX / RadiusY
        controls.children.append(smallLabel("RadiusX             RadiusY"))
        let radiusRow = makeTwoColumnRow()
        radiusXSlider = makeSlider(min: 0, max: 1, step: 0.01, initial: 0.5)
        radiusYSlider = makeSlider(min: 0, max: 1, step: 0.01, initial: 0.5)
        wireSlider(radiusXSlider); wireSlider(radiusYSlider)
        try? Grid.setColumn(radiusXSlider, 0)
        try? Grid.setColumn(radiusYSlider, 1)
        radiusRow.children.append(radiusXSlider)
        radiusRow.children.append(radiusYSlider)
        controls.children.append(radiusRow)

        // GradientOrigin.X / GradientOrigin.Y
        controls.children.append(smallLabel("GradientOrigin.X    GradientOrigin.Y"))
        let originRow = makeTwoColumnRow()
        originXSlider = makeSlider(min: 0, max: 1, step: 0.01, initial: 0.5)
        originYSlider = makeSlider(min: 0, max: 1, step: 0.01, initial: 0.5)
        wireSlider(originXSlider); wireSlider(originYSlider)
        try? Grid.setColumn(originXSlider, 0)
        try? Grid.setColumn(originYSlider, 1)
        originRow.children.append(originXSlider)
        originRow.children.append(originYSlider)
        controls.children.append(originRow)

        // SpreadMethod
        controls.children.append(smallLabel("SpreadMethod"))
        spreadMethodComboBox = ComboBox()
        spreadMethodComboBox.horizontalAlignment = .stretch

        let sm1 = ComboBoxItem(); sm1.content = "Pad"
        let sm2 = ComboBoxItem(); sm2.content = "Reflect"
        let sm3 = ComboBoxItem(); sm3.content = "Repeat"
        spreadMethodComboBox.items.append(sm1)
        spreadMethodComboBox.items.append(sm2)
        spreadMethodComboBox.items.append(sm3)
        spreadMethodComboBox.selectedIndex = 0

        spreadMethodComboBox.selectionChanged.addHandler { [weak self] _, _ in
            self?.updatePreviewAndSource()
        }
        controls.children.append(spreadMethodComboBox)

        try? Grid.setColumn(controls, 1)
        grid.children.append(controls)

        outer.child = grid
        return outer
    }

    // MARK: - Updates

    private func onMappingModeChanged() {
        let idx = Int(mappingModeComboBox.selectedIndex) // selectedIndex is Int32 in this projection
        let nextIsRelative = (idx == 0)

        guard nextIsRelative != isRelativeMode else {
            updatePreviewAndSource()
            return
        }

        if nextIsRelative {
            // Absolute -> Relative
            setSliderDomainRelative()
            centerXSlider.value = clamp(centerXSlider.value / previewSize, 0, 1)
            centerYSlider.value = clamp(centerYSlider.value / previewSize, 0, 1)
            radiusXSlider.value = clamp(radiusXSlider.value / previewSize, 0, 1)
            radiusYSlider.value = clamp(radiusYSlider.value / previewSize, 0, 1)
            originXSlider.value = clamp(originXSlider.value / previewSize, 0, 1)
            originYSlider.value = clamp(originYSlider.value / previewSize, 0, 1)
        } else {
            // Relative -> Absolute
            setSliderDomainAbsolute()
            centerXSlider.value = clamp(centerXSlider.value * previewSize, 0, previewSize)
            centerYSlider.value = clamp(centerYSlider.value * previewSize, 0, previewSize)
            radiusXSlider.value = clamp(radiusXSlider.value * previewSize, 0, previewSize)
            radiusYSlider.value = clamp(radiusYSlider.value * previewSize, 0, previewSize)
            originXSlider.value = clamp(originXSlider.value * previewSize, 0, previewSize)
            originYSlider.value = clamp(originYSlider.value * previewSize, 0, previewSize)
        }

        isRelativeMode = nextIsRelative
        updatePreviewAndSource()
    }

    private func updatePreviewAndSource() {
        applyPreviewXaml()

        if xamlBox != nil {
            xamlBox.text = buildSourceXaml()
        }
    }

    private func applyPreviewXaml() {
        let mapping = (Int(mappingModeComboBox.selectedIndex) == 0) ? "RelativeToBoundingBox" : "Absolute"
        let spread = spreadMethodString()

        let cx = fmt(centerXSlider.value)
        let cy = fmt(centerYSlider.value)
        let rx = fmt(radiusXSlider.value)
        let ry = fmt(radiusYSlider.value)
        let ox = fmt(originXSlider.value)
        let oy = fmt(originYSlider.value)

        // Load a UIElement that contains the brush (cast-to-Brush can fail in some projections)
        let elementXaml = """
<Border xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Width="200" Height="200">
  <Border.Background>
    <RadialGradientBrush
        MappingMode="\(mapping)"
        Center="\(cx),\(cy)"
        RadiusX="\(rx)"
        RadiusY="\(ry)"
        GradientOrigin="\(ox),\(oy)"
        SpreadMethod="\(spread)">
      <GradientStop Color="#FFFF00" Offset="0.0" />
      <GradientStop Color="#0000FF" Offset="1.0" />
    </RadialGradientBrush>
  </Border.Background>
</Border>
"""

        if let el = try? XamlReader.load(elementXaml) as? UIElement {
            previewSquareHost.background = nil
            previewSquareHost.child = el
        } else {
            // Fallback
            previewSquareHost.child = nil
            previewSquareHost.background = createBrush(r: 0, g: 0, b: 255)
        }
    }

    private func buildSourceXaml() -> String {
        let mapping = (Int(mappingModeComboBox?.selectedIndex ?? 0) == 0) ? "RelativeToBoundingBox" : "Absolute"
        let spread = spreadMethodString(selectedIndex: Int(spreadMethodComboBox?.selectedIndex ?? 0))

        let cx = fmt(centerXSlider?.value ?? 0.5)
        let cy = fmt(centerYSlider?.value ?? 0.5)
        let rx = fmt(radiusXSlider?.value ?? 0.5)
        let ry = fmt(radiusYSlider?.value ?? 0.5)
        let ox = fmt(originXSlider?.value ?? 0.5)
        let oy = fmt(originYSlider?.value ?? 0.5)

        return """
<Rectangle Width="200" Height="200">
  <Rectangle.Fill>
    <media:RadialGradientBrush
        MappingMode="\(mapping)"
        Center="\(cx),\(cy)"
        RadiusX="\(rx)"
        RadiusY="\(ry)"
        GradientOrigin="\(ox),\(oy)"
        SpreadMethod="\(spread)">

      <GradientStop Color="Yellow" Offset="0.0" />
      <GradientStop Color="Blue" Offset="1.0" />

    </media:RadialGradientBrush>
  </Rectangle.Fill>
</Rectangle>
"""
    }

    private func spreadMethodString() -> String {
        return spreadMethodString(selectedIndex: Int(spreadMethodComboBox.selectedIndex))
    }

    private func spreadMethodString(selectedIndex: Int) -> String {
        switch selectedIndex {
        case 1: return "Reflect"
        case 2: return "Repeat"
        default: return "Pad"
        }
    }

    private func fmt(_ v: Double) -> String {
        // Gallery-style simple formatting
        if isRelativeMode {
            return String(format: "%.2f", v)
        } else {
            return String(format: "%.1f", v)
        }
    }

    private func clamp(_ v: Double, _ lo: Double, _ hi: Double) -> Double {
        return max(lo, min(hi, v))
    }

    // MARK: - Slider domains

    private func setSliderDomainRelative() {
        setSlider(centerXSlider, min: 0, max: 1, step: 0.01)
        setSlider(centerYSlider, min: 0, max: 1, step: 0.01)
        setSlider(radiusXSlider, min: 0, max: 1, step: 0.01)
        setSlider(radiusYSlider, min: 0, max: 1, step: 0.01)
        setSlider(originXSlider, min: 0, max: 1, step: 0.01)
        setSlider(originYSlider, min: 0, max: 1, step: 0.01)
    }

    private func setSliderDomainAbsolute() {
        setSlider(centerXSlider, min: 0, max: previewSize, step: 1)
        setSlider(centerYSlider, min: 0, max: previewSize, step: 1)
        setSlider(radiusXSlider, min: 0, max: previewSize, step: 1)
        setSlider(radiusYSlider, min: 0, max: previewSize, step: 1)
        setSlider(originXSlider, min: 0, max: previewSize, step: 1)
        setSlider(originYSlider, min: 0, max: previewSize, step: 1)
    }

    private func setSlider(_ s: Slider, min: Double, max: Double, step: Double) {
        s.minimum = min
        s.maximum = max
        s.stepFrequency = step
    }

    // MARK: - Small helpers

    private func makeTwoColumnRow() -> Grid {
        let row = Grid()
        row.columnSpacing = 12

        let c1 = ColumnDefinition()
        c1.width = GridLength(value: 1, gridUnitType: .star)
        row.columnDefinitions.append(c1)

        let c2 = ColumnDefinition()
        c2.width = GridLength(value: 1, gridUnitType: .star)
        row.columnDefinitions.append(c2)

        return row
    }

    private func makeSlider(min: Double, max: Double, step: Double, initial: Double) -> Slider {
        let s = Slider()
        s.minimum = min
        s.maximum = max
        s.value = initial
        s.stepFrequency = step
        return s
    }

    private func wireSlider(_ slider: Slider) {
        slider.valueChanged.addHandler { [weak self] _, _ in
            self?.updatePreviewAndSource()
        }
    }

    private func smallLabel(_ text: String) -> TextBlock {
        let tb = TextBlock()
        tb.text = text
        tb.fontSize = 12
        tb.opacity = 0.75
        tb.margin = Thickness(left: 0, top: 6, right: 0, bottom: 0)
        return tb
    }

    private func createCardBorder() -> Border {
        let border = Border()
        border.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = createBrush(r: 200, g: 200, b: 200)
        border.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        return border
    }

    private func makeSourceCodeSectionWithRefs(tabs: [(String, String)]) -> (Border, [TextBox]) {
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

        var textBoxes: [TextBox] = []

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

            textBoxes.append(tb)
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
        return (outer, textBoxes)
    }

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
