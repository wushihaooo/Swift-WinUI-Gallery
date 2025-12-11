import WinUI
import Foundation
import WindowsFoundation
import WinAppSDK
import UWP

class FlipViewPage: Grid {
    private var page: Page = Page()
    private var exampleStackPanel: StackPanel = StackPanel()
    override init() {
        super.init()
        loadXamlFromFile(
            filePath: Bundle.module.path(
                forResource: "FlipViewPage", 
                ofType: "xaml", 
                inDirectory: "Assets/xaml") ?? ""
        )
        setupHeader()
        setupSimpleFlipView()
        setupBindFlipView()
        setupVerticalFlipView()
        self.children.append(page)
    }

    let simpleFlipViewImages: [String] = ["cliff", "grapes", "rainier", "sunset", "valley"]

    private func setupSimpleFlipView() {
        let example1: Grid = try! page.findName("Example1") as! Grid
        let simpleFlipView: FlipView = try! example1.findName("SimpleFlipView") as! FlipView
        for item in simpleFlipViewImages {
            let image = Image()
            image.source = BitmapImage(Uri(Bundle.module.path(forResource: item, ofType: "jpg", inDirectory: "Assets/SampleMedia")!))
            simpleFlipView.items.append(image)
        }

        let _ = exampleStackPanel.children.remove(at: exampleStackPanel.children.index(of: example1)!)
        let controlExample = ControlExample()
        controlExample.headerText = "A simple FlipView with items declared inline"
        controlExample.example = example1
        self.exampleStackPanel.children.append(controlExample.view)
        // self.exampleStackPanel.children.append(ControlExample(
        //     headerText: "A simple FlipView with items declared inline",
        //     isOutputDisplay: false,
        //     isOptionsDisplay: false,
        //     contentPresenter: example1
        // ).controlExample)
    }

    let bindFlipViewItems: [String] = ["Resources", "Style", "Binding", "Templates", "CustomControls", "ScratchPad"]

    func createFlipViewItem(title: String, imagePath: String) -> Grid {
        // 创建Grid容器
        let grid = Grid()
        
        // 设置Grid的行定义
        let row1 = RowDefinition()
        row1.height = GridLength(value: 1, gridUnitType: .star)
        grid.rowDefinitions.append(row1)
        
        let row2 = RowDefinition()
        row2.height = GridLength(value: 1, gridUnitType: .auto)
        grid.rowDefinitions.append(row2)
        
        // 创建Image控件
        let image = Image()
        image.width = 36
        image.verticalAlignment = .center
        image.stretch = .uniform
        
        // 设置图片源
        let uri = Uri(imagePath)
        let bitmapImage = BitmapImage()
        bitmapImage.uriSource = uri
        image.source = bitmapImage
        
        // 将Image添加到Grid
        grid.children.append(image)
        
        // 创建Border控件
        let border = Border()
        border.height = 60
        border.background = SolidColorBrush(Color(a: 165, r: 255, g: 255, b: 255)) // #A5FFFFFF
        try? Grid.setRow(border, 1) // Border在第1行
        
        // 创建TextBlock控件
        let textBlock = TextBlock()
        textBlock.text = title
        textBlock.padding = Thickness(left: 12, top: 12, right: 12, bottom: 12)
        textBlock.horizontalAlignment = .center
        textBlock.foreground = SolidColorBrush(Colors.black)
        textBlock.fontSize = 16 // 设置字体大小
        
        // 将TextBlock添加到Border中
        border.child = textBlock
        
        // 将Border添加到Grid
        grid.children.append(border)
        return grid
    }

    private func setupBindFlipView() {
        let example2: Grid = try! page.findName("Example2") as! Grid
        let bindFlipView: FlipView = try! example2.findName("bindFlipView") as! FlipView
        for item in bindFlipViewItems {
            let t_grid = createFlipViewItem(
                title: item, 
                imagePath: Bundle.module.path(forResource: "CodeTagIcon", ofType: "png", inDirectory: "Assets/ControlImages")!
            )
            bindFlipView.items.append(t_grid)
        }
        let _ = exampleStackPanel.children.remove(at: exampleStackPanel.children.index(of: example2)!)
        let controlExample = ControlExample()
        controlExample.headerText = "A simple FlipView with items declared inline"
        controlExample.example = example2
        self.exampleStackPanel.children.append(controlExample.view)
        // self.exampleStackPanel.children.append(ControlExample(
        //     headerText: "A simple FlipView with items declared inline",
        //     isOutputDisplay: false,
        //     isOptionsDisplay: false,
        //     contentPresenter: example2
        // ).controlExample)
    }
    
    private func setupVerticalFlipView() {
        let example3: Grid = try! page.findName("Example3") as! Grid
        let verticalFlipView: FlipView = try! example3.findName("VerticalFlipView") as! FlipView
        for item in simpleFlipViewImages {
            let image = Image()
            image.source = BitmapImage(Uri(Bundle.module.path(forResource: item, ofType: "jpg", inDirectory: "Assets/SampleMedia")!))
            verticalFlipView.items.append(image)
        }
        let _ = exampleStackPanel.children.remove(at: exampleStackPanel.children.index(of: example3)!)
        let controlExample = ControlExample()
        controlExample.headerText = "Vertical FlipView"
        controlExample.example = example3
        self.exampleStackPanel.children.append(controlExample.view)
        // self.exampleStackPanel.children.append(ControlExample(
        //     headerText: "Vertical FlipView",
        //     isOutputDisplay: false,
        //     isOptionsDisplay: false,
        //     contentPresenter: example3
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
    private func setupHeader() {
        let headerGrid = try! page.findName("headerGrid") as! Grid
        let pageHeader: PageHeader
        let controlInfo = ControlInfo(
            title: "FlipView",
            apiNamespace: "Microsoft.UI.Xaml.Controls",
            baseClasses: [
                "Object",
                "DependencyObject",
                "UIElement",
                "FrameworkElement",
                "Control",
                "ItemsControl",
                "Selector"
            ],
            docs: [
                ControlInfoDocLink(
                    title: "FlipView-API",
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
}