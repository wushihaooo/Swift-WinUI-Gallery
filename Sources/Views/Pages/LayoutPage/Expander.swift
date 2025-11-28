import Foundation
import UWP
import WinAppSDK
import WindowsFoundation
import WinUI

class ExpanderPage: Grid {
    private var titleGrid = Grid()//标题
    private var mainPanel = StackPanel() 
    private var expander1: Expander!
    private var directionCombo: ComboBox!

    override init() {
        super.init()
        setTitle()
        setMainPanel()
        setUpView()
    }

    private func setUpView() {
        let titleBarRow = RowDefinition()
        titleBarRow.height = GridLength(value: 1, gridUnitType: .auto)
        self.rowDefinitions.append(titleBarRow)

        let mainRow = RowDefinition()
        mainRow.height = GridLength(value: 1, gridUnitType: .star)
        self.rowDefinitions.append(mainRow)
        
        self.children.append(titleGrid)
        try? Grid.setRow(titleGrid, 0)

        self.children.append(mainPanel)
        try? Grid.setRow(mainPanel, 1)

    }


    private func setTitle() {
        let titleRow = RowDefinition()
        titleRow.height = GridLength(value: 1, gridUnitType: .auto)
        titleGrid.rowDefinitions.append(titleRow)
        
        let descriptionRow = RowDefinition()
        descriptionRow.height = GridLength(value: 1, gridUnitType: .auto)
        titleGrid.rowDefinitions.append(descriptionRow)

        let titleTextBlock = TextBlock()
        titleTextBlock.text = "Expander"
        titleTextBlock.fontSize = 30
        titleTextBlock.fontWeight = FontWeights.bold
        titleGrid.children.append(titleTextBlock)
        try? Grid.setRow(titleTextBlock, 0)

        let descriptionTextBlock = TextBlock()
        descriptionTextBlock.text = "The Expander has a header and can expand to show a body with more content. Use an Expander when some content is only relevant some of the time (for example to read more information or access additional options for an item)."
        descriptionTextBlock.fontSize = 16
        titleGrid.children.append(descriptionTextBlock)
        try? Grid.setRow(descriptionTextBlock, 1)

        titleGrid.margin = Thickness(left: 20, top: 10, right: 20, bottom: 10)

    }

    private func setMainPanel() {

        // 第一个 Expander 区域
        let expanderSection1 = StackPanel()
        expanderSection1.margin = Thickness(left: 20, top: 10, right: 20, bottom: 20)

        let section1Title = TextBlock()
        section1Title.text = "An expander with a header and content"
        section1Title.fontSize = 18
        section1Title.fontWeight = FontWeights.semiBold
        expanderSection1.children.append(section1Title)

        let expanderGrid1 = Grid()
        let row1 = RowDefinition()
        row1.height = GridLength(value: 1, gridUnitType: .auto)
        expanderGrid1.rowDefinitions.append(row1)

        // Expander 控件
        expander1 = Expander()
        expander1.header = "This text is in the header"
        expander1.content = "This is in the content"
        expander1.isExpanded = false
        expander1.expandDirection = .down
        try?Grid.setRow(expander1, 0)
        expanderGrid1.children.append(expander1)

        // 右侧下拉框区域
        let rightPanel1 = StackPanel()
        rightPanel1.orientation = .vertical
        rightPanel1.verticalAlignment = .center
        rightPanel1.horizontalAlignment = .right
        let directionLabel = TextBlock()
        directionLabel.text = "ExpandDirection"
        directionLabel.margin = Thickness(left: 0, top: 0, right: 10, bottom: 0)
        directionCombo = ComboBox()
        directionCombo.items.append("Down")
        directionCombo.items.append("Up")
        directionCombo.selectedIndex = 0
        directionCombo.selectionChanged.addHandler { [weak self] sender, args in
            guard let self = self, let combo = sender as? ComboBox else { return }
            let selectedIndex = combo.selectedIndex
            switch selectedIndex {
            case 0:
                print("Down")
                self.expander1.expandDirection = .down
            case 1:
                print("Up")
                self.expander1.expandDirection = .up
            default:
                break
            }
        }
        rightPanel1.children.append(directionLabel)
        rightPanel1.children.append(directionCombo)
        try?Grid.setRow(rightPanel1, 0)
        expanderGrid1.children.append(rightPanel1)

         expanderSection1.children.append(expanderGrid1)

        // 第二个 Expander 区域（居中对齐）
        let expanderSection2 = StackPanel()
        expanderSection2.margin = Thickness(left: 20, top: 10, right: 20, bottom: 20)

        let section2Title = TextBlock()
        section2Title.text = "Modifying Expanders content alignment"
        section2Title.fontSize = 18
        section2Title.fontWeight = FontWeights.semiBold
        expanderSection2.children.append(section2Title)

        let expander2 = Expander()
        let centeredHeader = TextBlock()
        centeredHeader.text = "This text is centered"
        centeredHeader.horizontalAlignment = .center  // 关键：水平居中
        expander2.header = centeredHeader  // 赋值给 Expander 的 header
        expander2.horizontalAlignment = .stretch
        expander2.content =  "居中内容区域..."
        expander2.isExpanded = false
        expanderSection2.children.append(expander2)

        mainPanel.children.append(expanderSection1)
        mainPanel.children.append(expanderSection2)
    }
   

}