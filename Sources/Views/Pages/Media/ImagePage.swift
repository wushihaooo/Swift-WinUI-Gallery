// Sources/Views/Pages/Media/ImagePage.swift
import WinUI
import WinAppSDK
import WindowsFoundation

final class ImagePage: Grid {
    // 资源前缀：<package>_<target>.resources
    private let resPrefix = "Swift-WinUI-Gallery_SwiftWinUIGallery.resources"

    override init() {
        super.init()
        self.children.append(makeContent())
    }

    // MARK: - UI
    private func makeContent() -> UIElement {
        let page = """
<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
      xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
  <Grid.RowDefinitions>
    <RowDefinition Height="Auto"/>
    <RowDefinition Height="*"/>
  </Grid.RowDefinitions>

  <!-- Header -->
  <Grid Grid.Row="0" Padding="24,16,24,8">
    <Grid.ColumnDefinitions>
      <ColumnDefinition Width="*"/>
      <ColumnDefinition Width="Auto"/>
    </Grid.ColumnDefinitions>

    <TextBlock Text="Image" FontSize="32" FontWeight="SemiBold"
               VerticalAlignment="Center"/>

    <StackPanel Grid.Column="1" Orientation="Horizontal" Spacing="8" VerticalAlignment="Center">
      <Button Content="Documentation"/>
      <Button Content="Source"/>
    </StackPanel>
  </Grid>

  <!-- Body -->
  <ScrollViewer Grid.Row="1">
    <StackPanel x:Name="CardsHost" Spacing="16" Padding="24,8,24,24"/>
  </ScrollViewer>
</Grid>
"""
        // 载入框架
        guard let root = try? XamlReader.load(page) as? FrameworkElement else {
            let tb = TextBlock(); tb.text = "XAML 解析失败"
            return tb
        }

        // 往容器里追加每个卡片
        if let obj = try? root.findName("CardsHost"), let host = obj as? StackPanel {
            host.children.append(makeCard_BasicImage())
            host.children.append(makeCard_DecodeToRenderSize())
            host.children.append(makeCard_3())   
            host.children.append(makeCard_Svg())
        }

        return root
    }

    // MARK: - Card 1: 本地图片
    private func makeCard_BasicImage() -> UIElement {
        let xaml = """
<Border xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Padding="16" CornerRadius="8"
        Background="{ThemeResource CardBackgroundFillColorDefaultBrush}"
        BorderBrush="{ThemeResource CardStrokeColorDefaultBrush}"
        BorderThickness="1">
  <StackPanel Spacing="12">
    <Grid>
      <Grid.ColumnDefinitions>
        <ColumnDefinition Width="*"/>
        <ColumnDefinition Width="260"/>
      </Grid.ColumnDefinitions>

      <TextBlock Text="A basic image from a local file." VerticalAlignment="Center"/>

      <Image Grid.Column="1" Height="100"
             Source="ms-appx:///\(resPrefix)/Assets/2.jpg" />
    </Grid>

    <Expander Header="Source code">
      <TextBox IsReadOnly="True" AcceptsReturn="True" TextWrapping="NoWrap"
               BorderThickness="0" Background="Transparent"
               FontFamily="Cascadia Code, Consolas, monospace"
               Text="&lt;Image Height=&quot;100&quot;&#10;        Source=&quot;ms-appx:///\(resPrefix)/Assets/2.jpg&quot; /&gt;"/>
    </Expander>
  </StackPanel>
</Border>
"""
        if let el = try? XamlReader.load(xaml) as? UIElement { return el }
        let tb = TextBlock(); tb.text = "Card 1 加载失败"; return tb
    }

    // MARK: - Card 2: 解码到渲染尺寸
    private func makeCard_DecodeToRenderSize() -> UIElement {
        let xaml = """
<Border xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Padding="16" CornerRadius="8"
        Background="{ThemeResource CardBackgroundFillColorDefaultBrush}"
        BorderBrush="{ThemeResource CardStrokeColorDefaultBrush}"
        BorderThickness="1">
  <StackPanel Spacing="12">
    <Grid>
      <Grid.ColumnDefinitions>
        <ColumnDefinition Width="*"/>
        <ColumnDefinition Width="260"/>
      </Grid.ColumnDefinitions>

      <TextBlock Text="An image decoded to the rendering size" VerticalAlignment="Center"/>

      <Image Grid.Column="1" Height="100">
        <Image.Source>
          <BitmapImage UriSource="ms-appx:///\(resPrefix)/Assets/2.jpg"
                       DecodePixelHeight="100"/>
        </Image.Source>
      </Image>
    </Grid>

    <Expander Header="Source code">
      <TextBox IsReadOnly="True" AcceptsReturn="True" TextWrapping="NoWrap"
               BorderThickness="0" Background="Transparent"
               FontFamily="Cascadia Code, Consolas, monospace"
               Text="&lt;Image Height=&quot;100&quot;&gt;&#10;  &lt;Image.Source&gt;&#10;    &lt;BitmapImage UriSource=&quot;ms-appx:///\(resPrefix)/Assets/2.jpg&quot;&#10;                 DecodePixelHeight=&quot;100&quot; /&gt;&#10;  &lt;/Image.Source&gt;&#10;&lt;/Image&gt;"/>
    </Expander>
  </StackPanel>
</Border>
"""
        if let el = try? XamlReader.load(xaml) as? UIElement { return el }
        let tb = TextBlock(); tb.text = "Card 2 加载失败"; return tb
    }

    // MARK: - Card 3: 简化按钮切换（点击载入不同 XAML 片段）
    private func makeCard_3() -> UIElement {
        let xaml = """
<Border xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Padding="16" CornerRadius="8"
        Background="{ThemeResource CardBackgroundFillColorDefaultBrush}"
        BorderBrush="{ThemeResource CardStrokeColorDefaultBrush}"
        BorderThickness="1">
  <StackPanel Spacing="12">
    <Grid>
      <Grid.ColumnDefinitions>
        <ColumnDefinition Width="*"/>
        <ColumnDefinition Width="260"/>
      </Grid.ColumnDefinitions>

      <TextBlock Text="A basic image from a local file." VerticalAlignment="Center"/>

      <Image Stretch="Fill" Grid.Column="1" Height="100"
             Source="ms-appx:///\(resPrefix)/Assets/2.jpg" />
    </Grid>

    <Expander Header="Source code">
      <TextBox IsReadOnly="True" AcceptsReturn="True" TextWrapping="NoWrap"
               BorderThickness="0" Background="Transparent"
               FontFamily="Cascadia Code, Consolas, monospace"
               Text="&lt;Image Stretch=&quot;Fill&quot; Height=&quot;100&quot;&#10;        Source=&quot;ms-appx:///\(resPrefix)/Assets/2.jpg&quot; /&gt;"/>
    </Expander>
  </StackPanel>
</Border>
"""
        if let el = try? XamlReader.load(xaml) as? UIElement { return el }
        let tb = TextBlock(); tb.text = "Card 1 加载失败"; return tb
    }

    // MARK: - Card 4: SVG
    private func makeCard_Svg() -> UIElement {
        let xaml = """
<Border xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Padding="16" CornerRadius="8"
        Background="{ThemeResource CardBackgroundFillColorDefaultBrush}"
        BorderBrush="{ThemeResource CardStrokeColorDefaultBrush}"
        BorderThickness="1">
  <StackPanel Spacing="12">
    <Grid>
      <Grid.ColumnDefinitions>
        <ColumnDefinition Width="*"/>
        <ColumnDefinition Width="260"/>
      </Grid.ColumnDefinitions>

      <TextBlock Text="An SVG image." VerticalAlignment="Center"/>

      <Image Grid.Column="1" Height="100"
             Source="ms-appx:///\(resPrefix)/Assets/1.svg" />
    </Grid>

    <Expander Header="Source code">
      <TextBox IsReadOnly="True" AcceptsReturn="True" TextWrapping="NoWrap"
               BorderThickness="0" Background="Transparent"
               FontFamily="Cascadia Code, Consolas, monospace"
               Text="&lt;Image Height=&quot;100&quot; Source=&quot;ms-appx:///\(resPrefix)/Assets/1.svg&quot; /&gt;"/>
    </Expander>
  </StackPanel>
</Border>
"""
        if let el = try? XamlReader.load(xaml) as? UIElement { return el }
        let tb = TextBlock(); tb.text = "Card 4 加载失败"; return tb
    }
}
