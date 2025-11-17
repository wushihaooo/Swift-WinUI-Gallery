@preconcurrency import WinUI
import WinAppSDK
import Foundation
import UWP

class ContentDialogPage: Grid {
    private var mainScrollViewer: ScrollViewer!
    private var contentStackPanel: StackPanel!
    
    // 保持对结果文本的强引用
    private var basicDialogResultText: TextBlock!
    private var noDefaultDialogResultText: TextBlock!
    
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
        contentStackPanel.children.append(createBasicDialogSection())
        contentStackPanel.children.append(createNoDefaultButtonSection())
        
        mainScrollViewer.content = contentStackPanel
        self.children.append(mainScrollViewer)
    }
    
    private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 8
        
        let titleText = TextBlock()
        titleText.text = "ContentDialog"
        titleText.fontSize = 32
        titleText.fontWeight = FontWeights.semiBold
        headerPanel.children.append(titleText)
        
        return headerPanel
    }
    
    private func createDescription() -> TextBlock {
        let descText = TextBlock()
        descText.text = "Use a ContentDialog to show relavant information or to provide a modal dialog experience that can show any XAML content."
        descText.fontSize = 14
        descText.textWrapping = .wrap
        descText.opacity = 0.8
        return descText
    }
    
    // MARK: - Basic Dialog Section
    private func createBasicDialogSection() -> Border {
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
        
        // 标题
        let titleText = TextBlock()
        titleText.text = "A basic content dialog with content."
        titleText.fontSize = 16
        titleText.fontWeight = FontWeights.semiBold
        contentPanel.children.append(titleText)
        
        // 结果显示区域
        let resultPanel = StackPanel()
        resultPanel.orientation = .horizontal
        resultPanel.spacing = 12
        
        let showButton = Button()
        showButton.content = "Show dialog"
        
        basicDialogResultText = TextBlock()
        basicDialogResultText.text = ""  // 初始为空
        basicDialogResultText.verticalAlignment = .center
        
        showButton.click.addHandler { [weak self] sender, args in
            self?.showBasicDialog()
        }
        
        resultPanel.children.append(showButton)
        resultPanel.children.append(basicDialogResultText)
        contentPanel.children.append(resultPanel)
        
        outerBorder.child = contentPanel
        return outerBorder
    }
    
    // MARK: - No Default Button Section
    private func createNoDefaultButtonSection() -> Border {
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
        
        // 标题
        let titleText = TextBlock()
        titleText.text = "A content dialog without a default button."
        titleText.fontSize = 16
        titleText.fontWeight = FontWeights.semiBold
        contentPanel.children.append(titleText)
        
        // 按钮和结果显示区域
        let resultPanel = StackPanel()
        resultPanel.orientation = .horizontal
        resultPanel.spacing = 12
        
        let showButton = Button()
        showButton.content = "Show dialog without default button"
        
        noDefaultDialogResultText = TextBlock()
        noDefaultDialogResultText.text = ""
        noDefaultDialogResultText.verticalAlignment = .center
        
        showButton.click.addHandler { [weak self] sender, args in
            self?.showNoDefaultDialog()
        }
        
        resultPanel.children.append(showButton)
        resultPanel.children.append(noDefaultDialogResultText)
        contentPanel.children.append(resultPanel)
        
        outerBorder.child = contentPanel
        return outerBorder
    }
    
    // MARK: - Show Dialogs
    private func showBasicDialog() {
        let dialog = ContentDialog()
        dialog.title = "Save your work?"
        
        // 创建对话框内容 - 包含文本和复选框
        let contentPanel = StackPanel()
        contentPanel.spacing = 12
        
        let descText = TextBlock()
        descText.text = "Lorem ipsum dolor sit amet, adipisicing elit."
        descText.textWrapping = .wrap
        contentPanel.children.append(descText)
        
        let checkBox = CheckBox()
        checkBox.content = "Upload your content to the cloud."
        contentPanel.children.append(checkBox)
        
        dialog.content = contentPanel
        
        dialog.primaryButtonText = "Save"
        dialog.secondaryButtonText = "Don't Save"
        dialog.closeButtonText = "Cancel"
        dialog.defaultButton = .primary
        dialog.xamlRoot = self.xamlRoot
        
        guard let asyncOp = try? dialog.showAsync() else { 
            print("[ContentDialog] Failed to show dialog")
            return 
        }
        
        asyncOp.completed = { [weak self] op, status in
            guard let self = self else { return }
            guard let op = op, let result = try? op.getResults() else { 
                return 
            }
            
            // 直接更新 UI（WinUI 回调在 UI 线程）
            switch result {
            case .primary:
                self.basicDialogResultText.text = "User saved their work"
            case .secondary:
                self.basicDialogResultText.text = "User did not save their work"
            default:
                self.basicDialogResultText.text = "User cancelled the dialog"
            }
        }
    }
    
    private func showNoDefaultDialog() {
        let dialog = ContentDialog()
        dialog.title = "Replace file?"
        dialog.content = "A file with this name already exists. Replacing it will overwrite its contents."
        dialog.primaryButtonText = "Replace"
        dialog.secondaryButtonText = "Keep"
        dialog.closeButtonText = "Cancel"
        dialog.defaultButton = .none
        dialog.xamlRoot = self.xamlRoot
        
        guard let asyncOp = try? dialog.showAsync() else { return }
        
        asyncOp.completed = { [weak self] op, status in
            guard let self = self else { return }
            guard let op = op, let result = try? op.getResults() else { return }
            
            // 直接更新 UI（WinUI 回调在 UI 线程）
            switch result {
            case .primary:
                self.noDefaultDialogResultText.text = "User replaced the file"
            case .secondary:
                self.noDefaultDialogResultText.text = "User kept the file"
            default:
                self.noDefaultDialogResultText.text = "User cancelled the dialog"
            }
        }
    }
}