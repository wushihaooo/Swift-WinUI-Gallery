import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

// WinUI 3 Gallery - ThemeShadow
final class ThemeShadowPage: Grid {

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
        contentStackPanel.spacing = 16

        contentStackPanel.children.append(createHeader())

        let desc = TextBlock()
        desc.text = "Adds a realistic shadow effect to UI elements using the system's lighting and depth to enhance visual hierarchy."
        desc.textWrapping = .wrap
        desc.opacity = 0.85
        desc.margin = Thickness(left: 0, top: 2, right: 0, bottom: 12)
        contentStackPanel.children.append(desc)

        let sectionHeader = TextBlock()
        sectionHeader.text = "ThemeShadow applied to a Border"
        sectionHeader.fontSize = 16
        sectionHeader.fontWeight = FontWeights.semiBold
        sectionHeader.margin = Thickness(left: 0, top: 0, right: 0, bottom: 6)
        contentStackPanel.children.append(sectionHeader)

        contentStackPanel.children.append(makeThemeShadowCard())

        mainScrollViewer.content = contentStackPanel
        children.append(mainScrollViewer)
    }

    // MARK: - Header

    private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 12

        let titleRow = StackPanel()
        titleRow.orientation = .horizontal
        titleRow.spacing = 10

        let titleText = TextBlock()
        titleText.text = "ThemeShadow"
        titleText.fontSize = 32
        titleText.fontWeight = FontWeights.semiBold
        titleRow.children.append(titleText)

        let info = TextBlock()
        info.text = "ⓘ"
        info.fontSize = 14
        info.opacity = 0.6
        info.verticalAlignment = .center
        titleRow.children.append(info)

        headerPanel.children.append(titleRow)

        let tabsPanel = StackPanel()
        tabsPanel.orientation = .horizontal
        tabsPanel.spacing = 16

        let docText = TextBlock()
        docText.text = "Documentation"
        docText.fontSize = 14
        docText.fontWeight = FontWeights.semiBold
        docText.foreground = createAccentBrush()
        docText.padding = Thickness(left: 12, top: 6, right: 12, bottom: 6)
        tabsPanel.children.append(docText)

        let sourceText = TextBlock()
        sourceText.text = "Source"
        sourceText.fontSize = 14
        sourceText.opacity = 0.6
        sourceText.padding = Thickness(left: 12, top: 6, right: 12, bottom: 6)
        tabsPanel.children.append(sourceText)

        headerPanel.children.append(tabsPanel)
        return headerPanel
    }

    // MARK: - Card

    private func makeThemeShadowCard() -> UIElement {
        let cardXaml = """
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

      <!-- Demo area -->
      <Border Background="#1B1B1B"
              Padding="16">
        <Grid x:Name="DemoGrid"
              MinHeight="260">
          <!-- Receiver surface (ThemeShadow 需要 receivers 才会显示) -->
          <Grid x:Name="ShadowCastGrid"
                Background="Transparent"/>

          <!-- Shadow caster -->
          <Border x:Name="ShadowRect"
                  Width="200"
                  Height="200"
                  HorizontalAlignment="Center"
                  VerticalAlignment="Center"
                  CornerRadius="8"
                  Background="#2A2A2A"
                  Translation="0,0,46">
            <Border.Shadow>
              <ThemeShadow x:Name="shadow"/>
            </Border.Shadow>
          </Border>
        </Grid>
      </Border>

      <!-- Controls -->
      <Border Grid.Column="1"
              BorderBrush="{ThemeResource CardStrokeColorDefaultBrush}"
              BorderThickness="1,0,0,0">
        <StackPanel Padding="16"
                    Spacing="8">
          <TextBlock Text="Z-translation"
                     FontWeight="SemiBold"/>
          <Slider x:Name="ZSlider"
                  Minimum="0"
                  Maximum="80"
                  Value="46"/>
          <TextBlock x:Name="ZValueText"
                     Text="46"
                     Opacity="0.7"/>
        </StackPanel>
      </Border>
    </Grid>

    <!-- Divider -->
    <Border Height="1"
            Background="{ThemeResource CardStrokeColorDefaultBrush}"
            Opacity="0.6"/>

    <Expander Header="Source code">
      <Grid x:Name="SourceHost"
            Padding="16,12,16,16"/>
    </Expander>
  </StackPanel>
</Border>
"""

        guard let el = try? XamlReader.load(cardXaml) as? UIElement else {
            return makeXamlLoadErrorCard()
        }

        if let fe = el as? FrameworkElement {
            wireUpDemo(fe: fe)
            populateSourceCode(fe: fe)
        }

        return el
    }

    private func wireUpDemo(fe: FrameworkElement) {
        let shadowRect = (try? fe.findName("ShadowRect")) as? Border
        let castGrid = (try? fe.findName("ShadowCastGrid")) as? UIElement
        let slider = (try? fe.findName("ZSlider")) as? Slider
        let valueText = (try? fe.findName("ZValueText")) as? TextBlock
        let shadow = (try? fe.findName("shadow")) as? ThemeShadow

        // ThemeShadow receivers（关键：否则大概率看不到阴影）
        if let shadow = shadow, let receiver = castGrid {
            shadow.receivers.append(receiver)
        }

        let applyZ: (Double) -> Void = { z in
            valueText?.text = String(format: "%.0f", z)
            guard let rect = shadowRect else { return }

            // UIElement.Translation = Vector3(x,y,z)
            var v = Vector3()
            v.x = 0
            v.y = 0
            v.z = Float(z)
            rect.translation = v
        }

        applyZ(slider?.value ?? 46)

        slider?.valueChanged.addHandler { _, args in
            guard let args = args else { return }
            applyZ(args.newValue)
        }
    }

    private func populateSourceCode(fe: FrameworkElement) {
        guard let host = (try? fe.findName("SourceHost")) as? Panel else { return }

        let tabView = TabView()
        tabView.tabWidthMode = .sizeToContent
        tabView.isAddTabButtonVisible = false
        tabView.canReorderTabs = false

        let xamlItem = TabViewItem()
        xamlItem.header = "XAML"
        xamlItem.isClosable = false
        let xamlBox = makeCodeBox()
        xamlBox.text = themeShadowXamlSnippet()
        xamlItem.content = xamlBox
        tabView.tabItems.append(xamlItem)

        let csItem = TabViewItem()
        csItem.header = "C#"
        csItem.isClosable = false
        let csBox = makeCodeBox()
        csBox.text = themeShadowCSharpSnippet()
        csItem.content = csBox
        tabView.tabItems.append(csItem)

        host.children.append(tabView)
    }

    private func makeCodeBox() -> TextBox {
        let tb = TextBox()
        tb.isReadOnly = true
        tb.acceptsReturn = true
        tb.textWrapping = .noWrap
        tb.fontFamily = FontFamily("Cascadia Code, Consolas, monospace")
        tb.fontSize = 12
        tb.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        tb.background = nil
        return tb
    }

    private func themeShadowXamlSnippet() -> String {
        return """
<Grid>
  <Grid x:Name="ShadowCastGrid"/>

  <Border x:Name="ShadowRect"
          Width="200"
          Height="200"
          Translation="0,0,46">
    <Border.Shadow>
      <ThemeShadow x:Name="shadow"/>
    </Border.Shadow>
  </Border>
</Grid>
"""
    }

    private func themeShadowCSharpSnippet() -> String {
        return """
private void ShadowRect_Loaded(object sender, RoutedEventArgs e)
{
    shadow.Receivers.Add(ShadowCastGrid);
}

// Update elevation (Z) based on a slider value:
ShadowRect.Translation = new Vector3(0, 0, (float)ZSlider.Value);
"""
    }

    // MARK: - Helpers

    private func makeXamlLoadErrorCard() -> Border {
        let border = Border()
        border.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = createBrush(r: 120, g: 60, b: 60, a: 200)
        border.background = createBrush(r: 35, g: 25, b: 25)
        border.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)

        let tb = TextBlock()
        tb.text = "Failed to load XAML for ThemeShadow demo."
        tb.textWrapping = .wrap
        tb.opacity = 0.9
        border.child = tb
        return border
    }

    private func createAccentBrush() -> SolidColorBrush {
        return createBrush(r: 0, g: 120, b: 215)
    }

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
}
