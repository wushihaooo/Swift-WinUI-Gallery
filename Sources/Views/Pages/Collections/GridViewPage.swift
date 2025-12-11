import WinUI
import Foundation
import WindowsFoundation

class GridViewPage: Grid {
    private var page: Page = Page()
    private var exampleStackPanel: StackPanel = StackPanel()
    override init() {
        super.init()
        let filePath: String = Bundle.module.path(forResource: "GridViewPage", ofType: "xaml", inDirectory: "Assets/xaml") ?? ""
        loadXamlFromFile(filePath: filePath)
        setupHeader()
        setupExample1()
        setupExample2()
        self.children.append(page)
    }

    private func setupHeader() {
        let headerGrid = try! page.findName("headerGrid") as! Grid
        let pageHeader: PageHeader
        let controlInfo = ControlInfo(
            title: "GridView",
            apiNamespace: "Microsoft.UI.Xaml.Controls",
            baseClasses: [
                "Object",
                "DependencyObject",
                "UIElement",
                "FrameworkElement",
                "Control",
                "ItemsControl",
                "Selector",
                "ListViewBase"
            ],
            docs: [
                ControlInfoDocLink(
                    title: "GridView-API",
                    uri: "https://learn.microsoft.com/zh-cn/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.controls.listview?view=windows-app-sdk-1.8"
                ),
                ControlInfoDocLink(
                    title: "Guidelines",
                    uri: "https://learn.microsoft.com/zh-cn/windows/apps/design/controls/listview-and-gridview"
                )
            ]
        )
        pageHeader = PageHeader(item: controlInfo)
        pageHeader.themeButtonVisibility = .visible
        pageHeader.margin = Thickness(left: 36, top: 36, right: 36, bottom: 0)
        headerGrid.children.append(pageHeader)
    }

    private func createGridViewImage(imageName: String) -> Image {
        let image = Image()
        image.width = 190
        image.height = 130
        image.stretch = .uniformToFill
        image.source = BitmapImage(Uri(Bundle.module.path(forResource: imageName, ofType: "jpg", inDirectory: "Assets/SampleMedia")!))
        return image
    }
    let example1Data: [String] = ["cliff", "grapes", "rainier", "sunset", "valley"]
    private func setupExample1() {
        let example1: Grid = try! page.findName("Example1") as! Grid
        let exampleGridView1: GridView = try! example1.findName("exampleGridView1") as! GridView
        let clickOutput0 = try! example1.findName("ClickOutput0") as! TextBlock
        for item in example1Data {
            exampleGridView1.items.append(createGridViewImage(imageName: item))
        }
        exampleGridView1.itemClick.addHandler { sender, args in
            if let clickedItem = args?.clickedItem as? Image {
                // 在 GridView 的 Items 中查找索引
                var index = -1
                for i in 0..<Int(exampleGridView1.items.count) {
                    if let item = exampleGridView1.items[i] as? Image, item.source == clickedItem.source {
                        index = i
                        break
                    }
                }
                clickOutput0.text = "You clicked Item \(index + 1)"
            }
        }
        let _ = exampleStackPanel.children.remove(at: exampleStackPanel.children.index(of: example1)!)
        let controlExample = ControlExample()
        controlExample.headerText = "GridView with Layout Customization"
        controlExample.example = example1
        self.exampleStackPanel.children.append(controlExample.view)
        // self.exampleStackPanel.children.append(ControlExample(
        //     headerText: "GridView with Layout Customization",
        //     isOutputDisplay: false,
        //     isOptionsDisplay: false,
        //     contentPresenter: example1
        // ).controlExample)
    }
    func createStyledNumberBox(header: String, minValue: Double, maxValue: Double, value: Double, valueChangedHandler: @escaping (Double) -> Void) -> StackPanel {
        let stackPanel = StackPanel()
        stackPanel.orientation = .vertical
        stackPanel.spacing = 8
        
        // 创建标题
        let headerText = TextBlock()
        headerText.text = header
        stackPanel.children.append(headerText)
        
        // 创建TextBox作为数字输入框
        let textBox = TextBox()
        textBox.text = String(value)
        textBox.horizontalAlignment = .stretch
        
        // 添加输入验证和值改变处理
        textBox.textChanged.addHandler { (_, _) in
            let text = textBox.text
            if let number = Double(text) {
                if number >= minValue && number <= maxValue {
                    valueChangedHandler(number)
                }
            }
        }
        
        stackPanel.children.append(textBox)
        
        return stackPanel
    }

    // 设置NumberBox控件区域
    func createNumberBoxControls(styleGrid: GridView) -> StackPanel {
        let stackPanel = StackPanel()
        stackPanel.orientation = .vertical
        stackPanel.spacing = 12
        
        // Column Space NumberBox
        let columnSpaceControl = createStyledNumberBox(
            header: "Space between columns:",
            minValue: 0,
            maxValue: 50,
            value: 5
        ) { value in
            for element in styleGrid.items {
                guard value >= 0 && value <= 100 else { return }
                if let gridViewItem = element as? Image {
                    gridViewItem.margin = Thickness(
                        left: value, 
                        top: gridViewItem.margin.top, 
                        right: value, 
                        bottom: gridViewItem.margin.bottom)
                }
            }
        }
        
        // Row Space NumberBox
        let rowSpaceControl = createStyledNumberBox(
            header: "Space between rows:",
            minValue: 0,
            maxValue: 50,
            value: 5
        ) { value in
            guard value >= 0 && value <= 100 else { return }
            for element in styleGrid.items {
                if let gridViewItem = element as? Image {
                    gridViewItem.margin = Thickness(
                        left: gridViewItem.margin.left, 
                        top: value, 
                        right: gridViewItem.margin.right, 
                        bottom: value)
                }
            }
        }
        
        // Wrap Item Count NumberBox
        let wrapCountControl = createStyledNumberBox(
            header: "Maximum number of items before wrapping:",
            minValue: 1,
            maxValue: 10,
            value: 3
        ) { value in
            guard value >= 1 && value <= 8 else { return }
        }
        
        stackPanel.children.append(columnSpaceControl)
        stackPanel.children.append(rowSpaceControl)
        stackPanel.children.append(wrapCountControl)
        
        return stackPanel
    }
    
    
    private func setupExample2() {
        let example1: Grid = try! page.findName("Example2") as! Grid
        let styleGrid: GridView = try! example1.findName("StyledGrid") as! GridView
        for item in example1Data {
            styleGrid.items.append(createGridViewImage(imageName: item))
        }

        let _ = exampleStackPanel.children.remove(at: exampleStackPanel.children.index(of: example1)!)
        let controlExample = ControlExample()
        controlExample.headerText = "Basic GridView with Simple DataTemplate"
        controlExample.options = createNumberBoxControls(styleGrid: styleGrid)
        controlExample.example = example1
        self.exampleStackPanel.children.append(controlExample.view)
        // self.exampleStackPanel.children.append(ControlExample(
        //     headerText: "Basic GridView with Simple DataTemplate",
        //     isOutputDisplay: false,
        //     isOptionsDisplay: true,
        //     contentPresenter: example1,
        //     optionsPresenter: createNumberBoxControls(styleGrid: styleGrid)
        // ).controlExample)
    }

    private func loadXamlFromFile(filePath: String) {
        do {
            let root = try XamlReader.load(FileReader.readFileFromPath(filePath) ?? "")
            if let page = root as? Page {
                self.page = page        
                self.exampleStackPanel = try! page.findName("exampleStackPanel") as! StackPanel
            } else {
                print("XAML根元素类型转换失败, 实际类型: \(type(of: root))")
            }
        } catch {
            print("XAML 加载失败: \(error)")
        }
    }
}