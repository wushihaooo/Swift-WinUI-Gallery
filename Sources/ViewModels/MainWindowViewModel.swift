import Foundation

class MainWindowViewModel: BaseViewModel, @unchecked Sendable {
    // MARK: - Properties
    
    private var _selectedCategory: Category = .home
    var selectedCategory: Category {
        get { _selectedCategory }
        set {
            _selectedCategory = newValue
            notifyPropertyChanged("selectedCategory")
            updateNavigation()
        }
    }

    // MARK: - Commands
    lazy var navigateCommand: CommandWithParameter<Category> = {
        return CommandWithParameter<Category>(action: { [weak self] category in
            self?.navigate(to: category)
        })
    }()

    lazy var refreshCommand: Command = {
        return Command(action: { [weak self] in
            self?.refresh()
        })
    }()

    // MARK: -Initialization

    override init() {
        super.init()
    }

    // MARK: - Methods

    private func navigate(to category: Category) {
        selectedCategory = category
    }

    private func updateNavigation() {
        // 根据选中的分类更新导航的状态
        print("Navigating to: \(selectedCategory)")
    }

    private func refresh() {
        // 刷新数据
        print("Refreshing data...")
    }

}