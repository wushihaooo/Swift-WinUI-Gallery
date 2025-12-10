import WinUI

class DatePickerPage: Page {
    private var pageRootGrid: Grid = Grid()
    private var exampleStackPanel: StackPanel = StackPanel()
    private var headerGrid: Grid = Grid()
    private var bodyScrollViewer: ScrollViewer = ScrollViewer()

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
            title: "DatePicker",
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
                    title: "DatePicker-API",
                    uri: "https://learn.microsoft.com/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.controls.datepicker"
                ),
                ControlInfoDocLink(
                    title: "Guidelines",
                    uri: "https://learn.microsoft.com/zh-cn/windows/apps/develop/ui/controls/date-picker"
                )
            ]
        )
        let pageHeader: PageHeader = PageHeader(item: controlInfo)
        pageHeader.themeButtonVisibility = .visible
        pageHeader.margin = Thickness(left: 36, top: 36, right: 36, bottom: 0)
        self.headerGrid.children.append(pageHeader)
    }
    
    private func setupBody() {
        self.bodyScrollViewer.margin = Thickness(left: 36, top: 0, right: 36, bottom: 0)
        // self.bodyScrollViewer.row = 1
        let bodyStackPanel = StackPanel()
        bodyStackPanel.spacing = 8
        bodyStackPanel.orientation = .vertical
        let descText = TextBlock()
        descText.text = """
        Use a DatePicker to let users set a date in your app, for example to schedule an appointment. The DatePicker displays three controls for month, date, and year. These controls are easy to use with touch or mouse, and they can be styled and configured in several different ways.
        """
        bodyStackPanel.children.append(descText)

        let fullDatePickerSample = DTControlExample()
        let fullDatePicker = DatePicker()
        fullDatePicker.header = "Pick a date"
        fullDatePickerSample.headerText = "A simple DatePicker with a header"
        fullDatePickerSample.example = fullDatePicker
        bodyStackPanel.children.append(fullDatePickerSample.view)

        let nonYearDatePickerSample = DTControlExample()
        let nonYearDatePicker = DatePicker()
        nonYearDatePicker.yearVisible = false
        nonYearDatePickerSample.example = nonYearDatePicker
        bodyStackPanel.children.append(nonYearDatePickerSample.view)
        self.bodyScrollViewer.content = bodyStackPanel
    }
}
