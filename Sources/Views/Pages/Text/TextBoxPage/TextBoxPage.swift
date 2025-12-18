import WinUI
import UWP
import WinAppSDK

class TextBoxPage: Page {
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
            title: "TextBox",
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
                    uri: "https://learn.microsoft.com/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.controls.textbox"
                ),
                ControlInfoDocLink(
                    title: "Guidelines",
                    uri: "https://learn.microsoft.com/zh-cn/windows/apps/develop/ui/controls/text-box"
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
        Use a TextBox to let a user enter simple text input in your app. You can add a header and placeholder text to let the user know what the TextBox is for, and you can customize it in other ways.
        """
        bodyStackPanel.children.append(descText)

        setupSimpleTextBox()
        setupDecoTextBox()
        setupVariousTextBox()
        setupMultiLineTextBox()

        self.bodyScrollViewer.content = bodyStackPanel
    }

    private func setupSimpleTextBox() {
        let example = ControlExample()
        example.headerText = "A Simple TextBox."
        let tb = TextBox()
        example.example = tb
        bodyStackPanel.children.append(example.view)
    }
    
    private func setupDecoTextBox() {
        let example = ControlExample()
        example.headerText = "A TextBox with a header and placeholder text."
        let tb = TextBox()
        tb.header = "Enter your name"
        tb.placeholderText = "Name"
        example.example = tb
        bodyStackPanel.children.append(example.view)
    }

    private func setupVariousTextBox() {
        let example = ControlExample()
        example.headerText = "A read-only TextBox with various properties set."
        let tb = TextBox()
        tb.text = "I am super excited to be here!"
        tb.isReadOnly = true
        let familyName = "Arial"
        tb.fontFamily = FontFamily(familyName)
        tb.fontSize = 24
        tb.fontStyle = FontStyle.italic
        tb.characterSpacing = 200
        let c = Color(a: 100, r: 81, g: 120, b: 190)
        let brush = SolidColorBrush(c)
        tb.foreground = brush
        example.example = tb
        bodyStackPanel.children.append(example.view)
    }

    private func setupMultiLineTextBox() {
        let example = ControlExample()
        example.headerText = "A multi-line TextBox with spell checking and custom selection highlight color."

        // example area
        let tb = TextBox()
        tb.textWrapping = .wrap
        tb.acceptsReturn = true
        tb.isSpellCheckEnabled = true
        let brush = SolidColorBrush()
        brush.color = Colors.green
        tb.selectionHighlightColor = brush
        tb.minWidth = 400
        example.example = tb

        bodyStackPanel.children.append(example.view)
    }
}