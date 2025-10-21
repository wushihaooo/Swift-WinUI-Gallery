import Foundation
import UWP
import WinAppSDK
import WindowsFoundation
import WinUI

class LayoutPage: Grid {
    private var rootGrid = Grid()
    private var titleTextBlock = TextBlock()
    private var stackPanel1 = StackPanel() // 使用简单的 StackPanel
    private var stackPanel2 = StackPanel()

    private let cardData1: [(name: String, description: String, icon: String)] = [
        ("Border", "A container control that draws a boundary line...", "\u{E8F0}"),
        ("Canvas", "A layout panel that supports absolute positioning...", "\u{E8F1}"),
        ("Expander", "A container with a header that can be expanded...", "\u{E8F2}"),
        ("Grid", "A layout panel that supports arranging child elements...", "\u{E8F3}"),
        ("RadioButtons", "A control that displays a group of mutually exclusive options...", "\u{E8F4}"),
    ]

     private let cardData2: [(name: String, description: String, icon: String)] = [
        ("RelativePanel", "A panel that uses relationships between elements...", "\u{E8F5}"),
        ("SplitView", "A container that has 2 content areas...", "\u{E8F6}"),
        ("StackPanel", "A layout panel that arranges child elements into a single line...", "\u{E8F7}"),
        ("VariableSizedWrapGrid", "A layout panel that supports arranging child elements...", "\u{E8F8}"),
        ("Viewbox", "A container control that scales its content...", "\u{E8F9}")
    ]

    override init() {
        super.init()
        setupView()
    }

    private func setupView() {
        let titleRow = RowDefinition()
        titleRow.height = GridLength(value: 1, gridUnitType: .auto)
        self.rowDefinitions.append(titleRow)
        
        let contentRow = RowDefinition()
        contentRow.height = GridLength(value: 1, gridUnitType: .star)
        self.rowDefinitions.append(contentRow)

        // 标题
        titleTextBlock.text = "Layout"
        titleTextBlock.fontSize = 30
        titleTextBlock.verticalAlignment = .center
        titleTextBlock.margin = Thickness(left: 20, top: 10, right: 20, bottom: 10)
        self.children.append(titleTextBlock)
        try? Grid.setRow(titleTextBlock, 0)
    
        let content = createGrid()
        self.children.append(content)
        try? Grid.setRow(content, 1)
    }

    private func createGrid() -> Grid {
        // 设置行定义
        let row1 = RowDefinition()
        row1.height = GridLength(value: 1, gridUnitType: .auto)
        rootGrid.rowDefinitions.append(row1)

        let row2 = RowDefinition()
        row2.height = GridLength(value: 1, gridUnitType: .auto)
        rootGrid.rowDefinitions.append(row2)

        // 使用简单的 StackPanel
        stackPanel1.orientation = .horizontal
        stackPanel1.spacing = 10
        stackPanel1.padding = Thickness(left: 20, top: 0, right: 20, bottom: 20)

        stackPanel2.orientation = .horizontal
        stackPanel2.spacing = 10
        stackPanel2.padding = Thickness(left: 20, top: 0, right: 20, bottom: 20)


        for cardInfo in cardData1 {
            let card = Border()
            card.background = SolidColorBrush(Colors.white)
            card.borderBrush = SolidColorBrush(Colors.lightGray)
            card.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
            card.width = 260  // 固定宽度
            card.height = 190 // 固定高度

            let stackPanel = StackPanel()
            stackPanel.orientation = .vertical
            stackPanel.spacing = 8
            card.child = stackPanel

            let title = TextBlock()
            title.text = cardInfo.name
            title.fontSize = 18
            stackPanel.children.append(title)

            let desc = TextBlock()
            desc.text = cardInfo.description
            desc.fontSize = 14
            desc.foreground = SolidColorBrush(Colors.gray)
            desc.textWrapping = .wrap
            desc.maxLines = 3
            stackPanel.children.append(desc)

            stackPanel1.children.append(card)
        }

        rootGrid.children.append(stackPanel1)
        try? Grid.setRow(stackPanel1, 0)  // 放在第1行
        
        for cardInfo in cardData2 {
            let card = Border()
            card.background = SolidColorBrush(Colors.white)
            card.borderBrush = SolidColorBrush(Colors.lightGray)
            card.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
            card.width = 260  // 固定宽度
            card.height = 190 // 固定高度

            let stackPanel = StackPanel()
            stackPanel.orientation = .vertical
            stackPanel.spacing = 8
            card.child = stackPanel

            let title = TextBlock()
            title.text = cardInfo.name
            title.fontSize = 18
            stackPanel.children.append(title)

            let desc = TextBlock()
            desc.text = cardInfo.description
            desc.fontSize = 14
            desc.foreground = SolidColorBrush(Colors.gray)
            desc.textWrapping = .wrap
            desc.maxLines = 3
            stackPanel.children.append(desc)

            stackPanel2.children.append(card)
        }
        rootGrid.children.append(stackPanel2)
        try? Grid.setRow(stackPanel2, 1)  // 放在第1行
        return rootGrid
    }

}