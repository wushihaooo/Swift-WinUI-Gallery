// import WinUI
// import WinAppSDK
// import Foundation

// class RepeatButtonPage: StackPanel {
//     private let outputText = TextBlock()
//     private let countText = TextBlock()
//     private var timer: Foundation.Timer?
//     private var count: Int = 0

//     override init() {
//         super.init()
//         setupLayout()
//     }

//     // MARK: - 布局
//     private func setupLayout() {
//         self.orientation = .vertical
//         self.spacing = 10
//         self.padding = Thickness(left: 20, top: 20, right: 20, bottom: 20)

//         // 标题
//         let title = TextBlock()
//         title.text = "RepeatButton Example"
//         title.fontSize = 20
//         self.children.append(title)

//         // RepeatButton
//         let repeatButton = RepeatButton()
//         let btnText = TextBlock()
//         btnText.text = "Hold to Increase"
//         btnText.fontSize = 16
//         repeatButton.content = btnText
//         repeatButton.margin = Thickness(left: 0, top: 10, right: 0, bottom: 0)

//         // 输出
//         countText.text = "Count: 0"
//         outputText.text = "Output: Ready"
//         countText.fontSize = 14
//         outputText.fontSize = 14

//         self.children.append(repeatButton)
//         self.children.append(countText)
//         self.children.append(outputText)


//     }


// }
