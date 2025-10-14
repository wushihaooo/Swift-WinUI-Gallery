import Foundation

class BaseViewModel: ObservableObject, @unchecked Sendable {
    var propertyChanged: ((String) -> Void)?
    
    init() {
        print("BaseViewModel.init()")
    }
    
    deinit {
        print("ViewModel deallocated: \(type(of: self))")
    }
}