import WinUI
import WinAppSDK

func createFundamentalsPage() -> ScrollViewer {
    let scrollViewer = ScrollViewer()
    
    let panel = StackPanel()
    panel.padding = Thickness(left: 40, top: 40, right: 40, bottom: 40)
    panel.spacing = 24
    
    let title = TextBlock()
    title.text = "Fundamentals"
    title.fontSize = 40
    
    let description = TextBlock()
    description.text = "Learn the fundamental concepts of WinUI 3 development."
    description.fontSize = 16
    description.textWrapping = .wrap
    description.opacity = 0.6
    
    panel.children.append(title)
    panel.children.append(description)
    
    scrollViewer.content = panel
    return scrollViewer
}

func createDesignPage() -> ScrollViewer {
    let scrollViewer = ScrollViewer()
    
    let panel = StackPanel()
    panel.padding = Thickness(left: 40, top: 40, right: 40, bottom: 40)
    panel.spacing = 24
    
    let title = TextBlock()
    title.text = "Design"
    title.fontSize = 40
    
    let description = TextBlock()
    description.text = "Guidelines and toolkits for creating stunning WinUI experiences."
    description.fontSize = 16
    description.textWrapping = .wrap
    description.opacity = 0.6
    
    panel.children.append(title)
    panel.children.append(description)
    
    scrollViewer.content = panel
    return scrollViewer
}

func createAccessibilityPage() -> ScrollViewer {
    let scrollViewer = ScrollViewer()
    
    let panel = StackPanel()
    panel.padding = Thickness(left: 40, top: 40, right: 40, bottom: 40)
    panel.spacing = 24
    
    let title = TextBlock()
    title.text = "Accessibility"
    title.fontSize = 40
    
    let description = TextBlock()
    description.text = "Make your apps accessible to everyone."
    description.fontSize = 16
    description.textWrapping = .wrap
    description.opacity = 0.6
    
    panel.children.append(title)
    panel.children.append(description)
    
    scrollViewer.content = panel
    return scrollViewer
}

func createAllControlsPage() -> ScrollViewer {
    let scrollViewer = ScrollViewer()
    
    let panel = StackPanel()
    panel.padding = Thickness(left: 40, top: 40, right: 40, bottom: 40)
    panel.spacing = 24
    
    let title = TextBlock()
    title.text = "All Controls"
    title.fontSize = 40
    
    let description = TextBlock()
    description.text = "Browse all available WinUI controls and samples."
    description.fontSize = 16
    description.textWrapping = .wrap
    description.opacity = 0.6
    
    // 创建控件列表
    let controlsList = createControlsList()
    
    panel.children.append(title)
    panel.children.append(description)
    panel.children.append(controlsList)
    
    scrollViewer.content = panel
    return scrollViewer
}

func createControlsList() -> StackPanel {
    let panel = StackPanel()
    panel.spacing = 12
    panel.margin = Thickness(left: 0, top: 20, right: 0, bottom: 0)
    
    let controls = [
        ("Button", "A control that responds to user input and raises a Click event."),
        ("TextBlock", "A lightweight control for displaying text."),
        ("TextBox", "A control that allows users to input text."),
        ("CheckBox", "A control that allows users to select or clear an option."),
        ("ComboBox", "A drop-down list of items a user can select from."),
        ("ListView", "A control that displays data items in a vertical list."),
        ("GridView", "A control that displays data items in rows and columns.")
    ]
    
    for control in controls {
        let itemBorder = Border()
        itemBorder.padding = Thickness(left: 16, top: 12, right: 16, bottom: 12)
        itemBorder.margin = Thickness(left: 0, top: 0, right: 0, bottom: 8)
        
        let itemPanel = StackPanel()
        itemPanel.spacing = 4
        
        let nameText = TextBlock()
        nameText.text = control.0
        nameText.fontSize = 16
        
        let descText = TextBlock()
        descText.text = control.1
        descText.fontSize = 12
        descText.opacity = 0.6
        descText.textWrapping = .wrap
        
        itemPanel.children.append(nameText)
        itemPanel.children.append(descText)
        
        itemBorder.child = itemPanel
        panel.children.append(itemBorder)
    }
    
    return panel
}