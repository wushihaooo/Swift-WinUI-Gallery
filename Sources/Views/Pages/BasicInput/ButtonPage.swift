import WinUI
import WinAppSDK

class CustomButton: Button {
    var buttonText: String
    
    init(buttonText: String) {
        self.buttonText = buttonText
        super.init()
        setupButton()
    }
    
    private func setupButton() {
        let textBlock = TextBlock()
        textBlock.text = buttonText
        textBlock.fontSize = 14
        self.content = textBlock
        
        self.padding = Thickness(left: 20, top: 8, right: 20, bottom: 8)
        self.horizontalAlignment = .left
        self.verticalAlignment = .center
        
        self.click.addHandler { _, _ in
            print("按钮被点击：\(self.buttonText)")
        }
    }
}

class ButtonPage: StackPanel {
    private let outputText = TextBlock()
    private let customButton = CustomButton(buttonText: "Click me")
    
    override init() {
        super.init()
        setupLayout()
    }
    
    private func setupLayout() {
        self.orientation = .vertical
        self.spacing = 15
        self.padding = Thickness(left: 20, top: 20, right: 20, bottom: 20)
        
        // 标题文字
        let title = TextBlock()
        title.text = "Button"
        title.fontSize = 20
        
        // ✅ 添加 “Disable 按钮” 的复选框
        let disableCheckBox = CheckBox()
        disableCheckBox.content = TextBlock()
        (disableCheckBox.content as! TextBlock).text = "Disable button"
        (disableCheckBox.content as! TextBlock).fontSize = 14
        
        disableCheckBox.checked.addHandler { [weak self] _, _ in
            self?.customButton.isEnabled = false
            self?.outputText.text = "Output: Button disabled"
        }
        disableCheckBox.unchecked.addHandler { [weak self] _, _ in
            self?.customButton.isEnabled = true
            self?.outputText.text = "Output: Button enabled"
        }
        
        // 按钮与输出文字在同一行
        let buttonRow = StackPanel()
        buttonRow.orientation = .horizontal
        buttonRow.spacing = 20
        
        // 输出文字
        outputText.text = "Output:"
        outputText.fontSize = 14
        outputText.verticalAlignment = .center
        
        // 点击事件
        customButton.click.addHandler { [weak self] _, _ in
            self?.outputText.text = "Output: Button clicked!"
        }
        
        // 组装水平布局
        buttonRow.children.append(customButton)
        buttonRow.children.append(outputText)
        
        // 添加到主布局
        self.children.append(title)
        self.children.append(disableCheckBox)
        self.children.append(buttonRow)
    }
}


