import WinUI
import WinAppSDK

private func createRadioButton(content: String, customFontSize: Double) -> RadioButton {
    let radioButton = RadioButton()

    let textBlock = TextBlock()
    textBlock.text = content
    textBlock.fontSize = customFontSize

    radioButton.content = textBlock

    return radioButton
}

class RadioButtonPage: StackPanel {
    private let outputText = TextBlock()
    
    override init() {
        super.init()
        setupLayout()
    }

    private func setupLayout() {
        self.orientation = .vertical
        self.spacing = 15
        self.padding = Thickness(left: 20, top: 20, right: 20, bottom: 20)

        // 标题
        let title = TextBlock()
        title.text = "RadioButton"
        title.fontSize = 20

        // 输出文字
        outputText.text = "Output:"
        outputText.fontSize = 14
        outputText.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)

        // ✅ 第一组 RadioButton
        let group1Panel = StackPanel()
        group1Panel.orientation = .vertical
        group1Panel.spacing = 5

        let group1Title = TextBlock()
        group1Title.text = "Group 1:"
        group1Title.fontSize = 16

        let optionA = createRadioButton(content: "Option A", customFontSize: 14)
        let optionB = createRadioButton(content: "Option B", customFontSize: 14)
        let optionC = createRadioButton(content: "Option C", customFontSize: 14)

        // 设置分组名
        optionA.groupName = "Group1"
        optionB.groupName = "Group1"
        optionC.groupName = "Group1"

        // 添加事件
        [optionA, optionB, optionC].forEach { button in
            button.checked.addHandler { [weak self] _, _ in
                self?.outputText.text = "Output: \(button.content as! TextBlock).text selected in Group 1"
            }
        }

        group1Panel.children.append(group1Title)
        group1Panel.children.append(optionA)
        group1Panel.children.append(optionB)
        group1Panel.children.append(optionC)

        // ✅ 第二组 RadioButton
        let group2Panel = StackPanel()
        group2Panel.orientation = .vertical
        group2Panel.spacing = 5

        let group2Title = TextBlock()
        group2Title.text = "Group 2:"
        group2Title.fontSize = 16

        let red = createRadioButton(content: "Red", customFontSize: 14)
        let green = createRadioButton(content: "Green", customFontSize: 14)
        let blue = createRadioButton(content: "Blue", customFontSize: 14)

        red.groupName = "Group2"
        green.groupName = "Group2"
        blue.groupName = "Group2"

        [red, green, blue].forEach { button in
            button.checked.addHandler { [weak self] _, _ in
                self?.outputText.text = "Output: \((button.content as! TextBlock).text) selected in Group 2"
            }
        }

        group2Panel.children.append(group2Title)
        group2Panel.children.append(red)
        group2Panel.children.append(green)
        group2Panel.children.append(blue)

        // 添加到主布局
        self.children.append(title)
        self.children.append(group1Panel)
        self.children.append(group2Panel)
        self.children.append(outputText)
    }
}
