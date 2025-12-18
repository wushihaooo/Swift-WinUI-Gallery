import WinUI

class PasswordBoxPage: Page {
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
            title: "PasswordBox",
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
                    title: "PasswordBox-API",
                    uri: "https://learn.microsoft.com/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.controls.passwordbox"
                ),
                ControlInfoDocLink(
                    title: "Guidelines",
                    uri: "https://learn.microsoft.com/zh-cn/windows/apps/develop/ui/controls/password-box"
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
        A user can enter a single line of non-wrapping text in a PasswordBox control. The text is masked bycharacters that you can specify by using the PasswordChar property, and you can specify themaximum number of characters that the user can enter by setting the MaxLength property.
        """
        bodyStackPanel.children.append(descText)

        setupSimplePasswordBox()
        setupCustomPasswordBox()
        setupRevealPasswordBox()

        self.bodyScrollViewer.content = bodyStackPanel
    }
    
    private func setupSimplePasswordBox() {
        let pwdBoxExample = ControlExample()
        pwdBoxExample.headerText = "A simple PasswordBox"
        let pwdBox = PasswordBox()
        pwdBox.horizontalAlignment = .left
        pwdBox.width = 300
        pwdBoxExample.example = pwdBox
        bodyStackPanel.children.append(pwdBoxExample.view)
    }

    private func setupCustomPasswordBox() {
        let pwdBoxExample = ControlExample()
        pwdBoxExample.headerText = "A PasswordBox with header, placeholder text and custom character"
        let pwdBox = PasswordBox()
        pwdBox.header = "Password"
        pwdBox.placeholderText = "Enter your password"
        pwdBox.horizontalAlignment = .left
        pwdBox.passwordChar = "#"
        pwdBox.width = 300
        pwdBoxExample.example = pwdBox
        bodyStackPanel.children.append(pwdBoxExample.view)
    }
    private func setupRevealPasswordBox() {
        let pwdBoxExample = ControlExample()
        pwdBoxExample.headerText = "A simple PasswordBox"
        let sp = StackPanel()
        sp.orientation = .horizontal
        sp.spacing = 5

        let pwdBox = PasswordBox()
        pwdBox.horizontalAlignment = .left
        pwdBox.width = 250
        sp.children.append(pwdBox)
        
        let cb = CheckBox()
        cb.content = "Show password"
        cb.isChecked = false
        cb.checked.addHandler { _, _ in 
            pwdBox.passwordRevealMode = .visible
        }
        cb.unchecked.addHandler { _, _ in
            pwdBox.passwordRevealMode = .hidden
        }
        sp.children.append(cb)

        pwdBoxExample.example = sp
        bodyStackPanel.children.append(pwdBoxExample.view)
    }
}