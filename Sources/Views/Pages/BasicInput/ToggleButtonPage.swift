import WinUI
import WinAppSDK

class ToggleButtonPage: StackPanel {
    private let outputText = TextBlock()

    // ToggleButton
    private let toggleButton = ToggleButton()
    // 控制 ToggleButton 是否禁用
    private let disableCheckBox = CheckBox()

    override init() {
        super.init()
        setupLayout()
        setupHandlers()
    }

    private func setupLayout() {
        self.orientation = .vertical
        self.spacing = 10
        self.padding = Thickness(left: 20, top: 20, right: 20, bottom: 20)

        // ✅ 页面标题
        let title = TextBlock()
        title.text = "ToggleButton Example"
        title.fontSize = 20
        self.children.append(title)

        // ToggleButton
        toggleButton.content = "ToggleButton"
        toggleButton.width = 150
        toggleButton.height = 40
        toggleButton.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)
        self.children.append(toggleButton)

        // Disable 控制 CheckBox
        disableCheckBox.content = TextBlock()
        (disableCheckBox.content as! TextBlock).text = "Disable ToggleButton"
        (disableCheckBox.content as! TextBlock).fontSize = 14
        disableCheckBox.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)
        self.children.append(disableCheckBox)

        // 输出文本
        outputText.text = "Output: ToggleButton not clicked yet"
        outputText.fontSize = 14
        outputText.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)
        self.children.append(outputText)
    }

    private func setupHandlers() {
        // ToggleButton 点击事件
        toggleButton.click.addHandler { [weak self] _, _ in
            guard let self = self else { return }
            if self.toggleButton.isChecked == true {
                self.outputText.text = "Output: ToggleButton is ON"
            } else if self.toggleButton.isChecked == false {
                self.outputText.text = "Output: ToggleButton is OFF"
            } else {
                self.outputText.text = "Output: ToggleButton state is indeterminate"
            }
        }

        // CheckBox 控制 ToggleButton 是否禁用
        disableCheckBox.checked.addHandler { [weak self] _, _ in
            self?.toggleButton.isEnabled = false
            self?.outputText.text = "Output: ToggleButton disabled"
        }
        disableCheckBox.unchecked.addHandler { [weak self] _, _ in
            self?.toggleButton.isEnabled = true
            self?.outputText.text = "Output: ToggleButton enabled"
        }
    }
}
