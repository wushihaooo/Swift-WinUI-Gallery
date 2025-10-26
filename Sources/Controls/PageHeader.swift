import Foundation
import WinUI
import WinAppSDK
@_spi(WinRTImplements) import WindowsFoundation

// MARK: - Models
public struct ControlInfoDocLink {
    public let title: String
    public let uri: String
    
    public init(title: String, uri: String) {
        self.title = title
        self.uri = uri
    }
}

public struct ControlInfo {
    public let title: String
    public let apiNamespace: String
    public let baseClasses: [String]
    public let docs: [ControlInfoDocLink]
    
    public init(title: String, apiNamespace: String = "", baseClasses: [String] = [], docs: [ControlInfoDocLink] = []) {
        self.title = title
        self.apiNamespace = apiNamespace
        self.baseClasses = baseClasses
        self.docs = docs
    }
}

// MARK: - PageHeader UserControl
public class PageHeader: UserControl {
    // UI Elements
    private var headerGrid: Grid!
    private var titleText: TextBlock!
    private var apiDetailsBtn: Button!
    private var apiDetailsFlyout: Flyout!
    private var docsButton: Button!
    private var sourceButton: Button!
    private var themeButton: Button!
    private var copyLinkButton: Button!
    private var feedbackButton: Button!
    private var favoriteButton: ToggleButton!
    private var copyLinkTeachingTip: TeachingTip!
    
    // Data
    private var item: ControlInfo
    private var _themeButtonVisibility: Visibility = .visible
    
    public var themeButtonVisibility: Visibility {
        get { _themeButtonVisibility }
        set {
            _themeButtonVisibility = newValue
            themeButton?.visibility = newValue
        }
    }
    
    // MARK: - Initialization
    public init(item: ControlInfo) {
        self.item = item
        super.init()
        _ = self.loaded.addHandler { [weak self] _, _ in
            self?.onLoaded()
        }
        buildUI()
    }
    
    // MARK: - UI Construction
    private func buildUI() {
        // Create main Grid
        headerGrid = Grid()
        
        // Define row definitions
        let row1 = RowDefinition()
        row1.height = GridLength(value: 0, gridUnitType: .auto)
        let row2 = RowDefinition()
        row2.height = GridLength(value: 0, gridUnitType: .auto)
        
        headerGrid.rowDefinitions.append(row1)
        headerGrid.rowDefinitions.append(row2)
        
        // Row 0: Title and API Details Button
        let titlePanel = createTitlePanel()
        try? Grid.setRow(titlePanel, 0)
        headerGrid.children.append(titlePanel)
        
        // Row 1: Action Buttons
        let actionGrid = createActionGrid()
        try! Grid.setRow(actionGrid, 1)
        actionGrid.margin = Thickness(left: 0, top: 12, right: 0, bottom: 12)
        headerGrid.children.append(actionGrid)

        // Set as content
        self.content = headerGrid
    }
    
    // MARK: - Title Panel
    private func createTitlePanel() -> StackPanel {
        let panel = StackPanel()
        panel.orientation = .horizontal
        panel.spacing = 4
        
        // Title TextBlock
        titleText = TextBlock()
        titleText.text = item.title
        titleText.textTrimming = .characterEllipsis
        titleText.textWrapping = .noWrap
        if let app = Application.current,
        let resources = app.resources,
        let titleStyle = resources.lookup("TitleTextBlockStyle") as? Style {
            titleText.style = titleStyle
        } else {
            // 如果无法获取样式资源，手动设置样式属性
            titleText.fontSize = 28
            // titleText.fontWeight = FontWeights.semiBold
        }
        // AutomationProperties.setAutomationId(titleText, "PageHeader")
        // AutomationProperties.setHeadingLevel(titleText, .level1)
        panel.children.append(titleText)
        
        // API Details Button
        apiDetailsBtn = Button()
        apiDetailsBtn.margin = Thickness(left: 0, top: 0, right: 0, bottom: 3)
        apiDetailsBtn.padding = Thickness(left: 4, top: 4, right: 4, bottom: 4)
        apiDetailsBtn.verticalAlignment = .bottom
        // AutomationProperties.setName(apiDetailsBtn, "API details")
        // ToolTipService.setToolTip(apiDetailsBtn, "API namespace and inheritance")
        
        let apiIcon = FontIcon()
        apiIcon.glyph = "\u{E946}"
        apiIcon.fontSize = 14
        apiDetailsBtn.content = apiIcon
        
        // Create API Details Flyout
        apiDetailsFlyout = createAPIDetailsFlyout()
        apiDetailsBtn.flyout = apiDetailsFlyout
        
        panel.children.append(apiDetailsBtn)
        
        return panel
    }
    
    // MARK: - API Details Flyout
    private func createAPIDetailsFlyout() -> Flyout {
        let flyout = Flyout()
        flyout.placement = .bottom
        
        let apiPanel = StackPanel()
        apiPanel.spacing = 16
        
        // Namespace section
        if !item.apiNamespace.isEmpty {
            let namespacePanel = StackPanel()
            namespacePanel.spacing = 8
            
            let namespaceLabel = TextBlock()
            namespaceLabel.text = "Namespace"
            namespacePanel.children.append(namespaceLabel)
            
            let namespaceValue = TextBlock()
            namespaceValue.text = item.apiNamespace
            namespaceValue.fontFamily = FontFamily("Consolas")
            namespaceValue.isTextSelectionEnabled = true
            namespacePanel.children.append(namespaceValue)
            
            apiPanel.children.append(namespacePanel)
            
            if !item.baseClasses.isEmpty {
                let separator = MenuFlyoutSeparator()
                separator.margin = Thickness(left: -12, top: 0, right: -12, bottom: 0)
                apiPanel.children.append(separator)
            }
        }
        
        // Inheritance section
        if !item.baseClasses.isEmpty {
            let inheritanceLabel = TextBlock()
            inheritanceLabel.text = "Inheritance"
            apiPanel.children.append(inheritanceLabel)
            
            // Create items for breadcrumb
            let itemsPanel = StackPanel()
            itemsPanel.orientation = .horizontal
            itemsPanel.spacing = 4
            
            for (index, className) in item.baseClasses.enumerated() {
                if index > 0 {
                    let chevron = TextBlock()
                    chevron.text = ">"
                    chevron.margin = Thickness(left: 4, top: 0, right: 4, bottom: 0)
                    itemsPanel.children.append(chevron)
                }
                
                let textBlock = TextBlock()
                textBlock.text = className
                textBlock.fontFamily = FontFamily("Consolas")
                itemsPanel.children.append(textBlock)
            }
            
            apiPanel.children.append(itemsPanel)
        }
        
        flyout.content = apiPanel
        return flyout
    }
    
    // MARK: - Action Grid
    private func createActionGrid() -> Grid {
        let grid = Grid()
        
        // Left side - Documentation and Source buttons
        let leftPanel = StackPanel()
        leftPanel.orientation = .horizontal
        leftPanel.spacing = 4
        
        // Documentation Button
        if !item.docs.isEmpty {
            docsButton = createDocumentationButton()
            leftPanel.children.append(docsButton)
        }
        
        // Source Button
        sourceButton = createSourceButton()
        leftPanel.children.append(sourceButton)
        
        grid.children.append(leftPanel)
        
        // Right side - Action buttons
        let rightPanel = StackPanel()
        rightPanel.horizontalAlignment = .right
        rightPanel.orientation = .horizontal
        
        // Theme Button
        themeButton = Button()
        themeButton.height = 32
        themeButton.margin = Thickness(left: 0, top: 0, right: 4, bottom: 0)
        themeButton.visibility = _themeButtonVisibility
        // AutomationProperties.setName(themeButton, "Toggle theme")
        // ToolTipService.setToolTip(themeButton, "Toggle theme")
        
        let themeIcon = FontIcon()
        themeIcon.glyph = "\u{E793}"
        themeIcon.fontSize = 16
        themeButton.content = themeIcon
        
        themeButton.click.addHandler { [weak self] _, _ in
            self?.onThemeButtonClick()
        }
        rightPanel.children.append(themeButton)
        
        if _themeButtonVisibility == .visible {
            let separator1 = Border()
            separator1.width = 1
            separator1.height = 20
            rightPanel.children.append(separator1)
        }
        
        // Copy Link Button
        copyLinkButton = Button()
        copyLinkButton.height = 32
        copyLinkButton.margin = Thickness(left: 4, top: 0, right: 4, bottom: 0)
        copyLinkButton.padding = Thickness(left: 11, top: 2, right: 11, bottom: 0)
        // AutomationProperties.setName(copyLinkButton, "Copy link")
        // ToolTipService.setToolTip(copyLinkButton, "Copy link")
        
        let copyIcon = FontIcon()
        copyIcon.glyph = "\u{E71B}"
        copyIcon.fontSize = 16
        copyLinkButton.content = copyIcon
        
        copyLinkButton.click.addHandler { [weak self] _, _ in
            self?.onCopyLinkButtonClick()
        }
        
        // Create Teaching Tip
        copyLinkTeachingTip = createCopyLinkTeachingTip()
        
        rightPanel.children.append(copyLinkButton)
        
        // Feedback Button
        feedbackButton = Button()
        feedbackButton.height = 32
        feedbackButton.margin = Thickness(left: 0, top: 0, right: 4, bottom: 0)
        // AutomationProperties.setName(feedbackButton, "Send feedback")
        // ToolTipService.setToolTip(feedbackButton, "Send feedback")
        
        let feedbackIcon = FontIcon()
        feedbackIcon.glyph = "\u{ED15}"
        feedbackIcon.fontSize = 16
        feedbackButton.content = feedbackIcon
        
        feedbackButton.click.addHandler { [weak self] _, _ in
            self?.onFeedbackButtonClick()
        }
        rightPanel.children.append(feedbackButton)
        
        let separator2 = Border()
        separator2.width = 1
        separator2.height = 20
        rightPanel.children.append(separator2)
        
        // Favorite Button
        favoriteButton = ToggleButton()
        favoriteButton.height = 32
        favoriteButton.margin = Thickness(left: 4, top: 0, right: 0, bottom: 0)
        // AutomationProperties.setName(favoriteButton, "Favorite sample")
        
        let favoriteIcon = FontIcon()
        favoriteIcon.fontSize = 16
        favoriteButton.content = favoriteIcon
        
        // Update icon based on checked state
        favoriteButton.checked.addHandler { [weak self] _, _ in
            self?.updateFavoriteIcon()
        }
        favoriteButton.unchecked.addHandler { [weak self] _, _ in
            self?.updateFavoriteIcon()
        }
        
        updateFavoriteIcon()
        rightPanel.children.append(favoriteButton)
        
        grid.children.append(rightPanel)
        
        return grid
    }
    
    // MARK: - Documentation Button
    private func createDocumentationButton() -> Button {
        let button = Button()
        // AutomationProperties.setName(button, "Documentation")
        // ToolTipService.setToolTip(button, "Documentation")
        
        let contentPanel = StackPanel()
        contentPanel.orientation = .horizontal
        contentPanel.spacing = 8
        
        let icon = FontIcon()
        icon.glyph = "\u{E8A5}"
        icon.fontSize = 16
        contentPanel.children.append(icon)
        
        let label = TextBlock()
        label.text = "Documentation"
        contentPanel.children.append(label)
        
        button.content = contentPanel
        
        // Create flyout with doc links
        let flyout = Flyout()
        flyout.placement = .bottom
        
        let stackPanel = StackPanel()
        stackPanel.margin = Thickness(left: -12, top: 0, right: -12, bottom: 0)
        
        for doc in item.docs {
            let hyperlink = HyperlinkButton()
            hyperlink.content = doc.title
            hyperlink.navigateUri = Uri(doc.uri)
            hyperlink.horizontalAlignment = .stretch
            hyperlink.horizontalContentAlignment = .left
            // ToolTipService.setToolTip(hyperlink, doc.uri)
            stackPanel.children.append(hyperlink)
        }
        
        flyout.content = stackPanel
        button.flyout = flyout
        
        return button
    }
    
    // MARK: - Source Button
    private func createSourceButton() -> Button {
        let button = Button()
        // AutomationProperties.setName(button, "Source code")
        // ToolTipService.setToolTip(button, "Source code of this sample page")
        
        let contentPanel = StackPanel()
        contentPanel.orientation = .horizontal
        contentPanel.spacing = 8
        
        // GitHub icon
        let icon = FontIcon()
        icon.glyph = "\u{E943}"
        icon.fontSize = 18
        contentPanel.children.append(icon)
        
        let label = TextBlock()
        label.text = "Source"
        contentPanel.children.append(label)
        
        button.content = contentPanel
        
        // Create flyout with source links
        let flyout = Flyout()
        flyout.placement = .bottom
        
        let sourcePanel = StackPanel()
        sourcePanel.margin = Thickness(left: 0, top: -8, right: 0, bottom: -12)
        
        // Control Source Panel
        let controlSourcePanel = StackPanel()
        controlSourcePanel.margin = Thickness(left: 0, top: 0, right: 0, bottom: 4)
        
        let controlHeaderPanel = StackPanel()
        controlHeaderPanel.orientation = .horizontal
        controlHeaderPanel.spacing = 8
        
        let controlLabel = TextBlock()
        controlLabel.text = "Control source code"
        controlHeaderPanel.children.append(controlLabel)
        
        let infoBtn = Button()
        infoBtn.padding = Thickness(left: 6, top: 5, right: 6, bottom: 6)
        // ToolTipService.setToolTip(infoBtn, "Source code of this control in the WinUI repository")
        // AutomationProperties.setName(infoBtn, "Info")

        let infoIcon = FontIcon()
        infoIcon.glyph = "\u{E946}"
        infoIcon.fontSize = 14
        infoBtn.content = infoIcon
        
        controlHeaderPanel.children.append(infoBtn)
        controlSourcePanel.children.append(controlHeaderPanel)
        
        let controlLink = HyperlinkButton()
        controlLink.content = item.title
        controlLink.margin = Thickness(left: -12, top: 4, right: -12, bottom: 0)
        controlLink.horizontalAlignment = .stretch
        controlLink.horizontalContentAlignment = .left
        controlLink.navigateUri = Uri("https://github.com/microsoft/microsoft-ui-xaml")
        controlSourcePanel.children.append(controlLink)
        
        sourcePanel.children.append(controlSourcePanel)
        
        let separator = MenuFlyoutSeparator()
        separator.margin = Thickness(left: -12, top: 0, right: -12, bottom: 0)
        sourcePanel.children.append(separator)
        
        // Sample Page Source Panel
        let sampleHeaderPanel = StackPanel()
        sampleHeaderPanel.margin = Thickness(left: 0, top: 8, right: 0, bottom: 0)
        sampleHeaderPanel.orientation = .horizontal
        sampleHeaderPanel.spacing = 8
        
        let sampleLabel = TextBlock()
        sampleLabel.text = "Sample page source code"
        sampleHeaderPanel.children.append(sampleLabel)
        
        let sampleInfoBtn = Button()
        sampleInfoBtn.padding = Thickness(left: 6, top: 5, right: 6, bottom: 6)
        // ToolTipService.setToolTip(sampleInfoBtn, "Source code of this sample page in the WinUI Gallery repository")
        // AutomationProperties.setName(sampleInfoBtn, "Info")
        
        let sampleInfoIcon = FontIcon()
        sampleInfoIcon.glyph = "\u{E946}"
        sampleInfoIcon.fontSize = 14
        sampleInfoBtn.content = sampleInfoIcon
        
        sampleHeaderPanel.children.append(sampleInfoBtn)
        sourcePanel.children.append(sampleHeaderPanel)
        
        let xamlLink = HyperlinkButton()
        xamlLink.content = "XAML"
        xamlLink.margin = Thickness(left: -12, top: 4, right: -12, bottom: 0)
        xamlLink.horizontalAlignment = .stretch
        xamlLink.horizontalContentAlignment = .left
        xamlLink.navigateUri = Uri("https://github.com/microsoft/WinUI-Gallery")
        sourcePanel.children.append(xamlLink)
        
        let csharpLink = HyperlinkButton()
        csharpLink.content = "C#"
        csharpLink.margin = Thickness(left: -12, top: 4, right: -12, bottom: 0)
        csharpLink.horizontalAlignment = .stretch
        csharpLink.horizontalContentAlignment = .left
        csharpLink.navigateUri = Uri("https://github.com/microsoft/WinUI-Gallery")
        sourcePanel.children.append(csharpLink)
        
        flyout.content = sourcePanel
        button.flyout = flyout
        
        return button
    }
    
    // MARK: - Teaching Tip
    private func createCopyLinkTeachingTip() -> TeachingTip {
        let tip = TeachingTip()
        tip.title = "Quickly reference this sample!"
        tip.subtitle = "Share with others or paste this link into the Run dialog to open the app to this page directly."
        tip.actionButtonContent = "Don't show again"
        tip.closeButtonContent = "Got it!"
        tip.preferredPlacement = .bottom
        tip.target = copyLinkButton
        
        tip.actionButtonClick.addHandler { [weak self] _, _ in
            self?.onCopyDontShowAgainButtonClick()
        }
        
        return tip
    }
    
    // MARK: - Event Handlers
    private func onLoaded() {
        // Initialization code when control is loaded
    }
    
    private func onThemeButtonClick() {
        // Toggle between Light/Dark theme
        if let rootElement = self.xamlRoot?.content as? FrameworkElement {
            let currentTheme = rootElement.requestedTheme
            let newTheme: ElementTheme = (currentTheme == .dark) ? .light : .dark
            rootElement.requestedTheme = newTheme
        }
    }
    
    private func onCopyLinkButtonClick() {
        // Copy link to clipboard - showing the teaching tip
        if !UserDefaults.standard.bool(forKey: "CopyLinkTeachingTipDismissed") {
            copyLinkTeachingTip?.isOpen = true
        }
    }
    
    private func onFeedbackButtonClick() {
        // Open feedback URL - would need proper launcher implementation
        // For now, just a placeholder
    }
    
    private func onCopyDontShowAgainButtonClick() {
        UserDefaults.standard.set(true, forKey: "CopyLinkTeachingTipDismissed")
        copyLinkTeachingTip?.isOpen = false
    }
    
    private func updateFavoriteIcon() {
        guard let icon = favoriteButton.content as? FontIcon else { return }
        let isChecked = favoriteButton.isChecked ?? false
        icon.glyph = isChecked ? "\u{E735}" : "\u{E734}"
        
        let _ = isChecked ? "Remove from favorites" : "Add to favorites"
        // ToolTipService.setToolTip(favoriteButton, tooltip)
    }
}

// MARK: - Usage Example
extension PageHeader {
    public static func createExample() -> PageHeader {
        let sampleItem = ControlInfo(
            title: "Button",
            apiNamespace: "Microsoft.UI.Xaml.Controls",
            baseClasses: ["Object", "DependencyObject", "UIElement", "FrameworkElement", "Control", "ButtonBase", "Button"],
            docs: [
                ControlInfoDocLink(
                    title: "Button API Documentation",
                    uri: "https://docs.microsoft.com/windows/winui/api/microsoft.ui.xaml.controls.button"
                ),
                ControlInfoDocLink(
                    title: "Guidelines",
                    uri: "https://docs.microsoft.com/windows/apps/design/controls/buttons"
                )
            ]
        )
        
        return PageHeader(item: sampleItem)
    }
}