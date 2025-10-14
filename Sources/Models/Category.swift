import Foundation

enum Category: String, CaseIterable, Codable {
    case home, fundamentals

    var text: String { self.rawValue.capitalized }
    var glyph: String {
        switch self {
            case .home: return "\u{E80F}" 
            case .fundamentals: return "\u{E8F1}" 
        }
    }

    var sortIndex: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}

enum Fundamentals: String, CaseIterable, Codable {
    case Resources, Styles, Binding, Templates, CustomUserControls, ScratchPad
        
    var text: String { self.rawValue.capitalized }
    var sortIndex: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}