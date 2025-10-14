import Foundation
import WinSDK

/// 属性变化通知协议
protocol ObservableObject: AnyObject {
    var propertyChanged: ((String) -> Void)? { get set }
    func notifyPropertyChanged(_ propertyName: String)
}

extension ObservableObject {
    func notifyPropertyChanged(_ propertyName: String) {
        propertyChanged?(propertyName)
    }
}