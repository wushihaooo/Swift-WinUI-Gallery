import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

// WinUI 3 Gallery - Scratch Pad
// A lightweight markup playground: edit XAML and render it via XamlReader.
final class ScratchPadPage: Grid {

    private var rootGrid: Grid!

    private var previewBorder: Border!
    private var editorTextBox: TextBox!

    private var loadButton: Button!
    private var resetButton: Button!

    override init() {
        super.init()
        setupUI()
    }

    private func setupUI() {
        rootGrid = Grid()
        rootGrid.padding = Thickness(left: 40, top: 24, right: 40, bottom: 40)

        let r0 = RowDefinition()
        r0.height = GridLength(value: 1, gridUnitType: .auto)
        let r1 = RowDefinition()
        r1.height = GridLength(value: 1, gridUnitType: .star)
        rootGrid.rowDefinitions.append(r0)
        rootGrid.rowDefinitions.append(r1)

        // Header + description
        let headerStack = StackPanel()
        headerStack.spacing = 12

        headerStack.children.append(createHeader())

        let desc = TextBlock()
        desc.text = "Provides an edit box where you can type in some markup and load it to see how it looks and behaves."
        desc.fontSize = 14
        desc.opacity = 0.85
        desc.textWrapping = .wrap
        headerStack.children.append(desc)

        rootGrid.children.append(headerStack)
        try? Grid.setRow(headerStack, 0)

        // Scratch surface
        let surface = createScratchSurface()
        rootGrid.children.append(surface)
        try? Grid.setRow(surface, 1)

        children.append(rootGrid)

        // Initial state
        resetScratchPad()
    }

    // MARK: - Header

    private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 12

        let titleText = TextBlock()
        titleText.text = "Scratch Pad"
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

    // MARK: - Scratch Surface

    private func createScratchSurface() -> Border {
        let outer = Border()
        outer.cornerRadius = CornerRadius(topLeft: 10, topRight: 10, bottomRight: 10, bottomLeft: 10)
        outer.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        outer.borderBrush = createBrush(r: 65, g: 65, b: 65, a: 160)
        outer.background = createBrush(r: 28, g: 28, b: 28)

        let grid = Grid()

        let rPreview = RowDefinition()
        rPreview.height = GridLength(value: 2, gridUnitType: .star)
        let rSep = RowDefinition()
        rSep.height = GridLength(value: 1, gridUnitType: .auto)
        let rEditor = RowDefinition()
        rEditor.height = GridLength(value: 1, gridUnitType: .star)

        grid.rowDefinitions.append(rPreview)
        grid.rowDefinitions.append(rSep)
        grid.rowDefinitions.append(rEditor)

        // Preview area
        previewBorder = Border()
        previewBorder.background = createBrush(r: 20, g: 20, b: 20)
        previewBorder.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        previewBorder.cornerRadius = CornerRadius(topLeft: 10, topRight: 10, bottomRight: 0, bottomLeft: 0)

        grid.children.append(previewBorder)
        try? Grid.setRow(previewBorder, 0)

        // Separator line
        let sep = Border()
        sep.height = 1
        sep.background = createBrush(r: 80, g: 80, b: 80, a: 180)
        sep.opacity = 0.35
        grid.children.append(sep)
        try? Grid.setRow(sep, 1)

        // Editor area
        let editorBorder = Border()
        editorBorder.background = createBrush(r: 48, g: 43, b: 58) // subtle purple like Gallery
        editorBorder.padding = Thickness(left: 16, top: 12, right: 16, bottom: 12)
        editorBorder.cornerRadius = CornerRadius(topLeft: 0, topRight: 0, bottomRight: 10, bottomLeft: 10)

        let editorArea = Grid()

        let c0 = ColumnDefinition()
        c0.width = GridLength(value: 1, gridUnitType: .star)
        let c1 = ColumnDefinition()
        c1.width = GridLength(value: 1, gridUnitType: .auto)
        editorArea.columnDefinitions.append(c0)
        editorArea.columnDefinitions.append(c1)

        editorTextBox = TextBox()
        editorTextBox.acceptsReturn = true
        editorTextBox.textWrapping = .noWrap
        editorTextBox.fontFamily = FontFamily("Cascadia Code, Consolas, monospace")
        editorTextBox.fontSize = 12
        editorTextBox.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        editorTextBox.background = createBrush(r: 0, g: 0, b: 0, a: 0) // transparent
        editorTextBox.margin = Thickness(left: 0, top: 0, right: 12, bottom: 0)

        editorArea.children.append(editorTextBox)
        try? Grid.setColumn(editorTextBox, 0)

        let buttonsPanel = StackPanel()
        buttonsPanel.spacing = 10
        buttonsPanel.verticalAlignment = .top

        loadButton = Button()
        loadButton.content = "Load"
        loadButton.minWidth = 140
        loadButton.height = 36
        loadButton.horizontalAlignment = .stretch
        loadButton.background = createBrush(r: 104, g: 210, b: 222) // teal-ish
        loadButton.foreground = createBrush(r: 0, g: 0, b: 0)
        buttonsPanel.children.append(loadButton)

        resetButton = Button()
        resetButton.content = "Reset"
        resetButton.minWidth = 140
        resetButton.height = 32
        resetButton.horizontalAlignment = .stretch
        buttonsPanel.children.append(resetButton)

        editorArea.children.append(buttonsPanel)
        try? Grid.setColumn(buttonsPanel, 1)

        editorBorder.child = editorArea

        grid.children.append(editorBorder)
        try? Grid.setRow(editorBorder, 2)

        // Events
        loadButton.click.addHandler { [weak self] _, _ in
            self?.renderFromEditor()
        }
        resetButton.click.addHandler { [weak self] _, _ in
            self?.resetScratchPad()
        }

        outer.child = grid
        return outer
    }

    // MARK: - Actions

    private func resetScratchPad() {
        editorTextBox.text = defaultMarkup()
        showPreviewMessage("Click the Load button to load the content below.", isError: false)
    }

    private func renderFromEditor() {
        let markup = (editorTextBox.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !markup.isEmpty else {
            showPreviewMessage("Nothing to load. Paste some XAML below and click Load.", isError: true)
            return
        }

        do {
            guard let obj = try loadMarkupWithFallback(markup) else {
                showPreviewMessage("Loaded markup returned nil.", isError: true)
                return
            }
            if let ui = obj as? UIElement {
                previewBorder.child = ui
            } else {
                showPreviewMessage("Loaded successfully, but the root object is not a UIElement.", isError: true)
            }
        } catch {
            showPreviewMessage("Failed to load markup:\n\(error)", isError: true)
        }
    }

    /// Try loading as-is. If it fails and the snippet has no xmlns, wrap it in a Grid with the default namespaces.
    private func loadMarkupWithFallback(_ markup: String) throws -> Any? {
        do {
            return try XamlReader.load(markup)
        } catch {
            if !markup.contains("xmlns=") {
                let wrapped = """
<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
      xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
\(markup)
</Grid>
"""
                return try XamlReader.load(wrapped)
            }
            throw error
        }
    }

    private func showPreviewMessage(_ text: String, isError: Bool) {
        let tb = TextBlock()
        tb.text = text
        tb.textWrapping = .wrap
        tb.horizontalAlignment = .center
        tb.verticalAlignment = .center
        tb.opacity = isError ? 1.0 : 0.8
        if isError {
            tb.foreground = createBrush(r: 255, g: 120, b: 120)
        }
        previewBorder.child = tb
    }

    // MARK: - Sample

    private func defaultMarkup() -> String {
        return """
<StackPanel Spacing="8">
  <!-- Note: {x:Bind} is not supported in Scratch Pad. -->
  <Border BorderThickness="1" BorderBrush="Green" CornerRadius="4" Padding="10">
    <StackPanel Spacing="8">
      <TextBlock>This is a sample TextBlock.</TextBlock>
      <Button Content="Click me!" />
    </StackPanel>
  </Border>

  <!-- Note: Syntax highlighting updates on \"Load\". -->
</StackPanel>
"""
    }

    // MARK: - Helpers

    private func createBrush(r: UInt8, g: UInt8, b: UInt8, a: UInt8 = 255) -> SolidColorBrush {
        let brush = SolidColorBrush()
        var c = Color()
        c.a = a
        c.r = r
        c.g = g
        c.b = b
        brush.color = c
        return brush
    }
}
