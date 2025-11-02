// Sources/Views/Pages/Media/PersonPicturePage.swift
import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

final class PersonPicturePage: Grid {

    override init() {
        super.init()
        self.children.append(makeContent())
    }

    // MARK: - UI 构建
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

    <TextBlock Text="PersonPicture" FontSize="32" FontWeight="SemiBold"
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
        guard let root = try? XamlReader.load(page) as? FrameworkElement else {
            let tb = TextBlock(); tb.text = "XAML 解析失败"
            return tb
        }

        if let obj = try? root.findName("CardsHost"), let host = obj as? StackPanel {
            host.children.append(makeCard_ProfilePicture())
            host.children.append(makeCard_DisplayName())
            host.children.append(makeCard_Initials())
        }

        return root
    }

    // MARK: - Card 1: ProfilePicture
    private func makeCard_ProfilePicture() -> UIElement {
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

      <TextBlock Text="PersonPicture with ProfilePicture (远程图片)" VerticalAlignment="Center"/>

      <PersonPicture Grid.Column="1" Width="100" Height="100"
        ProfilePicture="https://learn.microsoft.com/windows/uwp/contacts-and-calendar/images/shoulder-tap-static-payload.png" />
    </Grid>

    <Expander Header="Source code">
      <TextBox IsReadOnly="True" AcceptsReturn="True" TextWrapping="NoWrap"
               BorderThickness="0" Background="Transparent"
               FontFamily="Cascadia Code, Consolas, monospace"
               Text="&lt;PersonPicture Width=&quot;100&quot; Height=&quot;100&quot;&#10;  ProfilePicture=&quot;https://learn.microsoft.com/windows/uwp/contacts-and-calendar/images/shoulder-tap-static-payload.png&quot; /&gt;"/>
    </Expander>
  </StackPanel>
</Border>
"""
        if let el = try? XamlReader.load(xaml) as? UIElement { return el }
        let tb = TextBlock(); tb.text = "Card ProfilePicture 加载失败"; return tb
    }

    // MARK: - Card 2: DisplayName
    private func makeCard_DisplayName() -> UIElement {
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

      <TextBlock Text="PersonPicture with DisplayName" VerticalAlignment="Center"/>

      <PersonPicture Grid.Column="1" Width="100" Height="100" DisplayName="Jane Doe" />
    </Grid>

    <Expander Header="Source code">
      <TextBox IsReadOnly="True" AcceptsReturn="True" TextWrapping="NoWrap"
               BorderThickness="0" Background="Transparent"
               FontFamily="Cascadia Code, Consolas, monospace"
               Text="&lt;PersonPicture Width=&quot;100&quot; Height=&quot;100&quot; DisplayName=&quot;Jane Doe&quot; /&gt;"/>
    </Expander>
  </StackPanel>
</Border>
"""
        if let el = try? XamlReader.load(xaml) as? UIElement { return el }
        let tb = TextBlock(); tb.text = "Card DisplayName 加载失败"; return tb
    }

    // MARK: - Card 3: Initials
    private func makeCard_Initials() -> UIElement {
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

      <TextBlock Text="PersonPicture with Initials" VerticalAlignment="Center"/>

      <PersonPicture Grid.Column="1" Width="100" Height="100" Initials="SB" />
    </Grid>

    <Expander Header="Source code">
      <TextBox IsReadOnly="True" AcceptsReturn="True" TextWrapping="NoWrap"
               BorderThickness="0" Background="Transparent"
               FontFamily="Cascadia Code, Consolas, monospace"
               Text="&lt;PersonPicture Width=&quot;100&quot; Height=&quot;100&quot; Initials=&quot;SB&quot; /&gt;"/>
    </Expander>
  </StackPanel>
</Border>
"""
        if let el = try? XamlReader.load(xaml) as? UIElement { return el }
        let tb = TextBlock(); tb.text = "Card Initials 加载失败"; return tb
    }

}
