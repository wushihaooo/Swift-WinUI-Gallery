import WinUI

class TimePickerPage: Page {
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
            title: "TimePicker",
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
                    title: "TimePicker-API",
                    uri: "https://learn.microsoft.com/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.controls.timepicker"
                ),
                ControlInfoDocLink(
                    title: "Guidelines",
                    uri: "https://learn.microsoft.com/zh-cn/windows/apps/develop/ui/controls/time-picker"
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
        Use a TimePicker to let users set a time in your app, for example to set a reminder.The TimePicker displays three controls for hour, minute, and AM/PM. These controls are easy to use with touch or mouse, and they can be styled and configured in several different ways.
        """
        bodyStackPanel.children.append(descText)

        let simpleTimePickerSample = DTControlExample()
        let simpleTimePicker = TimePicker()
        simpleTimePickerSample.headerText = "A simple TimePikcer."
        simpleTimePicker.clockIdentifier = "12HourClock"
        simpleTimePicker.language = "en-US"
        simpleTimePickerSample.example = simpleTimePicker
        bodyStackPanel.children.append(simpleTimePickerSample.view)

        let spIncMinTimePickerSample = DTControlExample()
        let spIncMinTimePicker = TimePicker()
        spIncMinTimePickerSample.headerText = "A TimePikcer with a header and minute increments specificed."
        spIncMinTimePicker.clockIdentifier = "12HourClock"
        spIncMinTimePicker.language = "en-US" // TODO this line actually not work
        spIncMinTimePicker.header = "Arrival Time"
        spIncMinTimePicker.minuteIncrement = 15
        spIncMinTimePickerSample.example = spIncMinTimePicker
        bodyStackPanel.children.append(spIncMinTimePickerSample.view)

        let TFTimePickerSample = DTControlExample()
        let TFTimePicker = TimePicker()
        TFTimePickerSample.headerText = "A TimePikcer using a 24-hour clock, initialized to current time."
        TFTimePicker.language = "en-US"
        TFTimePicker.header = "24 hour clock"
        TFTimePickerSample.example = TFTimePicker
        bodyStackPanel.children.append(TFTimePickerSample.view)
        self.bodyScrollViewer.content = bodyStackPanel
    }
}
