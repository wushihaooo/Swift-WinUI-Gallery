import WinUI
import UWP
import Foundation
import WindowsFoundation

class CommandBarFlyoutPage: Grid {
    private var page: Page = Page()
    private var imageButton: Button!
    private var selectedOptionText: TextBlock!
    private var flyoutPanel: Border!
    private var secondaryCommandsPanel: StackPanel!
    private var dismissLayer: Border!
    private var isFlyoutVisible: Bool = false
    private var areSecondaryCommandsVisible: Bool = false
    
    override init() {
        super.init()
        loadXamlFromFile(
            filePath: Bundle.module.path(
                forResource: "CommandBarFlyoutPage", 
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
            title: "CommandBarFlyout",
            apiNamespace: "Microsoft.UI.Xaml.Controls",
            baseClasses: [
                "Object",
                "DependencyObject",
                "FlyoutBase",
                "CommandBarFlyout"
            ],
            docs: [
                ControlInfoDocLink(
                    title: "CommandBarFlyout API",
                    uri: "https://learn.microsoft.com/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.controls.commandbarflyout"
                ),
                ControlInfoDocLink(
                    title: "Guidelines",
                    uri: "https://learn.microsoft.com/windows/apps/design/controls/command-bar-flyout"
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
        
        // 添加页面描述
        let descText = TextBlock()
        descText.text = "A mini-toolbar which displays a set of proactive commands, as well as a secondary menu of commands if desired."
        descText.textWrapping = .wrap
        descText.fontSize = 14
        descText.margin = Thickness(left: 0, top: 0, right: 0, bottom: 24)
        exampleStackPanel.children.append(descText)
    }
    
    private func setupExample() {
        let exampleStackPanel = try! page.findName("exampleStackPanel") as! StackPanel
        
        let example1: Grid = try! page.findName("Example1") as! Grid
        let demo = createCommandBarFlyoutDemo()
        example1.children.append(demo)
        
        let _ = exampleStackPanel.children.remove(at: exampleStackPanel.children.index(of: example1)!)
        exampleStackPanel.children.append(ControlExample(
            headerText: "CommandBarFlyout for commands on an in-app object",
            isOutputDisplay: false,
            isOptionsDisplay: false,
            contentPresenter: example1
        ).controlExample)
    }
    
    private func createCommandBarFlyoutDemo() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12
        
        // 添加说明文字
        let instructionText = TextBlock()
        instructionText.text = "Click or right click the image to open a CommandBarFlyout"
        instructionText.fontSize = 14
        panel.children.append(instructionText)
        
        // 创建一个容器来放置图片和浮动菜单
        let container = Grid()
        container.margin = Thickness(left: 0, top: 12, right: 0, bottom: 0)
        
        // 创建图片按钮
        imageButton = Button()
        imageButton.padding = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        imageButton.background = nil
        imageButton.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        
        // 创建图片（直接加载真实图片文件）
        let image = Border()
        image.width = 400
        image.height = 300
        image.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        
        // 创建 Image 控件并加载图片
        let imageElement = Image()
        imageElement.stretch = .uniformToFill
        
        // 加载图片资源
        let imagePath = Bundle.module.path(forResource: "rainier", ofType: "jpg", inDirectory: "Assets/SampleMedia")!
        imageElement.source = BitmapImage(Uri(imagePath))
        
        image.child = imageElement
        imageButton.content = image
        
        // 添加点击事件（左键点击显示 flyout）
        imageButton.click.addHandler { [weak self] _, _ in
            self?.showFlyout()
        }
        
        // 注意：右键点击功能在当前 Swift 绑定中可能需要额外的事件处理
        // 目前左键点击即可显示 flyout
        
        container.children.append(imageButton)
        
        // 添加全屏透明背景层，用于捕获点击外部区域的事件
        let dismissLayer = Border()
        dismissLayer.background = SolidColorBrush(Color(a: 1, r: 0, g: 0, b: 0)) // 几乎完全透明
        dismissLayer.visibility = .collapsed // 初始隐藏
        dismissLayer.horizontalAlignment = .stretch
        dismissLayer.verticalAlignment = .stretch
        
        // 点击透明层时关闭 flyout
        dismissLayer.pointerPressed.addHandler { [weak self] sender, args in
            self?.hideFlyout()
            if let args = args {
                args.handled = true
            }
        }
        
        // 将透明层添加到容器（在图片和 flyout 之间）
        container.children.append(dismissLayer)
        
        // 保存引用以便控制显示/隐藏
        self.dismissLayer = dismissLayer
        
        // 创建 CommandBarFlyout（初始隐藏）
        flyoutPanel = createFlyoutPanel()
        flyoutPanel.visibility = .collapsed
        flyoutPanel.horizontalAlignment = .left
        flyoutPanel.verticalAlignment = .top
        // 定位在图片右侧，紧贴图片（图片宽度 400 + 小间距 8）
        flyoutPanel.margin = Thickness(left: 408, top: 100, right: 0, bottom: 0)
        
        container.children.append(flyoutPanel)
        
        panel.children.append(container)
        
        // 输出文本
        selectedOptionText = TextBlock()
        selectedOptionText.text = ""
        selectedOptionText.fontSize = 14
        selectedOptionText.foreground = SolidColorBrush(Color(a: 255, r: 180, g: 180, b: 180))
        panel.children.append(selectedOptionText)
        
        return panel
    }
    
    private func createFlyoutPanel() -> Border {
        let flyout = Border()
        flyout.background = SolidColorBrush(Color(a: 250, r: 44, g: 44, b: 44))
        flyout.borderBrush = SolidColorBrush(Color(a: 255, r: 70, g: 70, b: 70))
        flyout.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        flyout.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        flyout.padding = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        
        let contentPanel = StackPanel()
        contentPanel.spacing = 0
        
        // Primary commands (horizontal)
        let primaryCommands = StackPanel()
        primaryCommands.orientation = .horizontal
        primaryCommands.spacing = 0
        primaryCommands.horizontalAlignment = .left
        primaryCommands.padding = Thickness(left: 4, top: 4, right: 4, bottom: 4)
        
        // Share button
        let shareButton = createFlyoutButton("\u{E72D}", "Share")
        primaryCommands.children.append(shareButton)
        
        // Save button
        let saveButton = createFlyoutButton("\u{E74E}", "Save")
        primaryCommands.children.append(saveButton)
        
        // Delete button
        let deleteButton = createFlyoutButton("\u{E74D}", "Delete")
        primaryCommands.children.append(deleteButton)
        
        // More button (ellipsis)
        let moreButton = Button()
        moreButton.content = "⋯"
        moreButton.width = 40
        moreButton.height = 68
        moreButton.fontSize = 20
        moreButton.background = nil
        moreButton.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        moreButton.padding = Thickness(left: 4, top: 12, right: 4, bottom: 8)
        moreButton.click.addHandler { [weak self] _, _ in
            self?.toggleSecondaryCommands()
        }
        primaryCommands.children.append(moreButton)
        
        contentPanel.children.append(primaryCommands)
        
        // Secondary commands (vertical, initially hidden)
        secondaryCommandsPanel = createSecondaryCommandsPanel()
        contentPanel.children.append(secondaryCommandsPanel)
        
        flyout.child = contentPanel
        
        return flyout
    }
    
    private func createFlyoutButton(_ icon: String, _ label: String) -> Button {
        let button = Button()
        
        let content = StackPanel()
        content.spacing = 2
        content.horizontalAlignment = .center
        content.verticalAlignment = .center
        
        let iconText = TextBlock()
        iconText.text = icon
        iconText.fontSize = 20
        iconText.fontFamily = FontFamily("Segoe MDL2 Assets")
        iconText.horizontalAlignment = .center
        iconText.verticalAlignment = .center
        content.children.append(iconText)
        
        let labelText = TextBlock()
        labelText.text = label
        labelText.fontSize = 12
        labelText.horizontalAlignment = .center
        labelText.textAlignment = .center
        labelText.textWrapping = .noWrap
        content.children.append(labelText)
        
        button.content = content
        button.width = 68
        button.height = 68
        button.background = nil
        button.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        button.padding = Thickness(left: 8, top: 12, right: 8, bottom: 8)
        
        button.click.addHandler { [weak self, label] _, _ in
            self?.onElementClicked(label)
        }
        
        return button
    }
    
    private func createSecondaryCommandsPanel() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 0
        panel.visibility = .collapsed
        panel.margin = Thickness(left: 0, top: 4, right: 0, bottom: 0)
        
        // Separator
        let separator = Border()
        separator.height = 1
        separator.background = SolidColorBrush(Color(a: 80, r: 100, g: 100, b: 100))
        separator.margin = Thickness(left: 8, top: 4, right: 8, bottom: 4)
        panel.children.append(separator)
        
        // Resize button
        let resizeButton = createSecondaryButton("Resize")
        panel.children.append(resizeButton)
        
        // Move button
        let moveButton = createSecondaryButton("Move")
        panel.children.append(moveButton)
        
        return panel
    }
    
    private func createSecondaryButton(_ label: String) -> Button {
        let button = Button()
        button.content = label
        // 次要命令宽度 = 3个按钮(68*3) + 1个更多按钮(40) + 4个间距(4*4) = 260
        button.width = 260
        button.height = 40
        button.horizontalContentAlignment = .left
        button.background = nil
        button.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        button.padding = Thickness(left: 12, top: 8, right: 12, bottom: 8)
        button.fontSize = 14
        
        button.click.addHandler { [weak self, label] _, _ in
            self?.onElementClicked(label)
        }
        
        return button
    }
    
    private func showFlyout() {
        isFlyoutVisible = true
        flyoutPanel.visibility = .visible
        dismissLayer.visibility = .visible  // 显示透明层用于捕获外部点击
        
        // 隐藏次要命令
        secondaryCommandsPanel.visibility = .collapsed
        areSecondaryCommandsVisible = false
    }
    
    private func hideFlyout() {
        isFlyoutVisible = false
        flyoutPanel.visibility = .collapsed
        dismissLayer.visibility = .collapsed  // 隐藏透明层
        secondaryCommandsPanel.visibility = .collapsed
        areSecondaryCommandsVisible = false
    }
    
    private func toggleSecondaryCommands() {
        areSecondaryCommandsVisible.toggle()
        secondaryCommandsPanel.visibility = areSecondaryCommandsVisible ? .visible : .collapsed
    }
    
    private func onElementClicked(_ elementName: String) {
        selectedOptionText.text = "You clicked: \(elementName)"
        
        // 直接隐藏 flyout（移除延迟以避免并发问题）
        hideFlyout()
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