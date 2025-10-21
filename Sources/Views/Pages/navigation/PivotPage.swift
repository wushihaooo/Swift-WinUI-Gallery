import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

class PivotPage: Grid {
    private var codeTextBlock: TextBlock?
    private var xamlButton: Button?
    private var csharpButton: Button?

    private enum CodeTab {
        case xaml
        case csharp
    }

    private let xamlSampleText = """
<Pivot Title="EMAIL">
    <PivotItem Header="All">
        <TextBlock Text="all emails go here." />
    </PivotItem>
    <PivotItem Header="Unread">
        <TextBlock Text="unread emails go here." />
    </PivotItem>
    <PivotItem Header="Flagged">
        <TextBlock Text="flagged emails go here." />
    </PivotItem>
    <PivotItem Header="Urgent">
        <TextBlock Text="urgent emails go here." />
    </PivotItem>
</Pivot>
"""

    private let csharpSampleText = """
var pivot = new Pivot { Title = "EMAIL", MinHeight = 400 };
var pivotItems = new[] { "All", "Unread", "Flagged", "Urgent" };
var descriptions = new[] { 
    "all emails go here.", 
    "unread emails go here.", 
    "flagged emails go here.", 
    "urgent emails go here." 
};

for (int i = 0; i < pivotItems.Length; i++)
{
    var item = new PivotItem 
    { 
        Header = pivotItems[i],
        Content = new TextBlock { Text = descriptions[i] }
    };
    pivot.Items.Add(item);
}
"""

    override init() {
        super.init()
        setupView()
    }

    private func setupView() {
        let scrollViewer = ScrollViewer()
        scrollViewer.verticalScrollMode = .enabled
        scrollViewer.horizontalScrollMode = .disabled
        scrollViewer.verticalScrollBarVisibility = .auto
        scrollViewer.horizontalScrollBarVisibility = .hidden

        let mainStack = StackPanel()
        mainStack.spacing = 24
        mainStack.padding = Thickness(left: 24, top: 24, right: 24, bottom: 24)
        scrollViewer.content = mainStack
        self.children.append(scrollViewer)

        mainStack.children.append(createHeaderSection())
        mainStack.children.append(createIntroText())
        mainStack.children.append(createBasicPivotSample())
        mainStack.children.append(createSourceCodeSection())

        let spacer = TextBlock()
        spacer.height = 24
        mainStack.children.append(spacer)

        selectCodeTab(.xaml)
    }

    private func createHeaderSection() -> StackPanel {
        let section = StackPanel()
        section.spacing = 12

        let title = TextBlock()
        title.text = "Pivot 透视控件"
        title.fontSize = 32
        title.fontWeight = FontWeights.semiBold
        title.foreground = SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        section.children.append(title)

        return section
    }

    private func createIntroText() -> TextBlock {
        let intro = TextBlock()
        intro.text = "Pivot 控件用于在多个选项卡之间导航。适合展示分类内容，如邮件箱中的不同邮件分类。用户可以在透视项之间平滑滑动。"
        intro.fontSize = 14
        intro.foreground = SolidColorBrush(Color(a: 255, r: 204, g: 204, b: 204))
        intro.textWrapping = .wrap
        return intro
    }

    private func createBasicPivotSample() -> StackPanel {
        let container = StackPanel()
        container.spacing = 12

        let titleBlock = TextBlock()
        titleBlock.text = "基础 Pivot 示例"
        titleBlock.fontSize = 18
        titleBlock.fontWeight = FontWeights.semiBold
        titleBlock.foreground = SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        container.children.append(titleBlock)

        let descBlock = TextBlock()
        descBlock.text = "这是一个电子邮件分类示例，包含四个透视项。"
        descBlock.fontSize = 12
        descBlock.foreground = SolidColorBrush(Color(a: 255, r: 170, g: 170, b: 170))
        descBlock.textWrapping = .wrap
        container.children.append(descBlock)

        let border = Border()
        border.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = SolidColorBrush(Color(a: 255, r: 68, g: 68, b: 68))
        border.background = SolidColorBrush(Color(a: 255, r: 34, g: 34, b: 34))
        border.padding = Thickness(left: 12, top: 12, right: 12, bottom: 12)

        let pivot = Pivot()
        pivot.title = "EMAIL"
        pivot.minHeight = 380

        let categories = [
            ("All", "all emails go here."),
            ("Unread", "unread emails go here."),
            ("Flagged", "flagged emails go here."),
            ("Urgent", "urgent emails go here.")
        ]

        for (header, content) in categories {
            let item = PivotItem()
            item.header = header

            let textBlock = TextBlock()
            textBlock.text = content
            textBlock.fontSize = 14
            textBlock.foreground = SolidColorBrush(Color(a: 255, r: 204, g: 204, b: 204))
            textBlock.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
            item.content = textBlock

            pivot.items.append(item)
        }

        border.child = pivot
        container.children.append(border)
        return container
    }

    private func createSourceCodeSection() -> Expander {
        let expander = Expander()
        expander.header = "源代码"
        expander.isExpanded = true
        expander.margin = Thickness(left: 0, top: 12, right: 0, bottom: 0)

        let stack = StackPanel()
        stack.spacing = 8
        stack.padding = Thickness(left: 0, top: 8, right: 0, bottom: 0)

        let tabStack = StackPanel()
        tabStack.orientation = .horizontal
        tabStack.spacing = 12

        let xamlBtn = Button()
        xamlBtn.content = "XAML"
        xamlBtn.padding = Thickness(left: 12, top: 6, right: 12, bottom: 6)
        xamlBtn.cornerRadius = CornerRadius(topLeft: 4, topRight: 4, bottomRight: 4, bottomLeft: 4)
        xamlBtn.click.addHandler { [weak self] _, _ in
            self?.selectCodeTab(.xaml)
        }
        tabStack.children.append(xamlBtn)
        xamlButton = xamlBtn

        let csharpBtn = Button()
        csharpBtn.content = "C#"
        csharpBtn.padding = Thickness(left: 12, top: 6, right: 12, bottom: 6)
        csharpBtn.cornerRadius = CornerRadius(topLeft: 4, topRight: 4, bottomRight: 4, bottomLeft: 4)
        csharpBtn.click.addHandler { [weak self] _, _ in
            self?.selectCodeTab(.csharp)
        }
        tabStack.children.append(csharpBtn)
        csharpButton = csharpBtn

        stack.children.append(tabStack)

        let codeBorder = Border()
        codeBorder.cornerRadius = CornerRadius(topLeft: 6, topRight: 6, bottomRight: 6, bottomLeft: 6)
        codeBorder.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        codeBorder.borderBrush = SolidColorBrush(Color(a: 255, r: 68, g: 68, b: 68))
        codeBorder.background = SolidColorBrush(Color(a: 255, r: 30, g: 30, b: 30))
        codeBorder.padding = Thickness(left: 12, top: 12, right: 12, bottom: 12)

        let codeText = TextBlock()
        codeText.fontFamily = FontFamily("Consolas")
        codeText.fontSize = 11
        codeText.textWrapping = .wrap
        codeText.foreground = SolidColorBrush(Color(a: 255, r: 212, g: 212, b: 212))
        codeBorder.child = codeText
        codeTextBlock = codeText

        stack.children.append(codeBorder)
        expander.content = stack
        return expander
    }

    private func selectCodeTab(_ tab: CodeTab) {
        guard let codeTextBlock else { return }

        switch tab {
        case .xaml:
            codeTextBlock.text = xamlSampleText
            highlight(button: xamlButton, isSelected: true)
            highlight(button: csharpButton, isSelected: false)
        case .csharp:
            codeTextBlock.text = csharpSampleText
            highlight(button: xamlButton, isSelected: false)
            highlight(button: csharpButton, isSelected: true)
        }
    }

    private func highlight(button: Button?, isSelected: Bool) {
        guard let button else { return }
        if isSelected {
            button.background = SolidColorBrush(Color(a: 255, r: 0, g: 120, b: 212))
            button.foreground = SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        } else {
            button.background = SolidColorBrush(Color(a: 0, r: 0, g: 0, b: 0))
            button.foreground = SolidColorBrush(Color(a: 255, r: 153, g: 153, b: 153))
        }
    }
}
