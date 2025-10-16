import Foundation

class MainWindowViewModel: BaseViewModel, @unchecked Sendable {
    // MARK: - Properties
    private var _selectedCategory: any Category = MainCategory.home
    var selectedCategory: any Category {
        get { _selectedCategory }
        set {
            _selectedCategory = newValue
            notifyPropertyChanged("selectedCategory")
            updateNavigation()
        }
    }

    // MARK: - Commands
    lazy var navigateCommand: CommandWithParameter<any Category> = {
        return CommandWithParameter<any Category>(action: { [weak self] category in
            self?.navigate(to: category)
        })
    }()

    // MARK: - Initialization
    override init() {
        super.init()
    }

    // MARK: - Methods
    private func navigate(to category: any Category) {
        selectedCategory = category
    }

    private func updateNavigation() {
        // 根据选中的分类更新导航的状态
        print("Navigating to: \(selectedCategory)")
    }
}