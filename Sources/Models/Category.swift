import Foundation

protocol SubCategory: CaseIterable, Codable, RawRepresentable, Equatable where RawValue == String {
    var text: String { get }
    var sortIndex: Int { get }
}

extension SubCategory {
    var text: String { self.rawValue.capitalized }
    var sortIndex: Int {
        if let index = Self.allCases.firstIndex(of: self) {
            return Self.allCases.distance(from: Self.allCases.startIndex, to: index)
        }
        return 0
    }
}

enum Category: String, CaseIterable, Codable {
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

    var text: String { self.rawValue.capitalized }
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

    var subCategories: [any SubCategory] {
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
            return DataTimeCategory.allCases
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
}

enum FundamentalsCategory: String, SubCategory {
    case resources, styles, binding, templates, customUserControls, scratchPad
}

enum DesignCategory: String , SubCategory {
    case color, geometry, iconography, spacing, typography
}

enum AccessibilityCategory: String, SubCategory {
    case screenReaderSupport, keyBoardSupport, colorContrast
}


enum BasicInputCategory: String, SubCategory {
    case button, dropDownButton, HyperlinkButton, repeatButton, toggleButton, splitButton, toggleSplitButton, checkBox, colorPicker
    case comboBox, radioButton, ratingControl, slider, toggleSwitch
}

enum CollectionsCategory: String, SubCategory {
    case flipView, gridView, itemsRepeater, itemsView, listBox, listView, pullToRefresh, treeView
}


enum DataTimeCategory: String, SubCategory {
    case calendarDataPicker, calendarView, datePicker, timePicker
}

enum DialogsFlyoutsCategory: String, SubCategory {
    case contentDialog, flyout, popup, teachingTip
}

enum LayoutCategory: String, SubCategory {
    case border, canvas, expander, grid, radioButtons, relativePanel, variableSizedWrapGrid, viewBox
}

enum MediaCategory: String, SubCategory {
    case animatedVisualPlayer, captureElementCameraPreview, image, mapControl, mediaPlayerElement 
    case personPicture, sound, webView2
}

enum MenusToolbarsCategory: String, SubCategory {
    case appBarButton, appBarSeparator, appBarToggleButton, commandBar, commandBarFlyout, menuBar, menuFlyout, swipeControl
    case standardUICommand, XamlUICommand
}

enum MotionCategory: String, SubCategory {
    case animationInterop, connectedAnimation, easingFunctions
    case implicitTransitions, pageTransitions, themeTransitions, parallaxView
}

enum NavigationViewCategory: String, SubCategory {
    case breadcrumbBar, navigationView, pivot, selectorBar, tabView
}

enum ScrollingCategory: String, SubCategory {
    case annotatedScrollBar, pipsPager, scrollView, scrollViewer, semanticZoom
}

enum StatusInfoCategory: String, SubCategory {
    case infoBadge, infoBar, progressBar, progressRing, toolTip
}

enum StylesCategory: String, SubCategory {
    case AcrylicBrush, animatedIcon, compactSizing, iconElement, ling, shape, radialGradientBrush
    case systemBackdropsMicaAcrylic, themeShadow
}


enum SystemCategory: String, SubCategory {
    case appNotifications, badgeNotifications, clipboard, contentIsland, filePicker
}

enum TextCategory: String, SubCategory {
    case autoSuggestBox, numberBox, passwordBox, richEditBox, richTextBlock, textBlock, textBox
}

enum WindowingCategory: String, SubCategory {
    case appWindow, multipleWindows, titleBar
}