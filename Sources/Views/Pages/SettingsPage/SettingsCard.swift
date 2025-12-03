import WinUI
import Foundation
import WindowsFoundation
import WinAppSDK
import UWP

class SettingsCard: Grid, @unchecked Sendable{
    private var leftIcon: FontIcon!
    private var midGrid: Grid!
    private var rightControl: ComboBox!
    
    init(left: FontIcon, mid: Grid, right: ComboBox) {
        super.init()
        self.leftIcon = left
        self.midGrid = mid
        self.rightControl = right
        
        self.horizontalAlignment = .stretch
        self.minHeight = 80
        self.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)
        self.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        
        // 使用主题资源而不是硬编码颜色
        self.background = self.getBackgroundColor()
        self.borderBrush = self.getBorderColor()
        self.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        
        // 设置列定义
        let cd0 = ColumnDefinition()
        cd0.width = GridLength(value: 60, gridUnitType: .pixel) // 图标列
        self.columnDefinitions.append(cd0)
        
        let cd1 = ColumnDefinition()
        cd1.width = GridLength(value: 1, gridUnitType: .star) // 文本列
        self.columnDefinitions.append(cd1)
        
        let cd2 = ColumnDefinition()
        cd2.width = GridLength(value: 200, gridUnitType: .pixel) // 控件列
        self.columnDefinitions.append(cd2)
        
        // 设置图标样式
        left.fontSize = 24
        left.horizontalAlignment = .center
        left.verticalAlignment = .center
        
        // 设置文本样式
        if let midChild = mid.children.first as? TextBlock {
            midChild.fontSize = 16
            midChild.fontWeight = FontWeights.normal
            midChild.verticalAlignment = .center
            // 设置文本颜色
            midChild.foreground = self.getTextColor()
        }
        mid.horizontalAlignment = .left
        mid.verticalAlignment = .center
        
        // 设置下拉框样式
        right.horizontalAlignment = .stretch
        right.verticalAlignment = .center
        right.margin = Thickness(left: 8, top: 0, right: 0, bottom: 0)
        
        try! Grid.setColumn(left, 0)
        self.children.append(left)
        try! Grid.setColumn(mid, 1)
        self.children.append(mid)
        try! Grid.setColumn(right, 2)
        self.children.append(right)
        
        // 监听主题变化
        NotificationCenter.default.addObserver(forName: NSNotification.Name("ThemeChanged"), object: nil, queue: nil) { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateThemeColors()
            }
        }
    }
    
    private func getBackgroundColor() -> Brush {
        let actualTheme = Application.current.requestedTheme
        if actualTheme == .dark {
            // 暗色模式下的背景色
            return SolidColorBrush(Color(a: 255, r: 32, g: 32, b: 32))
        } else {
            // 浅色模式下的背景色
            return SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        }
    }
    
    private func getBorderColor() -> Brush {
        let actualTheme = Application.current.requestedTheme
        if actualTheme == .dark {
            // 暗色模式下的边框色
            return SolidColorBrush(Color(a: 255, r: 64, g: 64, b: 64))
        } else {
            // 浅色模式下的边框色
            return SolidColorBrush(Color(a: 255, r: 224, g: 224, b: 224))
        }
    }
    
    private func getTextColor() -> Brush {
        let actualTheme = Application.current.requestedTheme
        if actualTheme == .dark {
            // 暗色模式下的文字颜色
            return SolidColorBrush(Color(a: 255, r: 255, g: 255, b: 255))
        } else {
            // 浅色模式下的文字颜色
            return SolidColorBrush(Color(a: 255, r: 0, g: 0, b: 0))
        }
    }
    
    // 更新主题颜色
    private func updateThemeColors() {
        self.background = self.getBackgroundColor()
        self.borderBrush = self.getBorderColor()
        
        // 更新文本颜色
        if let midChild = self.midGrid?.children.first as? TextBlock {
            midChild.foreground = self.getTextColor()
        }
    }
    
    // 销毁时移除通知监听
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}