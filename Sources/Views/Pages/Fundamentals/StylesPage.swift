import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

// WinUI 3 Gallery - Style(s)
final class StylesPage: Grid {

    private var mainScrollViewer: ScrollViewer!
    private var contentStackPanel: StackPanel!

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
        contentStackPanel.spacing = 24

        contentStackPanel.children.append(createHeader())
        contentStackPanel.children.append(createOverview())
        contentStackPanel.children.append(createCreatingAndApplyingSection())
        contentStackPanel.children.append(createImplicitStyleSection())

        mainScrollViewer.content = contentStackPanel
        children.append(mainScrollViewer)
    }

    // MARK: - Header

    private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 12

        let titleText = TextBlock()
        titleText.text = "Style"
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

    // MARK: - Content

    private func createOverview() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 10

        let desc = TextBlock()
        desc.text = """
XAML Styles in WinUI 3 are reusable sets of property values that you can apply to multiple controls. They help maintain a consistent look and feel across your app. Instead of setting the same properties on every control, you define a style once and then reuse it wherever needed.

The definition of styles is similar to other resources: app-level, page-level, control-level.
"""
        desc.fontSize = 14
        desc.textWrapping = .wrap
        desc.opacity = 0.85
        panel.children.append(desc)

        panel.children.append(bulletList([
            "Styles are reusable collections of property settings for a specific control type.",
            "A keyed style is used for explicit application, while an implicit style is used for automatic application to all controls of a type.",
            "Styles improve maintainability, consistency, and reduce repetition in XAML code."
        ]))

        return panel
    }

    private func createCreatingAndApplyingSection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12

        panel.children.append(sectionTitle("Creating and applying a style"))

        let demo = createButtonStyleDemoCard()
        panel.children.append(demo)

        panel.children.append(makeSourceCodeSection(tabs: [
            ("XAML", keyedStyleXamlSource())
        ]))

        return panel
    }

    private func createImplicitStyleSection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12

        panel.children.append(sectionTitle("Style without a key (implicit style)"))

        let demo = createImplicitStyleDemoCard()
        panel.children.append(demo)

        panel.children.append(makeSourceCodeSection(tabs: [
            ("XAML", implicitStyleXamlSource())
        ]))

        return panel
    }

    // MARK: - Demo cards

    private func createButtonStyleDemoCard() -> Border {
        let outer = createCardBorder()

        let stack = StackPanel()
        stack.spacing = 10

        let defaultButton = Button()
        defaultButton.content = "Default button"
        defaultButton.horizontalAlignment = .left
        stack.children.append(defaultButton)

        let styledButton = Button()
        styledButton.content = "Styled button"
        styledButton.minWidth = 200
        styledButton.horizontalAlignment = .left
        styledButton.background = createBrushHex("#1F6E7A") // teal-ish
        styledButton.foreground = createBrush(r: 255, g: 255, b: 255)
        stack.children.append(styledButton)

        let overriddenButton = Button()
        overriddenButton.content = "Styled button (overridden)"
        overriddenButton.minWidth = 200
        overriddenButton.horizontalAlignment = .left
        overriddenButton.background = createBrushHex("#5A2A2A") // dark red/brown-ish
        overriddenButton.foreground = createBrush(r: 255, g: 255, b: 255)
        stack.children.append(overriddenButton)

        outer.child = stack
        return outer
    }

    private func createImplicitStyleDemoCard() -> Border {
        let outer = createCardBorder()

        let inner = Border()
        inner.background = createBrush(r: 20, g: 20, b: 20)
        inner.cornerRadius = CornerRadius(topLeft: 6, topRight: 6, bottomRight: 6, bottomLeft: 6)
        inner.padding = Thickness(left: 16, top: 14, right: 16, bottom: 14)

        let stack = StackPanel()
        stack.spacing = 2

        let line1 = TextBlock()
        line1.text = "This style is applied automatically!"
        line1.fontSize = 16
        line1.fontFamily = FontFamily("Consolas")
        line1.fontWeight = FontWeights.bold
        line1.foreground = createBrush(r: 255, g: 255, b: 255)
        stack.children.append(line1)

        let line2 = TextBlock()
        line2.text = "No need to set a key."
        line2.fontSize = 16
        line2.fontFamily = FontFamily("Consolas")
        line2.fontWeight = FontWeights.bold
        line2.foreground = createBrush(r: 255, g: 255, b: 255)
        stack.children.append(line2)

        inner.child = stack
        outer.child = inner
        return outer
    }

    // MARK: - Helpers (same style as other pages)

    private func sectionTitle(_ text: String) -> TextBlock {
        let tb = TextBlock()
        tb.text = text
        tb.fontSize = 20
        tb.fontWeight = FontWeights.semiBold
        tb.margin = Thickness(left: 0, top: 12, right: 0, bottom: 0)
        return tb
    }

    private func bulletList(_ items: [String]) -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 6
        panel.margin = Thickness(left: 0, top: 4, right: 0, bottom: 0)

        for item in items {
            let tb = TextBlock()
            tb.text = "• \(item)"
            tb.fontSize = 14
            tb.textWrapping = .wrap
            tb.opacity = 0.85
            panel.children.append(tb)
        }
        return panel
    }

    private func createCardBorder() -> Border {
        let border = Border()
        border.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = createBrush(r: 200, g: 200, b: 200)
        border.padding = Thickness(left: 24, top: 24, right: 24, bottom: 24)
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
        if s.count == 3 {
            // RGB -> RRGGBB
            s = s.map { "\($0)\($0)" }.joined()
        }

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

    private func keyedStyleXamlSource() -> String {
        return """
<StackPanel Spacing=\\"8\\">
  <StackPanel.Resources>
    <Style x:Key=\\"CustomButtonStyle\\" TargetType=\\"Button\\" BasedOn=\\"{StaticResource ButtonRevealStyle}\\">
      <Setter Property=\\"Background\\" Value=\\"{ThemeResource AccentAcrylicBackgroundFillColorDefaultBrush}\\" />
      <Setter Property=\\"MinWidth\\" Value=\\"200\\" />
    </Style>
  </StackPanel.Resources>

  <Button Content=\\"Default button\\" />
  <Button Content=\\"Styled button\\" Style=\\"{StaticResource CustomButtonStyle}\\" />
  <Button Content=\\"Styled button (overridden)\\" Style=\\"{StaticResource CustomButtonStyle}\\"
          Background=\\"{ThemeResource SystemFillColorCriticalBackgroundBrush}\\" />
</StackPanel>
"""
    }

    private func implicitStyleXamlSource() -> String {
        return """
<StackPanel>
  <StackPanel.Resources>
    <Style TargetType=\\"TextBlock\\">
      <Setter Property=\\"FontSize\\" Value=\\"16\\" />
      <Setter Property=\\"FontFamily\\" Value=\\"Consolas\\" />
      <Setter Property=\\"FontWeight\\" Value=\\"Bold\\" />
    </Style>
  </StackPanel.Resources>

  <TextBlock Text=\\"This style is applied automatically!\\" />
  <TextBlock Text=\\"No need to set a key.\\" />
</StackPanel>
"""
    }
}
