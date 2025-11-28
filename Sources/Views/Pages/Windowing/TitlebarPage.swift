// Sources/Views/Pages/Windowing/TitlebarPage.swift
import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

final class TitlebarPage: Grid {
    override init() {
        super.init()
        setupLayout()
    }

    private func setupLayout() {
        let rootGrid = Grid()
        let rowHeader = RowDefinition()
        rowHeader.height = GridLength(value: 0, gridUnitType: .auto)
        let rowBody = RowDefinition()
        rowBody.height = GridLength(value: 1, gridUnitType: .star)
        rootGrid.rowDefinitions.append(rowHeader)
        rootGrid.rowDefinitions.append(rowBody)

        let headerHost = Grid()
        try? Grid.setRow(headerHost, 0)
        rootGrid.children.append(headerHost)

        let controlInfo = ControlInfo(
            title: "TitleBar",
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
                    title: "TitleBar API",
                    uri: "https://learn.microsoft.com/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.controls.titlebar"
                ),
                ControlInfoDocLink(
                    title: "Title bar design guidance",
                    uri: "https://learn.microsoft.com/windows/apps/develop/title-bar"
                )
            ]
        )

        let pageHeader = PageHeader(item: controlInfo)
        pageHeader.themeButtonVisibility = .visible
        pageHeader.margin = Thickness(left: 36, top: 36, right: 36, bottom: 0)
        headerHost.children.append(pageHeader)

        let scrollViewer = ScrollViewer()
        try? Grid.setRow(scrollViewer, 1)
        scrollViewer.horizontalScrollBarVisibility = .disabled
        scrollViewer.verticalScrollBarVisibility = .auto

        let stack = StackPanel()
        stack.spacing = 24
        stack.padding = Thickness(left: 36, top: 24, right: 36, bottom: 36)
        scrollViewer.content = stack
        stack.children.append(createConfigurationCard())
        stack.children.append(createEndToEndCard())
        rootGrid.children.append(scrollViewer)

        self.children.append(rootGrid)
    }

    // MARK: - Card 1: TitleBar configuration

    private func createConfigurationCard() -> UIElement {
        let border = Border()
        border.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        border.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.margin = Thickness(left: 0, top: 0, right: 0, bottom: 8)
        border.background = SolidColorBrush(Color(a: 255, r: 32, g: 32, b: 32))
        border.borderBrush = SolidColorBrush(Color(a: 255, r: 64, g: 64, b: 64))

        let cardStack = StackPanel()
        cardStack.spacing = 16
        border.child = cardStack

        let sectionTitle = TextBlock()
        sectionTitle.text = "TitleBar configuration"
        sectionTitle.fontSize = 16
        sectionTitle.fontWeight = FontWeights.bold
        sectionTitle.margin = Thickness(left: 0, top: 0, right: 0, bottom: 8)
        cardStack.children.append(sectionTitle)

        let mainGrid = Grid()
        mainGrid.columnSpacing = 24

        let colLeft = ColumnDefinition()
        colLeft.width = GridLength(value: 1, gridUnitType: .star)
        let colRight = ColumnDefinition()
        colRight.width = GridLength(value: 260, gridUnitType: .pixel)
        mainGrid.columnDefinitions.append(colLeft)
        mainGrid.columnDefinitions.append(colRight)

        // 左侧：TitleBar
        let previewHost = Border()
        previewHost.cornerRadius = CornerRadius(topLeft: 4, topRight: 4, bottomRight: 4, bottomLeft: 4)
        previewHost.background = SolidColorBrush(Color(a: 255, r: 24, g: 24, b: 24))
        previewHost.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)

        let titleBar = TitleBar()
        titleBar.title = "WinUI Gallery"
        titleBar.subtitle = "Preview"
        titleBar.isBackButtonVisible = false
        titleBar.isPaneToggleButtonVisible = false

        // 左边“应用图标”
        let appIconBorder = Border()
        appIconBorder.width = 24
        appIconBorder.height = 24
        appIconBorder.cornerRadius = CornerRadius(topLeft: 4, topRight: 4, bottomRight: 4, bottomLeft: 4)
        appIconBorder.margin = Thickness(left: 16, top: 0, right: 8, bottom: 0)
        let appIconImage = Image()
        appIconImage.horizontalAlignment = .center
        appIconImage.verticalAlignment = .center
        appIconImage.stretch = .uniform
        if let iconPath = Bundle.module.path(
            forResource: "GalleryIcon",
            ofType: "ico",
            inDirectory: "Assets/Tiles"
        ) {
            appIconImage.source = BitmapImage(Uri(iconPath))
        }

        appIconBorder.child = appIconImage
        titleBar.leftHeader = appIconBorder

        // 右边“头像”
        let avatarBorder = Border()
        avatarBorder.width = 30
        avatarBorder.height = 30
        avatarBorder.cornerRadius = CornerRadius(topLeft: 15, topRight: 15, bottomRight: 15, bottomLeft: 15)
        avatarBorder.background = SolidColorBrush(Color(a: 255, r: 80, g: 80, b: 80))

        let avatarText = TextBlock()
        avatarText.text = "JD"
        avatarText.horizontalAlignment = .center
        avatarText.verticalAlignment = .center
        avatarBorder.child = avatarText
        titleBar.rightHeader = avatarBorder

        // 中间搜索框
        let searchBox = AutoSuggestBox()
        searchBox.width = 360
        searchBox.verticalAlignment = .center
        searchBox.placeholderText = "Search.."
        titleBar.content = searchBox

        previewHost.child = titleBar
        mainGrid.children.append(previewHost)

        // 右侧：配置控件
        let optionsPanel = StackPanel()
        optionsPanel.spacing = 12
        try? Grid.setColumn(optionsPanel, 1)

        let titleBox = TextBox()
        titleBox.header = "Title"
        titleBox.text = "WinUI Gallery"
        optionsPanel.children.append(titleBox)

        let subtitleBox = TextBox()
        subtitleBox.header = "Subtitle"
        subtitleBox.text = "Preview"
        optionsPanel.children.append(subtitleBox)

        let backToggle = ToggleSwitch()
        backToggle.header = "IsBackButtonVisible"
        backToggle.isOn = false
        optionsPanel.children.append(backToggle)

        let paneToggle = ToggleSwitch()
        paneToggle.header = "IsPaneToggleButtonVisible"
        paneToggle.isOn = false
        optionsPanel.children.append(paneToggle)

        mainGrid.children.append(optionsPanel)
        cardStack.children.append(mainGrid)

        // Source code
        let codeExpander = Expander()
        codeExpander.header = "Source code"
        codeExpander.isExpanded = false

        let pivot = Pivot()
        pivot.margin = Thickness(left: 0, top: 8, right: 0, bottom: 0)

        // XAML tab
        let xamlItem = PivotItem()
        xamlItem.header = "XAML"

        let xamlBox = TextBox()
        xamlBox.isReadOnly = true
        xamlBox.acceptsReturn = true
        xamlBox.textWrapping = .noWrap
        xamlBox.fontFamily = FontFamily("Cascadia Code, Consolas, monospace")
        xamlItem.content = xamlBox
        pivot.items.append(xamlItem)

        codeExpander.content = pivot
        cardStack.children.append(codeExpander)

        // ------- 动态更新 XAML 文本 -------

        func updateXamlSource() {
            let titleText = titleBox.text
            let subtitleText = subtitleBox.text
            let backText = backToggle.isOn ? "True" : "False"
            let paneText = paneToggle.isOn ? "True" : "False"

            xamlBox.text = """
<TitleBar
    Title="\(titleText)"
    Subtitle="\(subtitleText)"
    IsBackButtonVisible="\(backText)"
    IsPaneToggleButtonVisible="\(paneText)">
    <TitleBar.IconSource>
        <ImageIconSource ImageSource="/Assets/Tiles/GalleryIcon.ico" />
    </TitleBar.IconSource>
    <TitleBar.Content>
        <AutoSuggestBox
            Width="360"
            VerticalAlignment="Center"
            PlaceholderText="Search.."
            QueryIcon="Find" />
    </TitleBar.Content>
    <TitleBar.RightHeader>
        <PersonPicture
            Width="30"
            Height="30"
            Initials="JD" />
    </TitleBar.RightHeader>
</TitleBar>
"""
        }

        // 交互：右边控件驱动左边 TitleBar + 下面的 XAML 文本
        titleBox.textChanged.addHandler { _, _ in
            titleBar.title = titleBox.text
            updateXamlSource()
        }
        subtitleBox.textChanged.addHandler { _, _ in
            titleBar.subtitle = subtitleBox.text
            updateXamlSource()
        }
        backToggle.toggled.addHandler { _, _ in
            titleBar.isBackButtonVisible = backToggle.isOn
            updateXamlSource()
        }
        paneToggle.toggled.addHandler { _, _ in
            titleBar.isPaneToggleButtonVisible = paneToggle.isOn
            updateXamlSource()
        }

        updateXamlSource()
        return border
    }

    // MARK: - Card 2: End-to-end TitleBar sample
    private func createEndToEndCard() -> UIElement {
        let container = StackPanel()
        container.spacing = 8

        let cardBorder = Border()
        cardBorder.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        cardBorder.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        cardBorder.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)

        let cardStack = StackPanel()
        cardStack.spacing = 16
        cardBorder.child = cardStack

        let descText = TextBlock()
        descText.text =
"""
Click the button below to see an end to end sample of a TitleBar in an new window,
binding some of its properties to the NavigationView and navigation frame.
"""
        descText.textWrapping = .wrapWholeWords
        descText.textAlignment = .center
        descText.horizontalAlignment = .center
        cardStack.children.append(descText)

        let showButton = Button()
        showButton.horizontalAlignment = .center
        showButton.content = "Show sample window"

        if let style = Application.current?.resources?.lookup("AccentButtonStyle") as? Style {
            showButton.style = style
        }

        showButton.click.addHandler { [weak self] _, _ in
            self?.createTitleBarWindowSample()
        }

        cardStack.children.append(showButton)
        container.children.append(cardBorder)

        let sourceBorder = Border()
        sourceBorder.padding = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        sourceBorder.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        sourceBorder.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        sourceBorder.background = SolidColorBrush(Color(a: 255, r: 32, g: 32, b: 32))
        sourceBorder.borderBrush = SolidColorBrush(Color(a: 255, r: 64, g: 64, b: 64))

        let codeExpander = Expander()
        codeExpander.header = "Source code"
        codeExpander.isExpanded = false

        let pivot = Pivot()
        pivot.margin = Thickness(left: 0, top: 8, right: 0, bottom: 0)

        let xamlItem = PivotItem()
        xamlItem.header = "XAML"

        let xamlBox = TextBox()
        xamlBox.isReadOnly = true
        xamlBox.acceptsReturn = true
        xamlBox.textWrapping = .noWrap
        xamlBox.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        xamlBox.fontFamily = FontFamily("Cascadia Code, Consolas, monospace")
        xamlBox.text =
"""
<Grid>
    <Grid.RowDefinitions>
        <RowDefinition Height="Auto" />
        <!--  TitleBar  -->
        <RowDefinition Height="*" />
        <!--  NavigationView  -->
    </Grid.RowDefinitions>

    <TitleBar
        x:Name="titleBar"
        BackRequested="TitleBar_BackRequested"
        IsBackButtonVisible="{x:Bind navFrame.CanGoBack, Mode=OneWay}"
        IsPaneToggleButtonVisible="True"
        PaneToggleRequested="TitleBar_PaneToggleRequested" />

    <NavigationView
        x:Name="navView"
        Grid.Row="1"
        IsBackButtonVisible="Collapsed"
        IsPaneToggleButtonVisible="False">
        <NavigationView.MenuItems... />
        <Frame x:Name="navFrame" />
    </NavigationView>
</Grid>
"""
        let xamlScroll = ScrollViewer()
        xamlScroll.content = xamlBox
        xamlItem.content = xamlScroll
        pivot.items.append(xamlItem)

        let csItem = PivotItem()
        csItem.header = "C#"

        let csBox = TextBox()
        csBox.isReadOnly = true
        csBox.acceptsReturn = true
        csBox.textWrapping = .noWrap
        csBox.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        csBox.fontFamily = FontFamily("Cascadia Code, Consolas, monospace")
        csBox.text =
"""
this.ExtendsContentIntoTitleBar = true; // Extend the content into the title bar and hide the default titlebar
this.SetTitleBar(titleBar);            // Set the custom title bar
"""
        let csScroll = ScrollViewer()
        csScroll.content = csBox
        csItem.content = csScroll
        pivot.items.append(csItem)

        codeExpander.content = pivot
        sourceBorder.child = codeExpander

        container.children.append(sourceBorder)

        return container
    }

    private func createTitleBarWindowSample() {
        // TODO
        print("Show sample window clicked")
    }

    private func createSourceCodeSection(xaml: String, csharp: String) -> UIElement {
        let outerBorder = Border()
        outerBorder.cornerRadius = CornerRadius(topLeft: 4, topRight: 4, bottomRight: 4, bottomLeft: 4)
        outerBorder.background = SolidColorBrush(Color(a: 255, r: 24, g: 24, b: 24))

        let rootStack = StackPanel()
        rootStack.spacing = 0
        outerBorder.child = rootStack

        let headerGrid = Grid()
        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 1, gridUnitType: .star)
        let col2 = ColumnDefinition()
        col2.width = GridLength(value: 0, gridUnitType: .auto)
        headerGrid.columnDefinitions.append(col1)
        headerGrid.columnDefinitions.append(col2)
        headerGrid.padding = Thickness(left: 12, top: 8, right: 12, bottom: 8)

        let title = TextBlock()
        title.text = "Source code"
        title.verticalAlignment = .center
        headerGrid.children.append(title)

        rootStack.children.append(headerGrid)

        let separator = Border()
        separator.height = 1
        separator.background = SolidColorBrush(Color(a: 255, r: 64, g: 64, b: 64))
        rootStack.children.append(separator)

        let tabView = TabView()

        let xamlTab = TabViewItem()
        xamlTab.header = "XAML"
        let xamlScroll = ScrollViewer()
        xamlScroll.horizontalScrollBarVisibility = .auto
        xamlScroll.verticalScrollBarVisibility = .auto
        xamlScroll.content = createCodeTextBox(text: xaml)
        xamlTab.content = xamlScroll

        let csharpTab = TabViewItem()
        csharpTab.header = "C#"
        let csharpScroll = ScrollViewer()
        csharpScroll.horizontalScrollBarVisibility = .auto
        csharpScroll.verticalScrollBarVisibility = .auto
        csharpScroll.content = createCodeTextBox(text: csharp)
        csharpTab.content = csharpScroll

        tabView.tabItems.append(xamlTab)
        tabView.tabItems.append(csharpTab)

        rootStack.children.append(tabView)

        return outerBorder
    }

    private func createCodeTextBox(text: String) -> TextBox {
        let tb = TextBox()
        tb.isReadOnly = true
        tb.acceptsReturn = true
        tb.textWrapping = .noWrap
        tb.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        tb.background = SolidColorBrush(Color(a: 0, r: 0, g: 0, b: 0))
        tb.fontFamily = FontFamily("Cascadia Code, Consolas, monospace")
        tb.text = text
        return tb
    }
}
