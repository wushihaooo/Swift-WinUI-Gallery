import Foundation
import WinUI
import WinAppSDK
import UWP
import WindowsFoundation

// WinUI 3 Gallery - Templates (ControlTemplate + UserControl examples)
final class CustomUserControlsPage: Grid {

    private var mainScrollViewer: ScrollViewer!
    private var contentStackPanel: StackPanel!

    // Demo state
    private var incCount: Int = 0
    private var decCount: Int = 0

    private var incCountText: TextBlock!
    private var decCountText: TextBlock!

    private var passwordBox: PasswordBox!
    private var submitButton: Button!
    private var passwordValidationText: TextBlock!

    private var celsiusTextBox: TextBox!
    private var tempResultText: TextBlock!

    override init() {
        super.init()
        setupUI()
    }

    // MARK: - UI

    private func setupUI() {
        mainScrollViewer = ScrollViewer()
        mainScrollViewer.horizontalScrollBarVisibility = .disabled
        mainScrollViewer.verticalScrollBarVisibility = .auto

        contentStackPanel = StackPanel()
        contentStackPanel.padding = Thickness(left: 40, top: 24, right: 40, bottom: 40)
        contentStackPanel.spacing = 24

        contentStackPanel.children.append(createHeader())
        contentStackPanel.children.append(createOverview())

        contentStackPanel.children.append(createTemplatedControlSection())
        contentStackPanel.children.append(createPasswordValidationSection())
        contentStackPanel.children.append(createUserControlSection())

        mainScrollViewer.content = contentStackPanel
        children.append(mainScrollViewer)
    }

    // MARK: - Header

    private func createHeader() -> StackPanel {
        let headerPanel = StackPanel()
        headerPanel.spacing = 12

        let titleText = TextBlock()
        titleText.text = "Custom & User Controls"
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

    // MARK: - Overview

    private func createOverview() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 10

        let desc = TextBlock()
        desc.text = """
Templates let you change the visual structure of controls without changing their logic. In WinUI, you typically use:
• ControlTemplate: redefine how a control is composed (buttons, text, etc.)
• DataTemplate: define how data is visualized in lists and item controls

You can use templates to build reusable components, and pair them with custom controls or UserControls.
"""
        desc.fontSize = 14
        desc.textWrapping = .wrap
        desc.opacity = 0.85
        panel.children.append(desc)

        return panel
    }

    // MARK: - Section 1: Custom (templated) control

    private func createTemplatedControlSection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12

        panel.children.append(sectionTitle("Custom (templated) control"))

        let body = TextBlock()
        body.text = """
A custom control is a reusable component that derives from Control. It provides flexibility through ControlTemplates and supports styling and theming.
"""
        body.fontSize = 14
        body.textWrapping = .wrap
        body.opacity = 0.85
        panel.children.append(body)

        panel.children.append(bulletList([
            "Encapsulation: custom controls encapsulate behavior and UI logic, making them reusable across different projects.",
            "Theming: they support light and dark themes through theme resources."
        ]))

        let keyPoints = TextBlock()
        keyPoints.text = "Key points"
        keyPoints.fontSize = 14
        keyPoints.fontWeight = FontWeights.semiBold
        keyPoints.margin = Thickness(left: 0, top: 8, right: 0, bottom: 0)
        panel.children.append(keyPoints)

        panel.children.append(bulletList([
            "Use Generic.xaml (or a ResourceDictionary) to define the default style of a custom control.",
            "Override OnApplyTemplate() to interact with template parts.",
            "Use DependencyProperty for properties that support data binding."
        ]))

        let demoTitle = TextBlock()
        demoTitle.text = "Counter Control with Increment/Decrement Mode"
        demoTitle.fontSize = 14
        demoTitle.fontWeight = FontWeights.semiBold
        demoTitle.margin = Thickness(left: 0, top: 8, right: 0, bottom: 0)
        panel.children.append(demoTitle)

        panel.children.append(createCounterDemoCard())

        panel.children.append(makeSourceCodeSection(tabs: [
            ("XAML", counterXamlSource()),
            ("C#", counterCSharpSource())
        ]))

        return panel
    }

    private func createCounterDemoCard() -> Border {
        let outer = createCardBorder()

        let container = StackPanel()
        container.spacing = 14

        let row = StackPanel()
        row.orientation = .horizontal
        row.spacing = 24

        // Increment panel
        let incPanel = StackPanel()
        incPanel.spacing = 8

        incCountText = TextBlock()
        incCountText.text = "0"
        incCountText.fontSize = 28
        incCountText.fontWeight = FontWeights.semiBold
        incPanel.children.append(incCountText)

        let incButton = Button()
        incButton.content = "Increase"
        incButton.horizontalAlignment = .left
        incButton.click.addHandler { [weak self] _, _ in
            guard let self = self else { return }
            self.incCount += 1
            self.incCountText.text = "\(self.incCount)"
        }
        incPanel.children.append(incButton)

        // Decrement panel
        let decPanel = StackPanel()
        decPanel.spacing = 8

        decCountText = TextBlock()
        decCountText.text = "0"
        decCountText.fontSize = 28
        decCountText.fontWeight = FontWeights.semiBold
        decPanel.children.append(decCountText)

        let decButton = Button()
        decButton.content = "Decrease"
        decButton.horizontalAlignment = .left
        decButton.click.addHandler { [weak self] _, _ in
            guard let self = self else { return }
            self.decCount -= 1
            self.decCountText.text = "\(self.decCount)"
        }
        decPanel.children.append(decButton)

        row.children.append(incPanel)
        row.children.append(decPanel)

        container.children.append(row)
        outer.child = container
        return outer
    }

    // MARK: - Section 2: Password validation custom control (demo)

    private func createPasswordValidationSection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12

        panel.children.append(sectionTitle("Basic Custom Password Box with Validation"))

        panel.children.append(createPasswordDemoCard())

        panel.children.append(makeSourceCodeSection(tabs: [
            ("XAML", passwordXamlSource()),
            ("C#", passwordCSharpSource())
        ]))

        return panel
    }

    private func createPasswordDemoCard() -> Border {
        let outer = createCardBorder()

        let stack = StackPanel()
        stack.spacing = 12

        let label = TextBlock()
        label.text = "Password"
        label.fontSize = 14
        label.fontWeight = FontWeights.semiBold
        stack.children.append(label)

        passwordBox = PasswordBox()
        // WinUI PasswordBox supports PlaceholderText; projection name may vary by binding.
        passwordBox.placeholderText = "Enter password..."
        passwordBox.width = 240
        stack.children.append(passwordBox)

        submitButton = Button()
        submitButton.content = "Submit"
        submitButton.width = 240
        submitButton.isEnabled = false
        stack.children.append(submitButton)

        passwordValidationText = TextBlock()
        passwordValidationText.text = "Password must be at least 8 characters."
        passwordValidationText.fontSize = 12
        passwordValidationText.foreground = createBrushHex("#C42B1C") // critical-ish
        passwordValidationText.visibility = .collapsed
        stack.children.append(passwordValidationText)

        // Validate as user types
        passwordBox.passwordChanged.addHandler { [weak self] _, _ in
            self?.updatePasswordValidity()
        }

        submitButton.click.addHandler { [weak self] _, _ in
            guard let self = self else { return }
            // simple feedback
            self.passwordValidationText.text = "Submitted ✅"
            self.passwordValidationText.foreground = self.createBrush(r: 0, g: 120, b: 215)
            self.passwordValidationText.visibility = .visible
        }

        outer.child = stack
        return outer
    }

    private func updatePasswordValidity() {
        let pwd = passwordBox.password
        let ok = pwd.count >= 8

        submitButton.isEnabled = ok
        passwordValidationText.text = ok ? "" : "Password must be at least 8 characters."
        passwordValidationText.foreground = createBrushHex("#C42B1C")
        passwordValidationText.visibility = ok ? .collapsed : .visible
    }

    // MARK: - Section 3: UserControl example (demo)

    private func createUserControlSection() -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 12

        panel.children.append(sectionTitle("UserControl"))

        let desc = TextBlock()
        desc.text = "A UserControl is a reusable component that combines existing controls and logic into a cohesive unit. It allows for encapsulation of functionality and a consistent design across multiple instances."
        desc.fontSize = 14
        desc.textWrapping = .wrap
        desc.opacity = 0.85
        panel.children.append(desc)

        let demoTitle = TextBlock()
        demoTitle.text = "Temperature Converter UserControl example"
        demoTitle.fontSize = 14
        demoTitle.fontWeight = FontWeights.semiBold
        demoTitle.margin = Thickness(left: 0, top: 8, right: 0, bottom: 0)
        panel.children.append(demoTitle)

        panel.children.append(createTemperatureDemoCard())

        panel.children.append(makeSourceCodeSection(tabs: [
            ("XAML", userControlXamlSource()),
            ("C#", userControlCSharpSource())
        ]))

        return panel
    }

    private func createTemperatureDemoCard() -> Border {
        let outer = createCardBorder()

        let stack = StackPanel()
        stack.spacing = 12

        let label = TextBlock()
        label.text = "Enter Temperature in Celsius"
        label.fontSize = 14
        label.fontWeight = FontWeights.semiBold
        stack.children.append(label)

        celsiusTextBox = TextBox()
        celsiusTextBox.placeholderText = "Celsius"
        celsiusTextBox.width = 240
        stack.children.append(celsiusTextBox)

        let btn = Button()
        btn.content = "Convert to Fahrenheit"
        btn.width = 240
        btn.click.addHandler { [weak self] _, _ in
            self?.convertTemperature()
        }
        stack.children.append(btn)

        tempResultText = TextBlock()
        tempResultText.text = ""
        tempResultText.fontSize = 14
        tempResultText.opacity = 0.85
        stack.children.append(tempResultText)

        outer.child = stack
        return outer
    }

    private func convertTemperature() {
        let raw = celsiusTextBox.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let c = Double(raw) else {
            tempResultText.text = "Please enter a valid number."
            tempResultText.foreground = createBrushHex("#C42B1C")
            return
        }
        let f = c * 9.0 / 5.0 + 32.0
        tempResultText.text = String(format: "%.1f °F", f)
        tempResultText.foreground = nil
    }

    // MARK: - Helpers (match existing pages)

    private func sectionTitle(_ text: String) -> TextBlock {
        let tb = TextBlock()
        tb.text = text
        tb.fontSize = 20
        tb.fontWeight = FontWeights.semiBold
        tb.margin = Thickness(left: 0, top: 12, right: 0, bottom: 0)
        return tb
    }

    private func bulletList(_ items: [String]) -> StackPanel {
        let panel = StackPanel()
        panel.spacing = 6
        panel.margin = Thickness(left: 0, top: 4, right: 0, bottom: 0)

        for item in items {
            let tb = TextBlock()
            tb.text = "• \(item)"
            tb.fontSize = 14
            tb.textWrapping = .wrap
            tb.opacity = 0.85
            panel.children.append(tb)
        }
        return panel
    }

    private func createCardBorder() -> Border {
        let border = Border()
        border.cornerRadius = CornerRadius(topLeft: 8, topRight: 8, bottomRight: 8, bottomLeft: 8)
        border.borderThickness = Thickness(left: 1, top: 1, right: 1, bottom: 1)
        border.borderBrush = createBrush(r: 200, g: 200, b: 200)
        border.padding = Thickness(left: 24, top: 24, right: 24, bottom: 24)
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

    private func createBrushHex(_ hex: String) -> SolidColorBrush {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("#") { s.removeFirst() }
        if s.count == 3 { s = s.map { "\($0)\($0)" }.joined() }

        func u8(_ i: Int) -> UInt8 {
            let start = s.index(s.startIndex, offsetBy: i)
            let end = s.index(start, offsetBy: 2)
            let part = String(s[start..<end])
            return UInt8(part, radix: 16) ?? 0
        }

        if s.count == 6 {
            return createBrush(r: u8(0), g: u8(2), b: u8(4), a: 255)
        } else if s.count == 8 {
            return createBrush(r: u8(2), g: u8(4), b: u8(6), a: u8(0))
        } else {
            return createBrush(r: 0, g: 0, b: 0, a: 0)
        }
    }

    // MARK: - Source strings

    private func counterXamlSource() -> String {
        return """
<!-- Generic.xaml -->
<ResourceDictionary
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    xmlns:local="using:YourNamespace">

    <!-- Style definition for CounterControl -->
    <Style TargetType="local:CounterControl">
        <Setter Property="Template">
            <Setter.Value>
                <!-- CounterControlTemplate defines the structure of CounterControl -->
                <ControlTemplate TargetType="local:CounterControl">
                    <StackPanel HorizontalAlignment="Left" Spacing="8">
                        <TextBlock x:Name="CountText" FontSize="20" Text="0" HorizontalAlignment="Center" />
                        <Button x:Name="ActionButton" Content="Increase" HorizontalAlignment="Center" Width="100" />
                    </StackPanel>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
</ResourceDictionary>

<!-- YourPage.xaml -->
<Page
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    xmlns:controls="using:YourNamespace">
    <StackPanel Orientation="Horizontal" Spacing="8">
        <controls:CounterControl Mode="Increment" />
        <controls:CounterControl Mode="Decrement" />
    </StackPanel>
</Page>
"""
    }

    private func counterCSharpSource() -> String {
        return """
public enum CounterMode { Increment, Decrement }

public sealed class CounterControl : Control
{
    public CounterMode Mode
    {
        get => (CounterMode)GetValue(ModeProperty);
        set => SetValue(ModeProperty, value);
    }

    public static readonly DependencyProperty ModeProperty =
        DependencyProperty.Register(nameof(Mode), typeof(CounterMode), typeof(CounterControl),
            new PropertyMetadata(CounterMode.Increment));

    private int _count;
    private TextBlock _countText;
    private Button _actionButton;

    public CounterControl()
    {
        DefaultStyleKey = typeof(CounterControl);
    }

    protected override void OnApplyTemplate()
    {
        base.OnApplyTemplate();

        _countText = GetTemplateChild("CountText") as TextBlock;
        _actionButton = GetTemplateChild("ActionButton") as Button;

        if (_actionButton != null)
        {
            _actionButton.Click += (_, __) =>
            {
                _count += (Mode == CounterMode.Increment) ? 1 : -1;
                if (_countText != null) _countText.Text = _count.ToString();
            };
        }
    }
}
"""
    }

    private func passwordXamlSource() -> String {
        return """
<ResourceDictionary
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    xmlns:local="using:YourNamespace">

    <Style TargetType="local:ValidatedPasswordBox">
        <Setter Property="IsTabStop" Value="False" />
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="local:ValidatedPasswordBox">
                    <StackPanel Spacing="4">
                        <PasswordBox x:Name="PasswordInput" />
                        <RichTextBlock x:Name="ValidationRichText"
                                       AutomationProperties.LiveSetting="Polite"
                                       TextWrapping="Wrap"
                                       IsTextSelectionEnabled="False"
                                       Visibility="Collapsed"/>
                    </StackPanel>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
</ResourceDictionary>

<!-- YourPage.xaml -->
<Page xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
      xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
      xmlns:controls="using:YourNamespace">
    <StackPanel Spacing="8">
        <controls:ValidatedPasswordBox x:Name="PasswordInput"
                                       MinLength="8"
                                       Width="240"
                                       HorizontalAlignment="Left"
                                       Header="Password"
                                       PlaceholderText="Enter password..." />
        <Button Content="Submit"
                IsEnabled="{x:Bind PasswordInput.IsValid, Mode=OneWay}"
                Width="240" />
    </StackPanel>
</Page>
"""
    }

    private func passwordCSharpSource() -> String {
        return """
public sealed class ValidatedPasswordBox : Control
{
    public int MinLength
    {
        get => (int)GetValue(MinLengthProperty);
        set => SetValue(MinLengthProperty, value);
    }

    public static readonly DependencyProperty MinLengthProperty =
        DependencyProperty.Register(nameof(MinLength), typeof(int), typeof(ValidatedPasswordBox),
            new PropertyMetadata(8));

    public bool IsValid { get; private set; }

    private PasswordBox _passwordBox;
    private RichTextBlock _validationText;

    public ValidatedPasswordBox()
    {
        DefaultStyleKey = typeof(ValidatedPasswordBox);
    }

    protected override void OnApplyTemplate()
    {
        base.OnApplyTemplate();

        _passwordBox = GetTemplateChild("PasswordInput") as PasswordBox;
        _validationText = GetTemplateChild("ValidationRichText") as RichTextBlock;

        if (_passwordBox != null)
        {
            _passwordBox.PasswordChanged += (_, __) =>
            {
                IsValid = _passwordBox.Password.Length >= MinLength;
                _validationText.Visibility = IsValid ? Visibility.Collapsed : Visibility.Visible;
            };
        }
    }
}
"""
    }

    private func userControlXamlSource() -> String {
        return """
<!-- TemperatureConverterControl.xaml -->
<UserControl
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
    <StackPanel Spacing="8">
        <TextBox Header="Enter Temperature in Celsius"
                 x:Name="InputTextBox"
                 Width="200"
                 PlaceholderText="Celsius" />
        <Button Content="Convert to Fahrenheit"
                Width="200"
                Click="Button_Click" />
        <TextBlock x:Name="ResultTextBlock"
                   FontWeight="SemiBold" />
    </StackPanel>
</UserControl>

<!-- YourPage.xaml -->
<Page xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
      xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
      xmlns:local="using:YourNamespace">
    <Grid>
        <local:TemperatureConverterControl />
    </Grid>
</Page>
"""
    }

    private func userControlCSharpSource() -> String {
        return """
private void Button_Click(object sender, RoutedEventArgs e)
{
    if (double.TryParse(InputTextBox.Text, out var c))
    {
        var f = (c * 9.0 / 5.0) + 32.0;
        ResultTextBlock.Text = $"{f:0.0} °F";
    }
    else
    {
        ResultTextBlock.Text = "Please enter a valid number.";
    }
}
"""
    }
}
