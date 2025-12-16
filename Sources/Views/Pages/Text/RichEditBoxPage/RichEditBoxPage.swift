import WinUI

class RichEditBoxPage: Page {
    private var pageRootGrid: Grid = Grid()
    private var exampleStackPanel: StackPanel = StackPanel()
    private var headerGrid: Grid = Grid()
    private var bodyScrollViewer: ScrollViewer = ScrollViewer()
    private var bodyStackPanel: StackPanel = StackPanel()

    override init() {
        super.init()
        setupPageUI()
        setupHeader()
        setupBody()
    }
    
    private func setupPageUI() {
        self.padding = Thickness(left: 36, top: 36, right: 36, bottom: 0)

        let row1: RowDefinition = RowDefinition()
        row1.height = GridLength(value: 1, gridUnitType: GridUnitType.auto)
        pageRootGrid.rowDefinitions.append(row1)
        let row2: RowDefinition = RowDefinition()
        row2.height = GridLength(value: 1, gridUnitType: GridUnitType.star)
        pageRootGrid.rowDefinitions.append(row2)
        
        try! Grid.setRow(headerGrid, 0)
        pageRootGrid.children.append(headerGrid)
        try! Grid.setRow(bodyScrollViewer, 1)
        pageRootGrid.children.append(bodyScrollViewer)
        self.content = pageRootGrid
    }

    private func setupHeader() {
        let controlInfo = ControlInfo(
            title: "RichEditBox",
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
                    title: "RichEditBox-API", 
                    uri: "https://learn.microsoft.com/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.controls.richeditbox"),
                ControlInfoDocLink(
                    title: "Guidelines", 
                    uri: "https://learn.microsoft.com/zh-cn/windows/apps/develop/ui/controls/rich-text-block")
            ]
        )
        let pageHeader: PageHeader = PageHeader(item: controlInfo)
        pageHeader.themeButtonVisibility = .visible
        pageHeader.margin = Thickness(left: 36, top: 36, right: 36, bottom: 0)
        self.headerGrid.children.append(pageHeader)
    }

    private func setupBody() {
        self.bodyScrollViewer.margin = Thickness(left: 36, top: 0, right: 36, bottom: 0)
        bodyStackPanel.spacing = 8
        bodyStackPanel.orientation = .vertical

        let descText = TextBlock()
        descText.textWrapping = .wrap
        descText.text = """
        You can use a RichEditBox control to enter and edit rich text documents that ontain formated text, hyperinks, and images. By efault,the RichEditBox supports spellchecking.Youcan make a RichEditBox read-only by setting its lsReadOnly property to true.
        """
        bodyStackPanel.children.append(descText)
        
        setupSimpleRich()

        self.bodyScrollViewer.content = bodyStackPanel 
    }

    private func setupSimpleRich() {
        let ex = ControlExample()
        ex.headerText = "Can't Use RichEditBox for some reason."
        
        // let rich = RichEditBox()
        // ex.example = rich
        bodyStackPanel.children.append(ex.view)
    }
}