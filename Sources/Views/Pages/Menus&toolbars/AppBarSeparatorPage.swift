import WinUI
import UWP
import Foundation

class AppBarSeparatorPage: Grid {
    private var page: Page = Page()
    private var compactButtonPanel: StackPanel!
    private var expandedButtonPanel: Border!
    private var dismissLayer: Border!
    private var isExpanded: Bool = false
    
    override init() {
        super.init()
        loadXamlFromFile(
            filePath: Bundle.module.path(
                forResource: "AppBarSeparatorPage", 
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
            title: "AppBarSeparator",
            apiNamespace: "Microsoft.UI.Xaml.Controls",
            baseClasses: [
                "Object",
                "DependencyObject",
                "UIElement",
                "FrameworkElement",
                "Control"
            ],
            docs: [
                ControlInfoDocLink(
                    title: "AppBarSeparator API",
                    uri: "https://learn.microsoft.com/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.controls.appbarseparator"
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
        
        let descText = TextBlock()
        descText.text = "An AppBarSeparator creates a vertical line to visually separate groups of commands in an app bar. It has a compact state with reduced padding to match the compact state of the AppBarButton and AppBarToggleButton controls."
        descText.textWrapping = .wrap
        descText.fontSize = 14
        descText.margin = Thickness(left: 0, top: 0, right: 0, bottom: 16)
        exampleStackPanel.children.append(descText)
    }
    
    private func setupExample() {
        let exampleStackPanel = try! page.findName("exampleStackPanel") as! StackPanel
        let example1: Grid = try! page.findName("Example1") as! Grid
        
        let demoContainer = createDemoArea()
        example1.children.append(demoContainer)
        
        let _ = exampleStackPanel.children.remove(at: exampleStackPanel.children.index(of: example1)!)
        exampleStackPanel.children.append(ControlExample(
            headerText: "AppBarButtons separated by AppBarSeparators",
            isOutputDisplay: false,
            isOptionsDisplay: false,
            contentPresenter: example1
        ).controlExample)
    }
    
    private func createDemoArea() -> Grid {
        let containerGrid = Grid()
        containerGrid.minHeight = 120
        
        // 紧凑按钮栏（默认显示）
        compactButtonPanel = createCompactButtonPanel()
        compactButtonPanel.horizontalAlignment = .left
        compactButtonPanel.verticalAlignment = .center
        containerGrid.children.append(compactButtonPanel)
        
        // 添加透明遮罩层（用于捕获外部点击）
        dismissLayer = Border()
        dismissLayer.background = SolidColorBrush(Color(a: 1, r: 0, g: 0, b: 0))
        dismissLayer.visibility = .collapsed
        dismissLayer.horizontalAlignment = .stretch
        dismissLayer.verticalAlignment = .stretch
        
        dismissLayer.pointerPressed.addHandler { [weak self] sender, args in
            self?.collapseExpanded()
            if let args = args {
                args.handled = true
            }
        }
        
        containerGrid.children.append(dismissLayer)
        
        // 展开的按钮栏（覆盖显示）
        expandedButtonPanel = createExpandedButtonPanel()
        expandedButtonPanel.visibility = .collapsed
        expandedButtonPanel.horizontalAlignment = .left
        expandedButtonPanel.verticalAlignment = .center
        containerGrid.children.append(expandedButtonPanel)
        
        return containerGrid
    }
    
    private func createCompactButtonPanel() -> StackPanel {
        let panel = StackPanel()
        panel.orientation = .horizontal
        panel.spacing = 0
        
        panel.children.append(createCompactButton("\u{E722}"))  // Camera
        panel.children.append(createSeparator())
        panel.children.append(createCompactButton("\u{E8E1}"))  // Like
        panel.children.append(createCompactButton("\u{E8E0}"))  // Dislike
        panel.children.append(createSeparator())
        panel.children.append(createCompactButton("\u{E8A5}"))  // Page/Document
        
        let moreButton = createCompactButton("\u{E712}")  // More icon (省略号)
        moreButton.click.addHandler { [weak self] _, _ in
            self?.showExpanded()
        }
        panel.children.append(moreButton)
        
        return panel
    }
    
    private func createExpandedButtonPanel() -> Border {
        let border = Border()
        border.background = SolidColorBrush(Color(a: 255, r: 50, g: 50, b: 50))
        border.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        border.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = SolidColorBrush(Color(a: 255, r: 60, g: 60, b: 60))
        
        let panel = StackPanel()
        panel.orientation = .horizontal
        panel.spacing = 0
        
        // Camera button
        let cameraBtn = createLabeledButton("\u{E722}", "Attach\nCamera")
        panel.children.append(cameraBtn)
        panel.children.append(createSeparator())
        
        // Like button
        let likeBtn = createLabeledButton("\u{E8E1}", "Like")
        panel.children.append(likeBtn)
        
        // Dislike button
        let dislikeBtn = createLabeledButton("\u{E8E0}", "Dislike")
        panel.children.append(dislikeBtn)
        panel.children.append(createSeparator())
        
        // Orientation button
        let orientationBtn = createLabeledButton("\u{E8A5}", "Orientation")
        panel.children.append(orientationBtn)
        
        // More button (closes expanded view)
        let moreBtn = createLabeledButton("\u{E712}", "")  // More icon (省略号)
        panel.children.append(moreBtn)
        
        border.child = panel
        return border
    }
    
    private func showExpanded() {
        isExpanded = true
        compactButtonPanel.visibility = .collapsed
        expandedButtonPanel.visibility = .visible
        dismissLayer.visibility = .visible
    }
    
    private func collapseExpanded() {
        isExpanded = false
        compactButtonPanel.visibility = .visible
        expandedButtonPanel.visibility = .collapsed
        dismissLayer.visibility = .collapsed
    }
    
    private func toggleExpanded() {
        if isExpanded {
            collapseExpanded()
        } else {
            showExpanded()
        }
    }
    
    private func createCompactButton(_ icon: String) -> Button {
        let button = Button()
        let iconText = TextBlock()
        iconText.text = icon
        iconText.fontSize = 20
        iconText.fontFamily = FontFamily("Segoe MDL2 Assets")
        button.content = iconText
        button.width = 48
        button.height = 48
        button.margin = Thickness(left: 8, top: 0, right: 8, bottom: 0)
        button.background = nil
        button.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        return button
    }
    
    private func createLabeledButton(_ icon: String, _ label: String) -> Button {
        let button = Button()
        button.margin = Thickness(left: 12, top: 0, right: 12, bottom: 0)
        button.minWidth = 70
        button.background = nil
        button.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        button.padding = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        
        let panel = StackPanel()
        panel.spacing = 4
        
        let iconText = TextBlock()
        iconText.text = icon
        iconText.fontSize = 20
        iconText.fontFamily = FontFamily("Segoe MDL2 Assets")
        iconText.horizontalAlignment = .center
        iconText.foreground = SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        panel.children.append(iconText)
        
        if !label.isEmpty {
            let labelText = TextBlock()
            labelText.text = label
            labelText.fontSize = 12
            labelText.horizontalAlignment = .center
            labelText.textAlignment = .center
            labelText.foreground = SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
            labelText.margin = Thickness(left: 0, top: 4, right: 0, bottom: 0)
            panel.children.append(labelText)
        }
        
        button.content = panel
        
        // 添加点击事件关闭展开面板
        button.click.addHandler { [weak self] _, _ in
            self?.collapseExpanded()
        }
        
        return button
    }
    
    private func createSeparator() -> Border {
        let separator = Border()
        separator.width = 1
        separator.height = 48
        separator.background = SolidColorBrush(Color(a: 255, r: 60, g: 60, b: 60))
        separator.margin = Thickness(left: 12, top: 0, right: 12, bottom: 0)
        return separator
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