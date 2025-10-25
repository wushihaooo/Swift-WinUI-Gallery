import WinUI
import WinAppSDK

private func createCheckBox(content: String, fontSize: Double = 14, isThreeState: Bool = false) -> CheckBox {
    let checkBox = CheckBox()
    let textBlock = TextBlock()
    textBlock.text = content
    textBlock.fontSize = fontSize
    checkBox.content = textBlock
    checkBox.isThreeState = isThreeState
    return checkBox
}

class CheckBoxPage: StackPanel {
    private let outputText = TextBlock()

    // 分组选项
    private let selectAll = createCheckBox(content: "Select all", isThreeState: true)
    private let option1 = createCheckBox(content: "Option 1")
    private let option2 = createCheckBox(content: "Option 2")
    private let option3 = createCheckBox(content: "Option 3")

    override init() {
        super.init()
        setupLayout()
        setupHandlers()
    }

    private func setupLayout() {
        self.orientation = .vertical
        self.spacing = 10
        self.padding = Thickness(left: 20, top: 20, right: 20, bottom: 20)

        // ✅ 标题
        let title = TextBlock()
        title.text = "CheckBox Examples"
        title.fontSize = 20
        self.children.append(title)

        // ✅ 双状态 CheckBox
        let twoStateTitle = TextBlock()
        twoStateTitle.text = "Two-state CheckBox"
        twoStateTitle.fontSize = 16
        twoStateTitle.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)
        self.children.append(twoStateTitle)

        let twoStateCheckBox = createCheckBox(content: "Enable notifications", fontSize: 14, isThreeState: false)
        twoStateCheckBox.checked.addHandler { [weak self] _, _ in
            self?.outputText.text = "Output: Two-state checkbox checked"
        }
        twoStateCheckBox.unchecked.addHandler { [weak self] _, _ in
            self?.outputText.text = "Output: Two-state checkbox unchecked"
        }
        self.children.append(twoStateCheckBox)

        // ✅ 三状态 CheckBox
        let threeStateTitle = TextBlock()
        threeStateTitle.text = "Three-state CheckBox"
        threeStateTitle.fontSize = 16
        threeStateTitle.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)
        self.children.append(threeStateTitle)

        let threeStateCheckBox = createCheckBox(content: "Auto-sync files", fontSize: 14, isThreeState: true)
        threeStateCheckBox.checked.addHandler { [weak self] _, _ in
            self?.outputText.text = "Output: Three-state checkbox checked"
        }
        threeStateCheckBox.unchecked.addHandler { [weak self] _, _ in
            self?.outputText.text = "Output: Three-state checkbox unchecked"
        }
        threeStateCheckBox.indeterminate.addHandler { [weak self] _, _ in
            self?.outputText.text = "Output: Three-state checkbox indeterminate"
        }
        self.children.append(threeStateCheckBox)

        // ✅ CheckBox Group
        let groupTitle = TextBlock()
        groupTitle.text = "CheckBox Group (Select All)"
        groupTitle.fontSize = 16
        groupTitle.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)
        self.children.append(groupTitle)

        // 子选项缩进
        option1.margin = Thickness(left: 24, top: 0, right: 0, bottom: 0)
        option2.margin = Thickness(left: 24, top: 0, right: 0, bottom: 0)
        option3.margin = Thickness(left: 24, top: 0, right: 0, bottom: 0)

        self.children.append(selectAll)
        self.children.append(option1)
        self.children.append(option2)
        self.children.append(option3)

        // ✅ 输出文字
        outputText.text = "Output:"
        outputText.fontSize = 14
        outputText.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)
        self.children.append(outputText)
    }

    private func setupHandlers() {
        // 主 CheckBox 行为
        selectAll.checked.addHandler { [weak self] _, _ in
            self?.setAllOptionsChecked(true)
            self?.outputText.text = "Output: All options checked"
        }

        selectAll.unchecked.addHandler { [weak self] _, _ in
            self?.setAllOptionsChecked(false)
            self?.outputText.text = "Output: All options unchecked"
        }

        selectAll.indeterminate.addHandler { [weak self] _, _ in
            self?.outputText.text = "Output: Select all indeterminate"
        }

        // 子选项状态变化 -> 更新全选状态
        let updateHandler: RoutedEventHandler = { [weak self] _, _ in
            self?.updateSelectAllState()
        }

        option1.checked.addHandler(updateHandler)
        option1.unchecked.addHandler(updateHandler)
        option2.checked.addHandler(updateHandler)
        option2.unchecked.addHandler(updateHandler)
        option3.checked.addHandler(updateHandler)
        option3.unchecked.addHandler(updateHandler)
    }

    private func setAllOptionsChecked(_ value: Bool) {
        option1.isChecked = value
        option2.isChecked = value
        option3.isChecked = value
    }

    private func updateSelectAllState() {
        let states = [option1.isChecked, option2.isChecked, option3.isChecked]
        let allChecked = states.allSatisfy { $0 == true }
        let allUnchecked = states.allSatisfy { $0 == false }

        if allChecked {
            selectAll.isChecked = true
        } else if allUnchecked {
            selectAll.isChecked = false
        } else {
            selectAll.isChecked = nil // 不确定状态
        }
    }
}
