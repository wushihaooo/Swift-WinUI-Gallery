import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

// WinUI 3 Gallery - System Backdrops (Mica/Acrylic)
final class SystemBackdropsPage: Grid {

    private var mainScrollViewer: ScrollViewer!
    private var contentStackPanel: StackPanel!

    // Keep sample windows alive
    private var sampleWindows: [Window] = []

    override init() {
        super.init()
        setupUI()
    }

    private func setupUI() {
        mainScrollViewer = ScrollViewer()
        mainScrollViewer.horizontalScrollBarVisibility = .disabled
        mainScrollViewer.verticalScrollBarVisibility = .auto

        contentStackPanel = StackPanel()
        contentStackPanel.padding = Thickness(left: 40, top: 24, right: 40, bottom: 40)
        contentStackPanel.spacing = 24

        contentStackPanel.children.append(createHeader())
        contentStackPanel.children.append(createOverview())
        contentStackPanel.children.append(createBackdropTypesSection())
        contentStackPanel.children.append(createMicaControllerSection())
        contentStackPanel.children.append(createDesktopAcrylicControllerSection())

        mainScrollViewer.content = contentStackPanel
        children.append(mainScrollViewer)
    }

    // MARK: - Header

    private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 12

        let titleText = TextBlock()
        titleText.text = "System Backdrops (Mica/Acrylic)"
        titleText.fontSize = 32
        titleText.fontWeight = FontWeights.semiBold
        headerPanel.children.append(titleText)

        let tabsPanel = StackPanel()
        tabsPanel.orientation = .horizontal
        tabsPanel.spacing = 16

        let docText = TextBlock()
        docText.text = "Documentation"
        docText.fontSize = 14
        docText.fontWeight = FontWeights.semiBold
        docText.foreground = createBrush(r: 0, g: 120, b: 215)
        docText.padding = Thickness(left: 0, top: 4, right: 0, bottom: 4)
        tabsPanel.children.append(docText)

        let sourceText = TextBlock()
        sourceText.text = "Source"
        sourceText.fontSize = 14
        sourceText.opacity = 0.6
        sourceText.padding = Thickness(left: 0, top: 4, right: 0, bottom: 4)
        tabsPanel.children.append(sourceText)

        headerPanel.children.append(tabsPanel)
        return headerPanel
    }

    // MARK: - Sections

    private func createOverview() -> TextBlock {
        let desc = TextBlock()
        desc.text = """
System backdrops provide a transparency effect for the window background. Mica and Acrylic are the current supported backdrops. There are two options for applying a backdrop: first, use built-in Mica/Acrylic types, which have no customization and are simple to apply. The second is to create a customizable backdrop, which requires more code.
"""
        desc.fontSize = 14
        desc.textWrapping = .wrap
        desc.opacity = 0.85
        return desc
    }

    private func createBackdropTypesSection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12

        panel.children.append(sectionTitle("Backdrop types"))

        // Card
        let card = createCardBorder(padding: 20)

        let inner = StackPanel()
        inner.spacing = 12

        let text = TextBlock()
        text.textWrapping = .wrap
        text.fontSize = 14
        text.opacity = 0.9
        text.text = """
There are three backdrop types:
1. SystemBackdrop (The base class of every backdrop type)
2. MicaBackdrop (A backdrop that uses the Mica material)
3. DesktopAcrylicBackdrop (A backdrop that uses the Acrylic material)

Mica is an opaque, dynamic material that incorporates theme and desktop wallpaper to paint the background of windows. Mica is specifically designed for app performance as it only samples the desktop wallpaper once to create its visualization. Mica Alt is a variant of Mica, with stronger tinting of the user's desktop background. Recommended when creating an app with a tabbed title bar. All variants of Mica are available for Windows 11 build 22000 or later.

Acrylic is a semi-transparent material that replicates the effect of frosted glass. It is used only for transient, light-dismiss surfaces such as flyouts and context menus. There are two acrylic blend types that change what's visible through the material:
Background acrylic reveals the desktop wallpaper and other windows that are behind the currently active app, adding depth between application windows while celebrating the user's personalization preferences.
In-app acrylic adds a sense of depth within the app frame, providing both focus and hierarchy. (Implemented with a AcrylicBrush in XAML)
"""
        inner.children.append(text)

        let button = Button()
        button.content = "Show sample window"
        button.horizontalAlignment = .left
        button.click.addHandler { [weak self] _, _ in
            self?.openSampleWindow(initialBackdrop: .mica, initialTheme: .dark)
        }
        inner.children.append(button)

        card.child = inner
        panel.children.append(card)

        panel.children.append(makeSourceCodeSection(tabs: [
            ("XAML", backdropTypesXamlSource()),
            ("C#", backdropTypesCSharpSource())
        ]))

        return panel
    }

    private func createMicaControllerSection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12

        panel.children.append(sectionTitle("MicaController"))

        let card = createCardBorder(padding: 20)
        let inner = StackPanel()
        inner.spacing = 12

        let text = TextBlock()
        text.textWrapping = .wrap
        text.fontSize = 14
        text.opacity = 0.9
        text.text = """
Manages rendering and system policy for the mica material. The MicaController class provides a very customizable way to apply the Mica material to an app. This is a list of properties that can be modified: FallbackColor, Kind, LuminosityOpacity, TintColor and the TintOpacity.

There are 2 types of Mica:
1. Base (Lighter)
2. Alt (Darker)
"""
        inner.children.append(text)

        let button = Button()
        button.content = "Show sample window"
        button.horizontalAlignment = .left
        button.click.addHandler { [weak self] _, _ in
            self?.openSampleWindow(initialBackdrop: .micaAlt, initialTheme: .dark)
        }
        inner.children.append(button)

        card.child = inner
        panel.children.append(card)

        panel.children.append(makeSourceCodeSection(tabs: [
            ("C#", micaControllerCSharpSource())
        ]))

        return panel
    }

    private func createDesktopAcrylicControllerSection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12

        panel.children.append(sectionTitle("DesktopAcrylicController"))

        let card = createCardBorder(padding: 20)
        let inner = StackPanel()
        inner.spacing = 12

        let text = TextBlock()
        text.textWrapping = .wrap
        text.fontSize = 14
        text.opacity = 0.9
        text.text = """
Manages rendering and system policy for the background acrylic material. Acrylic has the same level of customization as Mica, but the type can't be changed using the DesktopAcrylicBackdrop class.

There are 2 types of Acrylic:
1. Base (Darker)
2. Thin (Lighter)

If you want to use Acrylic Thin in your app you have to use the DesktopAcrylicController class. The DesktopAcrylicBackdrop class uses the Base type.
"""
        inner.children.append(text)

        let button = Button()
        button.content = "Show sample window"
        button.horizontalAlignment = .left
        button.click.addHandler { [weak self] _, _ in
            self?.openSampleWindow(initialBackdrop: .acrylic, initialTheme: .dark)
        }
        inner.children.append(button)

        card.child = inner
        panel.children.append(card)

        panel.children.append(makeSourceCodeSection(tabs: [
            ("C#", desktopAcrylicControllerCSharpSource())
        ]))

        return panel
    }

    // MARK: - Sample window (interactive like WinUI Gallery)

    private enum BackdropSelection {
        case mica
        case micaAlt
        case acrylic
    }

    private enum ThemeSelection {
        case dark
        case light
        case systemDefault
    }

    private func openSampleWindow(initialBackdrop: BackdropSelection, initialTheme: ThemeSelection) {
        let win = Window()
        win.title = "SystemBackdrop sample window"
        win.extendsContentIntoTitleBar = false

        let root = Grid()
        // Important: leave background unset so the backdrop can show through.
        root.padding = Thickness(left: 24, top: 24, right: 24, bottom: 24)

        let stack = StackPanel()
        stack.spacing = 16
        stack.horizontalAlignment = .center
        stack.verticalAlignment = .center
        stack.maxWidth = 260

        // Current backdrop
        let backdropLabel = TextBlock()
        backdropLabel.text = "Current backdrop"
        backdropLabel.fontSize = 14
        backdropLabel.fontWeight = FontWeights.semiBold
        stack.children.append(backdropLabel)

        let backdropCombo = ComboBox()
        backdropCombo.horizontalAlignment = .stretch
        backdropCombo.items.append(makeComboItem("Mica"))
        backdropCombo.items.append(makeComboItem("Mica Alt"))
        backdropCombo.items.append(makeComboItem("Acrylic"))
        backdropCombo.selectedIndex = Int32(backdropIndex(for: initialBackdrop))
        stack.children.append(backdropCombo)

        // Window theme
        let themeLabel = TextBlock()
        themeLabel.text = "Window theme"
        themeLabel.fontSize = 14
        themeLabel.fontWeight = FontWeights.semiBold
        themeLabel.margin = Thickness(left: 0, top: 6, right: 0, bottom: 0)
        stack.children.append(themeLabel)

        let themeCombo = ComboBox()
        themeCombo.horizontalAlignment = .stretch
        themeCombo.items.append(makeComboItem("Dark"))
        themeCombo.items.append(makeComboItem("Light"))
        themeCombo.items.append(makeComboItem("Default"))
        themeCombo.selectedIndex = Int32(themeIndex(for: initialTheme))
        stack.children.append(themeCombo)

        root.children.append(stack)
        win.content = root

        // Apply initial settings
        applyBackdrop(to: win, selection: initialBackdrop)
        applyTheme(to: root, selection: initialTheme)

        // Wire events
        backdropCombo.selectionChanged.addHandler { [weak self, weak win] _, _ in
            guard let self = self, let win = win else { return }
            let idx = Int(backdropCombo.selectedIndex)
            self.applyBackdrop(to: win, selection: self.backdropSelection(fromIndex: idx))
        }

        themeCombo.selectionChanged.addHandler { [weak self] _, _ in
            guard let self = self else { return }
            let idx = Int(themeCombo.selectedIndex)
            self.applyTheme(to: root, selection: self.themeSelection(fromIndex: idx))
        }

        try? win.activate()
        sampleWindows.append(win)
    }

    private func applyBackdrop(to window: Window, selection: BackdropSelection) {
        switch selection {
        case .mica:
            let mica = MicaBackdrop()
            mica.kind = .base
            window.systemBackdrop = mica

        case .micaAlt:
            let mica = MicaBackdrop()
            mica.kind = .baseAlt
            window.systemBackdrop = mica

        case .acrylic:
            // Some projections may not expose DesktopAcrylicBackdrop type. Use XamlReader.
            let xaml = """
<DesktopAcrylicBackdrop xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" />
"""
            if let backdrop = try? XamlReader.load(xaml) as? SystemBackdrop {
                window.systemBackdrop = backdrop
            } else {
                window.systemBackdrop = nil
            }
        }
    }

    private func applyTheme(to root: Grid, selection: ThemeSelection) {
        // In WinUI, theme is controlled by FrameworkElement.RequestedTheme.
        // This property is projected as `requestedTheme` in Swift WinUI bindings.
        switch selection {
        case .dark:
            root.requestedTheme = .dark
        case .light:
            root.requestedTheme = .light
        case .systemDefault:
            root.requestedTheme = .default
        }
    }

    private func backdropIndex(for s: BackdropSelection) -> Int {
        switch s {
        case .mica: return 0
        case .micaAlt: return 1
        case .acrylic: return 2
        }
    }

    private func themeIndex(for s: ThemeSelection) -> Int {
        switch s {
        case .dark: return 0
        case .light: return 1
        case .systemDefault: return 2
        }
    }

    private func backdropSelection(fromIndex idx: Int) -> BackdropSelection {
        switch idx {
        case 1: return .micaAlt
        case 2: return .acrylic
        default: return .mica
        }
    }

    private func themeSelection(fromIndex idx: Int) -> ThemeSelection {
        switch idx {
        case 1: return .light
        case 2: return .systemDefault
        default: return .dark
        }
    }

    private func makeComboItem(_ text: String) -> ComboBoxItem {
        let item = ComboBoxItem()
        item.content = text
        return item
    }

    // MARK: - Helpers (same style as other pages)

    private func sectionTitle(_ text: String) -> TextBlock {
        let tb = TextBlock()
        tb.text = text
        tb.fontSize = 20
        tb.fontWeight = FontWeights.semiBold
        tb.margin = Thickness(left: 0, top: 12, right: 0, bottom: 0)
        return tb
    }

    private func createCardBorder(padding: Double) -> Border {
        let border = Border()
        border.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = createBrush(r: 200, g: 200, b: 200)
        border.padding = Thickness(left: padding, top: padding, right: padding, bottom: padding)
        return border
    }

    private func makeSourceCodeSection(tabs: [(String, String)]) -> Border {
        let outer = Border()
        outer.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        outer.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        outer.borderBrush = createBrush(r: 200, g: 200, b: 200)
        outer.padding = Thickness(left: 16, top: 16, right: 16, bottom: 16)

        let panel = StackPanel()
        panel.spacing = 8

        let toggle = Button()
        toggle.content = "▼ Source code"
        toggle.horizontalAlignment = .left
        toggle.padding = Thickness(left: 12, top: 8, right: 12, bottom: 8)
        toggle.background = nil
        toggle.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)

        let contentBorder = Border()
        contentBorder.padding = Thickness(left: 0, top: 8, right: 0, bottom: 0)
        contentBorder.visibility = .collapsed

        let tabView = TabView()
        tabView.tabWidthMode = .sizeToContent
        tabView.isAddTabButtonVisible = false
        tabView.canReorderTabs = false

        for (header, code) in tabs {
            let item = TabViewItem()
            item.header = header
            item.isClosable = false

            let tb = TextBox()
            tb.isReadOnly = true
            tb.acceptsReturn = true
            tb.textWrapping = .noWrap
            tb.fontFamily = FontFamily("Cascadia Code, Consolas, monospace")
            tb.fontSize = 12
            tb.borderThickness = Thickness(left: 0, top: 0, right: 0, bottom: 0)
            tb.background = nil
            tb.text = code

            item.content = tb
            tabView.tabItems.append(item)
        }

        contentBorder.child = tabView

        var visible = false
        toggle.click.addHandler { _, _ in
            visible.toggle()
            contentBorder.visibility = visible ? .visible : .collapsed
            toggle.content = visible ? "▲ Source code" : "▼ Source code"
        }

        panel.children.append(toggle)
        panel.children.append(contentBorder)
        outer.child = panel
        return outer
    }

    private func createBrush(r: UInt8, g: UInt8, b: UInt8, a: UInt8 = 255) -> SolidColorBrush {
        let brush = SolidColorBrush()
        var color = UWP.Color()
        color.a = a
        color.r = r
        color.g = g
        color.b = b
        brush.color = color
        return brush
    }

    // MARK: - Source strings

    private func backdropTypesXamlSource() -> String {
        return """
<!-- Mica -->
<Window.SystemBackdrop>
  <MicaBackdrop/>
</Window.SystemBackdrop>

<!-- Mica Alt -->
<Window.SystemBackdrop>
  <MicaBackdrop Kind=\\"BaseAlt\\"/>
</Window.SystemBackdrop>

<!-- Acrylic -->
<Window.SystemBackdrop>
  <DesktopAcrylicBackdrop/>
</Window.SystemBackdrop>
"""
    }

    private func backdropTypesCSharpSource() -> String {
        return """
// Mica
this.SystemBackdrop = new MicaBackdrop();

// Mica Alt
this.SystemBackdrop = new MicaBackdrop { Kind = MicaKind.BaseAlt };

// Acrylic
this.SystemBackdrop = new DesktopAcrylicBackdrop();
"""
    }

    private func micaControllerCSharpSource() -> String {
        return """
using System.Runtime.InteropServices;
using WinRT;
using Microsoft.UI.Composition;
using Microsoft.UI.Composition.SystemBackdrops;

MicaController micaController;
SystemBackdropConfiguration configurationSource;

bool TrySetMicaBackdrop(bool useMicaAlt)
{
    if (MicaController.IsSupported())
    {
        DispatcherQueue.EnsureSystemDispatcherQueue();

        // Hooking up the policy object
        configurationSource = new SystemBackdropConfiguration();
        Activated += Window_Activated;
        Closed += Window_Closed;
        ((FrameworkElement)Content).ActualThemeChanged += Window_ThemeChanged;

        // Initial configuration state
        configurationSource.IsInputActive = true;
        SetConfigurationSourceTheme();

        micaController = new MicaController();
        micaController.Kind = useMicaAlt ? MicaKind.BaseAlt : MicaKind.Base;

        // Enable the system backdrop
        micaController.AddSystemBackdropTarget(this.As<ICompositionSupportsSystemBackdrop>());
        micaController.SetSystemBackdropConfiguration(configurationSource);
        return true; // Succeeded
    }

    return false; // Mica is not supported on this system.
}

private void Window_Activated(object sender, WindowActivatedEventArgs args)
{
    configurationSource.IsInputActive = args.WindowActivationState != WindowActivationState.Deactivated;
}

private void Window_Closed(object sender, WindowEventArgs args)
{
    // Make sure any Mica/Acrylic controller is disposed
    if (micaController != null)
    {
        micaController.Dispose();
        micaController = null;
    }

    Activated -= Window_Activated;
    configurationSource = null;
}

private void Window_ThemeChanged(FrameworkElement sender, object args)
{
    if (configurationSource != null)
    {
        SetConfigurationSourceTheme();
    }
}

private void SetConfigurationSourceTheme()
{
    switch (((FrameworkElement)Content).ActualTheme)
    {
        case ElementTheme.Dark: configurationSource.Theme = SystemBackdropTheme.Dark; break;
        case ElementTheme.Light: configurationSource.Theme = SystemBackdropTheme.Light; break;
        case ElementTheme.Default: configurationSource.Theme = SystemBackdropTheme.Default; break;
    }
}
"""
    }

    private func desktopAcrylicControllerCSharpSource() -> String {
        return """
using System.Runtime.InteropServices;
using WinRT;
using Microsoft.UI.Composition;
using Microsoft.UI.Composition.SystemBackdrops;

DesktopAcrylicController acrylicController;
SystemBackdropConfiguration configurationSource;

bool TrySetAcrylicBackdrop(bool useAcrylicThin)
{
    if (DesktopAcrylicController.IsSupported())
    {
        DispatcherQueue.EnsureSystemDispatcherQueue();

        // Hooking up the policy object
        configurationSource = new SystemBackdropConfiguration();
        Activated += Window_Activated;
        Closed += Window_Closed;
        ((FrameworkElement)Content).ActualThemeChanged += Window_ThemeChanged;

        // Initial configuration state
        configurationSource.IsInputActive = true;
        SetConfigurationSourceTheme();

        acrylicController = new DesktopAcrylicController();
        acrylicController.Kind = useAcrylicThin ? DesktopAcrylicKind.Thin : DesktopAcrylicKind.Base;

        // Enable the system backdrop
        acrylicController.AddSystemBackdropTarget(this.As<ICompositionSupportsSystemBackdrop>());
        acrylicController.SetSystemBackdropConfiguration(configurationSource);
        return true; // Succeeded
    }

    return false; // Acrylic is not supported on this system.
}

private void Window_Activated(object sender, WindowActivatedEventArgs args)
{
    configurationSource.IsInputActive = args.WindowActivationState != WindowActivationState.Deactivated;
}

private void Window_Closed(object sender, WindowEventArgs args)
{
    // Make sure any Mica/Acrylic controller is disposed
    if (acrylicController != null)
    {
        acrylicController.Dispose();
        acrylicController = null;
    }

    Activated -= Window_Activated;
    configurationSource = null;
}

private void Window_ThemeChanged(FrameworkElement sender, object args)
{
    if (configurationSource != null)
    {
        SetConfigurationSourceTheme();
    }
}

private void SetConfigurationSourceTheme()
{
    switch (((FrameworkElement)Content).ActualTheme)
    {
        case ElementTheme.Dark: configurationSource.Theme = SystemBackdropTheme.Dark; break;
        case ElementTheme.Light: configurationSource.Theme = SystemBackdropTheme.Light; break;
        case ElementTheme.Default: configurationSource.Theme = SystemBackdropTheme.Default; break;
    }
}
"""
    }
}
