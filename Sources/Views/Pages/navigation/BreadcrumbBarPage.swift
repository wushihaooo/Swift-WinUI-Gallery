import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

public class Folder {
    public var name: String = ""
    
    public init(name: String) {
        self.name = name
    }
}

class BreadcrumbBarPage: Grid {
    let foldersString: [String] = ["Home", "Documents", "Design", "Northwind", "Images", "Folder1", "Folder2", "Folder3"]
    var folders: [Folder] = []
    
    let defaultFolders: [Folder] = [
        Folder(name: "Home"),
        Folder(name: "Folder1"),
        Folder(name: "Folder2"),
        Folder(name: "Folder3")
    ]
    
    var breadcrumbBar1: WinUI.BreadcrumbBar?
    var breadcrumbBar2: WinUI.BreadcrumbBar?
    
    var currentCodeTab: String = "XAML"
    var codeContentTextBlock: WinUI.TextBlock?
    var xamlButton: WinUI.Button?
    var csharpButton: WinUI.Button?
    var expander: WinUI.Expander?
    
    override init() {
        super.init()
        setupView()
    }

    private func setupView() {
        do {
            let root = try WinUI.XamlReader.load(Self.xamlMarkup)
            
            if let scrollViewer = root as? WinUI.ScrollViewer {
                scrollViewer.horizontalAlignment = WinUI.HorizontalAlignment.stretch
                scrollViewer.verticalAlignment = WinUI.VerticalAlignment.stretch
                
                // 查找并配置交互元素
                if let stackPanel = scrollViewer.content as? WinUI.StackPanel {
                    configureInteractiveElements(in: stackPanel)
                }
                
                self.children.append(scrollViewer)
                print("✓ BreadcrumbBarPage: XAML 加载成功 (ScrollViewer)")
            } else if let stackPanel = root as? WinUI.StackPanel {
                stackPanel.horizontalAlignment = WinUI.HorizontalAlignment.stretch
                stackPanel.verticalAlignment = WinUI.VerticalAlignment.stretch
                configureInteractiveElements(in: stackPanel)
                self.children.append(stackPanel)
                print("✓ BreadcrumbBarPage: XAML 加载成功 (StackPanel)")
            } else {
                print("❌ BreadcrumbBarPage: XamlReader 返回未知类型 - \(type(of: root))")
            }
        } catch {
            print("❌ BreadcrumbBarPage: XAML 加载异常 - \(error)")
        }
    }
    
    private func configureInteractiveElements(in stackPanel: WinUI.StackPanel) {
        // 遍历找到代码标签和内容
        for i in 0..<Int(stackPanel.children.count) {
            if let child = stackPanel.children[i] as? WinUI.StackPanel {
                // 查找代码标签行
                if let labelStack = findCodeLabelStack(in: child) {
                    setupCodeTabButtons(in: labelStack)
                }
                // 查找代码内容
                if let codeBlock = findCodeContentBlock(in: child) {
                    codeContentTextBlock = codeBlock
                }
            }
            // 查找 Expander
            if let exp = stackPanel.children[i] as? WinUI.Expander {
                expander = exp
            }
        }
    }
    
    private func findCodeLabelStack(in stack: WinUI.StackPanel) -> WinUI.StackPanel? {
        if stack.orientation == .horizontal {
            // 检查是否包含代码标签
            for i in 0..<Int(stack.children.count) {
                if let button = stack.children[i] as? WinUI.Button {
                    if let content = button.content as? String {
                        if content == "XAML" || content == "C#" {
                            return stack
                        }
                    }
                }
            }
        }
        return nil
    }
    
    private func findCodeContentBlock(in stack: WinUI.StackPanel) -> WinUI.TextBlock? {
        for i in 0..<Int(stack.children.count) {
            if let border = stack.children[i] as? WinUI.Border {
                if let textBlock = border.child as? WinUI.TextBlock {
                    return textBlock
                }
            }
        }
        return nil
    }
    
    private func setupCodeTabButtons(in labelStack: WinUI.StackPanel) {
        // 找到 XAML 和 C# Button，为它们添加点击事件处理
        var xamlIdx = -1
        var csharpIdx = -1
        
        for i in 0..<Int(labelStack.children.count) {
            if let button = labelStack.children[i] as? WinUI.Button {
                if let content = button.content as? String {
                    if content == "XAML" {
                        xamlIdx = i
                        xamlButton = button
                    } else if content == "C#" {
                        csharpIdx = i
                        csharpButton = button
                    }
                }
            }
        }
        
        print("✓ 找到代码标签按钮 - XAML: \(xamlIdx), C#: \(csharpIdx)")
    }

    private static let xamlMarkup = """
<ScrollViewer xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" 
              VerticalScrollMode="Enabled"
              HorizontalScrollMode="Disabled">
    <StackPanel Padding="24,24,24,24" Spacing="20">
        
        <!-- 顶部标题和选项卡 -->
        <StackPanel Spacing="12">
            <TextBlock Text="BreadcrumbBar" FontSize="32" FontWeight="SemiBold" Foreground="White"/>
            
            <!-- 文档和源代码标签 -->
            <StackPanel Orientation="Horizontal" Spacing="20">
                <TextBlock Text="Documentation" FontSize="14" Foreground="#0078D4" FontWeight="SemiBold" Padding="0,4,0,4"/>
                <TextBlock Text="Source" FontSize="14" Foreground="#999999" Padding="0,4,0,4"/>
            </StackPanel>
        </StackPanel>
        
        <!-- 描述部分 -->
        <TextBlock Text="The BreadcrumbBar control provides a common horizontal layout to display the trail of navigation taken to the current location. Resize to see the nodes crumble, starting at the root." 
                   FontSize="14" 
                   Foreground="#CCCCCC"
                   TextWrapping="Wrap"
                   LineHeight="20"/>
        
        <!-- 示例 1 -->
        <StackPanel Spacing="12">
            <TextBlock Text="A BreadcrumbBar control" FontSize="18" FontWeight="SemiBold" Foreground="White"/>
            
            <Border CornerRadius="4" Padding="16" BorderThickness="1" BorderBrush="#444444">
                <Border.Background>
                    <SolidColorBrush Color="#2A2A2A"/>
                </Border.Background>
                <TextBlock Text="Home > Documents > Design > Northwind > Images > Folder1 > Folder2 > Folder3" 
                           FontSize="14" 
                           Foreground="White"
                           TextWrapping="Wrap"/>
            </Border>
        </StackPanel>
        
        <!-- Source Code 可折叠部分 -->
        <Expander Header="Source code" IsExpanded="True">
            <Expander.Content>
                <StackPanel Spacing="8">
                    <!-- 代码标签按钮 -->
                    <StackPanel Orientation="Horizontal" Spacing="12">
                        <Button Content="XAML" Padding="8,4,8,4" Background="Transparent" Foreground="#0078D4" FontSize="13" FontWeight="SemiBold"/>
                        <Button Content="C#" Padding="8,4,8,4" Background="Transparent" Foreground="#999999" FontSize="13"/>
                    </StackPanel>
                    
                    <!-- 代码内容 -->
                    <Border CornerRadius="4" Padding="12" BorderThickness="1" BorderBrush="#444444" Background="#1E1E1E">
                        <TextBlock Text="BreadcrumbBar1.ItemsSource = new string[] { &quot;Home&quot;, &quot;Documents&quot;, &quot;Design&quot;, &quot;Northwind&quot;, &quot;Images&quot;, &quot;Folder1&quot;, &quot;Folder2&quot;, &quot;Folder3&quot; };" 
                                   FontSize="12" 
                                   Foreground="#D4D4D4"
                                   TextWrapping="Wrap"
                                   FontFamily="Consolas, Courier New, monospace"/>
                    </Border>
                </StackPanel>
            </Expander.Content>
        </Expander>
        
        <!-- 示例 2 -->
        <StackPanel Spacing="12">
            <TextBlock Text="BreadCrumbBar Control with Custom DataTemplate" FontSize="18" FontWeight="SemiBold" Foreground="White"/>
            
            <Border CornerRadius="4" Padding="16" BorderThickness="1" BorderBrush="#444444">
                <Border.Background>
                    <SolidColorBrush Color="#2A2A2A"/>
                </Border.Background>
                <TextBlock Text="Home > Folder1 > Folder2 > Folder3" 
                           FontSize="14" 
                           Foreground="White"
                           TextWrapping="Wrap"/>
            </Border>
        </StackPanel>
        
        <!-- Reset 按钮 -->
        <Button Content="Reset sample" Margin="0,12,0,0" Padding="12,8,24,8" Background="#0078D4" Foreground="White"/>
        
        <TextBlock Text="" Height="24"/>
    </StackPanel>
</ScrollViewer>
"""
}
