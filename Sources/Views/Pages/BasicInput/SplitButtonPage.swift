import WinUI
import WinAppSDK

class SplitButtonPage: StackPanel {

    private let outputText = TextBlock()
    private var currentColorName: String = "Green"
    private let colorBorder = Border()

    override init() {
        super.init()
        setupLayout()
    }

    private func setupLayout() {
        self.orientation = .vertical
        self.spacing = 10
        self.padding = Thickness(left: 20, top: 20, right: 20, bottom: 20)

        // 标题
        let title = TextBlock()
        title.text = "SplitButton Example"
        title.fontSize = 20
        self.children.append(title)

        // 用 Button 模拟 SplitButton
        let mainButton = Button()
        mainButton.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)

        // 当前颜色显示
        colorBorder.width = 32
        colorBorder.height = 32
        var cornerRadius = CornerRadius()
        cornerRadius.topLeft = 4
        cornerRadius.topRight = 4
        cornerRadius.bottomLeft = 4
        cornerRadius.bottomRight = 4
        colorBorder.cornerRadius = cornerRadius
        colorBorder.background = SolidColorBrush(Colors.green)
        mainButton.content = colorBorder

        // Flyout
        let flyout = Flyout()
        flyout.placement = FlyoutPlacementMode.bottom

        let panel = StackPanel()
        panel.orientation = .vertical
        panel.spacing = 5
        panel.padding = Thickness(left: 10, top: 10, right: 10, bottom: 10)

        let colors: [(String, _)] = [
            ("Red", Colors.red),
            ("Green", Colors.green),
            ("Blue", Colors.blue),
            ("Yellow", Colors.yellow)
        ]

        for (name, color) in colors {
            let button = Button()
            let rect = Border()
            rect.width = 24
            rect.height = 24
            var rectCornerRadius = CornerRadius()
            rectCornerRadius.topLeft = 4
            rectCornerRadius.topRight = 4
            rectCornerRadius.bottomLeft = 4
            rectCornerRadius.bottomRight = 4
            rect.cornerRadius = rectCornerRadius
            rect.background = SolidColorBrush(color)
            button.content = rect

            button.click.addHandler { [weak self] (_ sender: Optional<Any>, _ args: Optional<RoutedEventArgs>) in
                guard let self = self else { return }
                self.currentColorName = name
                self.colorBorder.background = SolidColorBrush(color)
                // 修正：处理可能抛出的错误
                do {
                    try flyout.hide()
                } catch {
                    print("Error hiding flyout: \(error)")
                }
                self.outputText.text = "Changed color to \(name)"
            }

            panel.children.append(button)
        }

        flyout.content = panel
        mainButton.flyout = flyout

        // 点击主按钮事件
        mainButton.click.addHandler { [weak self] (_ sender: Optional<Any>, _ args: Optional<RoutedEventArgs>) in
            guard let self = self else { return }
            self.outputText.text = "Clicked main button with color: \(self.currentColorName)"
        }

        self.children.append(mainButton)

        // 输出文字
        outputText.text = "Output:"
        outputText.fontSize = 14
        outputText.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)
        self.children.append(outputText)
    }
}