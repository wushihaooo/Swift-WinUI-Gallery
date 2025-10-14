import Foundation

// 简单命令（无参数）
class Command {
    private let action: () -> Void
    private let canExecuteFunc: (() -> Bool)?
    
    var canExecuteChanged: (() -> Void)?
    
    init(action: @escaping () -> Void, canExecute: (() -> Bool)? = nil) {
        self.action = action
        self.canExecuteFunc = canExecute
        print("Command initialized")
    }
    
    func execute() {
        print("Command.execute() called")
        print("canExecute: \(canExecute())")
        
        guard canExecute() else {
            print("Command.execute() - canExecute is false, aborting")
            return
        }
        
        print("Command.execute() - executing action")
        action()
        print("Command.execute() - action completed")
    }
    
    func canExecute() -> Bool {
        let result = canExecuteFunc?() ?? true
        print("Command.canExecute() returning: \(result)")
        return result
    }
    
    func raiseCanExecuteChanged() {
        print("Command.raiseCanExecuteChanged() called")
        canExecuteChanged?()
    }
}

// 带参数的命令
class CommandWithParameter<T> {
    private let action: (T) -> Void
    
    init(action: @escaping (T) -> Void) {
        self.action = action
        print("CommandWithParameter initialized")
    }
    
    func execute(parameter: T) {
        print("CommandWithParameter.execute() called with parameter: \(parameter)")
        action(parameter)
        print("CommandWithParameter.execute() completed")
    }
}