// Sources/Views/Pages/Media/ImagePage.swift
import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation


// MARK: - 简单 MVVM 帮助类型

/// 最简单的“可观察值”，用于 VM -> View 绑定
private final class Observable<Value> {
    var value: Value {
        didSet { observer?(value) }
    }

    /// 数值变化时回调
    var observer: ((Value) -> Void)?

    init(_ value: Value) {
        self.value = value
    }
}

/// Image stretching 卡片的 ViewModel
private final class ImageStretchViewModel {
    enum Mode {
        case none
        case fill
        case uniform
        case uniformToFill
    }

    /// 当前选择的拉伸模式
    let stretchMode: Observable<ImageStretchViewModel.Mode> = Observable<Mode>(.fill)
}


final class ImagePage: Grid {
    // 资源前缀：<package>_<target>.resources
    private let resPrefix = "Swift-WinUI-Gallery_SwiftWinUIGallery.resources"

    private let stretchViewModel = ImageStretchViewModel()

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
            // host.children.append(makeCard_3())   
            host.children.append(makeCard_ImageStretch())
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

    // MARK: - Card 3: Image stretching（使用 ViewModel + “绑定” 示例）
    private func makeCard_ImageStretch() -> UIElement {
        let xaml = """
    <Border xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
            xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
            Padding="16" CornerRadius="8"
            Background="{ThemeResource CardBackgroundFillColorDefaultBrush}"
            BorderBrush="{ThemeResource CardStrokeColorDefaultBrush}"
            BorderThickness="1">
      <StackPanel Spacing="12">

        <!-- 标题 -->
        <TextBlock Text="Image stretching." VerticalAlignment="Center"/>

        <Grid>
          <Grid.ColumnDefinitions>
            <ColumnDefinition Width="*"/>
            <ColumnDefinition Width="260"/>
          </Grid.ColumnDefinitions>

          <!-- 左侧预览图像 -->
          <Border Grid.Column="0"
                  Width="260"
                  Height="140"
                  Background="#222222">
            <Image x:Name="StretchPreviewImage"
                  Source="ms-appx:///\(resPrefix)/Assets/2.jpg"
                  Stretch="Fill" />
          </Border>

          <!-- 右侧四个单选按钮 -->
          <StackPanel Grid.Column="1"
                      Padding="12"
                      Spacing="8"
                      VerticalAlignment="Center">
            <TextBlock Text="Image stretch mode" Margin="0,0,0,8"/>

            <RadioButton x:Name="StretchNoneRadio"
                        Content="None"
                        GroupName="ImageStretchModeGroup"/>
            <RadioButton x:Name="StretchFillRadio"
                        Content="Fill"
                        GroupName="ImageStretchModeGroup"/>
            <RadioButton x:Name="StretchUniformRadio"
                        Content="Uniform"
                        GroupName="ImageStretchModeGroup"/>
            <RadioButton x:Name="StretchUniformToFillRadio"
                        Content="UniformToFill"
                        GroupName="ImageStretchModeGroup"/>
          </StackPanel>
        </Grid>

        <Expander Header="Source code">
          <TextBox IsReadOnly="True" AcceptsReturn="True" TextWrapping="NoWrap"
                  BorderThickness="0" Background="Transparent"
                  FontFamily="Cascadia Code, Consolas, monospace"
                  Text="&lt;Image Height=&quot;140&quot; Stretch=&quot;Fill&quot; Source=&quot;ms-appx:///\(resPrefix)/Assets/2.jpg&quot; /&gt;"/>
        </Expander>
      </StackPanel>
    </Border>
    """

        // 载入 XAML
        guard let root = try? XamlReader.load(xaml) as? FrameworkElement else {
            let tb = TextBlock(); tb.text = "Card 3 加载失败"; return tb
        }

        // 拿到需要绑定的控件
        guard
            let image = (try? root.findName("StretchPreviewImage")) as? Image,
            let rbNone = (try? root.findName("StretchNoneRadio")) as? RadioButton,
            let rbFill = (try? root.findName("StretchFillRadio")) as? RadioButton,
            let rbUniform = (try? root.findName("StretchUniformRadio")) as? RadioButton,
            let rbUniformToFill = (try? root.findName("StretchUniformToFillRadio")) as? RadioButton
        else {
            let tb = TextBlock(); tb.text = "Card 3 控件查找失败"; return tb
        }

        // MARK: VM -> View “绑定”
        let vm: ImageStretchViewModel = stretchViewModel

        vm.stretchMode.observer = { mode in
            // 这里的 image / rbXXX 都是强引用
            switch mode {
            case .none:
                image.stretch = .none
            case .fill:
                image.stretch = .fill
            case .uniform:
                image.stretch = .uniform
            case .uniformToFill:
                image.stretch = .uniformToFill
            }

            rbNone.isChecked          = (mode == .none)
            rbFill.isChecked          = (mode == .fill)
            rbUniform.isChecked       = (mode == .uniform)
            rbUniformToFill.isChecked = (mode == .uniformToFill)
        }

        // MARK: View -> VM：用 Click 事件就好
        rbNone.click.addHandler { _, _ in
            print("image = \(image), rbFill = \(rbFill)")

            vm.stretchMode.value = .none
        }
        rbFill.click.addHandler { _, _ in
            print("image = \(image), rbFill = \(rbFill)")

            vm.stretchMode.value = .fill
        }
        rbUniform.click.addHandler { _, _ in
            print("image = \(image), rbFill = \(rbFill)")

            vm.stretchMode.value = .uniform
        }
        rbUniformToFill.click.addHandler { _, _ in
            print("image = \(image), rbFill = \(rbFill)")

            vm.stretchMode.value = .uniformToFill
        }

        // 设置初始值（会触发 observer，把 UI 同步成 UniformToFill）
        vm.stretchMode.value = .uniformToFill

        return root
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
