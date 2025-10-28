import WinUI
import WinAppSDK
import Foundation
import UWP
import WindowsFoundation

class TreeViewPage: Page {
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
    }

    private func setupPageHeader() {
        let controlInfo = ControlInfo(
            title: "TreeView",
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
                    title: "TreeView-API",
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
        textBlock.text = "The TreeView control is a hierarchical list pattern with expanding and collapsing nodes that contain nested items. "
        textBlock.textWrapping = .wrap
        stackPanel.children.append(textBlock)
    }

    private func setupExample1() {
        let grid = Grid()
        grid.horizontalAlignment = .left
        grid.height = 280
        grid.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        let treeView = TreeView()
        treeView.minWidth = 345
        treeView.maxHeight = 400
        treeView.margin = Thickness(left: 0, top: 12, right: 0, bottom: 0)
        treeView.horizontalAlignment = .center
        treeView.verticalAlignment = .top
        treeView.allowDrop = true
        treeView.canDragItems = true
        for i in 0..<5 {
            let tb = TextBlock()
            tb.text = "Item \(i)"
            let treeViewNode = TreeViewNode()
            for j in 0..<5 {
                let tb2 = TextBlock()
                tb2.text = "Item \(i)-\(j)"
                let treeViewNode2 = TreeViewNode()
                treeViewNode2.content = tb2
                treeViewNode.children.append(treeViewNode2)
            }
            treeViewNode.content = tb
            treeView.rootNodes.append(treeViewNode)
        }
        grid.children.append(treeView)
        let Example1 = ControlExample(
            headerText: "A simple TreeView with drag and drop support",
            contentPresenter: grid,
        )
        self.stackPanel.children.append(Example1.controlExample)
    }
}