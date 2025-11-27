@preconcurrency import WinUI
import WinAppSDK
import Foundation
import UWP
import WindowsFoundation

class AppNotificationsPage: Grid {
    private var mainScrollViewer: ScrollViewer!
    private var contentStackPanel: StackPanel!
    private var soundEventComboBox: ComboBox!
    
    override init() {
        super.init()
        setupView()
    }
    
    private func setupView() {
        let rowDef = RowDefinition()
        rowDef.height = GridLength(value: 1, gridUnitType: .star)
        self.rowDefinitions.append(rowDef)
        
        mainScrollViewer = ScrollViewer()
        mainScrollViewer.verticalScrollBarVisibility = .auto
        mainScrollViewer.horizontalScrollBarVisibility = .disabled
        
        contentStackPanel = StackPanel()
        contentStackPanel.padding = Thickness(left: 40, top: 40, right: 40, bottom: 40)
        contentStackPanel.spacing = 24
        
        contentStackPanel.children.append(createHeader())
        contentStackPanel.children.append(createDescription())
        contentStackPanel.children.append(createInfoBar1())
        contentStackPanel.children.append(createInfoBar2())
        contentStackPanel.children.append(createWarningBar())
        contentStackPanel.children.append(createBasicNotificationSection())
        contentStackPanel.children.append(createInformationalSection())
        contentStackPanel.children.append(createVisualSection())
        contentStackPanel.children.append(createControlsSection())
        contentStackPanel.children.append(createProgressSection())
        
        mainScrollViewer.content = contentStackPanel
        self.children.append(mainScrollViewer)
    }
    
    private func createHeader() -> TextBlock {
        let titleText = TextBlock()
        titleText.text = "App notifications"
        titleText.fontSize = 28
        titleText.fontWeight = FontWeights.semiBold
        return titleText
    }
    
    private func createDescription() -> TextBlock {
        let descText = TextBlock()
        descText.text = "Send rich, interactive notifications from your app. Notifications can include text, images, and actions."
        descText.textWrapping = .wrap
        descText.foreground = createSecondaryBrush()
        return descText
    }
    
    private func createInfoBar1() -> InfoBar {
        let infoBar = InfoBar()
        infoBar.isOpen = true
        infoBar.severity = .informational
        infoBar.isClosable = false
        infoBar.message = "The AppNotificationManager class has a dependency on the Singleton package. Because of that dependency, there are certain considerations to be aware of if you're calling these APIs from a self-contained app. For more info, and specifics, see Dependencies on additional MSIX packages."
        return infoBar
    }
    
    private func createInfoBar2() -> InfoBar {
        let infoBar = InfoBar()
        infoBar.isOpen = true
        infoBar.severity = .informational
        infoBar.isClosable = false
        infoBar.message = "If Do Not Disturb mode is enabled in system settings, these notifications will not appear as toast popups, but they will still be added to the notification center and can be viewed there."
        return infoBar
    }
    
    private func createWarningBar() -> InfoBar {
        let warningBar = InfoBar()
        warningBar.isOpen = true
        warningBar.severity = .warning
        warningBar.isClosable = false
        warningBar.title = "App notifications should not be noisy"
        warningBar.message = "App notifications are designed to convey timely and relevant information without disrupting the user experience. Excessive use of sound, prolonged durations, or overly attention-seeking visuals can lead to user fatigue and diminish the overall effectiveness of notifications."
        return warningBar
    }
    
    private func createBasicNotificationSection() -> StackPanel {
        let section = StackPanel()
        section.spacing = 12
        
        let titleText = TextBlock()
        titleText.text = "Basic notification"
        titleText.fontSize = 18
        titleText.fontWeight = FontWeights.semiBold
        section.children.append(titleText)
        
        let button = Button()
        button.content = "Show notification"
        button.click.addHandler { [weak self] _, _ in
            self?.showBasicNotification()
        }
        section.children.append(button)
        
        return section
    }
    
    private func createInformationalSection() -> StackPanel {
        let section = StackPanel()
        section.spacing = 12
        
        let titleText = TextBlock()
        titleText.text = "Informational notification with logo and custom audio"
        titleText.fontSize = 18
        titleText.fontWeight = FontWeights.semiBold
        section.children.append(titleText)
        
        let grid = Grid()
        let col1 = ColumnDefinition()
        col1.width = GridLength(value: 1, gridUnitType: .star)
        let col2 = ColumnDefinition()
        col2.width = GridLength(value: 0, gridUnitType: .auto)
        grid.columnDefinitions.append(col1)
        grid.columnDefinitions.append(col2)
        
        let button = Button()
        button.content = "Show informational notification with logo and custom audio"
        button.click.addHandler { [weak self] _, _ in
            self?.showInformationalNotification()
        }
        Grid.setColumn(button, 0)
        grid.children.append(button)
        
        let controlPanel = StackPanel()
        controlPanel.orientation = .horizontal
        controlPanel.spacing = 8
        controlPanel.verticalAlignment = .center
        
        let label = TextBlock()
        label.text = "AppNotificationSoundEvent"
        label.verticalAlignment = .center
        controlPanel.children.append(label)
        
        soundEventComboBox = ComboBox()
        soundEventComboBox.minWidth = 120
        setupSoundEventComboBox()
        controlPanel.children.append(soundEventComboBox)
        
        Grid.setColumn(controlPanel, 1)
        grid.children.append(controlPanel)
        
        section.children.append(grid)
        
        return section
    }
    
    private func createVisualSection() -> StackPanel {
        let section = StackPanel()
        section.spacing = 12
        
        let titleText = TextBlock()
        titleText.text = "Visual notification with hero image and attribution"
        titleText.fontSize = 18
        titleText.fontWeight = FontWeights.semiBold
        section.children.append(titleText)
        
        let button = Button()
        button.content = "Show visual notification with hero image and attribution"
        button.click.addHandler { [weak self] _, _ in
            self?.showVisualNotification()
        }
        section.children.append(button)
        
        return section
    }
    
    private func createControlsSection() -> StackPanel {
        let section = StackPanel()
        section.spacing = 12
        
        let titleText = TextBlock()
        titleText.text = "Notification with AppNotification controls"
        titleText.fontSize = 18
        titleText.fontWeight = FontWeights.semiBold
        section.children.append(titleText)
        
        let button = Button()
        button.content = "Show notification with AppNotification controls"
        button.click.addHandler { [weak self] _, _ in
            self?.showNotificationWithControls()
        }
        section.children.append(button)
        
        return section
    }
    
    private func createProgressSection() -> StackPanel {
        let section = StackPanel()
        section.spacing = 12
        
        let titleText = TextBlock()
        titleText.text = "Notification with ProgressBar"
        titleText.fontSize = 18
        titleText.fontWeight = FontWeights.semiBold
        section.children.append(titleText)
        
        let button = Button()
        button.content = "Show notification with progress bar"
        button.click.addHandler { [weak self] _, _ in
            self?.showNotificationWithProgress()
        }
        section.children.append(button)
        
        return section
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
    
    private func setupSoundEventComboBox() {
        let soundEvents = [
            "Default",
            "IM",
            "Mail",
            "Reminder",
            "SMS",
            "Alarm",
            "Alarm2",
            "Alarm3",
            "Alarm4",
            "Alarm5",
            "Alarm6",
            "Alarm7",
            "Alarm8",
            "Alarm9",
            "Alarm10"
        ]
        
        for event in soundEvents {
            let item = ComboBoxItem()
            item.content = event
            soundEventComboBox.items.append(item)
        }
        
        soundEventComboBox.selectedIndex = 0
    }
    
    private func showBasicNotification() {
        Task { @MainActor in
            do {
                let notificationManager = AppNotificationManager.default
                
                let builder = AppNotificationBuilder()
                builder.addText("Basic notification")
                builder.addText("This is a simple notification with text content.")
                
                let notification = builder.buildNotification()
                try notificationManager.show(notification)
                
                print("Basic notification sent")
            } catch {
                print("Error showing notification: \(error)")
            }
        }
    }
    
    private func showInformationalNotification() {
        Task { @MainActor in
            do {
                let notificationManager = AppNotificationManager.default
                
                let selectedSound = getSelectedSoundEvent()
                
                let builder = AppNotificationBuilder()
                builder.addText("Informational notification")
                builder.addText("This notification includes a logo and custom audio.")
                builder.setAppLogoOverride(Uri("ms-appx:///Assets/StoreLogo.png"))
                
                if selectedSound != "Default" {
                    builder.setAudioUri(Uri("ms-winsoundevent:Notification.\(selectedSound)"))
                }
                
                let notification = builder.buildNotification()
                try notificationManager.show(notification)
                
                print("Informational notification sent with sound: \(selectedSound)")
            } catch {
                print("Error showing notification: \(error)")
            }
        }
    }
    
    private func showVisualNotification() {
        Task { @MainActor in
            do {
                let notificationManager = AppNotificationManager.default
                
                let builder = AppNotificationBuilder()
                builder.addText("Visual notification")
                builder.addText("This notification features a hero image and attribution text.")
                builder.setHeroImage(Uri("ms-appx:///Assets/HeroImage.png"))
                builder.setAttributionText("Attribution text")
                
                let notification = builder.buildNotification()
                try notificationManager.show(notification)
                
                print("Visual notification sent")
            } catch {
                print("Error showing notification: \(error)")
            }
        }
    }
    
    private func showNotificationWithControls() {
        Task { @MainActor in
            do {
                let notificationManager = AppNotificationManager.default
                
                let builder = AppNotificationBuilder()
                builder.addText("Notification with controls")
                builder.addText("This notification includes interactive buttons.")
                
                builder.addButton(AppNotificationButton("Accept")
                    .addArgument("action", "accept"))
                builder.addButton(AppNotificationButton("Decline")
                    .addArgument("action", "decline"))
                
                let notification = builder.buildNotification()
                try notificationManager.show(notification)
                
                print("Notification with controls sent")
            } catch {
                print("Error showing notification: \(error)")
            }
        }
    }
    
    private func showNotificationWithProgress() {
        Task { @MainActor in
            do {
                let notificationManager = AppNotificationManager.default
                
                let builder = AppNotificationBuilder()
                builder.addText("Downloading file...")
                builder.setProgressBar(AppNotificationProgressBar()
                    .bindTitle()
                    .bindValue()
                    .bindValueStringOverride()
                    .bindStatus())
                
                let notification = builder.buildNotification()
                notification.tag = "download-progress"
                
                try notificationManager.show(notification)
                
                Task {
                    for progress in stride(from: 0.0, through: 1.0, by: 0.2) {
                        try? await Task.sleep(nanoseconds: 1_000_000_000)
                        
                        let data = AppNotificationProgressData(1)
                        data.title = "Downloading..."
                        data.value = progress
                        data.valueStringOverride = "\(Int(progress * 100))%"
                        data.status = progress < 1.0 ? "In progress..." : "Complete!"
                        
                        try? notificationManager.updateAsync(data, "download-progress")
                    }
                }
                
                print("Notification with progress sent")
            } catch {
                print("Error showing notification: \(error)")
            }
        }
    }
    
    private func getSelectedSoundEvent() -> String {
        guard let selectedItem = soundEventComboBox.selectedItem as? ComboBoxItem,
              let content = selectedItem.content as? String else {
            return "Default"
        }
        return content
    }
}