import WinUI
import UWP
import Foundation

class AppBarButtonPage: Grid {
    private var page: Page = Page()
    private var clickMessageTextBlock: TextBlock!
    
    override init() {
        super.init()
        loadXamlFromFile(
            filePath: Bundle.module.path(
                forResource: "AppBarButtonPage", 
                ofType: "xaml", 
                inDirectory: "Assets/xaml") ?? ""
        )
        setupHeader()
        setupDescription()
        setupExample()
        self.children.append(page)
    }
    
    private func setupHeader() {
        let headerGrid = try! page.findName("headerGrid") as! Grid
        let controlInfo = ControlInfo(
            title: "AppBarButton",
            apiNamespace: "Microsoft.UI.Xaml.Controls",
            baseClasses: [
                "Object",
                "DependencyObject",
                "UIElement",
                "FrameworkElement",
                "Control",
                "ButtonBase",
                "Button"
            ],
            docs: [
                ControlInfoDocLink(
                    title: "AppBarButton API",
                    uri: "https://learn.microsoft.com/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.controls.appbarbutton"
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
        
        // 添加描述文本（在演示区域外面）
        let descText = TextBlock()
        descText.text = """
        AppBarButton differs from standard buttons in several ways:
        - Their default appearance is a transparent background with a smaller size.
        - You use the Label and Icon properties to set the content instead of the Content property. The Content property is ignored.
        - The button's IsCompact property controls its size.
        """
        descText.textWrapping = .wrap
        descText.fontSize = 14
        descText.margin = Thickness(left: 0, top: 0, right: 0, bottom: 16)
        exampleStackPanel.children.append(descText)
    }
    
    private func setupExample() {
        let exampleStackPanel = try! page.findName("exampleStackPanel") as! StackPanel
        let example1: Grid = try! page.findName("Example1") as! Grid
        
        // 创建演示区域
        let demoGrid = Grid()
        let leftCol = ColumnDefinition()
        leftCol.width = GridLength(value: 120, gridUnitType: .pixel)
        demoGrid.columnDefinitions.append(leftCol)
        
        let rightCol = ColumnDefinition()
        rightCol.width = GridLength(value: 1, gridUnitType: .star)
        demoGrid.columnDefinitions.append(rightCol)
        
        // 左侧：模拟 AppBarButton
        let buttonPanel = StackPanel()
        buttonPanel.horizontalAlignment = .center
        buttonPanel.verticalAlignment = .center
        buttonPanel.spacing = 8
        
        let demoBtn = Button()
        let iconText = TextBlock()
        iconText.text = "\u{E8E1}"  // Like icon from Segoe MDL2 Assets
        iconText.fontSize = 48
        iconText.fontFamily = FontFamily("Segoe MDL2 Assets")
        demoBtn.content = iconText
        demoBtn.width = 80
        demoBtn.height = 80
        demoBtn.click.addHandler { [weak self] _, _ in
            self?.onDemoButtonClicked()
        }
        buttonPanel.children.append(demoBtn)
        
        let btnLabel = TextBlock()
        btnLabel.text = "Symbolic\non"
        btnLabel.textAlignment = .center
        btnLabel.fontSize = 12
        buttonPanel.children.append(btnLabel)
        
        try? Grid.setColumn(buttonPanel, 0)
        demoGrid.children.append(buttonPanel)
        
        // 右侧：点击消息提示
        let messagePanel = StackPanel()
        messagePanel.verticalAlignment = .center
        messagePanel.padding = Thickness(left: 16, top: 0, right: 0, bottom: 0)
        
        clickMessageTextBlock = TextBlock()
        clickMessageTextBlock.text = "Click the button to see feedback"
        clickMessageTextBlock.fontSize = 14
        clickMessageTextBlock.foreground = SolidColorBrush(Color(a: 255, r: 200, g: 200, b: 200))
        messagePanel.children.append(clickMessageTextBlock)
        
        try? Grid.setColumn(messagePanel, 1)
        demoGrid.children.append(messagePanel)
        
        example1.children.append(demoGrid)
        
        let _ = exampleStackPanel.children.remove(at: exampleStackPanel.children.index(of: example1)!)
        exampleStackPanel.children.append(ControlExample(
            headerText: "An AppBarButton with a symbol icon",
            isOutputDisplay: false,
            isOptionsDisplay: false,
            contentPresenter: example1
        ).controlExample)
    }
    
    private func onDemoButtonClicked() {
        clickMessageTextBlock.text = "You clicked: AppBar-style Button (Like)"
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