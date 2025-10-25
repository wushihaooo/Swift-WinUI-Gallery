// import WinUI
// import WinAppSDK

// private func createComboBox(items: [String], placeholder: String = "", width: Double = 200, isEditable: Bool = false) -> ComboBox {
//     let comboBox = ComboBox()
//     comboBox.width = width
//     comboBox.isEditable = isEditable

//     // 添加选项
//     for item in items {
//         comboBox.items.append(item)
//     }

//     // 占位符
//     comboBox.placeholderText = placeholder

//     return comboBox
// }

// class ComboBoxPage: StackPanel {
//     private let outputText = TextBlock()

//     // ComboBox 数据
//     private let colorOptions = ["Blue", "Green", "Red", "Yellow"]
//     private let fontOptions: [(String, String)] = [("Arial", "Arial"), ("Times New Roman", "TimesNewRoman"), ("Calibri", "Calibri")]
//     private let fontSizes = ["10", "12", "14", "16", "18", "20"]

//     // ComboBox 组件
//     private let colorComboBox = ComboBox()
//     private let fontComboBox = ComboBox()
//     private let fontSizeComboBox = ComboBox()

//     override init() {
//         super.init()
//         setupLayout()
//         setupHandlers()
//     }

//     private func setupLayout() {
//         self.orientation = .vertical
//         self.spacing = 10
//         self.padding = Thickness(left: 20, top: 20, right: 20, bottom: 20)

//         let title = TextBlock()
//         title.text = "ComboBox Examples"
//         title.fontSize = 20
//         self.children.append(title)

//         // Color ComboBox
//         let colorTitle = TextBlock()
//         colorTitle.text = "Colors"
//         colorTitle.fontSize = 16
//         self.children.append(colorTitle)

//         colorComboBox.width = 200
//         colorComboBox.placeholderText = "Pick a color"
//         for color in colorOptions { colorComboBox.items.append(color) }
//         self.children.append(colorComboBox)

//         // Font ComboBox
//         let fontTitle = TextBlock()
//         fontTitle.text = "Font"
//         fontTitle.fontSize = 16
//         self.children.append(fontTitle)

//         fontComboBox.width = 200
//         for font in fontOptions { fontComboBox.items.append(font.0) }
//         self.children.append(fontComboBox)

//         // FontSize ComboBox
//         let fontSizeTitle = TextBlock()
//         fontSizeTitle.text = "Font Size"
//         fontSizeTitle.fontSize = 16
//         self.children.append(fontSizeTitle)

//         fontSizeComboBox.width = 200
//         fontSizeComboBox.isEditable = true
//         for size in fontSizes { fontSizeComboBox.items.append(size) }
//         self.children.append(fontSizeComboBox)

//         // 输出文本
//         outputText.text = "Output:"
//         outputText.fontSize = 14
//         outputText.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)
//         self.children.append(outputText)
//     }

//     private func setupHandlers() {
//         // 颜色选择事件
//         colorComboBox.selectionChanged.addHandler { [weak self] sender, args in
//             if let combo = sender as? ComboBox, let index = combo.selectedIndex, index >= 0 {
//                 self?.outputText.text = "Output: Selected color - \(self!.colorOptions[index])"
//             }
//         }

//         // 字体选择事件
//         fontComboBox.selectionChanged.addHandler { [weak self] sender, args in
//             if let combo = sender as? ComboBox, let index = combo.selectedIndex, index >= 0 {
//                 self?.outputText.text = "Output: Selected font - \(self!.fontOptions[index].0)"
//             }
//         }

//         // 字号输入事件
//         fontSizeComboBox.textSubmitted.addHandler { [weak self] sender, args in
//             if let combo = sender as? ComboBox {
//                 let text = combo.text ?? ""
//                 self?.outputText.text = "Output: Font size entered - \(text)"
//             }
//         }
//     }
// }
