import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

// Swift WinUI 3 Gallery - Binding
final class BindingPage: Grid {

    // MARK: - UI

    private var mainScrollViewer: ScrollViewer!
    private var contentStackPanel: StackPanel!

    // MARK: - Demo controls

    private var sourceTextBoxOneWay: TextBox!
    private var targetTextBoxOneWay: TextBox!

    private var sourceTextBoxTwoWay: TextBox!
    private var targetTextBoxTwoWay: TextBox!
    private var isSyncingTwoWay: Bool = false

    private var greetingTextBlock: TextBlock!

    private var functionDatePicker: DatePicker!
    private var dateStatusText: TextBlock!

    private var converterInputTextBox: TextBox!
    private var converterResultText: TextBlock!

    private var vmTitleValue: TextBlock!
    private var vmDescriptionValue: TextBlock!

    private var nullValueTextBlock: TextBlock!

    // MARK: - Init

    override init() {
        super.init()
        setupUI()
        wireUpDemos()
    }

    // MARK: - Setup

    private func setupUI() {
        mainScrollViewer = ScrollViewer()
        mainScrollViewer.horizontalScrollBarVisibility = .disabled
        mainScrollViewer.verticalScrollBarVisibility = .auto

        contentStackPanel = StackPanel()
        contentStackPanel.padding = Thickness(left: 40, top: 24, right: 40, bottom: 40)
        contentStackPanel.spacing = 24

        contentStackPanel.children.append(createHeader())
        contentStackPanel.children.append(createOverview())

        contentStackPanel.children.append(createBindingBetweenControlsSection())
        contentStackPanel.children.append(createCodeBehindSection())
        contentStackPanel.children.append(createFunctionBindSection())
        contentStackPanel.children.append(createConverterSection())
        contentStackPanel.children.append(createViewModelSection())
        contentStackPanel.children.append(createTargetNullValueSection())

        mainScrollViewer.content = contentStackPanel
        children.append(mainScrollViewer)
    }

    // MARK: - Header

    private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 12

        let titleText = TextBlock()
        titleText.text = "Binding"
        titleText.fontSize = 32
        titleText.fontWeight = FontWeights.semiBold
        headerPanel.children.append(titleText)

        // Documentation / Source tabs (visual only, like other pages in this project)
        let tabsPanel = StackPanel()
        tabsPanel.orientation = .horizontal
        tabsPanel.spacing = 16

        let docText = TextBlock()
        docText.text = "Documentation"
        docText.fontSize = 14
        docText.fontWeight = FontWeights.semiBold
        docText.foreground = createBrush(r: 0, g: 120, b: 215)
        docText.padding = Thickness(left: 0, top: 4, right: 0, bottom: 4)
        tabsPanel.children.append(docText)

        let sourceText = TextBlock()
        sourceText.text = "Source"
        sourceText.fontSize = 14
        sourceText.opacity = 0.6
        sourceText.padding = Thickness(left: 0, top: 4, right: 0, bottom: 4)
        tabsPanel.children.append(sourceText)

        headerPanel.children.append(tabsPanel)
        return headerPanel
    }

    // MARK: - Overview

    private func createOverview() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 10

        let desc = TextBlock()
        desc.text = "Binding in WinUI 3 is a way to connect a property of a control to a source, such as another property, a data object, or a view model. It keeps the data synchronized between the source and the target control, enabling dynamic updates."
        desc.fontSize = 14
        desc.textWrapping = .wrap
        desc.opacity = 0.85
        panel.children.append(desc)

        let keyHeader = TextBlock()
        keyHeader.text = "Key concepts"
        keyHeader.fontSize = 14
        keyHeader.fontWeight = FontWeights.semiBold
        keyHeader.margin = Thickness(left: 0, top: 4, right: 0, bottom: 0)
        panel.children.append(keyHeader)

        panel.children.append(bulletList([
            "Target: The property of a control to which data is bound (e.g., Text, Background, Visibility).",
            "Source: The data being bound, such as a property in a class, another control, or a static resource.",
            "Binding Modes:"
        ]))

        panel.children.append(indentedBulletList([
            "OneWay updates the target when the source changes.",
            "TwoWay updates both the target and the source.",
            "OneTime sets the target once and does not update afterward."
        ], indent: 18))

        let linkLine = StackPanel()
        linkLine.orientation = .horizontal
        linkLine.spacing = 4

        let lead = TextBlock()
        lead.text = "Learn more about the differences between x:Bind and Binding by visiting"
        lead.fontSize = 14
        lead.textWrapping = .wrap
        lead.opacity = 0.85

        let link = TextBlock()
        link.text = "Microsoft Learn."
        link.fontSize = 14
        link.fontWeight = FontWeights.semiBold
        link.foreground = createBrush(r: 0, g: 120, b: 215)

        linkLine.children.append(lead)
        linkLine.children.append(link)
        panel.children.append(linkLine)

        return panel
    }

    // MARK: - Section: Binding between controls

    private func createBindingBetweenControlsSection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12

        panel.children.append(sectionTitle("Binding between controls"))
        panel.children.append(makeBetweenControlsDemoCard())
        panel.children.append(makeSourceCodeSection(
            tabs: [("XAML", betweenControlsXamlSource())],
            isExpandedByDefault: true
        ))

        return panel
    }

    private func makeBetweenControlsDemoCard() -> Border {
        let outer = createCardBorder()
        outer.background = createBrush(r: 20, g: 20, b: 20, a: 30)

        let root = StackPanel()
        root.spacing = 12

        let grid = Grid()

        let c0 = ColumnDefinition(); c0.width = GridLength(value: 1, gridUnitType: .star)
        let c1 = ColumnDefinition(); c1.width = GridLength(value: 24, gridUnitType: .pixel)
        let c2 = ColumnDefinition(); c2.width = GridLength(value: 1, gridUnitType: .star)
        grid.columnDefinitions.append(c0)
        grid.columnDefinitions.append(c1)
        grid.columnDefinitions.append(c2)

        // Left: OneWay
        let left = StackPanel()
        left.spacing = 8

        let leftTitle = TextBlock()
        leftTitle.text = "OneWay binding"
        leftTitle.fontSize = 14
        leftTitle.fontWeight = FontWeights.semiBold
        left.children.append(leftTitle)

        sourceTextBoxOneWay = TextBox()
        sourceTextBoxOneWay.placeholderText = "Enter text here"
        sourceTextBoxOneWay.horizontalAlignment = .stretch
        left.children.append(sourceTextBoxOneWay)

        targetTextBoxOneWay = TextBox()
        targetTextBoxOneWay.placeholderText = "Mirrors above text"
        targetTextBoxOneWay.horizontalAlignment = .stretch
        left.children.append(targetTextBoxOneWay)

        // Middle separator
        // Note: AppBarSeparator isn't projected in some Swift/WinUI bindings.
        // Use a simple 1px Border as a vertical divider instead.
        let sep = Border()
        sep.width = 1
        sep.horizontalAlignment = .center
        sep.verticalAlignment = .stretch
        sep.margin = Thickness(left: 0, top: 4, right: 0, bottom: 4)
        sep.background = SolidColorBrush(Color(a: 120, r: 255, g: 255, b: 255))

        // Right: TwoWay
        let right = StackPanel()
        right.spacing = 8

        let rightTitle = TextBlock()
        rightTitle.text = "TwoWay binding"
        rightTitle.fontSize = 14
        rightTitle.fontWeight = FontWeights.semiBold
        right.children.append(rightTitle)

        sourceTextBoxTwoWay = TextBox()
        sourceTextBoxTwoWay.placeholderText = "Enter text here"
        sourceTextBoxTwoWay.horizontalAlignment = .stretch
        right.children.append(sourceTextBoxTwoWay)

        targetTextBoxTwoWay = TextBox()
        targetTextBoxTwoWay.placeholderText = "Mirrors and edits above text"
        targetTextBoxTwoWay.horizontalAlignment = .stretch
        right.children.append(targetTextBoxTwoWay)

        grid.children.append(left)
        try? Grid.setColumn(left, 0)

        grid.children.append(sep)
        try? Grid.setColumn(sep, 1)

        grid.children.append(right)
        try? Grid.setColumn(right, 2)

        root.children.append(grid)

        let expl = TextBlock()
        expl.text = "In OneWay binding mode, changes in the source (SourceTextBox) are reflected in the target, but not vice versa.\nIn TwoWay binding mode, changes in either box update the other."
        expl.fontSize = 12
        expl.textWrapping = .wrap
        expl.opacity = 0.8
        root.children.append(expl)

        outer.child = root
        return outer
    }

    // MARK: - Section: Code-behind

    private func createCodeBehindSection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12

        panel.children.append(sectionTitle("Binding to a property in code-behind"))
        panel.children.append(makeHelloCard())
        panel.children.append(makeSourceCodeSection(tabs: [
            ("XAML", codeBehindXamlSource()),
            ("C#", codeBehindCSharpSource())
        ]))

        return panel
    }

    private func makeHelloCard() -> Border {
        let outer = createCardBorder()
        outer.background = createBrush(r: 20, g: 20, b: 20, a: 30)

        let inner = Border()
        inner.background = createBrush(r: 18, g: 18, b: 18)
        inner.cornerRadius = CornerRadius(topLeft: 6, topRight: 6, bottomRight: 6, bottomLeft: 6)
        inner.padding = Thickness(left: 16, top: 12, right: 16, bottom: 12)

        greetingTextBlock = TextBlock()
        greetingTextBlock.text = "Hello, WinUI 3!"
        greetingTextBlock.fontSize = 24
        greetingTextBlock.fontWeight = FontWeights.semiBold
        greetingTextBlock.textWrapping = .wrap

        inner.child = greetingTextBlock
        outer.child = inner
        return outer
    }

    // MARK: - Section: Function in x:Bind

    private func createFunctionBindSection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12

        panel.children.append(sectionTitle("Using a function in x:Bind"))
        panel.children.append(makeFunctionDemoCard())
        panel.children.append(makeSourceCodeSection(tabs: [
            ("XAML", functionXamlSource()),
            ("C#", functionCSharpSource())
        ]))

        return panel
    }

    private func makeFunctionDemoCard() -> Border {
        let outer = createCardBorder()
        outer.background = createBrush(r: 20, g: 20, b: 20, a: 30)

        let stack = StackPanel()
        stack.spacing = 10

        functionDatePicker = DatePicker()
        functionDatePicker.header = "Select a date"
        functionDatePicker.horizontalAlignment = .left
        stack.children.append(functionDatePicker)

        dateStatusText = TextBlock()
        dateStatusText.text = "No date selected"
        dateStatusText.fontSize = 12
        dateStatusText.opacity = 0.85
        stack.children.append(dateStatusText)

        outer.child = stack
        return outer
    }

    // MARK: - Section: Converter

    private func createConverterSection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12

        panel.children.append(sectionTitle("Using a converter in Binding"))
        panel.children.append(makeConverterDemoCard())
        panel.children.append(makeSourceCodeSection(tabs: [
            ("XAML", converterXamlSource()),
            ("C#", converterCSharpSource())
        ]))

        return panel
    }

    private func makeConverterDemoCard() -> Border {
        let outer = createCardBorder()
        outer.background = createBrush(r: 20, g: 20, b: 20, a: 30)

        let stack = StackPanel()
        stack.spacing = 10

        converterInputTextBox = TextBox()
        converterInputTextBox.header = "Enter Text:"
        converterInputTextBox.width = 300
        stack.children.append(converterInputTextBox)

        converterResultText = TextBlock()
        converterResultText.text = "The input is not empty."
        converterResultText.fontSize = 12
        converterResultText.opacity = 0.85
        converterResultText.visibility = .collapsed
        stack.children.append(converterResultText)

        outer.child = stack
        return outer
    }

    // MARK: - Section: View model

    private func createViewModelSection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12

        panel.children.append(sectionTitle("Binding to a view model"))
        panel.children.append(makeViewModelDemoCard())
        panel.children.append(makeSourceCodeSection(tabs: [
            ("XAML", viewModelXamlSource()),
            ("C#", viewModelCSharpSource())
        ]))
        panel.children.append(makeMvvmToolkitInfoCard())

        return panel
    }

    private func makeViewModelDemoCard() -> Border {
        let outer = createCardBorder()
        outer.background = createBrush(r: 20, g: 20, b: 20, a: 30)

        let stack = StackPanel()
        stack.spacing = 6

        let titleLabel = TextBlock()
        titleLabel.text = "Title:"
        titleLabel.fontSize = 12
        titleLabel.fontWeight = FontWeights.semiBold
        stack.children.append(titleLabel)

        vmTitleValue = TextBlock()
        vmTitleValue.text = "Welcome to WinUI 3"
        vmTitleValue.fontSize = 12
        vmTitleValue.opacity = 0.9
        stack.children.append(vmTitleValue)

        let descLabel = TextBlock()
        descLabel.text = "Description:"
        descLabel.fontSize = 12
        descLabel.fontWeight = FontWeights.semiBold
        descLabel.margin = Thickness(left: 0, top: 6, right: 0, bottom: 0)
        stack.children.append(descLabel)

        vmDescriptionValue = TextBlock()
        vmDescriptionValue.text = "This is an example of binding to a view model."
        vmDescriptionValue.fontSize = 12
        vmDescriptionValue.opacity = 0.9
        stack.children.append(vmDescriptionValue)

        outer.child = stack
        return outer
    }

    private func makeMvvmToolkitInfoCard() -> Border {
        let outer = Border()
        outer.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        outer.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        outer.borderBrush = createBrush(r: 200, g: 200, b: 200)
        outer.background = createBrush(r: 10, g: 10, b: 10, a: 25)
        outer.padding = Thickness(left: 16, top: 12, right: 16, bottom: 12)

        let row = StackPanel()
        row.orientation = .horizontal
        row.spacing = 10

        let iconCircle = Border()
        iconCircle.width = 16
        iconCircle.height = 16
        iconCircle.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        iconCircle.background = createBrush(r: 0, g: 120, b: 215)
        iconCircle.verticalAlignment = .top
        iconCircle.margin = Thickness(left: 0, top: 2, right: 0, bottom: 0)

        let content = StackPanel()
        content.spacing = 6

        let title = TextBlock()
        title.text = "MVVM Toolkit"
        title.fontSize = 12
        title.fontWeight = FontWeights.semiBold
        content.children.append(title)

        let body = TextBlock()
        body.text = "The MVVM Toolkit, part of the .NET Community Toolkit, is designed to simplify the implementation of the Model-View-ViewModel (MVVM) pattern in applications. The toolkit includes a sample app to demonstrate its features and usage."
        body.fontSize = 12
        body.textWrapping = .wrap
        body.opacity = 0.85
        content.children.append(body)

        let link = TextBlock()
        link.text = "Go to the MVVM Toolkit repository"
        link.fontSize = 12
        link.fontWeight = FontWeights.semiBold
        link.foreground = createBrush(r: 0, g: 120, b: 215)
        content.children.append(link)

        row.children.append(iconCircle)
        row.children.append(content)

        outer.child = row
        return outer
    }

    // MARK: - Section: TargetNullValue

    private func createTargetNullValueSection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12

        panel.children.append(sectionTitle("Binding with TargetNullValue"))
        panel.children.append(makeTargetNullValueCard())
        panel.children.append(makeSourceCodeSection(tabs: [
            ("XAML", targetNullValueXamlSource()),
            ("C#", targetNullValueCSharpSource())
        ]))

        return panel
    }

    private func makeTargetNullValueCard() -> Border {
        let outer = createCardBorder()
        outer.background = createBrush(r: 20, g: 20, b: 20, a: 30)

        let inner = Border()
        inner.background = createBrush(r: 18, g: 18, b: 18)
        inner.cornerRadius = CornerRadius(topLeft: 6, topRight: 6, bottomRight: 6, bottomLeft: 6)
        inner.padding = Thickness(left: 16, top: 10, right: 16, bottom: 10)

        nullValueTextBlock = TextBlock()
        nullValueTextBlock.text = "Anonymous User"
        nullValueTextBlock.fontSize = 12
        nullValueTextBlock.opacity = 0.9

        inner.child = nullValueTextBlock
        outer.child = inner
        return outer
    }

    // MARK: - Wiring

    private func wireUpDemos() {
        // OneWay: source -> target
        sourceTextBoxOneWay.textChanged.addHandler { [weak self] _, _ in
            guard let self = self else { return }
            self.targetTextBoxOneWay.text = self.sourceTextBoxOneWay.text
        }

        // TwoWay: keep both in sync
        sourceTextBoxTwoWay.textChanged.addHandler { [weak self] _, _ in
            guard let self = self else { return }
            guard !self.isSyncingTwoWay else { return }
            self.isSyncingTwoWay = true
            self.targetTextBoxTwoWay.text = self.sourceTextBoxTwoWay.text
            self.isSyncingTwoWay = false
        }
        targetTextBoxTwoWay.textChanged.addHandler { [weak self] _, _ in
            guard let self = self else { return }
            guard !self.isSyncingTwoWay else { return }
            self.isSyncingTwoWay = true
            self.sourceTextBoxTwoWay.text = self.targetTextBoxTwoWay.text
            self.isSyncingTwoWay = false
        }

        // Function sample: date -> formatted label
        functionDatePicker.dateChanged.addHandler { [weak self] _, _ in
            guard let self = self else { return }
            let dt = self.functionDatePicker.date
            self.dateStatusText.text = self.formatDate(dt)
        }

        // Converter sample: show message if non-empty
        converterInputTextBox.textChanged.addHandler { [weak self] _, _ in
            guard let self = self else { return }
            let empty = self.converterInputTextBox.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            self.converterResultText.visibility = empty ? .collapsed : .visible
        }
    }

    // MARK: - Helpers

    private func sectionTitle(_ text: String) -> TextBlock {
        let tb = TextBlock()
        tb.text = text
        tb.fontSize = 18
        tb.fontWeight = FontWeights.semiBold
        tb.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)
        return tb
    }

    private func bulletList(_ items: [String]) -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 6
        panel.margin = Thickness(left: 0, top: 4, right: 0, bottom: 0)

        for item in items {
            let tb = TextBlock()
            tb.text = "• \(item)"
            tb.fontSize = 14
            tb.textWrapping = .wrap
            tb.opacity = 0.85
            panel.children.append(tb)
        }
        return panel
    }

    private func indentedBulletList(_ items: [String], indent: Double) -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 6
        panel.margin = Thickness(left: indent, top: 0, right: 0, bottom: 0)

        for item in items {
            let tb = TextBlock()
            tb.text = "• \(item)"
            tb.fontSize = 14
            tb.textWrapping = .wrap
            tb.opacity = 0.85
            panel.children.append(tb)
        }
        return panel
    }

    private func createCardBorder() -> Border {
        let border = Border()
        border.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = createBrush(r: 200, g: 200, b: 200)
        border.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        return border
    }

    private func makeSourceCodeSection(
        tabs: [(String, String)],
        isExpandedByDefault: Bool = false
    ) -> Border {
        let outer = Border()
        outer.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        outer.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        outer.borderBrush = createBrush(r: 200, g: 200, b: 200)
        outer.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)

        let panel = StackPanel()
        panel.spacing = 8

        let toggle = Button()
        toggle.horizontalAlignment = .left
        toggle.padding = Thickness(left: 12, top: 8, right: 12, bottom: 8)
        toggle.background = nil
        toggle.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)

        let contentBorder = Border()
        contentBorder.padding = Thickness(left: 0, top: 8, right: 0, bottom: 0)

        let tabView = TabView()
        tabView.tabWidthMode = .sizeToContent
        tabView.isAddTabButtonVisible = false
        tabView.canReorderTabs = false

        for (header, code) in tabs {
            let item = TabViewItem()
            item.header = header
            item.isClosable = false

            let tb = TextBox()
            tb.isReadOnly = true
            tb.acceptsReturn = true
            tb.textWrapping = .noWrap
            tb.fontFamily = FontFamily("Cascadia Code, Consolas, monospace")
            tb.fontSize = 12
            tb.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
            tb.background = nil
            tb.text = code

            item.content = tb
            tabView.tabItems.append(item)
        }

        contentBorder.child = tabView

        var visible = isExpandedByDefault
        contentBorder.visibility = visible ? .visible : .collapsed
        toggle.content = visible ? "▲ Source code" : "▼ Source code"

        toggle.click.addHandler { _, _ in
            visible.toggle()
            contentBorder.visibility = visible ? .visible : .collapsed
            toggle.content = visible ? "▲ Source code" : "▼ Source code"
        }

        panel.children.append(toggle)
        panel.children.append(contentBorder)
        outer.child = panel

        return outer
    }

    private func createBrush(r: UInt8, g: UInt8, b: UInt8, a: UInt8 = 255) -> SolidColorBrush {
        let brush = SolidColorBrush()
        var color = UWP.Color()
        color.a = a
        color.r = r
        color.g = g
        color.b = b
        brush.color = color
        return brush
    }

    // MARK: - Date formatting

    private func formatDate(_ dateTime: WindowsFoundation.DateTime) -> String {
        // WindowsFoundation.DateTime is 100ns ticks since 1601-01-01
        let ticks = Double(dateTime.universalTime)
        let unixTicksOffset: Double = 116444736000000000 // 1601 -> 1970 in 100ns
        let seconds = (ticks - unixTicksOffset) / 10_000_000

        if seconds.isFinite {
            let date = Date(timeIntervalSince1970: seconds)
            let fmt = DateFormatter()
            fmt.dateStyle = .medium
            fmt.timeStyle = .none
            return fmt.string(from: date)
        }
        return "Date selected"
    }

    // MARK: - Source strings

    private func betweenControlsXamlSource() -> String {
        return """
<Grid ColumnSpacing=\"12\">
  <Grid.ColumnDefinitions>
    <ColumnDefinition Width=\"auto\" />
    <ColumnDefinition Width=\"auto\" />
    <ColumnDefinition Width=\"auto\" />
  </Grid.ColumnDefinitions>

  <StackPanel Spacing=\"8\" Grid.Column=\"0\">
    <TextBlock Text=\"One-way Binding\" FontWeight=\"SemiBold\" />
    <!-- One-way binding: The target TextBox mirrors the text entered in the SourceTextBox, but any change in the target is not reflected back to the source -->
    <TextBox x:Name=\"SourceTextBoxOneWay\" Width=\"200\" PlaceholderText=\"Enter text here\" />
    <TextBox x:Name=\"TargetTextBoxOneWay\" Width=\"200\" PlaceholderText=\"Mirrors above text\"
             Text=\"{Binding Text, ElementName=SourceTextBoxOneWay, Mode=OneWay}\" />
  </StackPanel>

  <AppBarSeparator Grid.Column=\"1\" />

  <StackPanel Spacing=\"8\" Grid.Column=\"2\">
    <TextBlock Text=\"Two-way Binding\" FontWeight=\"SemiBold\" />
    <TextBox x:Name=\"SourceTextBoxTwoWay\" Width=\"200\" PlaceholderText=\"Enter text here\" />
    <TextBox x:Name=\"TargetTextBoxTwoWay\" Width=\"200\" PlaceholderText=\"Mirrors and edits above text\"
             Text=\"{Binding Text, ElementName=SourceTextBoxTwoWay, Mode=TwoWay, UpdateSourceTrigger=PropertyChanged}\" />
  </StackPanel>
</Grid>
"""
    }

    private func codeBehindXamlSource() -> String {
        return """
<TextBlock
  Text=\"{x:Bind GreetingMessage}\"
  FontSize=\"24\"
  HorizontalAlignment=\"Center\"
  VerticalAlignment=\"Center\" />
"""
    }

    private func codeBehindCSharpSource() -> String {
        return """
public string GreetingMessage { get; set; } = \"Hello, WinUI 3!\";
"""
    }

    private func functionXamlSource() -> String {
        return """
<DatePicker x:Name=\"DatePickerControl\" Header=\"Select a date\" />
<TextBlock Text=\"{x:Bind FormatDate(DatePickerControl.SelectedDate), Mode=OneWay}\" />
"""
    }

    private func functionCSharpSource() -> String {
        return """
private string FormatDate(DateTimeOffset? date)
{
    return date.HasValue ? date.Value.ToString(\"D\") : \"No date selected\";
}
"""
    }

    private func converterXamlSource() -> String {
        return """
<Page.Resources>
  <!-- Declare the converter -->
  <local:EmptyStringToVisibilityConverter x:Key=\"EmptyStringToVisibilityConverter\" />
</Page.Resources>

<StackPanel Spacing=\"8\">
  <TextBox x:Name=\"InputTextBox\" Header=\"Enter Text:\" Width=\"300\" />

  <!-- TextBlock Visibility Depends on Input Text -->
  <TextBlock Text=\"The input is not empty.\"
             Visibility=\"{Binding Text, ElementName=InputTextBox, Converter={StaticResource EmptyStringToVisibilityConverter}}\" />
</StackPanel>
"""
    }

    private func converterCSharpSource() -> String {
        return """
public class EmptyStringToVisibilityConverter : IValueConverter
{
    public object Convert(object value, Type targetType, object parameter, string language)
    {
        var s = value as string;
        return string.IsNullOrEmpty(s) ? Visibility.Collapsed : Visibility.Visible;
    }

    public object ConvertBack(object value, Type targetType, object parameter, string language)
        => throw new NotImplementedException();
}
"""
    }

    private func viewModelXamlSource() -> String {
        return """
<TextBlock Text=\"Title:\" FontWeight=\"SemiBold\" />
<TextBlock Text=\"{Binding Title}\" FontSize=\"16\" />

<TextBlock Text=\"Description:\" FontWeight=\"SemiBold\" />
<TextBlock Text=\"{Binding Description}\" FontSize=\"16\" />
"""
    }

    private func viewModelCSharpSource() -> String {
        return """
public class SampleViewModel
{
    public string Title { get; set; } = \"Welcome to WinUI 3\";
    public string Description { get; set; } = \"This is an example of binding to a view model.\";
}
"""
    }

    private func targetNullValueXamlSource() -> String {
        return """
<!-- TargetNullValue property help handle scenarios where the binding source is null -->
<TextBlock Text=\"{Binding ViewModel.NullString, Mode=OneWay, TargetNullValue=Anonymous User}\" />
"""
    }

    private func targetNullValueCSharpSource() -> String {
        return """
public class SampleViewModel
{
    public string? NullString { get; set; } = null;
}
"""
    }
}
