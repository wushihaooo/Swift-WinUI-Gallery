import WinUI
import Foundation
import WindowsFoundation
import WinAppSDK
import UWP

class ToolTipPage: Grid {

    private let exampleStackPanel = StackPanel()

    override init() {
        super.init()
        setupLayout()
        setupExample1_ButtonSimpleToolTip()
        setupExample2_TextBlockOffsetToolTip()
        setupExample3_ImagePlacementRectToolTip()
    }

    // MARK: - 基础布局：Header + ScrollViewer + StackPanel

    private func setupLayout() {
        let headerRow = RowDefinition()
        headerRow.height = GridLength(value: 1, gridUnitType: .auto)
        let contentRow = RowDefinition()
        contentRow.height = GridLength(value: 1, gridUnitType: .star)
        rowDefinitions.append(headerRow)
        rowDefinitions.append(contentRow)

        // Header
        let headerGrid = Grid()
        try? Grid.setRow(headerGrid, 0)
        children.append(headerGrid)

        let controlInfo = ControlInfo(
            title: "ToolTip",
            apiNamespace: "Microsoft.UI.Xaml.Controls",
            baseClasses: [
                "Object",
                "DependencyObject",
                "UIElement",
                "FrameworkElement",
                "ContentControl"
            ],
            docs: [
                ControlInfoDocLink(
                    title: "ToolTip - API",
                    uri: "https://learn.microsoft.com/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.controls.tooltip"
                ),
                ControlInfoDocLink(
                    title: "Guidelines",
                    uri: "https://learn.microsoft.com/windows/apps/design/controls/tooltip"
                )
            ]
        )

        let pageHeader = PageHeader(item: controlInfo)
        pageHeader.themeButtonVisibility = .visible
        pageHeader.margin = Thickness(left: 36, top: 36, right: 36, bottom: 0)
        headerGrid.children.append(pageHeader)

        // Content
        let scrollViewer = ScrollViewer()
        scrollViewer.verticalScrollMode = .auto
        scrollViewer.verticalScrollBarVisibility = .auto
        try? Grid.setRow(scrollViewer, 1)
        children.append(scrollViewer)

        exampleStackPanel.orientation = .vertical
        exampleStackPanel.spacing = 24
        exampleStackPanel.margin = Thickness(left: 36, top: 24, right: 36, bottom: 36)
        scrollViewer.content = exampleStackPanel
    }

    // MARK: - Example 1: A button with a simple ToolTip.

    private func setupExample1_ButtonSimpleToolTip() {
        let button = Button()
        button.content = "Button with a simple ToolTip."
        button.horizontalAlignment = .left

        let tip = ToolTip()
        tip.content = "This is a simple ToolTip."

        _ = try? ToolTipService.setToolTip(button, tip)

        let example = ControlExample(
            headerText: "A button with a simple ToolTip.",
            isOutputDisplay: false,
            isOptionsDisplay: false,
            contentPresenter: button,
            optionsPresenter: StackPanel()
        ).controlExample

        exampleStackPanel.children.append(example)
    }

    // MARK: - Example 2: A TextBlock with an offset ToolTip.

    private func setupExample2_TextBlockOffsetToolTip() {
        let textBlock = TextBlock()
        textBlock.text = "TextBlock with an offset ToolTip."
        textBlock.horizontalAlignment = .left

        let tip = ToolTip()
        tip.content = "This ToolTip appears slightly offset."
        
        _ = try? ToolTipService.setToolTip(textBlock, tip)

        _ = try? ToolTipService.setPlacement(textBlock, PlacementMode.bottom)

        let example = ControlExample(
            headerText: "A TextBlock with an offset ToolTip.",
            isOutputDisplay: false,
            isOptionsDisplay: false,
            contentPresenter: textBlock,
            optionsPresenter: StackPanel()
        ).controlExample

        exampleStackPanel.children.append(example)
    }

    // MARK: - Example 3: An Image with a ToolTip using PlacementRect.

    private func setupExample3_ImagePlacementRectToolTip() {
        let image = Image()
        image.width = 400
        image.height = 260
        image.stretch = .uniformToFill
        image.horizontalAlignment = .left

        if let path = Bundle.module.path(
            forResource: "cliff",
            ofType: "jpg",
            inDirectory: "Assets/SampleMedia"
        ) {
            let uri = Uri(path)
            let bitmap = BitmapImage(uri)
            image.source = bitmap
        }

        let tipTextBlock = TextBlock()
        tipTextBlock.text = "An image of a cliff with sea view."
        tipTextBlock.textWrapping = .wrapWholeWords

        let tip = ToolTip()
        tip.content = tipTextBlock

        _ = try? ToolTipService.setToolTip(image, tip)

        _ = try? ToolTipService.setPlacement(image, PlacementMode.bottom)

        let example = ControlExample(
            headerText: "An Image with a ToolTip using PlacementRect.",
            isOutputDisplay: false,
            isOptionsDisplay: false,
            contentPresenter: image,
            optionsPresenter: StackPanel()
        ).controlExample

        exampleStackPanel.children.append(example)
    }
}
