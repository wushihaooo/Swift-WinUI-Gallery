import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

// WinUI 3 Gallery - IconElement
final class IconElementPage: Grid {

    // 资源前缀：<package>_<target>.resources
    // 你项目里其它页面（例如 ImagePage）就是用这个前缀来访问被 SwiftPM 打包进 bundle 的资源。
    private let resPrefix = "Swift-WinUI-Gallery_SwiftWinUIGallery.resources"

    private var mainScrollViewer: ScrollViewer!
    private var contentStackPanel: StackPanel!

    override init() {
        super.init()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        mainScrollViewer = ScrollViewer()
        mainScrollViewer.horizontalScrollBarVisibility = .disabled
        mainScrollViewer.verticalScrollBarVisibility = .auto

        contentStackPanel = StackPanel()
        contentStackPanel.padding = Thickness(left: 40, top: 24, right: 40, bottom: 40)
        contentStackPanel.spacing = 16

        // Header
        contentStackPanel.children.append(createHeader())

        // Description
        let desc = TextBlock()
        desc.text = "Represents icon controls that use different image types as its content."
        desc.textWrapping = .wrap
        desc.opacity = 0.85
        desc.margin = Thickness(left: 0, top: 2, right: 0, bottom: 10)
        contentStackPanel.children.append(desc)

        // Sections
        contentStackPanel.children.append(makeBitmapIconSection())
        contentStackPanel.children.append(makeFontIconSection())
        contentStackPanel.children.append(makeImageIconBitmapSection())
        contentStackPanel.children.append(makeImageIconSvgSection())
        contentStackPanel.children.append(makePathIconSection())
        contentStackPanel.children.append(makeSymbolIconSection())

        mainScrollViewer.content = contentStackPanel
        children.append(mainScrollViewer)
    }

    // MARK: - Header

    private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 12

        // Title + info hint
        let titleRow = StackPanel()
        titleRow.orientation = .horizontal
        titleRow.spacing = 10

        let titleText = TextBlock()
        titleText.text = "IconElement"
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

        // Documentation / Source "tabs"
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

    // MARK: - Sections

    private func makeBitmapIconSection() -> UIElement {
        let section = StackPanel()
        section.spacing = 10

        let header = TextBlock()
        header.text = "A BitmapIcon with a multicolor bitmap image"
        header.fontSize = 16
        header.fontWeight = FontWeights.semiBold
        section.children.append(header)

        let cardXaml = """
<Border xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Padding="0"
        CornerRadius="8"
        Background="{ThemeResource CardBackgroundFillColorDefaultBrush}"
        BorderBrush="{ThemeResource CardStrokeColorDefaultBrush}"
        BorderThickness="1">
  <StackPanel>
    <Grid Padding="16">
      <Grid.ColumnDefinitions>
        <ColumnDefinition Width="*" />
        <ColumnDefinition Width="220" />
      </Grid.ColumnDefinitions>

      <StackPanel Spacing="12">
        <TextBlock TextWrapping="Wrap">
          The ShowAsMonochrome property (true by default) will result in a solid block of the foreground color if the property is set to true and the icon is more than one color. This behavior can be ignored by setting the ShowAsMonochrome property to false.
        </TextBlock>

        <BitmapIcon x:Name="SlicesIcon"
                    UriSource="ms-appx:///\(resPrefix)/Assets/ControlImages/CodeTagIcon.png"
                    Width="50"
                    ShowAsMonochrome="{Binding ElementName=MonochromeCheckBox, Path=IsChecked}" />
      </StackPanel>

      <StackPanel Grid.Column="1"
                  HorizontalAlignment="Right"
                  VerticalAlignment="Top"
                  Spacing="8">
        <CheckBox x:Name="MonochromeCheckBox"
                  Content="Monochrome"
                  IsThreeState="False"/>
      </StackPanel>
    </Grid>

    <Expander Header="Source code">
      <StackPanel Spacing="8" Padding="16,12,16,16">
        <TextBlock Text="XAML" FontWeight="SemiBold" />
        <TextBox x:Name="CodeBox"
                 IsReadOnly="True"
                 AcceptsReturn="True"
                 TextWrapping="NoWrap"
                 BorderThickness="0"
                 Background="Transparent"
                 FontFamily="Cascadia Code, Consolas, monospace" />
      </StackPanel>
    </Expander>
  </StackPanel>
</Border>
"""
        let xamlCode = """
<BitmapIcon x:Name="SlicesIcon"
           UriSource="ms-appx:///\(resPrefix)/Assets/ControlImages/CodeTagIcon.png"
           Width="50"
           ShowAsMonochrome="False" />
"""

        return loadCard(cardXaml: cardXaml, code: xamlCode)
    }

    private func makeFontIconSection() -> UIElement {
        let section = StackPanel()
        section.spacing = 10

        let header = TextBlock()
        header.text = "A FontIcon using a glyph from a specific font family in a button"
        header.fontSize = 16
        header.fontWeight = FontWeights.semiBold
        section.children.append(header)

        let desc = TextBlock()
        desc.text = "Use FontIcon as the icon for a control if you want to specify a Glyph value from a FontFamily. Windows 10 uses the Segoe MDL2 Assets FontFamily and that is what this example is showing."
        desc.textWrapping = .wrap
        desc.opacity = 0.85
        section.children.append(desc)

        let cardXaml = """
<Border xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Padding="16"
        CornerRadius="8"
        Background="{ThemeResource CardBackgroundFillColorDefaultBrush}"
        BorderBrush="{ThemeResource CardStrokeColorDefaultBrush}"
        BorderThickness="1">
  <StackPanel Spacing="12">
    <Button x:Name="ExampleButton1" Width="44" Height="44">
      <FontIcon FontFamily="Segoe MDL2 Assets" Glyph="&#xE790;"/>
    </Button>

    <Expander Header="Source code">
      <StackPanel Spacing="8" Padding="0,12,0,0">
        <TextBlock Text="XAML" FontWeight="SemiBold" />
        <TextBox x:Name="CodeBox"
                 IsReadOnly="True"
                 AcceptsReturn="True"
                 TextWrapping="NoWrap"
                 BorderThickness="0"
                 Background="Transparent"
                 FontFamily="Cascadia Code, Consolas, monospace" />
      </StackPanel>
    </Expander>
  </StackPanel>
</Border>
"""
        let xamlCode = """
<Button Name="ExampleButton1">
    <FontIcon FontFamily="Segoe MDL2 Assets" Glyph="&#xE790;"/>
</Button>
"""
        return loadCard(cardXaml: cardXaml, code: xamlCode)
    }

    private func makeImageIconBitmapSection() -> UIElement {
        let section = StackPanel()
        section.spacing = 10

        let header = TextBlock()
        header.text = "A ImageIcon using a bitmap image in a button"
        header.fontSize = 16
        header.fontWeight = FontWeights.semiBold
        section.children.append(header)

        let desc = TextBlock()
        desc.text = "To use an ImageIcon as the icon for a control, you can set image that has a file format supported by the Image class."
        desc.textWrapping = .wrap
        desc.opacity = 0.85
        section.children.append(desc)

        let cardXaml = """
<Border xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Padding="16"
        CornerRadius="8"
        Background="{ThemeResource CardBackgroundFillColorDefaultBrush}"
        BorderBrush="{ThemeResource CardStrokeColorDefaultBrush}"
        BorderThickness="1">
  <StackPanel Spacing="12">
    <Button x:Name="ImageExample1" Width="100" Height="100">
      <ImageIcon Source="ms-appx:///\(resPrefix)/Assets/ControlImages/CodeTagIcon.png"/>
    </Button>

    <Expander Header="Source code">
      <StackPanel Spacing="8" Padding="0,12,0,0">
        <TextBlock Text="XAML" FontWeight="SemiBold" />
        <TextBox x:Name="CodeBox"
                 IsReadOnly="True"
                 AcceptsReturn="True"
                 TextWrapping="NoWrap"
                 BorderThickness="0"
                 Background="Transparent"
                 FontFamily="Cascadia Code, Consolas, monospace" />
      </StackPanel>
    </Expander>
  </StackPanel>
</Border>
"""
        let xamlCode = """
<Button Name="ImageExample1" Width="100">
    <ImageIcon Source="ms-appx:///\(resPrefix)/Assets/ControlImages/CodeTagIcon.png"/>
</Button>
"""
        return loadCard(cardXaml: cardXaml, code: xamlCode)
    }

    private func makeImageIconSvgSection() -> UIElement {
        let section = StackPanel()
        section.spacing = 10

        let header = TextBlock()
        header.text = "A ImageIcon using a SVG image in a button"
        header.fontSize = 16
        header.fontWeight = FontWeights.semiBold
        section.children.append(header)

        let cardXaml = """
<Border xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Padding="16"
        CornerRadius="8"
        Background="{ThemeResource CardBackgroundFillColorDefaultBrush}"
        BorderBrush="{ThemeResource CardStrokeColorDefaultBrush}"
        BorderThickness="1">
  <StackPanel Spacing="12">
    <Button x:Name="ImageExample2" Width="100" Height="100">
      <ImageIcon Source="https://raw.githubusercontent.com/DiemenDesign/LibreICONS/master/svg-color/libre-camera-panorama.svg"
                 Width="50"/>
    </Button>

    <Expander Header="Source code">
      <StackPanel Spacing="8" Padding="0,12,0,0">
        <TextBlock Text="XAML" FontWeight="SemiBold" />
        <TextBox x:Name="CodeBox"
                 IsReadOnly="True"
                 AcceptsReturn="True"
                 TextWrapping="NoWrap"
                 BorderThickness="0"
                 Background="Transparent"
                 FontFamily="Cascadia Code, Consolas, monospace" />
      </StackPanel>
    </Expander>
  </StackPanel>
</Border>
"""
        let xamlCode = """
<Button Name="ImageExample2" Width="100">
    <ImageIcon Source="https://raw.githubusercontent.com/DiemenDesign/LibreICONS/master/svg-color/libre-camera-panorama.svg"
              Width="50"/>
</Button>
"""
        return loadCard(cardXaml: cardXaml, code: xamlCode)
    }

    private func makePathIconSection() -> UIElement {
        let section = StackPanel()
        section.spacing = 10

        let header = TextBlock()
        header.text = "A PathIcon in a button"
        header.fontSize = 16
        header.fontWeight = FontWeights.semiBold
        section.children.append(header)

        let desc = TextBlock()
        desc.text = "To use a PathIcon as the icon for a control, you specify the path data of the image you are trying to display. The path data draws a series of connected lines and curves."
        desc.textWrapping = .wrap
        desc.opacity = 0.85
        section.children.append(desc)

        let cardXaml = """
<Border xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Padding="16"
        CornerRadius="8"
        Background="{ThemeResource CardBackgroundFillColorDefaultBrush}"
        BorderBrush="{ThemeResource CardStrokeColorDefaultBrush}"
        BorderThickness="1">
  <StackPanel Spacing="12">
    <Button x:Name="Example1Button" Width="44" Height="44">
      <PathIcon Data="F1 M 16,12 20,2L 20,16 1,16" HorizontalAlignment="Center"/>
    </Button>

    <Expander Header="Source code">
      <StackPanel Spacing="8" Padding="0,12,0,0">
        <TextBlock Text="XAML" FontWeight="SemiBold" />
        <TextBox x:Name="CodeBox"
                 IsReadOnly="True"
                 AcceptsReturn="True"
                 TextWrapping="NoWrap"
                 BorderThickness="0"
                 Background="Transparent"
                 FontFamily="Cascadia Code, Consolas, monospace" />
      </StackPanel>
    </Expander>
  </StackPanel>
</Border>
"""
        let xamlCode = """
<Button Name="Example1Button">
    <PathIcon Data="F1 M 16,12 20,2L 20,16 1,16" HorizontalAlignment="Center"/>
</Button>
"""
        return loadCard(cardXaml: cardXaml, code: xamlCode)
    }

    private func makeSymbolIconSection() -> UIElement {
        let section = StackPanel()
        section.spacing = 10

        let header = TextBlock()
        header.text = "A SymbolIcon in a button"
        header.fontSize = 16
        header.fontWeight = FontWeights.semiBold
        section.children.append(header)

        let desc = TextBlock()
        desc.text = "To use a SymbolIcon as the icon for a control, you specify the enum value for the glyph you would like to display. SymbolIcon's enum is based off of icons from the Segoe MDL2 font used by Windows 10."
        desc.textWrapping = .wrap
        desc.opacity = 0.85
        section.children.append(desc)

        let cardXaml = """
<Border xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Padding="16"
        CornerRadius="8"
        Background="{ThemeResource CardBackgroundFillColorDefaultBrush}"
        BorderBrush="{ThemeResource CardStrokeColorDefaultBrush}"
        BorderThickness="1">
  <StackPanel Spacing="12">
    <Button x:Name="AcceptButton" HorizontalAlignment="Left">
      <StackPanel Orientation="Horizontal" Spacing="8">
        <SymbolIcon Symbol="Accept"/>
        <TextBlock Text="Accept" VerticalAlignment="Center"/>
      </StackPanel>
    </Button>

    <Expander Header="Source code">
      <StackPanel Spacing="8" Padding="0,12,0,0">
        <TextBlock Text="XAML" FontWeight="SemiBold" />
        <TextBox x:Name="CodeBox"
                 IsReadOnly="True"
                 AcceptsReturn="True"
                 TextWrapping="NoWrap"
                 BorderThickness="0"
                 Background="Transparent"
                 FontFamily="Cascadia Code, Consolas, monospace" />
      </StackPanel>
    </Expander>
  </StackPanel>
</Border>
"""
        let xamlCode = """
<Button Name="AcceptButton">
    <StackPanel Orientation="Horizontal" Spacing="8">
        <SymbolIcon Symbol="Accept"/>
        <TextBlock Text="Accept"/>
    </StackPanel>
</Button>
"""
        return loadCard(cardXaml: cardXaml, code: xamlCode)
    }

    // MARK: - XAML Loader

    private func loadCard(cardXaml: String, code: String) -> UIElement {
        guard let el = try? XamlReader.load(cardXaml) as? UIElement else {
            let tb = TextBlock()
            tb.text = "XAML 解析失败"
            return tb
        }

        if let fe = el as? FrameworkElement,
           let codeBox = (try? fe.findName("CodeBox")) as? TextBox {
            codeBox.text = code
        }
        return el
    }

    // MARK: - Brushes

    private func createAccentBrush() -> SolidColorBrush {
        // Windows accent-ish blue
        return createBrush(r: 0, g: 120, b: 215)
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
