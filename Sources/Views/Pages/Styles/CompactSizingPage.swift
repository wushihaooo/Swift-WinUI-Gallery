import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

// WinUI 3 Gallery - Compact Sizing
final class CompactSizingPage: Grid {

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
        contentStackPanel.children.append(createCompactSizingSection())

        mainScrollViewer.content = contentStackPanel
        children.append(mainScrollViewer)
    }

    // MARK: - Header / Overview

    private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 12

        let titleText = TextBlock()
        titleText.text = "Compact Sizing"
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

    private func createOverview() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 10

        let desc = TextBlock()
        desc.text = "Enables the creation of compact, smaller apps by adding a style resource at the app, page or control level."
        desc.fontSize = 14
        desc.opacity = 0.85
        desc.textWrapping = .wrap
        panel.children.append(desc)

        let supports = TextBlock()
        supports.text = "Controls that support compact styling:"
        supports.fontSize = 14
        supports.fontWeight = FontWeights.semiBold
        supports.margin = Thickness(left: 0, top: 8, right: 0, bottom: 0)
        panel.children.append(supports)

        panel.children.append(bulletList([
            "ListView",
            "TextBox",
            "PasswordBox",
            "AutoSuggestBox",
            "ComboBox",
            "DatePicker",
            "TimePicker",
            "TreeView",
            "NavigationView",
            "MenuBar"
        ]))

        return panel
    }

    // MARK: - Section

    private func createCompactSizingSection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12

        let header = TextBlock()
        header.text = "Compact Sizing for controls"
        header.fontSize = 20
        header.fontWeight = FontWeights.semiBold
        panel.children.append(header)

        panel.children.append(makeCard_CompactSizingDemo())
        return panel
    }

    // MARK: - Demo card (XAML + code-behind)

    private func makeCard_CompactSizingDemo() -> UIElement {
        let src = compactSizingXamlSource()
        let srcEsc = escapeForXamlAttribute(src)

        let xaml = """
<Border xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        CornerRadius="8"
        Background="{ThemeResource CardBackgroundFillColorDefaultBrush}"
        BorderBrush="{ThemeResource CardStrokeColorDefaultBrush}"
        BorderThickness="1">
  <StackPanel>

    <Grid>
      <Grid.ColumnDefinitions>
        <ColumnDefinition Width="*" />
        <ColumnDefinition Width="280" />
      </Grid.ColumnDefinitions>

      <!-- Left: form -->
      <StackPanel x:Name="FormPanel"
                  Padding="16"
                  Spacing="12">
        <TextBlock x:Name="FormTitle"
                   Text="Standard Size"
                   FontSize="18"
                   FontWeight="SemiBold"
                   Margin="0,0,0,4"/>

        <TextBlock Text="First Name:"/>
        <TextBox x:Name="FirstNameBox"/>

        <TextBlock Text="Last Name:"/>
        <TextBox x:Name="LastNameBox"/>

        <TextBlock Text="Password:"/>
        <PasswordBox x:Name="PasswordBox"/>

        <TextBlock Text="Confirm Password:"/>
        <PasswordBox x:Name="ConfirmPasswordBox"/>

        <DatePicker x:Name="DatePicker"
                    Header="Pick a date"/>
      </StackPanel>

      <!-- Right: sizing selector -->
      <Border Grid.Column="1"
              BorderBrush="{ThemeResource CardStrokeColorDefaultBrush}"
              BorderThickness="1,0,0,0">
        <StackPanel Padding="16"
                    Spacing="12">
          <TextBlock Text="Fluent Standard and Compact Sizing"
                     FontWeight="SemiBold"
                     TextWrapping="Wrap"/>
          <RadioButton x:Name="StandardRadio"
                       Content="Standard"
                       IsChecked="True"/>
          <RadioButton x:Name="CompactRadio"
                       Content="Compact"/>
        </StackPanel>
      </Border>
    </Grid>

    <!-- Divider -->
    <Border Height="1"
            Background="{ThemeResource CardStrokeColorDefaultBrush}"
            Opacity="0.6"/>

    <!-- Source -->
    <Expander Header="Source code">
      <TextBox IsReadOnly="True"
               AcceptsReturn="True"
               TextWrapping="NoWrap"
               BorderThickness="0"
               Background="Transparent"
               FontFamily="Cascadia Code, Consolas, monospace"
               FontSize="12"
               Text="\(srcEsc)"/>
    </Expander>

  </StackPanel>
</Border>
"""

        guard let root = try? XamlReader.load(xaml) as? UIElement else {
            return makeXamlLoadErrorCard()
        }

        wireUpSizingToggle(root)
        return root
    }

    private func wireUpSizingToggle(_ root: UIElement) {
        guard let fe = root as? FrameworkElement else { return }

        let formPanel = (try? fe.findName("FormPanel")) as? StackPanel
        let title = (try? fe.findName("FormTitle")) as? TextBlock

        let first = (try? fe.findName("FirstNameBox")) as? TextBox
        let last = (try? fe.findName("LastNameBox")) as? TextBox
        let pwd = (try? fe.findName("PasswordBox")) as? PasswordBox
        let confirm = (try? fe.findName("ConfirmPasswordBox")) as? PasswordBox
        let date = (try? fe.findName("DatePicker")) as? DatePicker

        let rbStandard = (try? fe.findName("StandardRadio")) as? RadioButton
        let rbCompact = (try? fe.findName("CompactRadio")) as? RadioButton

        let apply: (Bool) -> Void = { isCompact in
            title?.text = isCompact ? "Compact Size" : "Standard Size"
            formPanel?.spacing = isCompact ? 8 : 12

            // “Compact” here is a lightweight approximation via sizing tweaks.
            // (WinUI’s official density styles are shown in the source snippet.)
            let h: Double = isCompact ? 28 : 36
            let fs: Double = isCompact ? 12 : 14

            // Controls
            if let c = first { c.height = h; c.fontSize = fs }
            if let c = last { c.height = h; c.fontSize = fs }
            if let c = pwd { c.height = h; c.fontSize = fs }
            if let c = confirm { c.height = h; c.fontSize = fs }
            if let c = date { c.fontSize = fs }
        }

        // Initial state
        apply(false)

        rbStandard?.click.addHandler { _, _ in
            apply(false)
        }
        rbCompact?.click.addHandler { _, _ in
            apply(true)
        }
    }

    // MARK: - XAML source snippet

    private func compactSizingXamlSource() -> String {
        return """
<Page.Resources>
  <ResourceDictionary Source="ms-appx:///Microsoft.UI.Xaml/DensityStyles/Compact.xaml" />
</Page.Resources>
"""
    }

    private func escapeForXamlAttribute(_ text: String) -> String {
        var s = text
        s = s.replacingOccurrences(of: "&", with: "&amp;")
        s = s.replacingOccurrences(of: "<", with: "&lt;")
        s = s.replacingOccurrences(of: ">", with: "&gt;")
        s = s.replacingOccurrences(of: "\"", with: "&quot;")
        s = s.replacingOccurrences(of: "\r\n", with: "&#10;")
        s = s.replacingOccurrences(of: "\n", with: "&#10;")
        s = s.replacingOccurrences(of: "\r", with: "&#10;")
        return s
    }

    // MARK: - Common helpers

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

    private func makeXamlLoadErrorCard() -> Border {
        let border = Border()
        border.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = createBrush(r: 120, g: 60, b: 60, a: 200)
        border.background = createBrush(r: 35, g: 25, b: 25)
        border.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)

        let tb = TextBlock()
        tb.text = "Failed to load XAML for Compact Sizing demo."
        tb.textWrapping = .wrap
        tb.opacity = 0.9
        border.child = tb
        return border
    }

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
