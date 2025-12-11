import WinUI
import WinAppSDK
import Foundation
import UWP
import WindowsFoundation

class PullToRefreshPage: Page {
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
            title: "PullToRefresh",
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
                    title: "PullToRefresh-API",
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
        textBlock.text = "PullToRefresh lets a user pull down on a list of data using touch in order to retrieve more data. PullToRefresh is widely used on devices with a touch screen."
        textBlock.textWrapping = .wrap
        stackPanel.children.append(textBlock)
    }

    private func setupExample1() {
        let refreshContainer = RefreshContainer()
        refreshContainer.horizontalAlignment = .center
        refreshContainer.verticalAlignment = .center
        let listView = ListView()
        listView.name = "lv"
        listView.height = 200
        listView.minWidth = 200
        listView.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        for i in ["AcrylicBrush", "ColorPicker", "NavigationView", "ParallaxView", "PersonPicture"] {
            let textBlock = TextBlock()
            textBlock.text = i
            listView.items.append(textBlock)
        }
        refreshContainer.content = listView
        let stackPanel = StackPanel()
        stackPanel.horizontalAlignment = .left
        stackPanel.children.append(refreshContainer)

        let controlExample = ControlExample()
        controlExample.headerText = "Basic PullToRefresh"
        controlExample.example = stackPanel
        self.stackPanel.children.append(controlExample.view)
        // let Example1 = ControlExample(
        //     headerText: "Basic PullToRefresh",
        //     contentPresenter: stackPanel,
        // )
        // self.stackPanel.children.append(Example1.controlExample)
    }

    private func setupExample2() {
        let refreshContainer = RefreshContainer()
        refreshContainer.horizontalAlignment = .center
        refreshContainer.verticalAlignment = .center
        let listView = ListView()
        listView.name = "lv"
        listView.height = 200
        listView.minWidth = 200
        listView.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        for i in ["Mike", "Ben", "Barbra", "Claire", "Brain"] {
            let textBlock = TextBlock()
            textBlock.text = i
            listView.items.append(textBlock)
        }
        refreshContainer.content = listView
        let stackPanel = StackPanel()
        stackPanel.horizontalAlignment = .left
        stackPanel.children.append(refreshContainer)

        let controlExample = ControlExample()
        controlExample.headerText = "Basic PullToRefresh"
        controlExample.example = stackPanel
        self.stackPanel.children.append(controlExample.view)
        // let Example1 = ControlExample(
        //     headerText: "Basic PullToRefresh",
        //     contentPresenter: stackPanel,
        // )
        // self.stackPanel.children.append(Example1.controlExample)
    }
}