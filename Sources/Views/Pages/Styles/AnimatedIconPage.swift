import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

// WinUI 3 Gallery - AnimatedIcon
//
// This page mirrors the WinUI 3 Gallery layout for AnimatedIcon and *tries* to support
// the common built-in AnimatedVisualSource kinds by listing them all in the "Kind" ComboBox.
// In this Swift sample we default to a FontIcon fallback (always compiles).
//
// If your Swift projection exposes Microsoft.UI.Xaml.Controls.AnimatedIcon and
// Microsoft.UI.Xaml.Controls.AnimatedVisuals.*VisualSource types, you can enable
// REAL_ANIMATEDICON in Swift build flags (-D REAL_ANIMATEDICON) and wire the real control
// in the #if REAL_ANIMATEDICON section.
//
// NOTE: We avoid GCD timers/asyncAfter to prevent Swift 6 @Sendable self-capture warnings.
final class AnimatedIconPage: Grid {

    // MARK: - Kind model

    private enum Kind: String, CaseIterable {
        case animatedBack = "AnimatedBackVisualSource"
        case animatedChevronDownSmall = "AnimatedChevronDownSmallVisualSource"
        case animatedChevronRightDownSmall = "AnimatedChevronRightDownSmallVisualSource"
        case animatedChevronUpDownSmall = "AnimatedChevronUpDownSmallVisualSource"
        case animatedFind = "AnimatedFindVisualSource"
        case animatedGlobalNavigationButton = "AnimatedGlobalNavigationButtonVisualSource"
        case animatedSettings = "AnimatedSettingsVisualSource"

        static let defaultKind: Kind = .animatedFind
    }

    // MARK: - UI tree

    private var mainScrollViewer: ScrollViewer!
    private var contentStackPanel: StackPanel!

    // Sample 1: Button
    private var searchButton: Button!
    private var searchGlyph: FontIcon!
    private var kindComboBox: ComboBox!

    // Sample 1: Source code (dynamic)
    private var buttonXamlBox: TextBox!
    private var buttonCSharpBox: TextBox!

    // Sample 2: NavigationView demo
    private var navDemoIcon: FontIcon!
    private var navItemRow: Grid!

    // Sample 2: Source code (dynamic)
    private var navXamlBox: TextBox!

    // State
    private var selectedKind: Kind = Kind.defaultKind

    private let iconBaseSize: Double = 26
    private let iconHoverSize: Double = 34

    override init() {
        super.init()
        setupUI()
        applyKind(selectedKind) // ensure initial state is consistent
    }

    // MARK: - UI setup

    private func setupUI() {
        mainScrollViewer = ScrollViewer()
        mainScrollViewer.horizontalScrollBarVisibility = .disabled
        mainScrollViewer.verticalScrollBarVisibility = .auto

        contentStackPanel = StackPanel()
        contentStackPanel.padding = Thickness(left: 40, top: 24, right: 40, bottom: 40)
        contentStackPanel.spacing = 24

        contentStackPanel.children.append(createHeader())
        contentStackPanel.children.append(createIntro())

        contentStackPanel.children.append(createButtonSample())
        contentStackPanel.children.append(createNavigationViewSample())

        mainScrollViewer.content = contentStackPanel
        children.append(mainScrollViewer)
    }

    // MARK: - Header

    private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 12

        let titleText = TextBlock()
        titleText.text = "AnimatedIcon"
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
        desc.text = "An element that displays and controls an icon that animates when the user interacts with the control."
        desc.fontSize = 14
        desc.textWrapping = .wrap
        desc.opacity = 0.85
        return desc
    }

    // MARK: - Sample 1: Button

    private func createButtonSample() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12

        panel.children.append(subsectionTitle("Adding AnimatedIcon to a button"))

        let body = TextBlock()
        body.text = """
The following example is a button that the user clicks to load a search experience. The AnimatedIcon consumes the animation created using Adobe AfterEffects and translated into Microsoft.UI.Composition objects using Lottie-Windows. For guidance on how to properly structure your animation file see the AnimatedIcon Guidance page.
"""
        body.fontSize = 14
        body.textWrapping = .wrap
        body.opacity = 0.85
        panel.children.append(body)

        panel.children.append(createButtonSampleCard())

        let (codeBorder, boxes) = makeSourceCodeSectionWithRefs(tabs: [
            ("XAML", animatedIconButtonXamlSource(kind: selectedKind)),
            ("C#", animatedIconButtonCSharpSource())
        ])
        // boxes in same order as tabs
        buttonXamlBox = boxes[0]
        buttonCSharpBox = boxes[1]
        panel.children.append(codeBorder)

        return panel
    }

    private func createButtonSampleCard() -> Border {
        let outer = createCardBorder()

        let grid = Grid()
        grid.columnSpacing = 16

        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 1, gridUnitType: .star)
        grid.columnDefinitions.append(col1)

        let col2 = ColumnDefinition()
        col2.width = GridLength(value: 320, gridUnitType: .pixel)
        grid.columnDefinitions.append(col2)

        // Left: square button with icon
        searchButton = Button()
        searchButton.width = 75
        searchButton.height = 75
        searchButton.horizontalAlignment = .left
        searchButton.verticalAlignment = .center

        searchGlyph = FontIcon()
        searchGlyph.glyph = glyphForKind(selectedKind)
        searchGlyph.fontSize = iconBaseSize
        searchButton.content = searchGlyph

        searchButton.pointerEntered.addHandler { [weak self] _, _ in
            self?.setSearchIconHovered(true)
        }
        searchButton.pointerExited.addHandler { [weak self] _, _ in
            self?.setSearchIconHovered(false)
        }

        try? Grid.setColumn(searchButton, 0)
        grid.children.append(searchButton)

        // Right: Kind selector
        let rightPanel = StackPanel()
        rightPanel.spacing = 6
        rightPanel.horizontalAlignment = .stretch
        rightPanel.verticalAlignment = .top

        let kindLabel = TextBlock()
        kindLabel.text = "Kind"
        kindLabel.fontSize = 12
        kindLabel.opacity = 0.7
        rightPanel.children.append(kindLabel)

        kindComboBox = ComboBox()
        kindComboBox.horizontalAlignment = .stretch
        kindComboBox.minWidth = 280

        // Fill kinds (match Gallery order)
        for k in Kind.allCases {
            let item = ComboBoxItem()
            item.content = k.rawValue
            kindComboBox.items.append(item)
        }

        let defaultIndex: Int = Kind.allCases.firstIndex(of: Kind.defaultKind) ?? 0
        kindComboBox.selectedIndex = Int32(defaultIndex)
        kindComboBox.selectionChanged.addHandler { [weak self] _, _ in
            self?.onKindChanged()
        }
        rightPanel.children.append(kindComboBox)

        try? Grid.setColumn(rightPanel, 1)
        grid.children.append(rightPanel)

        outer.child = grid
        return outer
    }

    private func setSearchIconHovered(_ hovered: Bool) {
        searchGlyph.fontSize = hovered ? iconHoverSize : iconBaseSize
    }

    private func onKindChanged() {
        let idx32 = kindComboBox.selectedIndex
        let kinds = Kind.allCases
        let idx = Int(idx32)
        if idx >= 0 && idx < kinds.count {
            applyKind(kinds[idx])
        }
    }

    private func applyKind(_ kind: Kind) {
        selectedKind = kind

        // Update demo icons (fallback)
        searchGlyph.glyph = glyphForKind(kind)
        navDemoIcon?.glyph = glyphForKind(kind)

        // Update source code blocks
        buttonXamlBox?.text = animatedIconButtonXamlSource(kind: kind)
        navXamlBox?.text = animatedIconNavViewXamlSource(kind: kind)

        // If you enable REAL_ANIMATEDICON, you can additionally re-wire the real AnimatedIcon here.
        // (See #if REAL_ANIMATEDICON section below.)
    }

    private func glyphForKind(_ kind: Kind) -> String {
        // Segoe MDL2 Assets glyphs (fallback). Exact glyph may not match WinUI AnimatedVisual visuals;
        // this is a functional stand-in to verify selection wiring.
        switch kind {
        case .animatedBack:
            return "\u{E72B}" // Back
        case .animatedChevronDownSmall:
            return "\u{E96E}" // ChevronDownSmall (best-effort)
        case .animatedChevronRightDownSmall:
            return "\u{E971}" // ChevronRightDownSmall (best-effort)
        case .animatedChevronUpDownSmall:
            return "\u{E97A}" // ChevronUpDownSmall (best-effort)
        case .animatedFind:
            return "\u{E721}" // Find
        case .animatedGlobalNavigationButton:
            return "\u{E700}" // GlobalNavigationButton
        case .animatedSettings:
            return "\u{E713}" // Settings
        }
    }

    // MARK: - Sample 2: NavigationView

    private func createNavigationViewSample() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12
        panel.margin = Thickness(left: 0, top: 8, right: 0, bottom: 0)

        panel.children.append(subsectionTitle("Adding AnimatedIcon to a NavigationView"))

        let body = TextBlock()
        body.text = """
If you set an AnimatedIcon as the value of the Icon property, the NavigationViewItem will set the states of the AnimatedIcon for you, according to the states of the control. For guidance on how to properly structure your animation file see the AnimatedIcon Guidance page.

For this example, this sets a custom animation GameSettingsIcon that was generated by the LottieGen tool.
"""
        body.fontSize = 14
        body.textWrapping = .wrap
        body.opacity = 0.85
        panel.children.append(body)

        panel.children.append(createNavigationViewDemoCard())

        let (codeBorder, boxes) = makeSourceCodeSectionWithRefs(tabs: [
            ("XAML", animatedIconNavViewXamlSource(kind: selectedKind))
        ])
        navXamlBox = boxes[0]
        panel.children.append(codeBorder)

        return panel
    }

    private func createNavigationViewDemoCard() -> Border {
        let outer = createCardBorder()

        // Fake a NavigationView layout: left pane + content area
        let root = Grid()
        root.columnSpacing = 0

        let leftCol = ColumnDefinition()
        leftCol.width = GridLength(value: 64, gridUnitType: .pixel)
        root.columnDefinitions.append(leftCol)

        let rightCol = ColumnDefinition()
        rightCol.width = GridLength(value: 1, gridUnitType: .star)
        root.columnDefinitions.append(rightCol)

        // Left pane
        let pane = Grid()
        pane.rowSpacing = 16
        pane.padding = Thickness(left: 8, top: 8, right: 8, bottom: 8)

        let row0 = RowDefinition()
        row0.height = GridLength(value: 40, gridUnitType: .pixel)
        pane.rowDefinitions.append(row0)

        let row1 = RowDefinition()
        row1.height = GridLength(value: 1, gridUnitType: .star)
        pane.rowDefinitions.append(row1)

        // "Hamburger" placeholder
        let burger = FontIcon()
        burger.glyph = "\u{E700}" // GlobalNavigationButton
        burger.fontSize = 18
        burger.horizontalAlignment = .center
        burger.verticalAlignment = .center
        try? Grid.setRow(burger, 0)
        pane.children.append(burger)

        // Item row (icon + label)
        navItemRow = Grid()
        navItemRow.columnSpacing = 8
        navItemRow.verticalAlignment = .top
        navItemRow.margin = Thickness(left: 0, top: 12, right: 0, bottom: 0)

        let icCol = ColumnDefinition()
        icCol.width = GridLength(value: 24, gridUnitType: .pixel)
        navItemRow.columnDefinitions.append(icCol)

        let txCol = ColumnDefinition()
        txCol.width = GridLength(value: 1, gridUnitType: .star)
        navItemRow.columnDefinitions.append(txCol)

        navDemoIcon = FontIcon()
        navDemoIcon.glyph = glyphForKind(selectedKind)
        navDemoIcon.fontSize = 16
        navDemoIcon.horizontalAlignment = .center
        navDemoIcon.verticalAlignment = .center
        try? Grid.setColumn(navDemoIcon, 0)
        navItemRow.children.append(navDemoIcon)

        let itemText = TextBlock()
        itemText.text = "Game Settings"
        itemText.fontSize = 12
        itemText.verticalAlignment = .center
        itemText.opacity = 0.9
        try? Grid.setColumn(itemText, 1)
        navItemRow.children.append(itemText)

        // Hover simulation (pointer over)
        navItemRow.pointerEntered.addHandler { [weak self] _, _ in
            self?.navDemoIcon.fontSize = 20
        }
        navItemRow.pointerExited.addHandler { [weak self] _, _ in
            self?.navDemoIcon.fontSize = 16
        }

        try? Grid.setRow(navItemRow, 1)
        pane.children.append(navItemRow)

        try? Grid.setColumn(pane, 0)
        root.children.append(pane)

        // Content area placeholder
        let contentArea = Border()
        contentArea.margin = Thickness(left: 12, top: 8, right: 8, bottom: 8)
        contentArea.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        contentArea.borderBrush = createBrush(r: 200, g: 200, b: 200)
        contentArea.cornerRadius = CornerRadius(topLeft: 6, topRight: 6, bottomRight: 6, bottomLeft: 6)

        try? Grid.setColumn(contentArea, 1)
        root.children.append(contentArea)

        outer.child = root
        return outer
    }

    // MARK: - Helpers (same style as other pages)

    private func subsectionTitle(_ text: String) -> TextBlock {
        let tb = TextBlock()
        tb.text = text
        tb.fontSize = 14
        tb.fontWeight = FontWeights.semiBold
        tb.margin = Thickness(left: 0, top: 12, right: 0, bottom: 0)
        return tb
    }

    private func createCardBorder() -> Border {
        let border = Border()
        border.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = createBrush(r: 200, g: 200, b: 200)
        border.padding = Thickness(left: 24, top: 24, right: 24, bottom: 24)
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

    // MARK: - Source strings (dynamic by kind)

    private func animatedIconButtonXamlSource(kind: Kind) -> String {
        return """
<Button PointerEntered="Button_PointerEntered"
        PointerExited="Button_PointerExited"
        Width="75">
  <AnimatedIcon x:Name="SearchAnimatedIcon">
    <AnimatedIcon.Source>
      <animatedvisuals:\(kind.rawValue)/>
    </AnimatedIcon.Source>

    <AnimatedIcon.FallbackIconSource>
      <SymbolIconSource Symbol="Find"/>
    </AnimatedIcon.FallbackIconSource>
  </AnimatedIcon>
</Button>
"""
    }

    private func animatedIconButtonCSharpSource() -> String {
        return """
private void Button_PointerEntered(object sender, PointerRoutedEventArgs e)
{
    SearchAnimatedIcon.SetState("PointerOver");
}

private void Button_PointerExited(object sender, PointerRoutedEventArgs e)
{
    SearchAnimatedIcon.SetState("Normal");
}
"""
    }

    private func animatedIconNavViewXamlSource(kind: Kind) -> String {
        return """
<NavigationView>
  <NavigationView.MenuItems>
    <NavigationViewItem Content="Game Settings">
      <NavigationViewItem.Icon>
        <AnimatedIcon x:Name="AnimatedIcon">
          <AnimatedIcon.Source>
            <animatedvisuals:\(kind.rawValue)/>
          </AnimatedIcon.Source>

          <AnimatedIcon.FallbackIconSource>
            <FontIconSource Glyph="&#xE713;"/>
          </AnimatedIcon.FallbackIconSource>
        </AnimatedIcon>
      </NavigationViewItem.Icon>
    </NavigationViewItem>
  </NavigationView.MenuItems>
</NavigationView>
"""
    }

    // MARK: - Optional: Real AnimatedIcon wiring (compile only if you define -D REAL_ANIMATEDICON)

#if REAL_ANIMATEDICON
    // If your projection contains AnimatedIcon + AnimatedVisualSource types, you can build the real control.
    // Example (pseudo):
    //
    // private func buildRealSource(for kind: Kind) -> AnyObject {
    //     switch kind {
    //     case .animatedBack: return AnimatedBackVisualSource()
    //     case .animatedChevronDownSmall: return AnimatedChevronDownSmallVisualSource()
    //     ...
    //     }
    // }
    //
    // Then set:
    //   realAnimatedIcon.source = buildRealSource(for: kind) as? IAnimatedVisualSource
#endif
}
