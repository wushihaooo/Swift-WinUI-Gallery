import WinUI
import WinAppSDK
import Foundation

class ControlExample {
    private var root = Grid()
    var controlExample: Grid {
        get {
            return root
        }
    }
    private let headerText: String
    private var controlPresenterContent: UIElement
    private var outputPresenter: UIElement
    private var optionsPresenter: UIElement
    private var isOutputDisplay:Bool = false
    private var isOptionsDisplay:Bool = false

    init(headerText: String, 
            isOutputDisplay: Bool = false, 
            isOptionsDisplay: Bool = false, 
            contentPresenter: UIElement,
            outputPresenter: UIElement = Border(),
            optionsPresenter: UIElement = Border()) {
        self.headerText = headerText
        self.isOutputDisplay = isOutputDisplay
        self.isOptionsDisplay = isOptionsDisplay
        self.controlPresenterContent = contentPresenter
        self.outputPresenter = outputPresenter
        self.optionsPresenter = optionsPresenter
        do {
            let filePath: String? = Bundle.module.path(forResource: "ControlExample", ofType: "xaml", inDirectory: "Assets/xaml")
            print( "filePath:\(filePath ?? "nil")")
            let root: Any? = try XamlReader.load(FileReader.readFileFromPath(filePath!) ?? "")
            if let grid = root as? Grid {
                self.root = grid
            }
            setupUI()
        } catch {
            print("[ControlExample]: XamlReader Fail, reason: \(error)")
        }
    }
    private func setupUI() {
        let headerTextPresenter: TextBlock = try! root.findName("HeaderTextPresenter") as! TextBlock
        headerTextPresenter.text = self.headerText

        let controlPresenter: ContentPresenter = try! root.findName("ControlPresenter") as! ContentPresenter
        controlPresenter.content = self.controlPresenterContent
        let outputPresenter: StackPanel = try! root.findName("OutputPresenter") as! StackPanel
        outputPresenter.visibility = self.isOutputDisplay ? .visible : .collapsed
        outputPresenter.children.append(self.outputPresenter)
        let optionsPresenter: ContentPresenter = try! root.findName("OptionsPresenter") as! ContentPresenter
        optionsPresenter.visibility = self.isOptionsDisplay ? .visible : .collapsed
        optionsPresenter.content = self.optionsPresenter
    }
}