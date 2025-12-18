import WinUI
import Foundation
import WindowsFoundation
import WinAppSDK
import UWP

class CalendarViewPage: Page {
    private var pageRootGrid: Grid = Grid()
    private var exampleStackPanel: StackPanel = StackPanel()
    private var headerGrid: Grid = Grid()
    private var bodyScrollViewer: ScrollViewer = ScrollViewer()
    // private var example

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
        let pageHeader: PageHeader
        let controlInfo = ControlInfo(
            title: "CalendarView",
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
                    title: "CalendarView-API",
                    uri: "https://learn.microsoft.com/windows/windows-app-sdk/api/winrt/microsoft.ui.xaml.controls.calendarview"
                ),
                ControlInfoDocLink(
                    title: "Guidelines",
                    uri: "https://learn.microsoft.com/zh-cn/windows/apps/develop/ui/controls/calendar-view"
                )
            ]
        )
        pageHeader = PageHeader(item: controlInfo)
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
        descText.text = "CalendarView shows a larger view for showing and selecting and selecting dates. DatePicker by contrast has compact view with inline selection."
        bodyStackPanel.children.append(descText)

        // CardView
        let sample = CalendarView()
        let options = StackPanel()
        options.spacing = 15
        let isGroupLabelVisiable = CheckBox()
        isGroupLabelVisiable.content = "IsGroupLabelVisiable"
        isGroupLabelVisiable.isChecked = true
        sample.isGroupLabelVisible = true
        isGroupLabelVisiable.checked.addHandler { [weak sample] _, _ in
            sample?.isGroupLabelVisible = true
        }
        isGroupLabelVisiable.unchecked.addHandler { [weak sample] _, _ in
            sample?.isGroupLabelVisible = false
        }
        options.children.append(isGroupLabelVisiable)

        let isOutOfScopeEnabled = CheckBox()
        isOutOfScopeEnabled.content = "IsOutOfScopeEnabled"
        isOutOfScopeEnabled.isChecked = true
        sample.isOutOfScopeEnabled = true
        isOutOfScopeEnabled.checked.addHandler { [weak sample] _, _ in
            sample?.isOutOfScopeEnabled = true
        }
        isOutOfScopeEnabled.unchecked.addHandler { [weak sample] _, _ in
            sample?.isOutOfScopeEnabled = false
        }
        options.children.append(isOutOfScopeEnabled)

        let selectionMode = ComboBox()
        selectionMode.header = "SelectionMode"
        let none = ComboBoxItem()
        none.content = "None"
        let single = ComboBoxItem()
        single.content = "Single"
        let multiple = ComboBoxItem()
        multiple.content = "Multiple"
        selectionMode.items.append(none)
        selectionMode.items.append(single)
        selectionMode.items.append(multiple)
        selectionMode.selectionChanged.addHandler { _, _ in
            switch selectionMode.selectedIndex {
            case 0:
                sample.selectionMode = .none
            case 1:
                sample.selectionMode = .single
            case 2:
                sample.selectionMode = .multiple
            default:
                sample.selectionMode = .single
            }
        }
        selectionMode.selectedIndex = 1
        options.children.append(selectionMode)

        
        let language = ComboBox()
        let languageList: [String] = [
            "zh-CN", // 中文-简体
            "en-US", // 英语-美国
            "en-GB", // 英语-英国
            "en-AU", // 英语-澳大利亚
            "ja-JP", // 日语-日本
            "ko-KR", // 韩语-韩国
            "fr-FR", // 法语-法国
            "fr-CA", // 法语-加拿大
            "de-DE", // 德语-德国
            "es-ES", // 西班牙语-西班牙
            "es-MX", // 西班牙语-墨西哥
            "pt-BR", // 葡萄牙语-巴西
            "pt-PT", // 葡萄牙语-葡萄牙
            "ru-RU", // 俄语-俄罗斯
            "ar-SA", // 阿拉伯语-沙特
            "it-IT", // 意大利语-意大利
            "nl-NL", // 荷兰语-荷兰
            "tr-TR"  // 土耳其语-Türkiye
        ]
        for i in languageList {
            let iItem = ComboBoxItem()
            iItem.content = i
            language.items.append(iItem)
        }
        language.selectionChanged.addHandler { [weak sample] _, _ in
            sample?.language = languageList[Int(language.selectedIndex)]
        }
        sample.language = "zh-CN"
        language.selectedIndex = Int32(languageList.firstIndex(of: "zh-CN") ?? 0)
        options.children.append(language)
        
        let card = DTControlExample()
        card.headerText = "A basic calendar view."
        card.example = sample
        card.options = options

        bodyStackPanel.children.append(card.view)
        self.bodyScrollViewer.content = bodyStackPanel
        
    }
}
