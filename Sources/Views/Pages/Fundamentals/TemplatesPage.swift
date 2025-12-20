import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

/// WinUI 3 Gallery - Templates page (Swift)
///
/// Notes:
/// - Uses XamlReader to define ControlTemplate / DataTemplate / ItemsPanelTemplate demos (closest to WinUI Gallery).
/// - Card visuals use ThemeResource CardBackgroundFillColorDefaultBrush / CardStrokeColorDefaultBrush (theme-aware).
final class TemplatesPage: Grid {

    // MARK: - UI

    private let scrollViewer = ScrollViewer()
    private let rootStack = StackPanel()

    // MARK: - Init

    override init() {
        super.init()
        buildUI()
    }

    // MARK: - Build

    private func buildUI() {
        // ScrollViewer
        scrollViewer.horizontalScrollBarVisibility = .disabled
        scrollViewer.verticalScrollBarVisibility = .auto

        // Root stack
        rootStack.spacing = 18
        rootStack.padding = Thickness(left: 40, top: 24, right: 40, bottom: 40)

        // Header
        rootStack.children.append(makeHeader())

        // Intro / overview text
        rootStack.children.append(makeOverview())

        // Sections
        rootStack.children.append(makeSectionTitle("Customize the look of a TextBox with a ControlTemplate"))
        rootStack.children.append(makeCard_TextBoxControlTemplate())

        rootStack.children.append(makeSectionTitle("Customize a ComboBox's ItemTemplate using a DataTemplate"))
        rootStack.children.append(makeCard_ComboBoxDataTemplate())

        rootStack.children.append(makeSectionTitle("Customize an ItemsControl with an ItemsPanelTemplate"))
        rootStack.children.append(makeCard_ItemsPanelTemplate())

        scrollViewer.content = rootStack
        children.append(scrollViewer)
    }

    // MARK: - Header

    private func makeHeader() -> UIElement {
        let headerStack = StackPanel()
        headerStack.spacing = 12

        let title = TextBlock()
        title.text = "Templates"
        title.fontSize = 32
        title.fontWeight = FontWeights.semiBold
        headerStack.children.append(title)

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

        headerStack.children.append(tabsPanel)
        return headerStack
    }


    // MARK: - Overview

    private func makeOverview() -> UIElement {
        let panel = StackPanel()
        panel.spacing = 10

        let p1 = TextBlock()
        p1.text =
        "A template defines the structure and appearance of a control. Unlike styles, which set properties, templates allow you to completely customize how a control looks by redefining its visual tree (the XAML elements that make up the control). Templates provide the flexibility to change the look of controls while maintaining their functionality."
        p1.textWrapping = .wrap
        p1.fontSize = 14
        p1.opacity = 0.85
        panel.children.append(p1)

        let h1 = TextBlock()
        h1.text = "Placement of Templates"
        h1.fontSize = 14
        h1.fontWeight = FontWeights.semiBold
        h1.margin = Thickness(left: 0, top: 6, right: 0, bottom: 0)
        panel.children.append(h1)

        let p2 = TextBlock()
        p2.text =
        "Templates can be defined at the app, page, or control level, similar to styles and resources. The placement is determined by the intended scope and reuse of the template."
        p2.textWrapping = .wrap
        p2.fontSize = 14
        p2.opacity = 0.85
        panel.children.append(p2)

        let p3 = TextBlock()
        p3.text = "There are 3 types of templates:"
        p3.textWrapping = .wrap
        p3.fontSize = 14
        p3.opacity = 0.85
        p3.margin = Thickness(left: 0, top: 4, right: 0, bottom: 0)
        panel.children.append(p3)

        panel.children.append(bulletList([
            "ControlTemplate: customizes the structure of a control.",
            "DataTemplate: changes how individual items are displayed in a control like a ComboBox or ListView.",
            "ItemsPanelTemplate: defines how a collection of items is laid out."
        ]))

        return panel
    }

    // MARK: - Cards (XAML)

    private func makeCard_TextBoxControlTemplate() -> UIElement {
        let xaml = """
<Border xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Padding="16" CornerRadius="8"
        Background="{ThemeResource CardBackgroundFillColorDefaultBrush}"
        BorderBrush="{ThemeResource CardStrokeColorDefaultBrush}"
        BorderThickness="1">
  <StackPanel Spacing="12">

    <!-- Demo -->
    <Grid>
      <Grid.Resources>
        <ControlTemplate x:Key="CustomTextBoxTemplate" TargetType="TextBox">
          <StackPanel Spacing="8">
            <TextBlock Text="{TemplateBinding Header}" />
            <Border MinWidth="200"
                    Background="{ThemeResource CardBackgroundFillColorDefaultBrush}"
                    BorderBrush="{TemplateBinding BorderBrush}"
                    BorderThickness="2"
                    CornerRadius="4">
              <StackPanel Margin="4" Orientation="Horizontal" Spacing="4">
                <SymbolIcon Symbol="Edit" />
                <ScrollViewer x:Name="ContentElement"
                              Padding="{TemplateBinding Padding}"
                              HorizontalScrollBarVisibility="{TemplateBinding ScrollViewer.HorizontalScrollBarVisibility}"
                              VerticalScrollBarVisibility="{TemplateBinding ScrollViewer.VerticalScrollBarVisibility}" />
              </StackPanel>
            </Border>
          </StackPanel>
        </ControlTemplate>
      </Grid.Resources>

      <TextBox Padding="8"
               BorderBrush="{ThemeResource AccentFillColorDefaultBrush}"
               Header="Enter text here"
               Template="{StaticResource CustomTextBoxTemplate}" />
    </Grid>

    <!-- Source -->
    <Expander Header="Source code">
      <TextBox IsReadOnly="True"
               AcceptsReturn="True"
               TextWrapping="NoWrap"
               BorderThickness="0"
               Background="Transparent"
               FontFamily="Cascadia Code, Consolas, monospace"
               FontSize="12"
               Text="&lt;Grid&gt;&#10;  &lt;Grid.Resources&gt;&#10;    &lt;ControlTemplate x:Key=&quot;CustomTextBoxTemplate&quot; TargetType=&quot;TextBox&quot;&gt;&#10;      ...&#10;    &lt;/ControlTemplate&gt;&#10;  &lt;/Grid.Resources&gt;&#10;&#10;  &lt;TextBox Header=&quot;Enter text here&quot;&#10;           Template=&quot;{StaticResource CustomTextBoxTemplate}&quot; /&gt;&#10;&lt;/Grid&gt;"/>

    </Expander>

  </StackPanel>
</Border>
"""
        if let el = try? XamlReader.load(xaml) as? UIElement { return el }
        let tb = TextBlock(); tb.text = "TextBox template demo failed to load."
        return tb
    }

    private func makeCard_ComboBoxDataTemplate() -> UIElement {
        let xaml = """
<Border xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Padding="16" CornerRadius="8"
        Background="{ThemeResource CardBackgroundFillColorDefaultBrush}"
        BorderBrush="{ThemeResource CardStrokeColorDefaultBrush}"
        BorderThickness="1">
  <StackPanel Spacing="12">

    <!-- Demo -->
    <Grid>
      <Grid.Resources>
        <DataTemplate x:Key="CustomComboBoxItemTemplate">
          <StackPanel Orientation="Horizontal" Spacing="8">
            <Ellipse Width="8" Height="8"
                     Fill="{ThemeResource AccentFillColorDefaultBrush}" />
            <TextBlock Text="{Binding}" />
          </StackPanel>
        </DataTemplate>
      </Grid.Resources>

      <ComboBox Header="Options"
                ItemTemplate="{StaticResource CustomComboBoxItemTemplate}"
                SelectedIndex="0">
        <x:String>Option 1</x:String>
        <x:String>Option 2</x:String>
        <x:String>Option 3</x:String>
      </ComboBox>
    </Grid>

    <!-- Source -->
    <Expander Header="Source code">
      <TextBox IsReadOnly="True"
               AcceptsReturn="True"
               TextWrapping="NoWrap"
               BorderThickness="0"
               Background="Transparent"
               FontFamily="Cascadia Code, Consolas, monospace"
               FontSize="12"
               Text="&lt;Grid&gt;&#10;  &lt;Grid.Resources&gt;&#10;    &lt;DataTemplate x:Key=&quot;CustomComboBoxItemTemplate&quot;&gt;&#10;      ...&#10;    &lt;/DataTemplate&gt;&#10;  &lt;/Grid.Resources&gt;&#10;&#10;  &lt;ComboBox Header=&quot;Options&quot; ItemTemplate=&quot;{StaticResource CustomComboBoxItemTemplate}&quot; /&gt;&#10;&lt;/Grid&gt;"/>

    </Expander>

  </StackPanel>
</Border>
"""
        if let el = try? XamlReader.load(xaml) as? UIElement { return el }
        let tb = TextBlock(); tb.text = "ComboBox DataTemplate demo failed to load."
        return tb
    }

    private func makeCard_ItemsPanelTemplate() -> UIElement {
        let xaml = """
<Border xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Padding="16" CornerRadius="8"
        Background="{ThemeResource CardBackgroundFillColorDefaultBrush}"
        BorderBrush="{ThemeResource CardStrokeColorDefaultBrush}"
        BorderThickness="1">
  <StackPanel Spacing="12">

    <!-- Demo -->
    <Grid>
      <Grid.ColumnDefinitions>
        <ColumnDefinition Width="*"/>
        <ColumnDefinition Width="160"/>
      </Grid.ColumnDefinitions>

      <!-- Two ListViews layered; toggle Visibility to simulate switching ItemsPanelTemplate -->
      <Grid Grid.Column="0">

        <ListView x:Name="WrapList"
                  Height="96"
                  SelectionMode="Single"
                  SelectedIndex="18"
                  Background="Transparent"
                  BorderThickness="0"
                  ScrollViewer.HorizontalScrollBarVisibility="Disabled"
                  ScrollViewer.VerticalScrollBarVisibility="Disabled">
          <ListView.ItemsPanel>
            <ItemsPanelTemplate>
              <WrapGrid Orientation="Horizontal"/>
            </ItemsPanelTemplate>
          </ListView.ItemsPanel>
          <ListViewItem>Item 01</ListViewItem>
          <ListViewItem>Item 02</ListViewItem>
          <ListViewItem>Item 03</ListViewItem>
          <ListViewItem>Item 04</ListViewItem>
          <ListViewItem>Item 05</ListViewItem>
          <ListViewItem>Item 06</ListViewItem>
          <ListViewItem>Item 07</ListViewItem>
          <ListViewItem>Item 08</ListViewItem>
          <ListViewItem>Item 09</ListViewItem>
          <ListViewItem>Item 10</ListViewItem>
          <ListViewItem>Item 11</ListViewItem>
          <ListViewItem>Item 12</ListViewItem>
          <ListViewItem>Item 13</ListViewItem>
          <ListViewItem>Item 14</ListViewItem>
          <ListViewItem>Item 15</ListViewItem>
          <ListViewItem>Item 16</ListViewItem>
          <ListViewItem>Item 17</ListViewItem>
          <ListViewItem>Item 18</ListViewItem>
          <ListViewItem>Item 19</ListViewItem>
          <ListViewItem>Item 20</ListViewItem>
        </ListView>

        <ListView x:Name="StackList"
                  Height="96"
                  Visibility="Collapsed"
                  SelectionMode="Single"
                  SelectedIndex="18"
                  Background="Transparent"
                  BorderThickness="0"
                  ScrollViewer.HorizontalScrollBarVisibility="Auto"
                  ScrollViewer.VerticalScrollBarVisibility="Disabled">
          <ListView.ItemsPanel>
            <ItemsPanelTemplate>
              <StackPanel Orientation="Horizontal"/>
            </ItemsPanelTemplate>
          </ListView.ItemsPanel>
          <ListViewItem>Item 01</ListViewItem>
          <ListViewItem>Item 02</ListViewItem>
          <ListViewItem>Item 03</ListViewItem>
          <ListViewItem>Item 04</ListViewItem>
          <ListViewItem>Item 05</ListViewItem>
          <ListViewItem>Item 06</ListViewItem>
          <ListViewItem>Item 07</ListViewItem>
          <ListViewItem>Item 08</ListViewItem>
          <ListViewItem>Item 09</ListViewItem>
          <ListViewItem>Item 10</ListViewItem>
          <ListViewItem>Item 11</ListViewItem>
          <ListViewItem>Item 12</ListViewItem>
          <ListViewItem>Item 13</ListViewItem>
          <ListViewItem>Item 14</ListViewItem>
          <ListViewItem>Item 15</ListViewItem>
          <ListViewItem>Item 16</ListViewItem>
          <ListViewItem>Item 17</ListViewItem>
          <ListViewItem>Item 18</ListViewItem>
          <ListViewItem>Item 19</ListViewItem>
          <ListViewItem>Item 20</ListViewItem>
        </ListView>

      </Grid>

      <StackPanel Grid.Column="1" Spacing="8" VerticalAlignment="Center">
        <RadioButton x:Name="WrapGridRadio" Content="WrapGrid" GroupName="ItemsPanelMode" IsChecked="True"/>
        <RadioButton x:Name="StackPanelRadio" Content="StackPanel" GroupName="ItemsPanelMode"/>
      </StackPanel>
    </Grid>

    <!-- Source -->
    <Expander Header="Source code">
      <TextBox IsReadOnly="True"
               AcceptsReturn="True"
               TextWrapping="NoWrap"
               BorderThickness="0"
               Background="Transparent"
               FontFamily="Cascadia Code, Consolas, monospace"
               FontSize="12"
               Text="&lt;ListView&gt;&#10;  &lt;ListView.ItemsPanel&gt;&#10;    &lt;ItemsPanelTemplate&gt;&#10;      &lt;WrapGrid Orientation=&quot;Horizontal&quot; /&gt;&#10;    &lt;/ItemsPanelTemplate&gt;&#10;  &lt;/ListView.ItemsPanel&gt;&#10;&#10;  &lt;ListViewItem&gt;Item 01&lt;/ListViewItem&gt;&#10;  ...&#10;  &lt;ListViewItem&gt;Item 20&lt;/ListViewItem&gt;&#10;&lt;/ListView&gt;"/>
    </Expander>

  </StackPanel>
</Border>
"""

        guard let root = try? XamlReader.load(xaml) as? UIElement else {
            let tb = TextBlock(); tb.text = "ItemsPanelTemplate demo failed to load."
            return tb
        }

        // Wire up toggle logic (WrapGrid vs StackPanel).
        if let fe = root as? FrameworkElement {
            let wrapList = (try? fe.findName("WrapList")) as? ListView
            let stackList = (try? fe.findName("StackList")) as? ListView
            let rbWrap = (try? fe.findName("WrapGridRadio")) as? RadioButton
            let rbStack = (try? fe.findName("StackPanelRadio")) as? RadioButton

            rbWrap?.click.addHandler { _, _ in
                wrapList?.visibility = .visible
                stackList?.visibility = .collapsed
            }
            rbStack?.click.addHandler { _, _ in
                wrapList?.visibility = .collapsed
                stackList?.visibility = .visible
            }
        }

        return root
    }

    // MARK: - Helpers

    private func makeSectionTitle(_ text: String) -> TextBlock {
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
