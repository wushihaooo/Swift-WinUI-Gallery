@preconcurrency import WinUI
import WinAppSDK
import Foundation
import UWP
import WindowsFoundation

@MainActor
class AppNotificationsPage: Page {
    private var soundEventComboBox: ComboBox?
    
    override init() {
        super.init()
        
        nonisolated(unsafe) let unsafeSelf = self
        
        Task { @MainActor in
            await unsafeSelf.initializeUI()
        }
    }
    
    @MainActor
    private func initializeUI() async {
        let mainStack = StackPanel()
        mainStack.margin = Thickness(left: 36, top: 0, right: 36, bottom: 0)
        mainStack.spacing = 16
        
        // 标题
        let titleText = TextBlock()
        titleText.text = "App notifications"
        titleText.fontSize = 28
        titleText.fontWeight = FontWeights.semiBold
        titleText.margin = Thickness(left: 0, top: 12, right: 0, bottom: 4)
        mainStack.children.append(titleText)
        
        // 描述
        let descText = TextBlock()
        descText.text = "Send rich, interactive notifications from your app. Notifications can include text, images, and actions."
        descText.textWrapping = .wrap
        descText.foreground = createSecondaryBrush()
        descText.margin = Thickness(left: 0, top: 0, right: 0, bottom: 16)
        mainStack.children.append(descText)
        
        // InfoBar 1
        mainStack.children.append(createInfoBar1())
        
        // InfoBar 2
        mainStack.children.append(createInfoBar2())
        
        // Warning Bar
        mainStack.children.append(createWarningBar())
        
        // 分隔线
        let separator1 = Border()
        separator1.height = 1
        separator1.background = SolidColorBrush(Color(a: 255, r: 230, g: 230, b: 230))
        separator1.margin = Thickness(left: 0, top: 16, right: 0, bottom: 16)
        mainStack.children.append(separator1)
        
        // 1. Basic notification
        mainStack.children.append(createNotificationSection(
            title: "Basic notification",
            buttonText: "Show notification",
            optionsContent: nil,
            action: { [weak self] in self?.showWelcomeNotification() }
        ))
        
        // 2. Informational notification with logo and custom audio
        let soundOptions = createSoundOptionsContent()
        mainStack.children.append(createNotificationSection(
            title: "Informational notification with logo and custom audio",
            buttonText: "Show informational notification with logo and custom audio",
            optionsContent: soundOptions,
            action: { [weak self] in self?.showPersonPictureNotification() }
        ))
        
        // 3. Visual notification with hero image
        mainStack.children.append(createNotificationSection(
            title: "Visual notification with hero image and attribution",
            buttonText: "Show visual notification with hero image and attribution",
            optionsContent: nil,
            action: { [weak self] in self?.showHarborSceneNotification() }
        ))
        
        // 4. Notification with controls
        mainStack.children.append(createNotificationSection(
            title: "Notification with AppNotification controls",
            buttonText: "Show notification with AppNotification controls",
            optionsContent: nil,
            action: { [weak self] in self?.showSurveyNotification() }
        ))
        
        // 5. Notification with progress
        mainStack.children.append(createNotificationSection(
            title: "Notification with ProgressBar",
            buttonText: "Show notification with progress bar",
            optionsContent: nil,
            action: { [weak self] in self?.showProgressNotification() }
        ))
        
        let scrollViewer = ScrollViewer()
        scrollViewer.content = mainStack
        
        self.content = scrollViewer
    }
    
    @MainActor
    private func createNotificationSection(title: String, buttonText: String, optionsContent: UIElement?, action: @escaping () -> Void) -> Border {
        let border = Border()
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = SolidColorBrush(Color(a: 255, r: 230, g: 230, b: 230))
        border.cornerRadius = CornerRadius(topLeft: 4, topRight: 4, bottomRight: 4, bottomLeft: 4)
        border.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        border.margin = Thickness(left: 0, top: 0, right: 0, bottom: 16)
        
        let contentStack = StackPanel()
        contentStack.spacing = 12
        
        // 标题
        let header = TextBlock()
        header.text = title
        header.fontSize = 16
        header.fontWeight = FontWeights.semiBold
        contentStack.children.append(header)
        
        // 选项区域（如果有）
        if let options = optionsContent {
            contentStack.children.append(options)
        }
        
        // 按钮
        let button = Button()
        button.content = buttonText
        button.click.addHandler { _, _ in
            action()
        }
        contentStack.children.append(button)
        
        border.child = contentStack
        return border
    }
    
    @MainActor
    private func createSoundOptionsContent() -> StackPanel {
        let stack = StackPanel()
        stack.spacing = 8
        
        let label = TextBlock()
        label.text = "AppNotificationSoundEvent"
        label.fontSize = 14
        label.margin = Thickness(left: 0, top: 0, right: 0, bottom: 4)
        stack.children.append(label)
        
        soundEventComboBox = ComboBox()
        soundEventComboBox?.minWidth = 250
        soundEventComboBox?.horizontalAlignment = .left
        
        let soundEvents = ["Default", "IM", "Mail", "Reminder", "SMS", "Alarm", "Call"]
        
        for event in soundEvents {
            let item = ComboBoxItem()
            item.content = event
            soundEventComboBox?.items.append(item)
        }
        soundEventComboBox?.selectedIndex = 0
        
        if let comboBox = soundEventComboBox {
            stack.children.append(comboBox)
        }
        
        return stack
    }
    
    @MainActor
    private func createInfoBar1() -> InfoBar {
        let infoBar = InfoBar()
        infoBar.isOpen = true
        infoBar.severity = .informational
        infoBar.isClosable = false
        infoBar.message = "Toast notifications are displayed using Windows Shell Experience. They will appear in the notification center and as popup toasts."
        return infoBar
    }
    
    @MainActor
    private func createInfoBar2() -> InfoBar {
        let infoBar = InfoBar()
        infoBar.isOpen = true
        infoBar.severity = .informational
        infoBar.isClosable = false
        infoBar.message = "If Do Not Disturb mode is enabled in system settings, these notifications will not appear as toast popups, but they will still be added to the notification center and can be viewed there."
        return infoBar
    }
    
    @MainActor
    private func createWarningBar() -> InfoBar {
        let warningBar = InfoBar()
        warningBar.isOpen = true
        warningBar.severity = .warning
        warningBar.isClosable = false
        warningBar.title = "App notifications should not be noisy"
        warningBar.message = "App notifications are designed to convey timely and relevant information without disrupting the user experience. Excessive use of sound, prolonged durations, or overly attention-seeking visuals can lead to user fatigue and diminish the overall effectiveness of notifications."
        return warningBar
    }
    
    private func createSecondaryBrush() -> Brush {
        let brush = SolidColorBrush()
        var color = UWP.Color()
        color.a = 255
        color.r = 128
        color.g = 128
        color.b = 128
        brush.color = color
        return brush
    }
    
    // 1. Welcome notification
    private func showWelcomeNotification() {
        print("🔔 Button 1: Showing welcome notification...")
        WindowsToastHelper.showToast(
            xmlString: """
            <toast>
                <visual>
                    <binding template="ToastGeneric">
                        <text>Welcome to WinUI 3 Gallery</text>
                        <text>Explore interactive samples and discover the power of modern Windows UI.</text>
                    </binding>
                </visual>
            </toast>
            """
        )
    }
    
    // 2. PersonPicture notification with logo
    private func showPersonPictureNotification() {
        let selectedSound = getSelectedSoundEvent()
        print("🔔 Button 2: Showing PersonPicture notification with sound: \(selectedSound)")
        
        // 只有非 Default 时才添加音频标签
        let audioTag = selectedSound != "Default" 
            ? "<audio src=\"ms-winsoundevent:Notification.\(selectedSound)\"/>" 
            : ""
        
        print("📢 Audio tag: \(audioTag)")
        
        WindowsToastHelper.showToast(
            xmlString: """
            <toast>
                <visual>
                    <binding template="ToastGeneric">
                        <image placement="appLogoOverride" hint-crop="circle" src="https://picsum.photos/100/100"/>
                        <text>Control Highlight: PersonPicture</text>
                        <text>Use the PersonPicture control to display user avatars with initials or images.</text>
                    </binding>
                </visual>
                \(audioTag)
            </toast>
            """
        )
    }
    
    // 3. Harbor Scene with hero image
    private func showHarborSceneNotification() {
        print("🔔 Button 3: Showing Harbor Scene notification...")
        
        // 尝试获取本地图片路径
        let imagePath = getImagePath()
        print("🖼️ Image path: \(imagePath)")
        
        WindowsToastHelper.showToast(
            xmlString: """
            <toast>
                <visual>
                    <binding template="ToastGeneric">
                        <image placement="hero" src="\(imagePath)"/>
                        <text>Harbor Scene with Boats</text>
                        <text>A quiet harbor with boats gently anchored in view.</text>
                        <text placement="attribution">WinUI gallery assets</text>
                    </binding>
                </visual>
            </toast>
            """
        )
    }
    
    // 4. Survey notification
    private func showSurveyNotification() {
        print("🔔 Button 4: Showing Survey notification...")
        WindowsToastHelper.showToast(
            xmlString: """
            <toast>
                <visual>
                    <binding template="ToastGeneric">
                        <text>Survey</text>
                        <text>Please select your satisfaction level and leave a comment.</text>
                    </binding>
                </visual>
                <actions>
                    <input id="comment" type="text" placeHolderContent="Leave a comment here..."/>
                    <input id="satisfaction" type="selection" defaultInput="neutral">
                        <selection id="very-satisfied" content="Very Satisfied"/>
                        <selection id="satisfied" content="Satisfied"/>
                        <selection id="neutral" content="Neutral"/>
                        <selection id="dissatisfied" content="Dissatisfied"/>
                        <selection id="very-dissatisfied" content="Very Dissatisfied"/>
                    </input>
                    <action content="Submit" arguments="action=submit"/>
                </actions>
            </toast>
            """
        )
    }
    
    // 5. Progress notification
    private func showProgressNotification() {
        print("🔔 Button 5: Showing Progress notification...")
        WindowsToastHelper.showToast(
            xmlString: """
            <toast>
                <visual>
                    <binding template="ToastGeneric">
                        <text>Progress Bar Example</text>
                        <text>This is a sample notification showing how to use a progress bar.</text>
                        <progress title="Demo Progress" value="0.6" valueStringOverride="60%" status="In progress..."/>
                    </binding>
                </visual>
            </toast>
            """
        )
    }
    
    private func getImagePath() -> String {
        // 尝试从 Assets 获取图片路径
        if let imagePath = Bundle.module.path(forResource: "picture", ofType: "png", inDirectory: "Assets/SampleMedia/Scrolling") {
            return "file://\(imagePath)"
        }
        // 后备：使用网络图片
        return "https://picsum.photos/600/400"
    }
    
    private func getSelectedSoundEvent() -> String {
        // 音效名称映射：显示名称 -> Windows 音效标识符
        let soundMap = [
            "Default": "Default",
            "IM": "IM",
            "Mail": "Mail",
            "Reminder": "Reminder", 
            "SMS": "SMS",
            "Alarm": "Looping.Alarm",
            "Call": "Looping.Call"
        ]
        
        let soundEvents = ["Default", "IM", "Mail", "Reminder", "SMS", "Alarm", "Call"]
        
        guard let comboBox = soundEventComboBox else {
            print("⚠️ ComboBox is nil, using Default")
            return "Default"
        }
        
        let index = Int(comboBox.selectedIndex)
        print("📊 Selected index: \(index)")
        
        if index >= 0 && index < soundEvents.count {
            let displayName = soundEvents[index]
            let soundId = soundMap[displayName] ?? "Default"
            print("✅ Selected sound: \(displayName) -> \(soundId)")
            return soundId
        }
        
        print("⚠️ Index out of range, using Default")
        return "Default"
    }
}

fileprivate struct WindowsToastHelper {
    static func showToast(xmlString: String) {
        Task.detached {
            print("🚀 Starting PowerShell process...")
            
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe")
            
            // 使用 @" "@ here-string 来避免转义问题
            let script = """
            [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
            [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
            
            $xmlStr = @"
            \(xmlString)
            "@
            
            $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
            $xml.LoadXml($xmlStr)
            $toast = New-Object Windows.UI.Notifications.ToastNotification $xml
            [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('Microsoft.Windows.ShellExperienceHost_cw5n1h2txyewy!App').Show($toast)
            Write-Host 'SUCCESS'
            """
            
            process.arguments = ["-NoProfile", "-Command", script]
            
            let errorPipe = Pipe()
            let outputPipe = Pipe()
            process.standardError = errorPipe
            process.standardOutput = outputPipe
            
            do {
                try process.run()
                process.waitUntilExit()
                
                let exitCode = process.terminationStatus
                
                let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
                if !outputData.isEmpty, let outputString = String(data: outputData, encoding: .utf8) {
                    print("📤 PowerShell output: \(outputString)")
                }
                
                let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
                if !errorData.isEmpty, let errorString = String(data: errorData, encoding: .utf8) {
                    print("❌ PowerShell error: \(errorString)")
                }
                
                if exitCode == 0 {
                    print("✅ Toast notification sent successfully")
                } else {
                    print("⚠️ PowerShell exited with code: \(exitCode)")
                }
            } catch {
                print("❌ Failed to show toast: \(error)")
            }
        }
    }
}