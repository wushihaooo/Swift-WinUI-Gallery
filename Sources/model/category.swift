import Foundation

enum Category: String, CaseIterable, Codable {
    case home, fundamentals, design, accessibility, all, collections

    var text: String { self.rawValue.capitalized }
    var glyph: String {
        switch self {
            case .home: return "\u{E80F}" 
            case .fundamentals: return "\u{E8F1}" 
            case .design: return "\u{E771}"
            case .accessibility: return "\u{E776}"
            case .all: return "\u{E8FD}"
            case .collections: return "\u{E775}"
        }
    }

    var sortIndex: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}

enum Collections: String, CaseIterable, Codable {
    case flipview, gridview, itemsrepeater, itemsview, listbox, listview, pulltorefresh, treeview
        
    var text: String { self.rawValue.capitalized }
    var sortIndex: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}