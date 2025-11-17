@preconcurrency import WinUI
import WinAppSDK
import Foundation
import UWP
import WindowsFoundation

class TeachingTipPage: Grid {
    private var mainScrollViewer: ScrollViewer!
    private var contentStackPanel: StackPanel!
    
    private var targetedTip: TeachingTip!
    private var nonTargetedTip: TeachingTip!
    private var heroTip: TeachingTip!
    
    private var targetedButton: Button!
    private var nonTargetedButton: Button!
    private var heroButton: Button!
    
    override init() {
        super.init()
        setupView()
        createTeachingTips()
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
        contentStackPanel.children.append(createTargetedSection())
        contentStackPanel.children.append(createNonTargetedSection())
        contentStackPanel.children.append(createHeroSection())
        
        mainScrollViewer.content = contentStackPanel
        self.children.append(mainScrollViewer)
    }
    
    private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 8
        
        let titleText = TextBlock()
        titleText.text = "TeachingTip"
        titleText.fontSize = 32
        titleText.fontWeight = FontWeights.semiBold
        headerPanel.children.append(titleText)
        
        return headerPanel
    }
    
    private func createTargetedSection() -> Border {
        let section = createSection(
            title: "Show a targeted TeachingTip on a button.",
            buttonText: "Show TeachingTip",
            buttonAction: { [weak self] in
                self?.showTargetedTip()
            },
            buttonOut: { [weak self] button in
                self?.targetedButton = button
            }
        )
        return section
    }
    
    private func createNonTargetedSection() -> Border {
        let section = createSection(
            title: "Show a non-targeted TeachingTip with buttons.",
            buttonText: "Show TeachingTip",
            buttonAction: { [weak self] in
                self?.showNonTargetedTip()
            },
            buttonOut: { [weak self] button in
                self?.nonTargetedButton = button
            }
        )
        return section
    }
    
    private func createHeroSection() -> Border {
        let section = createSection(
            title: "Show a targeted TeachingTip with hero content on a button.",
            buttonText: "Show TeachingTip",
            buttonAction: { [weak self] in
                self?.showHeroTip()
            },
            buttonOut: { [weak self] button in
                self?.heroButton = button
            }
        )
        return section
    }
    
    private func createSection(title: String, buttonText: String, buttonAction: @escaping () -> Void, buttonOut: @escaping (Button) -> Void) -> Border {
        let outerBorder = Border()
        outerBorder.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        outerBorder.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        
        let borderBrush = SolidColorBrush()
        var borderColor = UWP.Color()
        borderColor.a = 255
        borderColor.r = 200
        borderColor.g = 200
        borderColor.b = 200
        borderBrush.color = borderColor
        outerBorder.borderBrush = borderBrush
        
        outerBorder.padding = Thickness(left: 24, top: 24, right: 24, bottom: 24)
        
        let contentPanel = StackPanel()
        contentPanel.spacing = 12
        
        let titleText = TextBlock()
        titleText.text = title
        titleText.fontSize = 14
        titleText.textWrapping = .wrap
        contentPanel.children.append(titleText)
        
        let button = Button()
        button.content = buttonText
        button.click.addHandler { sender, args in
            buttonAction()
        }
        contentPanel.children.append(button)
        buttonOut(button)
        
        outerBorder.child = contentPanel
        return outerBorder
    }
    
    private func createTeachingTips() {
        targetedTip = TeachingTip()
        targetedTip.title = "This is the title"
        targetedTip.subtitle = "And this is the subtitle"
        targetedTip.isLightDismissEnabled = true
        targetedTip.shouldConstrainToRootBounds = false
        
        self.children.append(targetedTip)
        
        nonTargetedTip = TeachingTip()
        nonTargetedTip.title = "This is the title"
        nonTargetedTip.subtitle = "And this is the subtitle"
        nonTargetedTip.actionButtonContent = "Action button"
        nonTargetedTip.closeButtonContent = "Close button"
        nonTargetedTip.isLightDismissEnabled = true
        
        nonTargetedTip.actionButtonClick.addHandler { sender, args in
            print("Action button clicked")
        }
        
        nonTargetedTip.closeButtonClick.addHandler { [weak self] sender, args in
            self?.nonTargetedTip?.isOpen = false
        }
        
        self.children.append(nonTargetedTip)
        
        heroTip = TeachingTip()
        heroTip.title = "This is the title"
        heroTip.subtitle = "And this is the subtitle"
        heroTip.shouldConstrainToRootBounds = false
        
        let heroImage = Image()
        let bitmapImage = BitmapImage()
        
        if let imagePath = Bundle.module.path(forResource: "picture", ofType: "png", inDirectory: "Assets/Scrolling") {
            let imageUri = Uri(imagePath)
            bitmapImage.uriSource = imageUri
            heroImage.source = bitmapImage
        }
        
        heroImage.width = 300
        heroImage.height = 200
        heroImage.stretch = .uniformToFill
        
        heroTip.heroContent = heroImage
        
        let descriptionText = TextBlock()
        descriptionText.text = "Description can go here"
        descriptionText.textWrapping = .wrap
        heroTip.content = descriptionText
        
        heroTip.isLightDismissEnabled = true
        
        self.children.append(heroTip)
    }
    
    private func showTargetedTip() {
        guard let tip = targetedTip, let button = targetedButton else { return }
        tip.target = button
        tip.isOpen = true
    }
    
    private func showNonTargetedTip() {
        guard let tip = nonTargetedTip else { return }
        tip.isOpen = true
    }
    
    private func showHeroTip() {
        guard let tip = heroTip, let button = heroButton else { return }
        tip.target = button
        tip.isOpen = true
    }
}