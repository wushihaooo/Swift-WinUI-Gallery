import Foundation

protocol Category: CaseIterable, Codable, RawRepresentable, Equatable where RawValue == String {
    var text: String { get }
    var sortIndex: Int { get }
    var canSelect: Bool { get }
    var subCategories: [any Category] { get }
}

extension Category {
    var text: String { self.rawValue.capitalized }
    var sortIndex: Int {
        if let index = Self.allCases.firstIndex(of: self) {
            return Self.allCases.distance(from: Self.allCases.startIndex, to: index)
        }
        return 0
    }
    var canSelect: Bool { true }
    var subCategories: [any Category] { [] }
}

enum MainCategory: String, Category {
    case home
    case fundamentals
    case design
    case accessibility
    case all
    case basicInput
    case collections
    case dataTime
    case dialogsFlyouts
    case layout
    case media
    case menusToolbars
    case motion
    case navigation
    case scrolling
    case statusInfo
    case styles
    case system
    case text
    case windowing

    static let rawValue2Title: [String: String] = [
        "home": "Home",
        "fundamentals": "Fundamentals",
        "design": "Design",
        "accessibility": "Accessibility",
        "all": "All",
        "basicInput": "Basic Input",
        "collections": "Collections",
        "dataTime": "Date & Time",
        "dialogsFlyouts": "Dialogs & Flyouts",
        "layout": "Layout",
        "media": "Media",
        "menusToolbars": "Menus & Toolbars",
        "motion": "Motion",
        "navigation": "Navigation",
        "scrolling": "Scrolling",
        "statusInfo": "Status Info",
        "styles": "Styles",
        "system": "System",
        "text": "Text",
        "windowing": "Windowing",
    ]
    var text: String { 
        debugPrint("[DEBUG--MainWindow] rawValue: \(self.rawValue) \(type(of: self.rawValue))")
        return Self.rawValue2Title[self.rawValue] ?? self.rawValue.capitalized 
    }

    var glyph: String {
        switch self {
            case .home: return "\u{E80F}" 
            case .fundamentals: return "\u{E8F1}" 
            case .design: return "\u{E790}"
            case .accessibility: return "\u{E7F4}"
            case .all: return "\u{E71D}"
            case .basicInput: return "\u{E8D7}"
            case .collections: return "\u{E8EF}"
            case .dataTime: return "\u{E823}"
            case .dialogsFlyouts: return "\u{E8A1}"
            case .layout: return "\u{ECA5}"
            case .media: return "\u{E714}"
            case .menusToolbars: return "\u{E700}"
            case .motion: return "\u{E7C3}"
            case .navigation: return "\u{E8FF}"
            case .scrolling: return "\u{E76E}"
            case .statusInfo: return "\u{E946}"
            case .styles: return "\u{E8C7}"
            case .system: return "\u{E7EF}"
            case .text: return "\u{E8D2}"
            case .windowing: return "\u{E8A7}"
        }
    }

    var sortIndex: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }

    var subCategories: [any Category] {
        switch self {
        case .fundamentals:
            return FundamentalsCategory.allCases
        case .design:
            return DesignCategory.allCases
        case .accessibility:
            return AccessibilityCategory.allCases
        case .basicInput:
            return BasicInputCategory.allCases
        case .collections:
            return CollectionsCategory.allCases
        case .dataTime:
            return DateTimeCategory.allCases
        case .dialogsFlyouts:
            return DialogsFlyoutsCategory.allCases
        case .layout:
            return LayoutCategory.allCases
        case .media:
            return MediaCategory.allCases
        case .menusToolbars:
            return MenusToolbarsCategory.allCases
        case .motion:
            return MotionCategory.allCases
        case .navigation:
            return NavigationViewCategory.allCases
        case .scrolling:
            return ScrollingCategory.allCases
        case .statusInfo:
            return StatusInfoCategory.allCases
        case .styles:
            return StylesCategory.allCases
        case .system:
            return SystemCategory.allCases
        case .text:
            return TextCategory.allCases
        case .windowing:
            return WindowingCategory.allCases
        default:
            return []
        }
    }

    var canSelect: Bool {
        switch self {
        case .home, .all:
            return true
        default:
            return false
        }
    }
}

enum FundamentalsCategory: String, Category {
    case resources, styles, binding, templates, customUserControls, scratchPad
}

enum DesignCategory: String , Category {
    case color, geometry, iconography, spacing, typography
}

enum AccessibilityCategory: String, Category {
    case screenReaderSupport, keyBoardSupport, colorContrast
}


enum BasicInputCategory: String, Category {
    case button, dropDownButton, HyperlinkButton, repeatButton, toggleButton, splitButton, toggleSplitButton, checkBox, colorPicker
    case comboBox, radioButton, ratingControl, slider, toggleSwitch
}

enum CollectionsCategory: String, Category {
    case flipView, gridView, itemsRepeater, itemsView, listBox, listView, pullToRefresh, treeView
}


enum DateTimeCategory: String, Category {
    case calendarDatePicker, calendarView, datePicker, timePicker
    var text: String { 
        debugPrint("[DEBUG--MainWindow] rawValue: \(self.rawValue) \(type(of: self.rawValue))")
        return Self.rawValue2Title[self.rawValue] ?? self.rawValue.capitalized 
    }
    static let rawValue2Title: [String: String] = [
        "calendarDatePicker": "CalendarDatePicker",
        "calendarView": "CalendarView",
        "datePicker": "DatePicker",
        "timePicker": "TimePicker"
    ]
}

enum DialogsFlyoutsCategory: String, Category {
    case contentDialog, flyout, popup, teachingTip
}

enum LayoutCategory: String, Category {
    case border, canvas, expander, grid, radioButtons, relativePanel, variableSizedWrapGrid, viewBox,stackPanel
}

enum MediaCategory: String, Category {
    case animatedVisualPlayer, captureElementCameraPreview, image, mapControl, mediaPlayerElement
    case personPicture, sound, webView2
}

enum MenusToolbarsCategory: String, Category {
    case appBarButton, appBarSeparator, appBarToggleButton, commandBar, commandBarFlyout, menuBar, menuFlyout, swipeControl
    case standardUICommand, XamlUICommand
}

enum MotionCategory: String, Category {
    case animationInterop, connectedAnimation, easingFunctions
    case implicitTransitions, pageTransitions, themeTransitions, parallaxView
}

enum NavigationViewCategory: String, Category {
    case breadcrumbBar, navigationView, pivot, selectorBar, tabView
}

enum ScrollingCategory: String, Category {
    case annotatedScrollBar, pipsPager, scrollView, scrollViewer, semanticZoom
}

enum StatusInfoCategory: String, Category {
    case infoBadge, infoBar, progressBar, progressRing, toolTip
}

enum StylesCategory: String, Category {
    case AcrylicBrush, animatedIcon, compactSizing, iconElement, ling, shape, radialGradientBrush
    case systemBackdropsMicaAcrylic, themeShadow
}


enum SystemCategory: String, Category {
    case appNotifications, badgeNotifications, clipboard, contentIsland, filePicker
}

enum TextCategory: String, Category {
    case autoSuggestBox, numberBox, passwordBox, richEditBox, richTextBlock, textBlock, textBox
}

enum WindowingCategory: String, Category {
    case appWindow, multipleWindows, titleBar
}