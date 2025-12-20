import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

// WinUI 3 Gallery - AcrylicBrush
final class AcrylicBrushPage: Grid {

    private var mainScrollViewer: ScrollViewer!
    private var contentStackPanel: StackPanel!

    // Live brushes for interactive samples
    private var customAcrylicBrush: AcrylicBrush!
    private var luminosityAcrylicBrush: AcrylicBrush!

    override init() {
        super.init()
        setupUI()
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

        contentStackPanel.children.append(createDefaultInAppSection())
        contentStackPanel.children.append(createCustomInAppSection())
        contentStackPanel.children.append(createLuminositySection())

        mainScrollViewer.content = contentStackPanel
        children.append(mainScrollViewer)
    }

    // MARK: - Header

    private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 12

        let titleText = TextBlock()
        titleText.text = "AcrylicBrush"
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
        desc.text = "A translucent material recommended for panel backgrounds. AcrylicBrush may fall back to SolidColorBrush in certain scenarios. Acrylic uses in-app acrylic (Backdrop) for a frosted effect."
        desc.fontSize = 14
        desc.textWrapping = .wrap
        desc.opacity = 0.85
        return desc
    }

    // MARK: - Sections

    private func createDefaultInAppSection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12

        panel.children.append(sectionTitle("Default in-app acrylic brush."))

        let card = createCardBorder(padding: 16)
        card.child = makePreviewOnlyCard(brush: makeDefaultInAppBrush())
        panel.children.append(card)

        panel.children.append(makeSourceCodeSection(tabs: [
            ("XAML", "<Rectangle Fill=\"{ThemeResource AcrylicInAppFillColorDefaultBrush}\" />")
        ]))

        return panel
    }

    private func createCustomInAppSection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12

        panel.children.append(sectionTitle("Custom acrylic in-app brush."))

        // Brush
        customAcrylicBrush = AcrylicBrush()
        // NOTE:
        // The Swift WinUI projection used in this project doesn't currently expose
        // AcrylicBackgroundSource / AcrylicBrush.backgroundSource. We rely on the
        // platform default background source (in-app acrylic) and only tweak tint/fallback.
        customAcrylicBrush.tintOpacity = 0.8
        customAcrylicBrush.tintColor = Color(a: 255, r: 0, g: 0, b: 0)
        customAcrylicBrush.fallbackColor = Color(a: 255, r: 0, g: 128, b: 0)

        let card = createCardBorder(padding: 16)
        card.child = makePreviewWithControlsCard(
            brush: customAcrylicBrush,
            controls: makeCustomControlsPanel(brush: customAcrylicBrush)
        )
        panel.children.append(card)

        panel.children.append(makeSourceCodeSection(tabs: [
            ("XAML", """
<Rectangle Fill=\"{ThemeResource CustomAcrylicInAppBrush}\" />

<ResourceDictionary x:Key=\"Default\">
  <media:AcrylicBrush x:Key=\"CustomAcrylicBrush\"
                    TintOpacity=\"0.8\"
                    TintColor=\"#FF000000\"
                    FallbackColor=\"#FF008000\" />
</ResourceDictionary>
""")
        ]))

        return panel
    }

    private func createLuminositySection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12

        panel.children.append(sectionTitle("Luminosity with in-app Acrylic."))

        luminosityAcrylicBrush = AcrylicBrush()
        luminosityAcrylicBrush.tintOpacity = 0.8
        luminosityAcrylicBrush.tintLuminosityOpacity = 0.8
        luminosityAcrylicBrush.tintColor = Color(a: 255, r: 135, g: 206, b: 235) // SkyBlue
        luminosityAcrylicBrush.fallbackColor = Color(a: 255, r: 135, g: 206, b: 235)

        let card = createCardBorder(padding: 16)
        card.child = makePreviewWithControlsCard(
            brush: luminosityAcrylicBrush,
            controls: makeLuminosityControlsPanel(brush: luminosityAcrylicBrush)
        )
        panel.children.append(card)

        panel.children.append(makeSourceCodeSection(tabs: [
            ("XAML", """
<Rectangle Fill=\"{ThemeResource CustomAcrylicInAppLuminosity}\" />

<ResourceDictionary x:Key=\"Default\">
  <media:AcrylicBrush x:Key=\"CustomAcrylicInAppLuminosity\"
                    TintOpacity=\"0.8\"
                    TintLuminosityOpacity=\"0.8\"
                    TintColor=\"SkyBlue\"
                    FallbackColor=\"SkyBlue\" />
</ResourceDictionary>
""")
        ]))

        return panel
    }

    // MARK: - Cards

    private func makePreviewOnlyCard(brush: Brush) -> UIElement {
        let root = Grid()
        root.children.append(makeAcrylicPreview(brush: brush))
        return root
    }

    private func makePreviewWithControlsCard(brush: Brush, controls: UIElement) -> UIElement {
        let root = Grid()

        let c0 = ColumnDefinition(); c0.width = GridLength(value: 1, gridUnitType: .star)
        let c1 = ColumnDefinition(); c1.width = GridLength(value: 260, gridUnitType: .pixel)
        root.columnDefinitions.append(c0)
        root.columnDefinitions.append(c1)

        let preview = makeAcrylicPreview(brush: brush)
        root.children.append(preview)
        try? Grid.setColumn(preview, 0)

        let controlsHost = Border()
        controlsHost.padding = Thickness(left: 16, top: 8, right: 16, bottom: 8)
        controlsHost.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        controlsHost.background = createBrush(r: 35, g: 35, b: 35, a: 180)
        controlsHost.child = controls

        root.children.append(controlsHost)
        try? Grid.setColumn(controlsHost, 1)

        return root
    }

    private func makeAcrylicPreview(brush: Brush) -> FrameworkElement {
        let host = Border()
        host.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        host.height = 220
        host.horizontalAlignment = .stretch

        let grid = Grid()

        // Background layer (something to blur)
        let bg = Border()
        bg.background = createBrush(r: 20, g: 55, b: 60)
        grid.children.append(bg)

        // Some simple "blobs" using Borders (circles)
        let blob1 = Border()
        blob1.width = 160
        blob1.height = 160
        blob1.cornerRadius = CornerRadius(topLeft: 80, topRight: 80, bottomRight: 80, bottomLeft: 80)
        blob1.background = createBrush(r: 150, g: 0, b: 160, a: 170)
        blob1.horizontalAlignment = .left
        blob1.verticalAlignment = .center
        blob1.margin = Thickness(left: 110, top: 0, right: 0, bottom: 0)
        grid.children.append(blob1)

        let blob2 = Border()
        blob2.width = 140
        blob2.height = 140
        blob2.cornerRadius = CornerRadius(topLeft: 70, topRight: 70, bottomRight: 70, bottomLeft: 70)
        blob2.background = createBrush(r: 160, g: 140, b: 0, a: 160)
        blob2.horizontalAlignment = .right
        blob2.verticalAlignment = .center
        blob2.margin = Thickness(left: 0, top: 0, right: 60, bottom: 0)
        grid.children.append(blob2)

        // Acrylic layer
        let acrylicLayer = Border()
        acrylicLayer.background = brush
        grid.children.append(acrylicLayer)

        // Corner accents (cyan top-left, yellow bottom-right)
        let cyanV = Border(); cyanV.width = 6; cyanV.height = 70
        cyanV.background = createBrush(r: 0, g: 255, b: 255)
        cyanV.horizontalAlignment = .left
        cyanV.verticalAlignment = .top
        cyanV.margin = Thickness(left: 16, top: 16, right: 0, bottom: 0)
        grid.children.append(cyanV)

        let cyanH = Border(); cyanH.width = 70; cyanH.height = 6
        cyanH.background = createBrush(r: 0, g: 255, b: 255)
        cyanH.horizontalAlignment = .left
        cyanH.verticalAlignment = .top
        cyanH.margin = Thickness(left: 16, top: 16, right: 0, bottom: 0)
        grid.children.append(cyanH)

        let yelV = Border(); yelV.width = 6; yelV.height = 70
        yelV.background = createBrush(r: 255, g: 255, b: 0)
        yelV.horizontalAlignment = .right
        yelV.verticalAlignment = .bottom
        yelV.margin = Thickness(left: 0, top: 0, right: 16, bottom: 16)
        grid.children.append(yelV)

        let yelH = Border(); yelH.width = 70; yelH.height = 6
        yelH.background = createBrush(r: 255, g: 255, b: 0)
        yelH.horizontalAlignment = .right
        yelH.verticalAlignment = .bottom
        yelH.margin = Thickness(left: 0, top: 0, right: 16, bottom: 16)
        grid.children.append(yelH)

        host.child = grid
        return host
    }

    // MARK: - Controls panels

    private func makeCustomControlsPanel(brush: AcrylicBrush) -> UIElement {
        let panel = StackPanel()
        panel.spacing = 10

        let t1 = TextBlock(); t1.text = "Tint Opacity :"; t1.fontSize = 12
        panel.children.append(t1)

        let opacitySlider = Slider()
        opacitySlider.minimum = 0
        opacitySlider.maximum = 1
        opacitySlider.value = brush.tintOpacity
        opacitySlider.stepFrequency = 0.01
        panel.children.append(opacitySlider)

        let t2 = TextBlock(); t2.text = "Tint Color :"; t2.fontSize = 12
        t2.margin = Thickness(left: 0, top: 6, right: 0, bottom: 0)
        panel.children.append(t2)

        let tintCombo = ComboBox()
        tintCombo.placeholderText = "#FF000000"
        tintCombo.items.append(makeComboItem("#FF000000"))
        tintCombo.items.append(makeComboItem("#FFFFFFFF"))
        tintCombo.items.append(makeComboItem("#FF0078D4"))
        tintCombo.items.append(makeComboItem("#FFA020F0"))
        tintCombo.selectedIndex = 0
        panel.children.append(tintCombo)

        let t3 = TextBlock(); t3.text = "Fallback Color :"; t3.fontSize = 12
        t3.margin = Thickness(left: 0, top: 6, right: 0, bottom: 0)
        panel.children.append(t3)

        let fallbackCombo = ComboBox()
        fallbackCombo.placeholderText = "#FF008000"
        fallbackCombo.items.append(makeComboItem("#FF008000"))
        fallbackCombo.items.append(makeComboItem("#FF202020"))
        fallbackCombo.items.append(makeComboItem("#FF8B0000"))
        fallbackCombo.items.append(makeComboItem("#FF2E8B57"))
        fallbackCombo.selectedIndex = 0
        panel.children.append(fallbackCombo)

        // Wire events
        opacitySlider.valueChanged.addHandler { _, _ in
            brush.tintOpacity = opacitySlider.value
        }

        tintCombo.selectionChanged.addHandler { _, _ in
            if let item = tintCombo.selectedItem as? ComboBoxItem,
               let str = item.content as? String,
               let color = Self.colorFromHex(str) {
                brush.tintColor = color
            }
        }

        fallbackCombo.selectionChanged.addHandler { _, _ in
            if let item = fallbackCombo.selectedItem as? ComboBoxItem,
               let str = item.content as? String,
               let color = Self.colorFromHex(str) {
                brush.fallbackColor = color
            }
        }

        return panel
    }

    private func makeLuminosityControlsPanel(brush: AcrylicBrush) -> UIElement {
        let panel = StackPanel()
        panel.spacing = 10

        let t1 = TextBlock(); t1.text = "Tint Opacity :"; t1.fontSize = 12
        panel.children.append(t1)

        let opacitySlider = Slider()
        opacitySlider.minimum = 0
        opacitySlider.maximum = 1
        opacitySlider.value = brush.tintOpacity
        opacitySlider.stepFrequency = 0.01
        panel.children.append(opacitySlider)

        let t2 = TextBlock(); t2.text = "Tint Luminosity Opacity :"; t2.fontSize = 12
        t2.margin = Thickness(left: 0, top: 6, right: 0, bottom: 0)
        panel.children.append(t2)

        let lumSlider = Slider()
        lumSlider.minimum = 0
        lumSlider.maximum = 1
        lumSlider.value = brush.tintLuminosityOpacity ?? 0.8
        lumSlider.stepFrequency = 0.01
        panel.children.append(lumSlider)

        opacitySlider.valueChanged.addHandler { _, _ in
            brush.tintOpacity = opacitySlider.value
        }

        lumSlider.valueChanged.addHandler { _, _ in
            brush.tintLuminosityOpacity = lumSlider.value
        }

        return panel
    }

    private func makeComboItem(_ text: String) -> ComboBoxItem {
        let item = ComboBoxItem()
        item.content = text
        return item
    }

    // MARK: - Brushes / Helpers

    private func makeDefaultInAppBrush() -> AcrylicBrush {
        let b = AcrylicBrush()
        b.tintOpacity = 0.6
        b.tintColor = Color(a: 255, r: 0, g: 0, b: 0)
        b.fallbackColor = Color(a: 255, r: 32, g: 32, b: 32)
        return b
    }

    private func sectionTitle(_ text: String) -> TextBlock {
        let tb = TextBlock()
        tb.text = text
        tb.fontSize = 14
        tb.fontWeight = FontWeights.semiBold
        return tb
    }

    private func createCardBorder(padding: Double) -> Border {
        let border = Border()
        border.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = createBrush(r: 200, g: 200, b: 200)
        border.padding = Thickness(left: padding, top: padding, right: padding, bottom: padding)
        return border
    }

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

    private func createBrush(r: UInt8, g: UInt8, b: UInt8, a: UInt8 = 255) -> SolidColorBrush {
        return SolidColorBrush(Color(a: a, r: r, g: g, b: b))
    }

    private static func colorFromHex(_ hex: String) -> Color? {
        // Supports #AARRGGBB
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("#") { s.removeFirst() }
        guard s.count == 8 else { return nil }

        func byte(_ start: Int) -> UInt8? {
            let i1 = s.index(s.startIndex, offsetBy: start)
            let i2 = s.index(i1, offsetBy: 2)
            let sub = String(s[i1..<i2])
            return UInt8(sub, radix: 16)
        }

        guard let a = byte(0), let r = byte(2), let g = byte(4), let b = byte(6) else { return nil }
        return Color(a: a, r: r, g: g, b: b)
    }
}
