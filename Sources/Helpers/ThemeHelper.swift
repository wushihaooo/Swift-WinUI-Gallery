import Foundation
import UWP
import WinAppSDK
import WindowsFoundation
import WinUI

class ThemeHelper {
    public static var rootTheme: ApplicationTheme {
        get {
            return Application.current.requestedTheme
        }
        set {
            Application.current.requestedTheme = newValue
            // 发送主题变化通知
            NotificationCenter.default.post(name: NSNotification.Name("ThemeChanged"), object: nil)
        }
    }
}