import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

class RichTextBlockPage: Page {
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
        setupHighlightRich()
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
            title: "RichTextBlock",
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
                    title: "TextBlock-API",
                    uri: "https://learn.microsoft.com/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.controls.richtextblock"
                ),
                ControlInfoDocLink(
                    title: "Guidelines",
                    uri: "https://learn.microsoft.com/zh-cn/windows/apps/develop/ui/controls/rich-text-block"
                )
            ]
        )
        let pageHeader: PageHeader = PageHeader(item: controlInfo)
        pageHeader.themeButtonVisibility = .visible
        pageHeader.margin = Thickness(left: 36, top: 36, right: 36, bottom: 0)
        self.headerGrid.children.append(pageHeader)
    }

    private func setupBody() {
        // setup component properties

        // bosyScrollViewer
        self.bodyScrollViewer.margin = Thickness(left: 36, top: 0, right: 36, bottom: 0)
        // self.bodyScrollViewer.row = 1

        // bodyStackPanel
        bodyStackPanel.spacing = 8
        bodyStackPanel.orientation = .vertical

        let descText = TextBlock()
        descText.textWrapping = .wrap
        descText.text = """
        RichTextBlock provides more advanced formatting features than the TextBlock control. You can apply character and paragraph formatting to the text in the RichTextBlock. For example, you can apply Bold, Italic, and Underline to any portion of the text in the control. You can use linked text containers (a RichTextBlock linked to RichTextBlock Overflow elements) to create advanced page layouts.
        """
        bodyStackPanel.children.append(descText)
        setupSimpleRich()
        setupCustomRich()
        setupOverflowRich()

        self.bodyScrollViewer.content = bodyStackPanel
    }
    
    private func setupSimpleRich() {
        let ex = ControlExample()
        bodyStackPanel.children.append(ex.view)
        ex.headerText = "A simple RichTextBlock"
        
        let rich = RichTextBlock()
        let p = Paragraph()
        let run = Run()
        run.text = "I am a RichTextBlock"
        p.inlines.append(run)
        rich.blocks.append(p)
        ex.example = rich
    }

    private func setupCustomRich() {
        let ex = ControlExample()
        ex.headerText = "A RichTextBlock with a custom selection highlight color."

        let rich = RichTextBlock()
        rich.textWrapping = .wrap
        rich.isTextSelectionEnabled = true
        let highlightBrush = SolidColorBrush()
        highlightBrush.color = Colors.green
        rich.selectionHighlightColor = highlightBrush

        let paragraph1 = Paragraph()
        let introRun = Run()
        introRun.text = "RichTextBlock provides a rich text display container that supports "
        paragraph1.inlines.append(introRun)

        let formattedRun = Run()
        formattedRun.text = "formatted text"
        formattedRun.fontStyle = .italic
        formattedRun.fontWeight = FontWeights.bold
        paragraph1.inlines.append(formattedRun)

        let commaRun = Run()
        commaRun.text = ", "
        paragraph1.inlines.append(commaRun)

        let hyperlink = Hyperlink()
        hyperlink.navigateUri = Uri("https://learn.microsoft.com/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.Documents.Hyperlink")
        let hyperlinkText = Run()
        hyperlinkText.text = "hyperlinks"
        hyperlink.inlines.append(hyperlinkText)
        paragraph1.inlines.append(hyperlink)

        let tailRun = Run()
        tailRun.text = ", inline images, and other rich content."
        paragraph1.inlines.append(tailRun)

        let paragraph2 = Paragraph()
        let paragraph2Run = Run()
        paragraph2Run.text = "RichTextBlock also supports a built-in overflow model."
        paragraph2.inlines.append(paragraph2Run)

        rich.blocks.append(paragraph1)
        rich.blocks.append(paragraph2)

        ex.example = rich
        bodyStackPanel.children.append(ex.view)
    }

    private func setupOverflowRich() {
        let ex = ControlExample()
        ex.headerText = "A RichTextBlock with overflow"
        let grid = Grid()
        for _ in 0..<3 {
            let col = ColumnDefinition()
            col.width = GridLength(value: 1, gridUnitType: .star)
            grid.columnDefinitions.append(col)
        }

        let rich = RichTextBlock()
        let firstOverflowContainer = RichTextBlockOverflow()
        let secondOverflowContainer = RichTextBlockOverflow()
        rich.maxHeight = 160
        firstOverflowContainer.maxHeight = 160
        secondOverflowContainer.maxHeight = 160
        try! Grid.setColumn(rich, 0)
        try! Grid.setColumn(firstOverflowContainer, 1)
        try! Grid.setColumn(secondOverflowContainer, 2)

        rich.overflowContentTarget = firstOverflowContainer
        rich.textAlignment = .justify
        rich.margin = Thickness(left: 12, top: 0, right: 0, bottom: 0)
        firstOverflowContainer.overflowContentTarget = secondOverflowContainer
        firstOverflowContainer.margin = Thickness(left: 12, top: 0, right: 0, bottom: 0)
        secondOverflowContainer.margin = Thickness(left: 12, top: 0, right: 0, bottom: 0)

        let p = Paragraph()
        let run = Run()
        run.text = """
        Linked text containers allow text which does not fit in one element to overflow into a different element on the page. Creative use of linked text containers enables basic multicolumn support and other advanced page layouts.
        Duis sed nulla metus, id hendrerit velit. Curabitur dolor purus, bibendum eu cursus lacinia, interdum vel augue. Aenean euismod eros et sapien vehicula dictum. Duis ullamcorper, turpis nec feugiat tincidunt, dui erat luctus risus, aliquam accumsan lacus est vel quam. Nunc lacus massa, varius eget accumsan id, congue sed orci. Duis dignissim hendrerit egestas. Proin ut turpis magna, sit amet porta erat. Nunc semper metus nec magna imperdiet nec vestibulum dui fringilla. Sed sed ante libero, nec porttitor mi. Ut luctus, neque vitae placerat egestas, urna leo auctor magna, sit amet ultricies ipsum felis quis sapien. Proin eleifend varius dui, at vestibulum nunc consectetur nec. Mauris nulla elit, ultrices a sodales non, aliquam ac est. Quisque sit amet risus nulla. Quisque vestibulum posuere velit, vitae vestibulum eros scelerisque sit amet. In in risus est, at laoreet dolor. Nullam aliquet pellentesque convallis. Ut vel tincidunt nulla. Mauris auctor tincidunt auctor. Aenean orci ante, vulputate ac sagittis sit amet, consequat at mi. Morbi elementum purus consectetur nisi adipiscing vitae blandit sapien placerat. Aliquam adipiscing tortor non sem lobortis consectetur mattis felis rhoncus. Nunc eu nunc rhoncus arcu sollicitudin ultrices. In vulputate eros in mauris aliquam id dignissim nisl laoreet.
        """
        p.inlines.append(run)
        rich.blocks.append(p)
        grid.children.append(rich)
        grid.children.append(firstOverflowContainer)
        grid.children.append(secondOverflowContainer)
        ex.example = grid
        bodyStackPanel.children.append(ex.view)
    }
    
    private func setupHighlightRich() {
        let ex = ControlExample()
        ex.headerText = "RichTextBlock with custom TextHighlighting"
        // example
        let rich = RichTextBlock()
        let para = Paragraph()
        let run = Run()
        run.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"
        para.inlines.append(run)
        rich.blocks.append(para)
        ex.example = rich

        // options
        let cb = ComboBox()
        cb.header = "Text highlighting color"
        for txt in ["Yellow", "Red", "Blue"] {
            let cbi = ComboBoxItem()
            cbi.content = txt
            cbi.tag = txt
            cb.items.append(cbi)
        }
        cb.loaded.addHandler { _, _ in
            cb.selectedIndex = 0 
        }
        // here I try to use cb.selectedItem.content as String, but failed. so
        // use index insteadlly.
        cb.selectionChanged.addHandler { _, _ in
            let idx = Int(cb.selectedIndex)
            guard idx >= 0 else { return }

            let color: Color
            switch idx {
            case 0: color = Colors.yellow
            case 1: color = Colors.red
            case 2: color = Colors.blue
            default: color = Colors.yellow
            }

            let brush = SolidColorBrush()
            brush.color = color
            var range = TextRange()
            range.startIndex = 28
            range.length = 11
            let highlighter = TextHighlighter()
            highlighter.background = brush
            highlighter.ranges.append(range)
            rich.textHighlighters.clear()
            rich.textHighlighters.append(highlighter)
        }

        ex.options = cb
        bodyStackPanel.children.append(ex.view)
    }
}
