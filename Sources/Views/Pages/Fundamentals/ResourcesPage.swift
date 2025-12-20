import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

// WinUI 3 Gallery - Resources
final class ResourcesPage: Grid {

    private var mainScrollViewer: ScrollViewer!
    private var contentStackPanel: StackPanel!

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

        // Header
        contentStackPanel.children.append(createHeader())

        // Overview
        contentStackPanel.children.append(createOverview())

        // Section 1
        contentStackPanel.children.append(createCreatingAndUsingSection())

        // Section 2
        contentStackPanel.children.append(createThemeResourcesSection())

        mainScrollViewer.content = contentStackPanel
        children.append(mainScrollViewer)
    }

    // MARK: - Header

    private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 12

        let titleText = TextBlock()
        titleText.text = "Resources"
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

    private func createOverview() -> TextBlock {
        let desc = TextBlock()
        desc.text = """
In WinUI 3, XAML resources are reusable objects like colors, brushes, or strings, defined once and used throughout your app to maintain consistency and simplify updates. These resources are typically stored in a ResourceDictionary for better organization and scalability. Special theme resources adapt automatically to light or dark modes, ensuring a seamless look across themes.
"""
        desc.fontSize = 14
        desc.textWrapping = .wrap
        desc.opacity = 0.85
        return desc
    }

    // MARK: - Section: Creating and using XAML resources

    private func createCreatingAndUsingSection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12

        let title = sectionTitle("Creating and using XAML resources")
        panel.children.append(title)

        let body = TextBlock()
        body.text = "XAML Resources are defined using the ResourceDictionary element. The important parts are the resource's key (a unique identifier) and the value (like a color or brush)."
        body.fontSize = 14
        body.textWrapping = .wrap
        body.opacity = 0.85
        panel.children.append(body)

        panel.children.append(bulletList([
            "App-level: Resources are defined globally, accessible throughout the application.",
            "Page-level: Resources are defined specific to a particular page.",
            "Control-level: Resources are defined local to a specific control, such as a Button or Grid."
        ]))

        let tipsHeader = TextBlock()
        tipsHeader.text = "Tips:"
        tipsHeader.fontSize = 14
        tipsHeader.fontWeight = FontWeights.semiBold
        tipsHeader.margin = Thickness(left: 0, top: 8, right: 0, bottom: 0)
        panel.children.append(tipsHeader)

        panel.children.append(bulletList([
            "Naming: descriptive keys should always be used for resources to make them easier to identify.",
            "Scope: Resources should be defined at the narrowest scope possible to improve maintainability.",
            "Access: {StaticResource Key} is used in XAML for most cases, and Resources[\"Key\"] is used in C# for runtime access."
        ]))

        panel.children.append(createResourceScopeDemoCard())
        panel.children.append(makeSourceCodeSection(tabs: [
            ("XAML", resourcesXamlSource()),
            ("C#", resourcesCSharpSource())
        ]))

        return panel
    }

    private func createResourceScopeDemoCard() -> Border {
        let demoBorder = createCardBorder()

        let stack = StackPanel()
        stack.spacing = 12

        let descText = TextBlock()
        descText.text = "This example shows how the same UI can be built using resources defined at different scopes."
        descText.fontSize = 14
        descText.textWrapping = .wrap
        descText.margin = Thickness(left: 0, top: 0, right: 0, bottom: 8)
        stack.children.append(descText)

        // Visual sample (nested)
        let outer = Border()
        outer.background = createBrushHex("#0078D4")
        outer.cornerRadius = CornerRadius(topLeft: 6, topRight: 6, bottomRight: 6, bottomLeft: 6)
        outer.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)

        let outerStack = StackPanel()
        outerStack.spacing = 12

        let outerTitle = TextBlock()
        outerTitle.text = "Using application-level resources"
        outerTitle.fontSize = 22
        outerTitle.fontWeight = FontWeights.semiBold
        outerTitle.foreground = createBrush(r: 255, g: 255, b: 255)
        outerStack.children.append(outerTitle)

        let mid = Border()
        mid.background = createBrushHex("#A94DC1")
        mid.cornerRadius = CornerRadius(topLeft: 6, topRight: 6, bottomRight: 6, bottomLeft: 6)
        mid.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        mid.margin = Thickness(left: 0, top: 0, right: 0, bottom: 0)

        let midStack = StackPanel()
        midStack.spacing = 12

        let midTitle = TextBlock()
        midTitle.text = "Using page-level resources"
        midTitle.fontSize = 16
        midTitle.fontWeight = FontWeights.semiBold
        midTitle.foreground = createBrush(r: 255, g: 255, b: 255)
        midStack.children.append(midTitle)

        let inner = Border()
        inner.background = createBrushHex("#E2241A")
        inner.cornerRadius = CornerRadius(topLeft: 6, topRight: 6, bottomRight: 6, bottomLeft: 6)
        inner.padding = Thickness(left: 12, top: 12, right: 12, bottom: 12)

        let innerText = TextBlock()
        innerText.text = "Using control-level resources"
        innerText.foreground = createBrush(r: 255, g: 255, b: 255)
        innerText.fontSize = 14
        innerText.textWrapping = .wrap
        inner.child = innerText

        midStack.children.append(inner)
        mid.child = midStack

        outerStack.children.append(mid)
        outer.child = outerStack

        stack.children.append(outer)

        demoBorder.child = stack
        return demoBorder
    }

    // MARK: - Section: Theme resources

    private func createThemeResourcesSection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12

        let title = sectionTitle("Theme resources")
        panel.children.append(title)

        let desc = TextBlock()
        desc.text = "WinUI includes built-in theme resources for commonly used colors. Theme resources automatically update when the theme changes."
        desc.fontSize = 14
        desc.textWrapping = .wrap
        desc.opacity = 0.85
        panel.children.append(desc)

        panel.children.append(bulletList([
            "ThemeResource is used for dynamic theme-based updates.",
            "ThemeDictionaries are defined to provide different values for light and dark themes.",
            "A fallback value should always be provided to ensure compatibility with undefined themes."
        ]))

        // StaticResource vs ThemeResource
        let subTitle = subsectionTitle("StaticResource versus ThemeResource")
        panel.children.append(subTitle)
        panel.children.append(callout("Toggle the theme using the theme switch button in the top right corner."))

        panel.children.append(createStaticVsThemeDemoCard())
        panel.children.append(makeSourceCodeSection(tabs: [
            ("XAML", staticVsThemeXamlSource())
        ]))

        // Define a new theme resource
        let subTitle2 = subsectionTitle("Define a new theme resource")
        panel.children.append(subTitle2)
        panel.children.append(callout("Toggle the theme using the theme switch button in the top right corner."))

        panel.children.append(createDefineThemeResourceDemoCard())
        panel.children.append(makeSourceCodeSection(tabs: [
            ("XAML", defineThemeResourceXamlSource())
        ]))

        return panel
    }

    private func createStaticVsThemeDemoCard() -> Border {
        let demoBorder = createCardBorder()

        let stack = StackPanel()
        stack.spacing = 12

        let descText = TextBlock()
        descText.text = "StaticResource resolves once and doesn't update when theme changes. ThemeResource updates automatically."
        descText.fontSize = 14
        descText.textWrapping = .wrap
        descText.margin = Thickness(left: 0, top: 0, right: 0, bottom: 8)
        stack.children.append(descText)

        let container = Border()
        container.background = createBrush(r: 25, g: 25, b: 25)
        container.cornerRadius = CornerRadius(topLeft: 6, topRight: 6, bottomRight: 6, bottomLeft: 6)
        container.padding = Thickness(left: 0, top: 0, right: 0, bottom: 0)

        let innerStack = StackPanel()
        innerStack.spacing = 0

        let row1 = Border()
        row1.background = createBrush(r: 245, g: 245, b: 245) // mimic StaticResource resolved at load
        row1.padding = Thickness(left: 12, top: 12, right: 12, bottom: 12)

        let t1 = TextBlock()
        t1.text = "StaticResource uses the value defined when the app starts and does not update when the theme changes."
        t1.fontSize = 14
        t1.textWrapping = .wrap
        t1.foreground = createBrush(r: 0, g: 0, b: 0)
        row1.child = t1

        let row2 = Border()
        row2.background = createBrush(r: 40, g: 40, b: 40) // mimic ThemeResource for dark
        row2.padding = Thickness(left: 12, top: 12, right: 12, bottom: 12)

        let t2 = TextBlock()
        t2.text = "ThemeResource adapts automatically to the current theme. If the app switches from light to dark, the color defined by ThemeResource changes."
        t2.fontSize = 14
        t2.textWrapping = .wrap
        t2.foreground = createBrush(r: 255, g: 255, b: 255)
        row2.child = t2

        innerStack.children.append(row1)
        innerStack.children.append(row2)

        container.child = innerStack
        stack.children.append(container)

        demoBorder.child = stack
        return demoBorder
    }

    private func createDefineThemeResourceDemoCard() -> Border {
        let demoBorder = createCardBorder()

        let stack = StackPanel()
        stack.spacing = 12

        let descText = TextBlock()
        descText.text = "This example defines custom theme resources using ThemeDictionaries, then consumes them via ThemeResource."
        descText.fontSize = 14
        descText.textWrapping = .wrap
        descText.margin = Thickness(left: 0, top: 0, right: 0, bottom: 8)
        stack.children.append(descText)

        // Use XamlReader for real ThemeDictionaries + ThemeResource behavior.
        if let themed = makeThemedDemoElement() {
            stack.children.append(themed)
        } else {
            let fail = TextBlock()
            fail.text = "(Theme demo failed to load)"
            stack.children.append(fail)
        }

        demoBorder.child = stack
        return demoBorder
    }

    private func makeThemedDemoElement() -> UIElement? {
        // NOTE: Replace the image UriSource if your assets differ.
        let xaml = """
<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
      xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
  <Grid.Resources>
    <ResourceDictionary>
      <ResourceDictionary.ThemeDictionaries>
        <ResourceDictionary x:Key="Default">
          <SolidColorBrush x:Key="BackgroundBrush" Color="#EEEEEE" />
          <SolidColorBrush x:Key="TextBrush" Color="#333333" />
          <x:String x:Key="ThemeString">Light theme</x:String>
          <BitmapImage x:Key="ThemeImage" UriSource="ms-appx:///Assets/2.jpg" />
        </ResourceDictionary>
        <ResourceDictionary x:Key="Dark">
          <SolidColorBrush x:Key="BackgroundBrush" Color="#333333" />
          <SolidColorBrush x:Key="TextBrush" Color="#EEEEEE" />
          <x:String x:Key="ThemeString">Dark theme</x:String>
          <BitmapImage x:Key="ThemeImage" UriSource="ms-appx:///Assets/2.jpg" />
        </ResourceDictionary>
      </ResourceDictionary.ThemeDictionaries>
    </ResourceDictionary>
  </Grid.Resources>

  <StackPanel MaxWidth="700" Padding="12"
              HorizontalAlignment="Center" VerticalAlignment="Center"
              Background="{ThemeResource BackgroundBrush}">
    <TextBlock Text="{ThemeResource ThemeString}"
               Foreground="{ThemeResource TextBrush}"
               FontSize="18" FontWeight="SemiBold"
               Margin="0,0,0,8" />
    <Border CornerRadius="6" BorderThickness="1" BorderBrush="#66000000" Height="220">
      <Image Source="{ThemeResource ThemeImage}" Stretch="UniformToFill" />
    </Border>
  </StackPanel>
</Grid>
"""
        guard let el = try? XamlReader.load(xaml) as? UIElement else { return nil }
        return el
    }

    // MARK: - Helpers: typography & layout

    private func sectionTitle(_ text: String) -> TextBlock {
        let tb = TextBlock()
        tb.text = text
        tb.fontSize = 20
        tb.fontWeight = FontWeights.semiBold
        tb.margin = Thickness(left: 0, top: 12, right: 0, bottom: 0)
        return tb
    }

    private func subsectionTitle(_ text: String) -> TextBlock {
        let tb = TextBlock()
        tb.text = text
        tb.fontSize = 16
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

    private func callout(_ text: String) -> Border {
        let border = Border()
        border.cornerRadius = CornerRadius(topLeft: 6, topRight: 6, bottomRight: 6, bottomLeft: 6)
        border.padding = Thickness(left: 12, top: 10, right: 12, bottom: 10)
        border.background = createBrush(r: 240, g: 240, b: 240)

        let tb = TextBlock()
        tb.text = text
        tb.fontSize = 13
        tb.textWrapping = .wrap
        tb.opacity = 0.85
        border.child = tb
        return border
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

    // MARK: - Source strings

    private func resourcesXamlSource() -> String {
        return """
<!-- App.xaml -->
<Application>
  <Application.Resources>
    <!-- Define an application-wide color resource -->
    <Color x:Key=\\"PrimaryColor\\">#0078D4</Color>
  </Application.Resources>
</Application>

<!-- YourPage.xaml -->
<Page xmlns=\\"http://schemas.microsoft.com/winfx/2006/xaml/presentation\\"
      xmlns:x=\\"http://schemas.microsoft.com/winfx/2006/xaml\\">
  <Page.Resources>
    <!-- Define page-level solid color brushes -->
    <SolidColorBrush x:Key=\\"HighlightBrush\\" Color=\\"#A94DC1\\" />
    <SolidColorBrush x:Key=\\"FontColor\\" Color=\\"White\\" />
  </Page.Resources>

  <!-- StackPanel using the application-level resource 'PrimaryColor' -->
  <StackPanel Background=\\"{StaticResource PrimaryColor}\\" Padding=\\"8\\">
    <TextBlock Text=\\"Using application-level resources\\" Foreground=\\"White\\" FontSize=\\"24\\" />

    <!-- StackPanel using the page-level resource 'HighlightBrush' -->
    <StackPanel Background=\\"{StaticResource HighlightBrush}\\" Padding=\\"8\\" Margin=\\"8\\">
      <TextBlock Text=\\"Using page-level resources\\" Foreground=\\"{StaticResource FontColor}\\" FontSize=\\"18\\" />

      <!-- StackPanel with control-level resources defined within its own Resources -->
      <StackPanel Padding=\\"8\\" Margin=\\"8\\">
        <StackPanel.Resources>
          <!-- Define control-level resources -->
          <Color x:Key=\\"BackgroundColor\\">#E2241A</Color>
          <x:String x:Key=\\"Description\\">Using control-level resources</x:String>
        </StackPanel.Resources>

        <Grid Background=\\"{StaticResource BackgroundColor}\\" Padding=\\"8\\">
          <TextBlock Text=\\"{StaticResource Description}\\" Foreground=\\"White\\" />
        </Grid>
      </StackPanel>
    </StackPanel>
  </StackPanel>
</Page>
"""
    }

    private func resourcesCSharpSource() -> String {
        return """
// App-level resource
var primary = (Windows.UI.Color)Application.Current.Resources[\\"PrimaryColor\\"];

// Page-level resource
var highlightBrush = (SolidColorBrush)Resources[\\"HighlightBrush\\"];

// Control-level resource (from a specific control's Resources)
var description = (string)someStackPanel.Resources[\\"Description\\"];
"""
    }

    private func staticVsThemeXamlSource() -> String {
        return """
<StackPanel>
  <Grid Background=\\"{StaticResource SolidBackgroundFillColorBaseBrush}\\">
    <TextBlock
      Text=\\"StaticResource uses the value defined when the app starts and does not update when the theme changes.\\"
      Foreground=\\"{StaticResource TextFillColorPrimaryBrush}\\"
      FontSize=\\"16\\"
      TextWrapping=\\"Wrap\\" />
  </Grid>

  <Grid Background=\\"{ThemeResource SolidBackgroundFillColorBaseBrush}\\">
    <TextBlock
      Text=\\"ThemeResource adapts automatically to the current theme. If the app switches from Light to Dark, the color defined by ThemeResource changes.\\"
      Foreground=\\"{ThemeResource TextFillColorPrimaryBrush}\\"
      FontSize=\\"16\\"
      TextWrapping=\\"Wrap\\" />
  </Grid>
</StackPanel>
"""
    }

    private func defineThemeResourceXamlSource() -> String {
        return """
<Grid>
  <Grid.Resources>
    <ResourceDictionary>
      <ResourceDictionary.ThemeDictionaries>
        <ResourceDictionary x:Key=\\"Default\\">
          <SolidColorBrush x:Key=\\"BackgroundBrush\\" Color=\\"#EEEEEE\\" />
          <SolidColorBrush x:Key=\\"TextBrush\\" Color=\\"#333333\\" />
          <x:String x:Key=\\"ThemeString\\">Light theme</x:String>
          <BitmapImage x:Key=\\"ThemeImage\\" UriSource=\\"ms-appx:///Assets/2.jpg\\" />
        </ResourceDictionary>

        <ResourceDictionary x:Key=\\"Dark\\">
          <SolidColorBrush x:Key=\\"BackgroundBrush\\" Color=\\"#333333\\" />
          <SolidColorBrush x:Key=\\"TextBrush\\" Color=\\"#EEEEEE\\" />
          <x:String x:Key=\\"ThemeString\\">Dark theme</x:String>
          <BitmapImage x:Key=\\"ThemeImage\\" UriSource=\\"ms-appx:///Assets/2.jpg\\" />
        </ResourceDictionary>
      </ResourceDictionary.ThemeDictionaries>
    </ResourceDictionary>
  </Grid.Resources>

  <StackPanel Background=\\"{ThemeResource BackgroundBrush}\\" Padding=\\"12\\" MaxWidth=\\"700\\"
              HorizontalAlignment=\\"Center\\" VerticalAlignment=\\"Center\\">
    <TextBlock Text=\\"{ThemeResource ThemeString}\\" Foreground=\\"{ThemeResource TextBrush}\\" FontSize=\\"18\\" />
    <Image Source=\\"{ThemeResource ThemeImage}\\" Height=\\"220\\" Stretch=\\"UniformToFill\\" />
  </StackPanel>
</Grid>
"""
    }

    // MARK: - Brush helpers

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
        // Supports: #RRGGBB or #AARRGGBB
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("#") { s.removeFirst() }

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
}
