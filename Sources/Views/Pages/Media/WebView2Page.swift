// Sources/Views/Pages/Media/WebView2Page.swift
import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

final class WebView2Page: Grid {

    override init() {
        super.init()
        self.children.append(makeContent())
    }

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

    <TextBlock Text="WebView2" FontSize="32" FontWeight="SemiBold"
               VerticalAlignment="Center"/>

    <StackPanel Grid.Column="1" Orientation="Horizontal" Spacing="8" VerticalAlignment="Center">
      <Button x:Name="DocBtn" Content="Documentation"/>
      <Button x:Name="SrcBtn" Content="Source"/>
    </StackPanel>
  </Grid>

  <!-- Body -->
  <ScrollViewer Grid.Row="1">
    <StackPanel x:Name="CardsHost" Spacing="16" Padding="24,8,24,24"/>
  </ScrollViewer>
</Grid>
"""
        guard let root = try? XamlReader.load(page) as? FrameworkElement else {
            let tb = TextBlock(); tb.text = "XAML 解析失败"
            return tb
        }

        if let obj = try? root.findName("CardsHost"), let host = obj as? StackPanel {
            host.children.append(makeCard_WebView2Simple())
        }

        return root
    }

    // MARK: - 单卡片：最简单的 WebView2
    private func makeCard_WebView2Simple() -> UIElement {
        // 这张卡把 WebView2 放在一个有内边距和圆角的容器里，大小会随容器伸展
        let xaml = """
<Border xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Padding="16" CornerRadius="8"
        Background="{ThemeResource CardBackgroundFillColorDefaultBrush}"
        BorderBrush="{ThemeResource CardStrokeColorDefaultBrush}"
        BorderThickness="1">
  <StackPanel Spacing="12">
    <TextBlock Text="A simple WebView2" FontWeight="SemiBold"/>

    <!-- 内容区域 -->
    <Grid MinWidth="200" MinHeight="200">
      <Grid.RowDefinitions>
        <RowDefinition Height="*"/>
      </Grid.RowDefinitions>

      <!-- 你的控件： -->
      <WebView2 x:Name="MyWebView2"
                Height="480"
                Source="https://learn.microsoft.com/windows/apps/winui/winui3/"
                HorizontalAlignment="Stretch"
                VerticalAlignment="Stretch"
                Grid.Row="0"
                MinHeight="200"
                MinWidth="200"/>
    </Grid>

    <Expander Header="Source code">
      <TextBox IsReadOnly="True" AcceptsReturn="True" TextWrapping="NoWrap"
               BorderThickness="0" Background="Transparent"
               FontFamily="Cascadia Code, Consolas, monospace"
               Text="&lt;WebView2 x:Name=&quot;MyWebView2&quot; Source=&quot;https://learn.microsoft.com/windows/apps/winui/winui3/&quot; HorizontalAlignment=&quot;Stretch&quot; VerticalAlignment=&quot;Stretch&quot; Grid.Row=&quot;1&quot; MinHeight=&quot;200&quot; MinWidth=&quot;200&quot;/&gt;"/>
    </Expander>
  </StackPanel>
</Border>
"""
        if let el = try? XamlReader.load(xaml) as? UIElement { return el }
        let tb = TextBlock(); tb.text = "WebView2 卡片加载失败"; return tb
    }


}
