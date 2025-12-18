import WinUI
import UWP
import WinAppSDK

class TextBlockPage: Page {
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

        // page resources
        let s = Style()
        // s.targetType = TypeName()
        // Use metadata kind so the style can match the actual control type
        s.targetType = TypeName(name: "Microsoft.UI.Xaml.Controls.TextBlock", kind: .metadata)
        let fontFamilySetter = Setter()
        fontFamilySetter.property = TextBlock.fontFamilyProperty
        fontFamilySetter.value = "Comic Sans MS"
        s.setters.append(fontFamilySetter)
        let fontStyleSetter = Setter()
        fontStyleSetter.property = TextBlock.fontStyleProperty
        fontStyleSetter.value = FontStyle.italic
        s.setters.append(fontStyleSetter)
        
        if self.resources == nil {
            self.resources = ResourceDictionary()
        }
        self.resources["CustomTextBlockStyle"] = s
        self.content = pageRootGrid
    }

    private func setupHeader() {
        let controlInfo = ControlInfo(
            title: "TextBlock",
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
                    uri: "https://learn.microsoft.com/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.controls.textblock"
                ),
                ControlInfoDocLink(
                    title: "Guidelines",
                    uri: "https://learn.microsoft.com/zh-cn/windows/apps/develop/ui/controls/text-block"
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
        descText.text = """
        TextBlock is the primary control for displaying read-only text in your app. You typically display textby setting the Text property to a simple string. You can also display a series of strings in Runelements and give each different formatting.
        """
        bodyStackPanel.children.append(descText)

        setupSimpleTextBlock()
        setupStyleTextBlock()
        setupVariousTextBlock()
        setupInlineTextBlock()
        setupSelectTextBlock()

        self.bodyScrollViewer.content = bodyStackPanel
    }

    private func setupSimpleTextBlock() {
        let example = ControlExample()
        example.headerText = "A Simple TextBlock."
        let tb = TextBlock()
        tb.text = "I am a TextBlock"
        example.example = tb
        bodyStackPanel.children.append(example.view)
    }

    private func setupStyleTextBlock() {
        let example = ControlExample()
        example.headerText = " I am a styled TextBlock"
        let tb = TextBlock()
        tb.text = "I am a styled TextBlock"
        tb.style = self.resources["CustomTextBlockStyle"] as! Style
        example.example = tb
        bodyStackPanel.children.append(example.view)
    }

    private func setupVariousTextBlock() {
        let example = ControlExample()
        example.headerText = "A TextBlock with various properties set"
        let tb = TextBlock()
        tb.text = "I am super excited to be here!"
        let familyName = "Arial"
        tb.fontFamily = FontFamily(familyName)
        tb.fontSize = 24
        tb.fontStyle = FontStyle.italic
        tb.textWrapping = .wrapWholeWords
        tb.characterSpacing = 200
        let brush = SolidColorBrush(Colors.cornflowerBlue)
        tb.foreground = brush
        example.example = tb
        bodyStackPanel.children.append(example.view)
    }

    private func creatStyledRun(textStyle: String = "common", content: String) -> Span {
        let span: Span
        switch textStyle {
        case "bold":
            span = Bold()
        case "italic":
            span = Italic()
        case "underline":
            span = Underline()
        default:
            // common
            span = Span()
        }
        let run = Run()
        run.text = content
        span.inlines.append(run)
        return span
    }

    private func setupInlineTextBlock() {
        let example = ControlExample()
        example.headerText = "A TextBlock with inline text elements"
        let tb = TextBlock()

        let run = Run()
        let familyName = "Times New Roman"
        run.fontFamily = FontFamily(familyName)
        let brush = SolidColorBrush()
        brush.color = Colors.darkGray
        run.foreground = brush
        run.text = "Text in a TextBlock doesn't have to be a simple string."
        tb.inlines.append(run)
        tb.inlines.append(LineBreak())

        let span = Span()
        span.inlines.append(creatStyledRun(content: "Text can be"))
        span.inlines.append(creatStyledRun(textStyle: "bold", content: "bold"))
        span.inlines.append(creatStyledRun(content: ", "))
        span.inlines.append(creatStyledRun(textStyle: "italic", content: "italic"))
        span.inlines.append(creatStyledRun(content: ", or "))
        span.inlines.append(creatStyledRun(textStyle: "underline", content: "underline"))
        span.inlines.append(creatStyledRun(content: "."))
        tb.inlines.append(span)

        example.example = tb
        bodyStackPanel.children.append(example.view)
    }

    private func setupSelectTextBlock() {
        let example = ControlExample()
        example.headerText = "A selectable TextBlock"

        // example area
        let tb = TextBlock()
        tb.text = "I am a selectable TextBlock with custom SelectionHighlightColor"
        tb.isTextSelectionEnabled = true
        let brush = SolidColorBrush()
        brush.color = Colors.darkOrange
        tb.selectionHighlightColor = brush
        example.example = tb

        // options area
        let tw = ToggleSwitch()
        tw.header = "IsTextSelectionEnabled"
        tw.isOn = false
        tw.toggled.addHandler { sender, args in
            guard let sender = sender as? ToggleSwitch else { return } 
            tb.isTextSelectionEnabled = sender.isOn
        }
        example.options = tw
        
        bodyStackPanel.children.append(example.view)
    }
}