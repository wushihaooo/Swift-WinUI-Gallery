import WinUI
import UWP
import Foundation

class AppBarToggleButtonPage: Grid {
    private var page: Page = Page()
    private var button1: Button!
    private var button2: Button!
    private var button3: Button!
    private var button4: Button!
    private var output1: TextBlock!
    private var output2: TextBlock!
    private var output3: TextBlock!
    private var output4: TextBlock!
    private var isChecked1: Bool = false
    private var isChecked2: Bool = false
    private var isChecked3: Bool = false
    private var isChecked4: Bool? = false  // Three-state: true/false/nil
    
    override init() {
        super.init()
        loadXamlFromFile(
            filePath: Bundle.module.path(
                forResource: "AppBarToggleButtonPage", 
                ofType: "xaml", 
                inDirectory: "Assets/xaml") ?? ""
        )
        setupHeader()
        setupDescription()
        setupExamples()
        self.children.append(page)
    }
    
    private func setupHeader() {
        let headerGrid = try! page.findName("headerGrid") as! Grid
        let controlInfo = ControlInfo(
            title: "AppBarToggleButton",
            apiNamespace: "Microsoft.UI.Xaml.Controls",
            baseClasses: [
                "Object",
                "DependencyObject",
                "UIElement",
                "FrameworkElement",
                "Control",
                "ContentControl",
                "ButtonBase",
                "ToggleButton",
                "AppBarToggleButton"
            ],
            docs: [
                ControlInfoDocLink(
                    title: "AppBarToggleButton API",
                    uri: "https://learn.microsoft.com/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.controls.appbartogglebutton"
                ),
                ControlInfoDocLink(
                    title: "Guidelines",
                    uri: "https://learn.microsoft.com/windows/apps/design/controls/app-bars"
                )
            ]
        )
        let pageHeader = PageHeader(item: controlInfo)
        pageHeader.themeButtonVisibility = .visible
        pageHeader.margin = Thickness(left: 36, top: 36, right: 36, bottom: 0)
        headerGrid.children.append(pageHeader)
    }
    
    private func setupDescription() {
        let exampleStackPanel = try! page.findName("exampleStackPanel") as! StackPanel
        
        // 添加描述性文字（在演示区域外面）
        let descText = TextBlock()
        descText.text = "An AppBarToggleButton looks like an AppBarButton, but works like a CheckBox. It typically has two states, checked (on) or unchecked (off), but can be indeterminate if the IsThreeState property is true. You can determine it's state by checking the IsChecked property."
        descText.textWrapping = .wrap
        descText.fontSize = 14
        descText.margin = Thickness(left: 0, top: 0, right: 0, bottom: 16)
        exampleStackPanel.children.append(descText)
    }
    
    private func setupExamples() {
        let exampleStackPanel = try! page.findName("exampleStackPanel") as! StackPanel
        
        // Example 1: Symbol icon
        let example1: Grid = try! page.findName("Example1") as! Grid
        let demo1 = createExample1()
        example1.children.append(demo1)
        
        let _ = exampleStackPanel.children.remove(at: exampleStackPanel.children.index(of: example1)!)
        exampleStackPanel.children.append(ControlExample(
            headerText: "An AppBarToggleButton with a symbol icon.",
            isOutputDisplay: false,
            isOptionsDisplay: false,
            contentPresenter: example1
        ).controlExample)
        
        // Example 2: Bitmap icon
        let example2: Grid = try! page.findName("Example2") as! Grid
        let demo2 = createExample2()
        example2.children.append(demo2)
        
        let _ = exampleStackPanel.children.remove(at: exampleStackPanel.children.index(of: example2)!)
        exampleStackPanel.children.append(ControlExample(
            headerText: "An AppBarToggleButton with a bitmap icon.",
            isOutputDisplay: false,
            isOptionsDisplay: false,
            contentPresenter: example2
        ).controlExample)
        
        // Example 3: Font icon
        let example3: Grid = try! page.findName("Example3") as! Grid
        let demo3 = createExample3()
        example3.children.append(demo3)
        
        let _ = exampleStackPanel.children.remove(at: exampleStackPanel.children.index(of: example3)!)
        exampleStackPanel.children.append(ControlExample(
            headerText: "An AppBarToggleButton with a font icon.",
            isOutputDisplay: false,
            isOptionsDisplay: false,
            contentPresenter: example3
        ).controlExample)
        
        // Example 4: Three-state with path icon
        let example4: Grid = try! page.findName("Example4") as! Grid
        let demo4 = createExample4()
        example4.children.append(demo4)
        
        let _ = exampleStackPanel.children.remove(at: exampleStackPanel.children.index(of: example4)!)
        exampleStackPanel.children.append(ControlExample(
            headerText: "A three-state AppBarToggleButton with a path icon.",
            isOutputDisplay: false,
            isOptionsDisplay: false,
            contentPresenter: example4
        ).controlExample)
    }
    
    private func createExample1() -> StackPanel {
        let panel = StackPanel()
        panel.orientation = .horizontal
        panel.spacing = 8
        
        // 创建按钮容器
        let buttonContainer = StackPanel()
        buttonContainer.horizontalAlignment = .center
        buttonContainer.verticalAlignment = .center
        buttonContainer.spacing = 8
        
        // 创建模拟 AppBarToggleButton 的按钮
        button1 = Button()
        let icon1 = TextBlock()
        icon1.text = "\u{E8B1}"  // Shuffle icon
        icon1.fontSize = 40
        icon1.fontFamily = FontFamily("Segoe MDL2 Assets")
        button1.content = icon1
        button1.width = 80
        button1.height = 80
        button1.background = nil
        button1.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        button1.click.addHandler { [weak self] _, _ in
            self?.toggleButton1()
        }
        buttonContainer.children.append(button1)
        
        // 添加标签
        let label = TextBlock()
        label.text = "SymbolIcon"
        label.textAlignment = .center
        label.fontSize = 12
        buttonContainer.children.append(label)
        
        panel.children.append(buttonContainer)
        
        // 创建输出文本
        output1 = TextBlock()
        output1.text = "IsChecked = False"
        output1.verticalAlignment = .center
        output1.margin = Thickness(left: 16, top: 0, right: 0, bottom: 0)
        output1.foreground = SolidColorBrush(Color(a: 255, r: 200, g: 200, b: 200))
        panel.children.append(output1)
        
        return panel
    }
    
    private func createExample2() -> StackPanel {
        let panel = StackPanel()
        panel.orientation = .horizontal
        panel.spacing = 8
        
        // 创建按钮容器
        let buttonContainer = StackPanel()
        buttonContainer.horizontalAlignment = .center
        buttonContainer.verticalAlignment = .center
        buttonContainer.spacing = 8
        
        // 创建模拟 AppBarToggleButton 的按钮（使用 bitmap icon）
        button2 = Button()
        let icon2 = TextBlock()
        icon2.text = "\u{E91B}"  // PictureEdit icon
        icon2.fontSize = 40
        icon2.fontFamily = FontFamily("Segoe MDL2 Assets")
        button2.content = icon2
        button2.width = 80
        button2.height = 80
        button2.background = nil
        button2.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        button2.click.addHandler { [weak self] _, _ in
            self?.toggleButton2()
        }
        buttonContainer.children.append(button2)
        
        // 添加标签
        let label = TextBlock()
        label.text = "BitmapIcon"
        label.textAlignment = .center
        label.fontSize = 12
        buttonContainer.children.append(label)
        
        panel.children.append(buttonContainer)
        
        // 创建输出文本
        output2 = TextBlock()
        output2.text = "IsChecked = False"
        output2.verticalAlignment = .center
        output2.margin = Thickness(left: 16, top: 0, right: 0, bottom: 0)
        output2.foreground = SolidColorBrush(Color(a: 255, r: 200, g: 200, b: 200))
        panel.children.append(output2)
        
        return panel
    }
    
    private func createExample3() -> StackPanel {
        let panel = StackPanel()
        panel.orientation = .horizontal
        panel.spacing = 8
        
        // 创建按钮容器
        let buttonContainer = StackPanel()
        buttonContainer.horizontalAlignment = .center
        buttonContainer.verticalAlignment = .center
        buttonContainer.spacing = 8
        
        // 创建模拟 AppBarToggleButton 的按钮（使用 font icon）
        button3 = Button()
        let icon3 = TextBlock()
        icon3.text = "Σ"  // Greek letter Sigma (Glyph 0x03A3)
        icon3.fontSize = 48
        icon3.fontFamily = FontFamily("Candara")
        button3.content = icon3
        button3.width = 80
        button3.height = 80
        button3.background = nil
        button3.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        button3.click.addHandler { [weak self] _, _ in
            self?.toggleButton3()
        }
        buttonContainer.children.append(button3)
        
        // 添加标签
        let label = TextBlock()
        label.text = "FontIcon"
        label.textAlignment = .center
        label.fontSize = 12
        buttonContainer.children.append(label)
        
        panel.children.append(buttonContainer)
        
        // 创建输出文本
        output3 = TextBlock()
        output3.text = "IsChecked = False"
        output3.verticalAlignment = .center
        output3.margin = Thickness(left: 16, top: 0, right: 0, bottom: 0)
        output3.foreground = SolidColorBrush(Color(a: 255, r: 200, g: 200, b: 200))
        panel.children.append(output3)
        
        return panel
    }
    
    private func createExample4() -> StackPanel {
        let panel = StackPanel()
        panel.orientation = .horizontal
        panel.spacing = 8
        
        // 创建按钮容器
        let buttonContainer = StackPanel()
        buttonContainer.horizontalAlignment = .center
        buttonContainer.verticalAlignment = .center
        buttonContainer.spacing = 8
        
        // 创建模拟 AppBarToggleButton 的按钮（使用 path icon）
        button4 = Button()
        let icon4 = TextBlock()
        icon4.text = "▶"  // Triangle path icon
        icon4.fontSize = 40
        icon4.fontFamily = FontFamily("Segoe MDL2 Assets")
        button4.content = icon4
        button4.width = 80
        button4.height = 80
        button4.background = nil
        button4.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        button4.click.addHandler { [weak self] _, _ in
            self?.toggleButton4ThreeState()
        }
        buttonContainer.children.append(button4)
        
        // 添加标签
        let label = TextBlock()
        label.text = "PathIcon"
        label.textAlignment = .center
        label.fontSize = 12
        buttonContainer.children.append(label)
        
        panel.children.append(buttonContainer)
        
        // 创建输出文本
        output4 = TextBlock()
        output4.text = "IsChecked = False"
        output4.verticalAlignment = .center
        output4.margin = Thickness(left: 16, top: 0, right: 0, bottom: 0)
        output4.foreground = SolidColorBrush(Color(a: 255, r: 200, g: 200, b: 200))
        panel.children.append(output4)
        
        return panel
    }
    
    // Toggle 方法
    private func toggleButton1() {
        isChecked1.toggle()
        updateButtonAppearance(button: button1, isChecked: isChecked1)
        output1.text = "IsChecked = \(isChecked1 ? "True" : "False")"
    }
    
    private func toggleButton2() {
        isChecked2.toggle()
        updateButtonAppearance(button: button2, isChecked: isChecked2)
        output2.text = "IsChecked = \(isChecked2 ? "True" : "False")"
    }
    
    private func toggleButton3() {
        isChecked3.toggle()
        updateButtonAppearance(button: button3, isChecked: isChecked3)
        output3.text = "IsChecked = \(isChecked3 ? "True" : "False")"
    }
    
    private func toggleButton4ThreeState() {
        // Three-state: false -> true -> nil -> false
        if let checked = isChecked4 {
            if checked {
                isChecked4 = nil
                output4.text = "IsChecked = Null"
                updateButtonAppearance(button: button4, isChecked: nil)
            } else {
                isChecked4 = true
                output4.text = "IsChecked = True"
                updateButtonAppearance(button: button4, isChecked: true)
            }
        } else {
            isChecked4 = false
            output4.text = "IsChecked = False"
            updateButtonAppearance(button: button4, isChecked: false)
        }
    }
    
    private func updateButtonAppearance(button: Button, isChecked: Bool?) {
        // 更新按钮外观以反映 checked 状态
        if let checked = isChecked, checked {
            // Checked state: 使用强调色背景
            button.background = SolidColorBrush(Color(a: 255, r: 0, g: 120, b: 212))
            button.foreground = SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        } else if isChecked == nil {
            // Indeterminate state: 使用半透明强调色
            button.background = SolidColorBrush(Color(a: 128, r: 0, g: 120, b: 212))
            button.foreground = SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        } else {
            // Unchecked state: 透明背景
            button.background = nil
            button.foreground = SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        }
    }
    
    private func loadXamlFromFile(filePath: String) {
        do {
            let root = try XamlReader.load(FileReader.readFileFromPath(filePath) ?? "")
            if let page = root as? Page {
                self.page = page
            } else {
                print("XAML根元素类型转换失败, 实际类型: \(type(of: root))")
            }
        } catch {
            print("XAML 加载失败: \(error)")
        }
    }
}