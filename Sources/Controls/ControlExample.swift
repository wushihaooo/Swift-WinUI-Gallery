import WinUI
import WinAppSDK
import Foundation

final class ControlExample {
    private(set) var view: Grid = Grid()

    // 数据属性
    var headerText: String? { didSet { headerTextPresenter.text = headerText ?? "" ; headerTextPresenter.visibility = (headerText?.isEmpty ?? true) ? .collapsed : .visible } }
    var example: UIElement? { didSet { controlPresenter.content = example } }
    var output: UIElement? { didSet { updateOutput() } }
    var options: UIElement? { didSet { updateOptions() } }
    var xamlCode: String? { didSet { xamlText.text = xamlCode ?? "" ; updateCodeTabVisibility() } }
    var csharpCode: String? { didSet { csharpText.text = csharpCode ?? "" ; updateCodeTabVisibility() } }

    // 组件引用
    private var headerTextPresenter: TextBlock!
    private var controlPresenter: ContentPresenter!
    private var outputPanel: StackPanel!
    private var optionsPresenter: ContentPresenter!
    private var selectorBar: SelectorBar!
    private var xamlContentPresenter: ContentPresenter!
    private var csharpContentPresenter: ContentPresenter!
    private let xamlText = TextBlock()
    private let csharpText = TextBlock()

    private var selectorBarXamlItem: SelectorBarItem!
    private var selectorBarCSharpItem: SelectorBarItem!

    init() {
        loadXaml()
        wireUp()
    }

    private func loadXaml() {
        let path = Bundle.module.path(forResource: "ControlExample", ofType: "xaml", inDirectory: "Assets/xaml")!
        let rootObj = try! XamlReader.load(FileReader.readFileFromPath(path) ?? "")
        self.view = rootObj as! Grid
        // 绑定命名元素
        headerTextPresenter = try! view.findName("HeaderTextPresenter") as! TextBlock
        controlPresenter    = try! view.findName("ControlPresenter") as! ContentPresenter
        outputPanel         = try! view.findName("OutputPresenter") as! StackPanel
        optionsPresenter    = try! view.findName("OptionsPresenter") as! ContentPresenter
        selectorBar         = try! view.findName("SelectorBarControl") as! SelectorBar
        xamlContentPresenter   = try! view.findName("XamlContentPresenter") as! ContentPresenter
        csharpContentPresenter = try! view.findName("CSharpContentPresenter") as! ContentPresenter
        
        selectorBarXamlItem   = try! selectorBar.findName("SelectorBarXamlItem") as! SelectorBarItem
        selectorBarCSharpItem = try! selectorBar.findName("SelectorBarCSharpItem") as! SelectorBarItem
    }

    private func wireUp() {
        // 默认隐藏输出/选项
        outputPanel.visibility = .collapsed
        optionsPresenter.visibility = .collapsed

        // 为代码区放入 TextBlock（你也可以用 RichTextBlock）
        xamlText.textWrapping = .wrap
        csharpText.textWrapping = .wrap
        xamlContentPresenter.content = xamlText
        csharpContentPresenter.content = csharpText
        xamlContentPresenter.visibility = .collapsed
        csharpContentPresenter.visibility = .collapsed

        selectorBar.selectionChanged.addHandler { [weak self] _, _ in
            self?.applySelection()
        }
    }

    private func updateOutput() {
        outputPanel.children.clear()
        if let output = output {
            let label = TextBlock()
            label.text = "Output:"
            outputPanel.children.append(label)
            outputPanel.children.append(output)
            outputPanel.visibility = .visible
        } else {
            outputPanel.visibility = .collapsed
        }
    }

    private func updateOptions() {
        if let options = options {
            optionsPresenter.content = options
            optionsPresenter.visibility = .visible
        } else {
            optionsPresenter.visibility = .collapsed
        }
    }

    private func updateCodeTabVisibility() {
        let hasXaml = !(xamlCode?.isEmpty ?? true)
        let hasCs   = !(csharpCode?.isEmpty ?? true)
        selectorBarXamlItem.visibility   = hasXaml ? .visible : .collapsed
        selectorBarCSharpItem.visibility = hasCs   ? .visible : .collapsed

        if selectorBar.selectedItem == nil {
            if hasXaml { selectorBar.selectedItem = selectorBarXamlItem }
            else if hasCs { selectorBar.selectedItem = selectorBarCSharpItem }
        }
        applySelection()
    }

    private func applySelection() {
        guard let selected = selectorBar.selectedItem as? SelectorBarItem else { return }
        let tag = (selected.tag as? String ?? "").lowercased()
        xamlContentPresenter.visibility = (tag == "xaml") ? .visible : .collapsed
        csharpContentPresenter.visibility = (tag == "csharp") ? .visible : .collapsed
        // 如果当前选项不可见，自动切到可见的一个
        if xamlContentPresenter.visibility == .collapsed && csharpContentPresenter.visibility == .collapsed {
            if !(xamlCode?.isEmpty ?? true) {
                selectorBar.selectedItem = try? selectorBar.findName("SelectorBarXamlItem") as? SelectorBarItem
                xamlContentPresenter.visibility = .visible
            } else if !(csharpCode?.isEmpty ?? true) {
                selectorBar.selectedItem = try? selectorBar.findName("SelectorBarCSharpItem") as? SelectorBarItem
                csharpContentPresenter.visibility = .visible
            }
        }
    }
}
