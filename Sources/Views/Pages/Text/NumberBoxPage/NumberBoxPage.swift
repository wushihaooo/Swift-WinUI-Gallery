import WinUI
import UWP

class NumberBoxPage: Page {
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
            title: "NumberBox",
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
                    title: "NumberBox-API",
                    uri: "https://learn.microsoft.com/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.controls.numberbox"
                ),
                ControlInfoDocLink(
                    title: "Guidelines",
                    uri: "https://learn.microsoft.com/zh-cn/windows/apps/develop/ui/controls/number-box"
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
        Use NumberBox to allow users to enter algebraic equations and numeric input in your app.
        """
        bodyStackPanel.children.append(descText)

        setupSimpleNumBox()
        setupSpinNumBox()
        setupFormattedNumBox()

        self.bodyScrollViewer.content = bodyStackPanel
    }

    private func setupSimpleNumBox() {
        let numberBoxControlExample = ControlExample()
        numberBoxControlExample.headerText = "A NumberBox that evaluates expressions"
        let numBox = NumberBox()
        numBox.header = "Enter an expression:"
        numBox.horizontalAlignment = .left
        numBox.value = .nan
        numBox.placeholderText = "1 + 2^2"
        numBox.acceptsExpression = true
        numBox.width = 200
        numberBoxControlExample.example = numBox
        bodyStackPanel.children.append(numberBoxControlExample.view)
    }

    private func setupSpinNumBox() {
        let spinNumBoxExample = ControlExample()
        spinNumBoxExample.headerText = "A NumberBox that evaluates expressions"
        let spinNumBox = NumberBox()
        spinNumBox.header = "Enter an integer:"
        spinNumBox.horizontalAlignment = .left
        spinNumBox.width = 200
        spinNumBox.value = 1
        spinNumBox.spinButtonPlacementMode = .inline
        spinNumBox.smallChange = 10
        spinNumBox.largeChange = 100
        spinNumBoxExample.example = spinNumBox
        let spinOptions = StackPanel()

        let sOptionHeader = TextBlock()
        sOptionHeader.text = "SpinButton placement"
        spinOptions.children.append(sOptionHeader)

        let inlineCkBox = CheckBox()
        let compatCkBox = CheckBox()
        inlineCkBox.content = "Inline"
        inlineCkBox.isChecked = true
        inlineCkBox.checked.addHandler { _, _ in
            inlineCkBox.isChecked = true
            compatCkBox.isChecked = false
            spinNumBox.spinButtonPlacementMode = .inline
        }
        compatCkBox.content = "Compact"
        compatCkBox.isChecked = false
        compatCkBox.checked.addHandler { _, _ in
            inlineCkBox.isChecked = false
            compatCkBox.isChecked = true
            spinNumBox.spinButtonPlacementMode = .compact
        }
        spinOptions.children.append(inlineCkBox)
        spinOptions.children.append(compatCkBox)

        spinNumBoxExample.options = spinOptions
        bodyStackPanel.children.append(spinNumBoxExample.view)
    }

    private func setupFormattedNumBox() {
        let formattedNumBoxExample = ControlExample()
        formattedNumBoxExample.headerText = "A formatted NumberBox that rounds to the nearest 0.25"

        let nb = NumberBox()
        nb.header = "Enter a dollar amount:"
        nb.placeholderText = "0.00"
        let rounder = IncrementNumberRounder()
        rounder.increment = 0.25
        rounder.roundingAlgorithm = RoundingAlgorithm.roundHalfUp
        let formatter = DecimalFormatter()
        formatter.integerDigits = 1
        formatter.fractionDigits = 2
        formatter.numberRounder = rounder
        nb.numberFormatter = formatter
        formattedNumBoxExample.example = nb

        bodyStackPanel.children.append(formattedNumBoxExample.view)
    }
}