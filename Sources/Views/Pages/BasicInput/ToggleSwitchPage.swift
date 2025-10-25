import WinUI
import WinAppSDK

// 创建 ToggleSwitch 控件
private func createToggleSwitch(header: String, offContent: String, onContent: String, isOn: Bool = false) -> ToggleSwitch {
    let toggleSwitch = ToggleSwitch()
    
    let headerText = TextBlock()
    headerText.text = header
    toggleSwitch.header = headerText
    toggleSwitch.offContent = offContent
    toggleSwitch.onContent = onContent
    toggleSwitch.isOn = isOn
    
    return toggleSwitch
}

// 创建 ProgressRing 控件
private func createProgressRing(isActive: Bool) -> ProgressRing {
    let progressRing = ProgressRing()
    progressRing.isActive = isActive
    progressRing.width = 32
    return progressRing
}

class ToggleSwitchPage: StackPanel {
    private let outputText = TextBlock()
    
    override init() {
        super.init()
        setupLayout()
        setupHandlers()
    }

    private func setupLayout() {
        self.orientation = .vertical
        self.spacing = 20
        self.padding = Thickness(left: 20, top: 20, right: 20, bottom: 20)
        
        // 标题
        let title = TextBlock()
        title.text = "ToggleSwitch Example"
        title.fontSize = 20
        self.children.append(title)
        
        // ToggleSwitch 和 ProgressRing 布局
        let toggleSwitchPanel = StackPanel()
        toggleSwitchPanel.orientation = .horizontal
        toggleSwitchPanel.spacing = 10
        
        let toggleSwitch = createToggleSwitch(header: "Toggle work", offContent: "Do work", onContent: "Working", isOn: true)
        let progressRing = createProgressRing(isActive: toggleSwitch.isOn)

        // 点击 ToggleSwitch 时更新 ProgressRing 的状态
        toggleSwitch.toggled.addHandler { [weak self] _, _ in
            progressRing.isActive = toggleSwitch.isOn
            self?.outputText.text = toggleSwitch.isOn ? "Output: Working" : "Output: Do work"
        }

        toggleSwitchPanel.children.append(toggleSwitch)
        toggleSwitchPanel.children.append(progressRing)
        
        // 添加到主布局
        self.children.append(toggleSwitchPanel)
        
        // 输出文字
        outputText.text = "Output:"
        outputText.fontSize = 14
        self.children.append(outputText)
    }

    private func setupHandlers() {
        // 当状态变化时，更新输出文字
        outputText.text = "Output: Toggle the switch to start/stop the work"
    }
}
