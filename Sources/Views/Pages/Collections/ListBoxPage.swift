import WinUI
import WinAppSDK
import Foundation
import UWP
import WindowsFoundation

class ListBoxPage: Page {
    let stackPanel = StackPanel()
    override init(){ 
        super.init()
        let scrollViewer = ScrollViewer()
        scrollViewer.content = stackPanel
        self.content = scrollViewer
        stackPanel.margin = Thickness(left: 36, top: 36, right: 36, bottom: 36)
        self.setupPageHeader()
        self.setupTextHeader()
        self.setupExample1()
        self.setupExample2()
    }

    private func setupPageHeader() {
        let controlInfo = ControlInfo(
            title: "ListBox",
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
        let pageHeader = PageHeader(item: controlInfo)
        pageHeader.themeButtonVisibility = .visible
        stackPanel.children.append(pageHeader)
    }

    private func setupTextHeader() {
        let textBlock = TextBlock()
        textBlock.text = "Use a ListBox when you want the options to be visible all the time or when users can select more than one option at a time. ListBox controls are always open, which allows several items to be displayed to the user without user interaction."
        textBlock.textWrapping = .wrap
        stackPanel.children.append(textBlock)
    }

    private func setupExample1() {
        let rectangle = Rectangle()
        rectangle.width = 100
        rectangle.height = 30
        rectangle.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)
        let listBox = ListBox()
        listBox.name = "ListBox1"
        listBox.minWidth = 200
        listBox.highContrastAdjustment = .auto
        listBox.selectionChanged.addHandler { sender, args in
            // 获取选中的索引
            let selectedIndex = listBox.selectedIndex
            if selectedIndex >= 0 {
                // 根据选中的索引获取对应的文本
                if let selectedItem = listBox.items[Int(selectedIndex)] as? TextBlock {
                    let selectedText = selectedItem.text.lowercased()
                    // 根据选中的文本设置矩形颜色
                    switch selectedText {
                    case "blue":
                        rectangle.fill = SolidColorBrush(Colors.blue)
                    case "green":
                        rectangle.fill = SolidColorBrush(Colors.green)
                    case "red":
                        rectangle.fill = SolidColorBrush(Colors.red)
                    case "yellow":
                        rectangle.fill = SolidColorBrush(Colors.yellow)
                    default:
                        rectangle.fill = SolidColorBrush(Colors.black)
                    }
                }
            }
        }
        for color in ["Blue", "Green", "Red", "Yellow"] {
            let item = TextBlock()
            item.text = color
            item.fontSize = 16
            listBox.items.append(item)
        }
        let stackPanel = StackPanel()
        stackPanel.children.append(listBox)
        stackPanel.children.append(rectangle)
        let controlExample = ControlExample()
        controlExample.headerText = "A ListBox with items defined inline and its minimum width set."
        controlExample.example = stackPanel
        self.stackPanel.children.append(controlExample.view)
        // let Example1 = ControlExample(
        //     headerText: "A ListBox with items defined inline and its minimum width set.",
        //     contentPresenter: stackPanel,
        // )
        // self.stackPanel.children.append(Example1.controlExample)
    }

    private func setupExample2() {
        let textBlock = TextBlock()
        textBlock.text = "You can set the font used for this text."
        textBlock.fontFamily = FontFamily("Segoe UI")
        let listBox = ListBox()
        listBox.name = "ListBox2"
        listBox.minWidth = 200
        listBox.highContrastAdjustment = .auto
        listBox.selectionChanged.addHandler { sender, args in
            // 获取选中的索引
            let selectedIndex = listBox.selectedIndex
            if selectedIndex >= 0 {
                // 根据选中的索引获取对应的文本
                if let selectedItem = listBox.items[Int(selectedIndex)] as? TextBlock {
                    let selectedText = selectedItem.text.lowercased()
                    // 根据选中的文本设置矩形颜色
                    switch selectedText {
                    case "arial":
                        textBlock.fontFamily = FontFamily("Arial")
                    case "comic sans ms":
                        textBlock.fontFamily = FontFamily("Comic Sans MS")
                    case "courier new":
                        textBlock.fontFamily = FontFamily("Courier New")
                    case "segoe ui":
                        textBlock.fontFamily = FontFamily("Segoe UI")
                    default:
                        textBlock.fontFamily = FontFamily("Segoe UI")
                    }
                }
            }
        }
        for item in ["Arial", "Comic Sans MS", "Courier New", "Segoe UI"] {
            let tTextBlock = TextBlock()
            tTextBlock.text = item
            tTextBlock.fontSize = 16
            listBox.items.append(tTextBlock)
        }
        let stackPanel = StackPanel()
        stackPanel.children.append(listBox)
        stackPanel.children.append(textBlock)
        let controlExample = ControlExample()
        controlExample.headerText = "A ListBox with its ItemsSource and Height set."
        controlExample.example = stackPanel
        self.stackPanel.children.append(controlExample.view)
        // let Example1 = ControlExample(
        //     headerText: "A ListBox with its ItemsSource and Height set.",
        //     contentPresenter: stackPanel,
        // )
        // self.stackPanel.children.append(Example1.controlExample)
    }
}