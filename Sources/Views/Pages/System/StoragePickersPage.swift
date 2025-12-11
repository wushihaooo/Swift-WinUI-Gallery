// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

import WinUI
import UWP
import Foundation
import WinSDK

// MARK: - File Dialog Helper (Win32 API)

fileprivate struct FileDialogHelper {
    static func showOpenDialog(owner: HWND?, filter: [(String, String)], title: String, multiSelect: Bool = false) -> [URL] {
        var dialog = OPENFILENAMEW()
        dialog.lStructSize = DWORD(MemoryLayout<OPENFILENAMEW>.size)
        dialog.hwndOwner = owner
        
        var fileBuffer = [WCHAR](repeating: 0, count: 32768)
        let fileBufferCount = DWORD(fileBuffer.count)
        
        // 关键：正确构建过滤器字符串
        var filterBuffer: [WCHAR] = []
        for (name, pattern) in filter {
            // 添加描述
            for char in name.utf16 {
                filterBuffer.append(WCHAR(truncatingIfNeeded: char))
            }
            filterBuffer.append(0)
            
            // 添加模式
            for char in pattern.utf16 {
                filterBuffer.append(WCHAR(truncatingIfNeeded: char))
            }
            filterBuffer.append(0)
        }
        filterBuffer.append(0)
        
        var titleBuffer: [WCHAR] = []
        for char in title.utf16 {
            titleBuffer.append(WCHAR(truncatingIfNeeded: char))
        }
        titleBuffer.append(0)
        
        var results: [URL] = []
        let fileBufferSize = fileBuffer.count
        
        fileBuffer.withUnsafeMutableBufferPointer { filePtr in
            filterBuffer.withUnsafeMutableBufferPointer { filterPtr in
                titleBuffer.withUnsafeMutableBufferPointer { titlePtr in
                    dialog.lpstrFile = filePtr.baseAddress
                    dialog.nMaxFile = fileBufferCount
                    dialog.lpstrFilter = UnsafePointer(filterPtr.baseAddress)
                    dialog.lpstrTitle = UnsafePointer(titlePtr.baseAddress)
                    dialog.nFilterIndex = 1
                    
                    var flags = DWORD(OFN_FILEMUSTEXIST | OFN_PATHMUSTEXIST | OFN_NOCHANGEDIR | OFN_EXPLORER | OFN_HIDEREADONLY)
                    if multiSelect {
                        flags |= DWORD(OFN_ALLOWMULTISELECT)
                    }
                    dialog.Flags = flags
                    
                    if GetOpenFileNameW(&dialog) {
                        if let ptr = filePtr.baseAddress {
                            if multiSelect {
                                // 解析多文件路径
                                var offset = 0
                                var directory = ""
                                var fileNames: [String] = []
                                
                                // 第一个字符串是目录
                                var currentString = ""
                                while offset < fileBufferSize {
                                    let wchar = ptr[offset]
                                    if wchar == 0 {
                                        if currentString.isEmpty {
                                            break
                                        }
                                        if directory.isEmpty {
                                            directory = currentString
                                        } else {
                                            fileNames.append(currentString)
                                        }
                                        currentString = ""
                                    } else {
                                        currentString.append(Character(UnicodeScalar(wchar)!))
                                    }
                                    offset += 1
                                }
                                
                                if fileNames.isEmpty {
                                    // 只选择了一个文件
                                    results.append(URL(fileURLWithPath: directory))
                                } else {
                                    // 选择了多个文件
                                    for fileName in fileNames {
                                        let fullPath = directory + "\\" + fileName
                                        results.append(URL(fileURLWithPath: fullPath))
                                    }
                                }
                            } else {
                                // 单文件选择
                                let path = String(decodingCString: ptr, as: UTF16.self)
                                if !path.isEmpty {
                                    results.append(URL(fileURLWithPath: path))
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return results
    }
    
    static func showSaveDialog(owner: HWND?, filter: [(String, String)], title: String, defaultExt: String, suggestedFileName: String) -> URL? {
        var dialog = OPENFILENAMEW()
        dialog.lStructSize = DWORD(MemoryLayout<OPENFILENAMEW>.size)
        dialog.hwndOwner = owner
        
        var fileBuffer = [WCHAR](repeating: 0, count: 32768)
        let fileBufferCount = DWORD(fileBuffer.count)
        
        // 预填充建议的文件名
        if !suggestedFileName.isEmpty {
            let nameChars = Array(suggestedFileName.utf16.map { WCHAR(truncatingIfNeeded: $0) })
            for (index, char) in nameChars.enumerated() {
                if index < fileBuffer.count - 1 {
                    fileBuffer[index] = char
                }
            }
        }
        
        // 构建过滤器
        var filterBuffer: [WCHAR] = []
        for (name, pattern) in filter {
            for char in name.utf16 {
                filterBuffer.append(WCHAR(truncatingIfNeeded: char))
            }
            filterBuffer.append(0)
            for char in pattern.utf16 {
                filterBuffer.append(WCHAR(truncatingIfNeeded: char))
            }
            filterBuffer.append(0)
        }
        filterBuffer.append(0)
        
        var titleBuffer: [WCHAR] = []
        for char in title.utf16 {
            titleBuffer.append(WCHAR(truncatingIfNeeded: char))
        }
        titleBuffer.append(0)
        
        var defaultExtBuffer: [WCHAR] = []
        for char in defaultExt.utf16 {
            defaultExtBuffer.append(WCHAR(truncatingIfNeeded: char))
        }
        defaultExtBuffer.append(0)
        
        var result: URL? = nil
        
        fileBuffer.withUnsafeMutableBufferPointer { filePtr in
            filterBuffer.withUnsafeMutableBufferPointer { filterPtr in
                titleBuffer.withUnsafeMutableBufferPointer { titlePtr in
                    defaultExtBuffer.withUnsafeMutableBufferPointer { extPtr in
                        dialog.lpstrFile = filePtr.baseAddress
                        dialog.nMaxFile = fileBufferCount
                        dialog.lpstrFilter = UnsafePointer(filterPtr.baseAddress)
                        dialog.lpstrTitle = UnsafePointer(titlePtr.baseAddress)
                        dialog.lpstrDefExt = UnsafePointer(extPtr.baseAddress)
                        dialog.nFilterIndex = 1
                        dialog.Flags = DWORD(OFN_PATHMUSTEXIST | OFN_OVERWRITEPROMPT | OFN_NOCHANGEDIR | OFN_EXPLORER | OFN_HIDEREADONLY)
                        
                        if GetSaveFileNameW(&dialog) {
                            if let ptr = filePtr.baseAddress {
                                let path = String(decodingCString: ptr, as: UTF16.self)
                                if !path.isEmpty {
                                    result = URL(fileURLWithPath: path)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return result
    }
    
    static func showFolderDialog(owner: HWND?, title: String) -> URL? {
        // 使用SHBrowseForFolder API选择文件夹
        var bi = BROWSEINFOW()
        bi.hwndOwner = owner
        bi.ulFlags = UINT(BIF_RETURNONLYFSDIRS | BIF_NEWDIALOGSTYLE | BIF_USENEWUI)
        
        var titleBuffer: [WCHAR] = []
        for char in title.utf16 {
            titleBuffer.append(WCHAR(truncatingIfNeeded: char))
        }
        titleBuffer.append(0)
        
        var result: URL? = nil
        
        titleBuffer.withUnsafeMutableBufferPointer { titlePtr in
            bi.lpszTitle = UnsafePointer(titlePtr.baseAddress)
            
            if let pidl = SHBrowseForFolderW(&bi) {
                var pathBuffer = [WCHAR](repeating: 0, count: 32768)
                pathBuffer.withUnsafeMutableBufferPointer { pathPtr in
                    if SHGetPathFromIDListW(pidl, pathPtr.baseAddress) {
                        if let ptr = pathPtr.baseAddress {
                            let path = String(decodingCString: ptr, as: UTF16.self)
                            if !path.isEmpty {
                                result = URL(fileURLWithPath: path)
                            }
                        }
                    }
                }
                CoTaskMemFree(pidl)
            }
        }
        
        return result
    }
}

// MARK: - StoragePickersPage

@MainActor
class StoragePickersPage: Grid {
    private var page: Page = Page()
    
    // Pick Single File Section - UI Elements
    private var pickSingleFileButton: Button?
    private var pickedSingleFileTextBlock: TextBlock?
    private var fileTypeComboBox1: ComboBox?
    private var commitButtonTextTextBox: TextBox?
    private var pickerLocationComboBox1: ComboBox?
    private var pickerViewModeComboBox1: ComboBox?
    
    // Pick Multiple Files Section - UI Elements
    private var pickMultipleFilesButton: Button?
    private var pickedMultipleFilesTextBlock: TextBlock?
    private var fileTypeComboBox2: ComboBox?
    private var commitButtonTextTextBox2: TextBox?
    private var pickerLocationComboBox2: ComboBox?
    private var pickerViewModeComboBox2: ComboBox?
    
    // Save File Section - UI Elements
    private var fileContentTextBox: TextBox?
    private var saveFileButton: Button?
    private var savedFileTextBlock: TextBlock?
    private var txtCheckBox: CheckBox?
    private var jsonCheckBox: CheckBox?
    private var xmlCheckBox: CheckBox?
    private var defaultExtensionComboBox: ComboBox?
    private var suggestedFileNameTextBox: TextBox?
    private var commitButtonTextTextBox3: TextBox?
    private var pickerLocationComboBox3: ComboBox?
    private var suggestedFolderTextBox: TextBox?
    
    // Pick Folder Section - UI Elements
    private var pickFolderButton: Button?
    private var pickedFolderTextBlock: TextBlock?
    private var commitButtonTextTextBox4: TextBox?
    private var pickerLocationComboBox4: ComboBox?
    private var pickerViewModeComboBox3: ComboBox?
    
    // Enum arrays for ComboBox binding
    private var pickerLocationIds: [PickerLocationId] = []
    private var pickerViewModes: [PickerViewMode] = []
    
    override init() {
        super.init()
        
        // 初始化枚举数组 - 手动列举所有值
        pickerLocationIds = [
            .documentsLibrary,
            .computerFolder,
            .desktop,
            .downloads,
            .homeGroup,
            .musicLibrary,
            .picturesLibrary,
            .videosLibrary,
            .objects3D,
            .unspecified
        ]
        pickerViewModes = [.list, .thumbnail]
        
        nonisolated(unsafe) let unsafeSelf = self
        
        Task { @MainActor in
            await unsafeSelf.initializeUI()
        }
    }
    
    @MainActor
    private func initializeUI() async {
        print("=== StoragePickersPage Initialization ===")
        
        if let filePath = Bundle.module.path(
            forResource: "StoragePickersPage", 
            ofType: "xaml", 
            inDirectory: "Assets/xaml"
        ) {
            print("XAML file path: \(filePath)")
            
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("✅ XAML file exists")
                await loadXamlFromFile(filePath: filePath)
            } else {
                print("❌ XAML file does not exist at path: \(filePath)")
                createSimpleUI()
            }
        } else {
            print("❌ Could not find XAML file path in bundle")
            createSimpleUI()
        }
        
        if self.children.count == 0 {
            self.children.append(page)
        }
        
        print("✅ StoragePickersPage initialized successfully")
    }
    
    @MainActor
    private func createSimpleUI() {
        let mainStack = StackPanel()
        mainStack.margin = Thickness(left: 36, top: 0, right: 36, bottom: 0)
        
        // InfoBar - 简化版本
        let infoBar = InfoBar()
        infoBar.isClosable = false
        infoBar.isOpen = true
        infoBar.margin = Thickness(left: 0, top: 8, right: 0, bottom: 0)
        infoBar.title = "Picker Behavior"
        infoBar.message = "The picker reopens in the last selected location and view. SuggestedStartLocation and ViewMode are only applied the first time the picker is opened (for example, right after app installation or when no previous selection exists)."
        mainStack.children.append(infoBar)
        
        // Pick Single File - 使用ControlExample包装
        let exampleContent = createPickSingleFileExample()
        let optionsContent = createPickSingleFileOptions()
        
        let controlExample = ControlExample()
        controlExample.headerText = "Pick single file"
        controlExample.example = exampleContent
        controlExample.options = optionsContent
        mainStack.children.append(controlExample.view)
        // let controlExample = ControlExample(
        //     headerText: "Pick single file",
        //     isOutputDisplay: false,
        //     isOptionsDisplay: true,
        //     contentPresenter: exampleContent,
        //     optionsPresenter: optionsContent
        // )
        // mainStack.children.append(controlExample.controlExample)
        
        // Pick Multiple Files - 使用ControlExample包装
        let multipleExampleContent = createPickMultipleFilesExample()
        let multipleOptionsContent = createPickMultipleFilesOptions()
        
        let multipleControlExample = ControlExample()
        multipleControlExample.headerText = "Pick multiple files"
        multipleControlExample.example = multipleExampleContent
        multipleControlExample.options = multipleOptionsContent
        mainStack.children.append(multipleControlExample.view)
        
        // Save File - 使用ControlExample包装
        let saveExampleContent = createSaveFileExample()
        let saveOptionsContent = createSaveFileOptions()
        
        let saveControlExample = ControlExample()
        saveControlExample.headerText = "Save file"
        saveControlExample.example = saveExampleContent
        saveControlExample.options = saveOptionsContent
        mainStack.children.append(saveControlExample.view)
        
        // Pick Folder - 使用ControlExample包装
        let folderExampleContent = createPickFolderExample()
        let folderOptionsContent = createPickFolderOptions()
        
        let folderControlExample = ControlExample()
        folderControlExample.headerText = "Pick folder"
        folderControlExample.example = folderExampleContent
        folderControlExample.options = folderOptionsContent
        mainStack.children.append(folderControlExample.view)
        
        // 将mainStack包装在ScrollViewer中
        let scrollViewer = ScrollViewer()
        scrollViewer.content = mainStack
        
        page.content = scrollViewer
        
        setupEventHandlers()
    }
    
    @MainActor
    private func createPickSingleFileExample() -> StackPanel {
        let exampleStack = StackPanel()
        exampleStack.spacing = 8
        
        let pickButton = Button()
        pickButton.content = "Pick a single file"
        pickButton.name = "PickSingleFileButton"
        exampleStack.children.append(pickButton)
        
        let resultText = TextBlock()
        resultText.text = "No file picked"
        resultText.name = "PickedSingleFileTextBlock"
        resultText.textWrapping = .wrap
        exampleStack.children.append(resultText)
        
        self.pickSingleFileButton = pickButton
        self.pickedSingleFileTextBlock = resultText
        
        return exampleStack
    }
    
    @MainActor
    private func createPickSingleFileOptions() -> StackPanel {
        let optionsStack = StackPanel()
        optionsStack.spacing = 8
        
        // File Type ComboBox - 完全按照原版
        let fileTypeCombo = ComboBox()
        fileTypeCombo.name = "FileTypeComboBox1"
        fileTypeCombo.header = "File type"
        fileTypeCombo.width = 200
        fileTypeCombo.horizontalAlignment = .left
        
        // 按照原版XAML的顺序和内容
        let allItem = ComboBoxItem()
        allItem.content = "All Files (*)"
        allItem.tag = "*"
        allItem.isSelected = true
        fileTypeCombo.items.append(allItem)
        
        let txtItem = ComboBoxItem()
        txtItem.content = "Text Files (*.txt)"
        txtItem.tag = ".txt"
        fileTypeCombo.items.append(txtItem)
        
        let imgItem = ComboBoxItem()
        imgItem.content = "Images (*.jpg, *.png)"
        imgItem.tag = "images"
        fileTypeCombo.items.append(imgItem)
        
        optionsStack.children.append(fileTypeCombo)
        
        // Commit Button Text
        let commitTextBox = TextBox()
        commitTextBox.name = "CommitButtonTextTextBox"
        commitTextBox.header = "Commit button text"
        commitTextBox.placeholderText = "Open"
        commitTextBox.text = "Pick File"
        commitTextBox.width = 200
        commitTextBox.horizontalAlignment = .left
        optionsStack.children.append(commitTextBox)
        
        // Suggested Start Location - 按原版顺序和显示
        let locationCombo = ComboBox()
        locationCombo.name = "PickerLocationComboBox1"
        locationCombo.header = "Suggested start location"
        locationCombo.width = 200
        locationCombo.horizontalAlignment = .left
        
        // 按照原版的顺序和显示名称
        let locationItems: [(PickerLocationId, String)] = [
            (.documentsLibrary, "DocumentsLibrary"),
            (.computerFolder, "ComputerFolder"),
            (.desktop, "Desktop"),
            (.downloads, "Downloads"),
            (.homeGroup, "HomeGroup"),
            (.musicLibrary, "MusicLibrary"),
            (.picturesLibrary, "PicturesLibrary"),
            (.videosLibrary, "VideosLibrary"),
            (.objects3D, "Objects3D"),
            (.unspecified, "Unspecified")
        ]
        
        for (index, (location, displayName)) in locationItems.enumerated() {
            let item = ComboBoxItem()
            item.content = displayName
            item.tag = location
            locationCombo.items.append(item)
            if location == .documentsLibrary {
                item.isSelected = true
                locationCombo.selectedIndex = Int32(index)
            }
        }
        optionsStack.children.append(locationCombo)
        
        // View Mode - 只有List和Thumbnail
        let viewModeCombo = ComboBox()
        viewModeCombo.name = "PickerViewModeComboBox1"
        viewModeCombo.header = "View mode"
        viewModeCombo.width = 200
        viewModeCombo.horizontalAlignment = .left
        
        let viewModeItems: [(PickerViewMode, String)] = [
            (.list, "List"),
            (.thumbnail, "Thumbnail")
        ]
        
        for (index, (mode, displayName)) in viewModeItems.enumerated() {
            let item = ComboBoxItem()
            item.content = displayName
            item.tag = mode
            viewModeCombo.items.append(item)
            if mode == .list {
                item.isSelected = true
                viewModeCombo.selectedIndex = Int32(index)
            }
        }
        optionsStack.children.append(viewModeCombo)
        
        // Store refs
        self.fileTypeComboBox1 = fileTypeCombo
        self.commitButtonTextTextBox = commitTextBox
        self.pickerLocationComboBox1 = locationCombo
        self.pickerViewModeComboBox1 = viewModeCombo
        
        return optionsStack
    }
    
    @MainActor
    private func createPickMultipleFilesExample() -> StackPanel {
        let exampleStack = StackPanel()
        exampleStack.spacing = 8
        
        let pickButton = Button()
        pickButton.content = "Pick multiple files"
        pickButton.name = "PickMultipleFilesButton"
        exampleStack.children.append(pickButton)
        
        let resultText = TextBlock()
        resultText.text = "No files picked"
        resultText.name = "PickedMultipleFilesTextBlock"
        resultText.textWrapping = .wrap
        exampleStack.children.append(resultText)
        
        self.pickMultipleFilesButton = pickButton
        self.pickedMultipleFilesTextBlock = resultText
        
        return exampleStack
    }
    
    @MainActor
    private func createPickMultipleFilesOptions() -> StackPanel {
        let optionsStack = StackPanel()
        optionsStack.spacing = 8
        
        // File Type ComboBox
        let fileTypeCombo = ComboBox()
        fileTypeCombo.name = "FileTypeComboBox2"
        fileTypeCombo.header = "File type"
        fileTypeCombo.width = 200
        fileTypeCombo.horizontalAlignment = .left
        
        let allItem = ComboBoxItem()
        allItem.content = "All Files (*)"
        allItem.tag = "*"
        allItem.isSelected = true
        fileTypeCombo.items.append(allItem)
        
        let txtItem = ComboBoxItem()
        txtItem.content = "Text Files (*.txt)"
        txtItem.tag = ".txt"
        fileTypeCombo.items.append(txtItem)
        
        let imgItem = ComboBoxItem()
        imgItem.content = "Images (*.jpg, *.png)"
        imgItem.tag = "images"
        fileTypeCombo.items.append(imgItem)
        
        optionsStack.children.append(fileTypeCombo)
        
        // Commit Button Text
        let commitTextBox = TextBox()
        commitTextBox.name = "CommitButtonTextTextBox2"
        commitTextBox.header = "Commit button text"
        commitTextBox.placeholderText = "Open"
        commitTextBox.text = "Pick Files"
        commitTextBox.width = 200
        commitTextBox.horizontalAlignment = .left
        optionsStack.children.append(commitTextBox)
        
        // Suggested Start Location
        let locationCombo = ComboBox()
        locationCombo.name = "PickerLocationComboBox2"
        locationCombo.header = "Suggested start location"
        locationCombo.width = 200
        locationCombo.horizontalAlignment = .left
        
        let locationItems: [(PickerLocationId, String)] = [
            (.documentsLibrary, "DocumentsLibrary"),
            (.computerFolder, "ComputerFolder"),
            (.desktop, "Desktop"),
            (.downloads, "Downloads"),
            (.homeGroup, "HomeGroup"),
            (.musicLibrary, "MusicLibrary"),
            (.picturesLibrary, "PicturesLibrary"),
            (.videosLibrary, "VideosLibrary"),
            (.objects3D, "Objects3D"),
            (.unspecified, "Unspecified")
        ]
        
        for (index, (location, displayName)) in locationItems.enumerated() {
            let item = ComboBoxItem()
            item.content = displayName
            item.tag = location
            locationCombo.items.append(item)
            if location == .documentsLibrary {
                item.isSelected = true
                locationCombo.selectedIndex = Int32(index)
            }
        }
        optionsStack.children.append(locationCombo)
        
        // View Mode
        let viewModeCombo = ComboBox()
        viewModeCombo.name = "PickerViewModeComboBox2"
        viewModeCombo.header = "View mode"
        viewModeCombo.width = 200
        viewModeCombo.horizontalAlignment = .left
        
        let viewModeItems: [(PickerViewMode, String)] = [
            (.list, "List"),
            (.thumbnail, "Thumbnail")
        ]
        
        for (index, (mode, displayName)) in viewModeItems.enumerated() {
            let item = ComboBoxItem()
            item.content = displayName
            item.tag = mode
            viewModeCombo.items.append(item)
            if mode == .list {
                item.isSelected = true
                viewModeCombo.selectedIndex = Int32(index)
            }
        }
        optionsStack.children.append(viewModeCombo)
        
        // Store refs
        self.fileTypeComboBox2 = fileTypeCombo
        self.commitButtonTextTextBox2 = commitTextBox
        self.pickerLocationComboBox2 = locationCombo
        self.pickerViewModeComboBox2 = viewModeCombo
        
        return optionsStack
    }
    
    @MainActor
    private func createSaveFileExample() -> StackPanel {
        let exampleStack = StackPanel()
        exampleStack.spacing = 8
        
        // File Content TextBox
        let contentTextBox = TextBox()
        contentTextBox.name = "FileContentTextBox"
        contentTextBox.header = "File content"
        contentTextBox.text = "Hello, WinUI!"
        contentTextBox.textWrapping = .wrap
        contentTextBox.acceptsReturn = true
        contentTextBox.width = 500
        contentTextBox.height = 200
        contentTextBox.horizontalAlignment = .left
        exampleStack.children.append(contentTextBox)
        
        let saveButton = Button()
        saveButton.content = "Save a file"
        saveButton.name = "SaveFileButton"
        exampleStack.children.append(saveButton)
        
        let resultText = TextBlock()
        resultText.text = "No file saved"
        resultText.name = "SavedFileTextBlock"
        resultText.textWrapping = .wrap
        exampleStack.children.append(resultText)
        
        self.fileContentTextBox = contentTextBox
        self.saveFileButton = saveButton
        self.savedFileTextBlock = resultText
        
        return exampleStack
    }
    
    @MainActor
    private func createSaveFileOptions() -> StackPanel {
        let optionsStack = StackPanel()
        optionsStack.spacing = 8
        
        // File Type CheckBoxes
        let txtCheckBox = CheckBox()
        txtCheckBox.name = "TxtCheckBox"
        txtCheckBox.content = "Text Files (*.txt)"
        txtCheckBox.isChecked = true
        optionsStack.children.append(txtCheckBox)
        
        let jsonCheckBox = CheckBox()
        jsonCheckBox.name = "JsonCheckBox"
        jsonCheckBox.content = "JSON Files (*.json)"
        optionsStack.children.append(jsonCheckBox)
        
        let xmlCheckBox = CheckBox()
        xmlCheckBox.name = "XmlCheckBox"
        xmlCheckBox.content = "XML Files (*.xml)"
        optionsStack.children.append(xmlCheckBox)
        
        // Default Extension ComboBox
        let defaultExtCombo = ComboBox()
        defaultExtCombo.name = "DefaultExtensionComboBox"
        defaultExtCombo.header = "Default extension"
        defaultExtCombo.width = 200
        defaultExtCombo.horizontalAlignment = .left
        defaultExtCombo.selectedIndex = 0
        
        let txtExt = ComboBoxItem()
        txtExt.content = ".txt"
        txtExt.isSelected = true
        defaultExtCombo.items.append(txtExt)
        
        let jsonExt = ComboBoxItem()
        jsonExt.content = ".json"
        defaultExtCombo.items.append(jsonExt)
        
        let xmlExt = ComboBoxItem()
        xmlExt.content = ".xml"
        defaultExtCombo.items.append(xmlExt)
        
        optionsStack.children.append(defaultExtCombo)
        
        // Suggested File Name TextBox
        let fileNameTextBox = TextBox()
        fileNameTextBox.name = "SuggestedFileNameTextBox"
        fileNameTextBox.header = "Suggested file name"
        fileNameTextBox.text = "NewDocument"
        fileNameTextBox.width = 200
        fileNameTextBox.horizontalAlignment = .left
        optionsStack.children.append(fileNameTextBox)
        
        // Commit Button Text
        let commitTextBox = TextBox()
        commitTextBox.name = "CommitButtonTextTextBox3"
        commitTextBox.header = "Commit button text"
        commitTextBox.placeholderText = "Save"
        commitTextBox.text = "Save File"
        commitTextBox.width = 200
        commitTextBox.horizontalAlignment = .left
        optionsStack.children.append(commitTextBox)
        
        // Suggested Start Location
        let locationCombo = ComboBox()
        locationCombo.name = "PickerLocationComboBox3"
        locationCombo.header = "Suggested start location"
        locationCombo.width = 200
        locationCombo.horizontalAlignment = .left
        
        let locationItems: [(PickerLocationId, String)] = [
            (.documentsLibrary, "DocumentsLibrary"),
            (.computerFolder, "ComputerFolder"),
            (.desktop, "Desktop"),
            (.downloads, "Downloads"),
            (.homeGroup, "HomeGroup"),
            (.musicLibrary, "MusicLibrary"),
            (.picturesLibrary, "PicturesLibrary"),
            (.videosLibrary, "VideosLibrary"),
            (.objects3D, "Objects3D"),
            (.unspecified, "Unspecified")
        ]
        
        for (index, (location, displayName)) in locationItems.enumerated() {
            let item = ComboBoxItem()
            item.content = displayName
            item.tag = location
            locationCombo.items.append(item)
            if location == .documentsLibrary {
                item.isSelected = true
                locationCombo.selectedIndex = Int32(index)
            }
        }
        optionsStack.children.append(locationCombo)
        
        // Suggested Folder TextBox (read-only)
        let folderTextBox = TextBox()
        folderTextBox.name = "SuggestedFolderTextBox"
        folderTextBox.header = "Suggested folder"
        folderTextBox.width = 200
        folderTextBox.placeholderText = "Optional"
        folderTextBox.isReadOnly = true
        folderTextBox.horizontalAlignment = .left
        optionsStack.children.append(folderTextBox)
        
        // Store refs
        self.txtCheckBox = txtCheckBox
        self.jsonCheckBox = jsonCheckBox
        self.xmlCheckBox = xmlCheckBox
        self.defaultExtensionComboBox = defaultExtCombo
        self.suggestedFileNameTextBox = fileNameTextBox
        self.commitButtonTextTextBox3 = commitTextBox
        self.pickerLocationComboBox3 = locationCombo
        self.suggestedFolderTextBox = folderTextBox
        
        return optionsStack
    }
    
    @MainActor
    private func createPickFolderExample() -> StackPanel {
        let exampleStack = StackPanel()
        exampleStack.spacing = 8
        
        let pickButton = Button()
        pickButton.content = "Pick a folder"
        pickButton.name = "PickFolderButton"
        exampleStack.children.append(pickButton)
        
        let resultText = TextBlock()
        resultText.text = "No folder picked"
        resultText.name = "PickedFolderTextBlock"
        resultText.textWrapping = .wrap
        exampleStack.children.append(resultText)
        
        self.pickFolderButton = pickButton
        self.pickedFolderTextBlock = resultText
        
        return exampleStack
    }
    
    @MainActor
    private func createPickFolderOptions() -> StackPanel {
        let optionsStack = StackPanel()
        optionsStack.spacing = 8
        
        // Commit Button Text
        let commitTextBox = TextBox()
        commitTextBox.name = "CommitButtonTextTextBox4"
        commitTextBox.header = "Commit button text"
        commitTextBox.placeholderText = "Select Folder"
        commitTextBox.text = "Pick Folder"
        commitTextBox.width = 200
        commitTextBox.horizontalAlignment = .left
        optionsStack.children.append(commitTextBox)
        
        // Suggested Start Location
        let locationCombo = ComboBox()
        locationCombo.name = "PickerLocationComboBox4"
        locationCombo.header = "Suggested start location"
        locationCombo.width = 200
        locationCombo.horizontalAlignment = .left
        
        let locationItems: [(PickerLocationId, String)] = [
            (.documentsLibrary, "DocumentsLibrary"),
            (.computerFolder, "ComputerFolder"),
            (.desktop, "Desktop"),
            (.downloads, "Downloads"),
            (.homeGroup, "HomeGroup"),
            (.musicLibrary, "MusicLibrary"),
            (.picturesLibrary, "PicturesLibrary"),
            (.videosLibrary, "VideosLibrary"),
            (.objects3D, "Objects3D"),
            (.unspecified, "Unspecified")
        ]
        
        for (index, (location, displayName)) in locationItems.enumerated() {
            let item = ComboBoxItem()
            item.content = displayName
            item.tag = location
            locationCombo.items.append(item)
            if location == .documentsLibrary {
                item.isSelected = true
                locationCombo.selectedIndex = Int32(index)
            }
        }
        optionsStack.children.append(locationCombo)
        
        // View Mode
        let viewModeCombo = ComboBox()
        viewModeCombo.name = "PickerViewModeComboBox3"
        viewModeCombo.header = "View mode"
        viewModeCombo.width = 200
        viewModeCombo.horizontalAlignment = .left
        
        let viewModeItems: [(PickerViewMode, String)] = [
            (.list, "List"),
            (.thumbnail, "Thumbnail")
        ]
        
        for (index, (mode, displayName)) in viewModeItems.enumerated() {
            let item = ComboBoxItem()
            item.content = displayName
            item.tag = mode
            viewModeCombo.items.append(item)
            if mode == .list {
                item.isSelected = true
                viewModeCombo.selectedIndex = Int32(index)
            }
        }
        optionsStack.children.append(viewModeCombo)
        
        // Store refs
        self.commitButtonTextTextBox4 = commitTextBox
        self.pickerLocationComboBox4 = locationCombo
        self.pickerViewModeComboBox3 = viewModeCombo
        
        return optionsStack
    }
    
    @MainActor
    private func loadXamlFromFile(filePath: String) async {
        do {
            let xamlContent = try String(contentsOfFile: filePath, encoding: .utf8)
            print("XAML content loaded, length: \(xamlContent.count)")
            
            if let loadedPage = try? XamlReader.load(xamlContent) as? Page {
                self.page = loadedPage
                print("✅ XAML parsed successfully")
                
                findControls()
                setupEventHandlers()
            } else {
                print("❌ Failed to parse XAML as Page")
                createSimpleUI()
            }
        } catch {
            print("❌ Error loading XAML: \(error)")
            createSimpleUI()
        }
    }
    
    @MainActor
    private func findControls() {
        pickSingleFileButton = findElementByName(page.content, name: "PickSingleFileButton") as? Button
        pickedSingleFileTextBlock = findElementByName(page.content, name: "PickedSingleFileTextBlock") as? TextBlock
        fileTypeComboBox1 = findElementByName(page.content, name: "FileTypeComboBox1") as? ComboBox
        commitButtonTextTextBox = findElementByName(page.content, name: "CommitButtonTextTextBox") as? TextBox
        pickerLocationComboBox1 = findElementByName(page.content, name: "PickerLocationComboBox1") as? ComboBox
        pickerViewModeComboBox1 = findElementByName(page.content, name: "PickerViewModeComboBox1") as? ComboBox
        
        print("Controls found:")
        print("- pickSingleFileButton: \(pickSingleFileButton != nil)")
        print("- pickedSingleFileTextBlock: \(pickedSingleFileTextBlock != nil)")
        print("- fileTypeComboBox1: \(fileTypeComboBox1 != nil)")
        print("- commitButtonTextTextBox: \(commitButtonTextTextBox != nil)")
        print("- pickerLocationComboBox1: \(pickerLocationComboBox1 != nil)")
        print("- pickerViewModeComboBox1: \(pickerViewModeComboBox1 != nil)")
    }
    
    @MainActor
    private func setupEventHandlers() {
        guard let button = pickSingleFileButton else { 
            return 
        }
        
        _ = button.click.addHandler { [weak self] sender, _ in
            guard let self = self else { return }
            self.handlePickSingleFile()
        }
        
        // Pick Multiple Files button
        if let multipleButton = pickMultipleFilesButton {
            _ = multipleButton.click.addHandler { [weak self] sender, _ in
                guard let self = self else { return }
                self.handlePickMultipleFiles()
            }
        }
        
        // Save File button
        if let saveButton = saveFileButton {
            _ = saveButton.click.addHandler { [weak self] sender, _ in
                guard let self = self else { return }
                self.handleSaveFile()
            }
        }
        
        // Pick Folder button
        if let folderButton = pickFolderButton {
            _ = folderButton.click.addHandler { [weak self] sender, _ in
                guard let self = self else { return }
                self.handlePickFolder()
            }
        }
    }
    
    // MARK: - 文件选择处理
    
    @MainActor
    private func handlePickSingleFile() {
        guard let button = pickSingleFileButton else { return }
        
        button.isEnabled = false
        
        var hwnd: HWND? = nil
        if let xamlRoot = button.xamlRoot {
            hwnd = HWND(bitPattern: Int(xamlRoot.contentIslandEnvironment.appWindowId.value))
        }
        
        // 根据ComboBox选择构建过滤器
        var filter: [(String, String)] = [("All Files", "*.*")]
        
        if let combo = fileTypeComboBox1, combo.selectedIndex >= 0 {
            let index = combo.selectedIndex
            
            switch index {
            case 0: // All Files (*)
                filter = [("All Files", "*.*")]
            case 1: // Text Files (*.txt)
                filter = [("Text Files", "*.txt")]
            case 2: // Images (*.jpg, *.png)
                filter = [("Image Files", "*.jpg;*.png")]
            default:
                filter = [("All Files", "*.*")]
            }
        }
        
        let commitText = commitButtonTextTextBox?.text ?? "Pick File"
        
        let urls = FileDialogHelper.showOpenDialog(owner: hwnd, filter: filter, title: commitText, multiSelect: false)
        if let url = urls.first {
            self.pickedSingleFileTextBlock?.text = "Picked: \(url.path)"
        } else {
            self.pickedSingleFileTextBlock?.text = "No file selected."
        }
        
        button.isEnabled = true
    }
    
    @MainActor
    private func handlePickMultipleFiles() {
        guard let button = pickMultipleFilesButton else { return }
        
        button.isEnabled = false
        
        var hwnd: HWND? = nil
        if let xamlRoot = button.xamlRoot {
            hwnd = HWND(bitPattern: Int(xamlRoot.contentIslandEnvironment.appWindowId.value))
        }
        
        // 根据ComboBox选择构建过滤器
        var filter: [(String, String)] = [("All Files", "*.*")]
        
        if let combo = fileTypeComboBox2, combo.selectedIndex >= 0 {
            let index = combo.selectedIndex
            
            switch index {
            case 0: // All Files (*)
                filter = [("All Files", "*.*")]
            case 1: // Text Files (*.txt)
                filter = [("Text Files", "*.txt")]
            case 2: // Images (*.jpg, *.png)
                filter = [("Image Files", "*.jpg;*.png")]
            default:
                filter = [("All Files", "*.*")]
            }
        }
        
        let commitText = commitButtonTextTextBox2?.text ?? "Pick Files"
        
        let urls = FileDialogHelper.showOpenDialog(owner: hwnd, filter: filter, title: commitText, multiSelect: true)
        if urls.count > 0 {
            var resultText = ""
            for url in urls {
                resultText += "- Picked: \(url.path)\n"
            }
            self.pickedMultipleFilesTextBlock?.text = resultText
        } else {
            self.pickedMultipleFilesTextBlock?.text = "No files selected."
        }
        
        button.isEnabled = true
    }
    
    @MainActor
    private func handleSaveFile() {
        guard let button = saveFileButton else { return }
        
        button.isEnabled = false
        
        var hwnd: HWND? = nil
        if let xamlRoot = button.xamlRoot {
            hwnd = HWND(bitPattern: Int(xamlRoot.contentIslandEnvironment.appWindowId.value))
        }
        
        // 构建过滤器（根据CheckBox选择）
        var filter: [(String, String)] = []
        
        if txtCheckBox?.isChecked == true {
            filter.append(("Text Files", "*.txt"))
        }
        if jsonCheckBox?.isChecked == true {
            filter.append(("JSON Files", "*.json"))
        }
        if xmlCheckBox?.isChecked == true {
            filter.append(("XML Files", "*.xml"))
        }
        
        if filter.isEmpty {
            filter.append(("All Files", "*.*"))
        }
        
        // 获取默认扩展名
        let defaultExt: String
        if let selectedItem = defaultExtensionComboBox?.selectedItem as? ComboBoxItem,
           let content = selectedItem.content as? String {
            defaultExt = content.hasPrefix(".") ? String(content.dropFirst()) : content
        } else {
            defaultExt = "txt"
        }
        
        let suggestedFileName = suggestedFileNameTextBox?.text ?? "NewDocument"
        let commitText = commitButtonTextTextBox3?.text ?? "Save File"
        
        if let url = FileDialogHelper.showSaveDialog(
            owner: hwnd,
            filter: filter,
            title: commitText,
            defaultExt: defaultExt,
            suggestedFileName: suggestedFileName
        ) {
            // 保存文件
            do {
                let content = fileContentTextBox?.text ?? ""
                try content.write(to: url, atomically: true, encoding: .utf8)
                self.savedFileTextBlock?.text = "File saved to: \(url.path)"
            } catch {
                self.savedFileTextBlock?.text = "Failed to save file: \(error.localizedDescription)"
            }
        } else {
            self.savedFileTextBlock?.text = "File save canceled."
        }
        
        button.isEnabled = true
    }
    
    @MainActor
    private func handlePickFolder() {
        guard let button = pickFolderButton else { return }
        
        button.isEnabled = false
        
        var hwnd: HWND? = nil
        if let xamlRoot = button.xamlRoot {
            hwnd = HWND(bitPattern: Int(xamlRoot.contentIslandEnvironment.appWindowId.value))
        }
        
        let commitText = commitButtonTextTextBox4?.text ?? "Pick Folder"
        
        if let url = FileDialogHelper.showFolderDialog(owner: hwnd, title: commitText) {
            self.pickedFolderTextBlock?.text = "Picked: \(url.path)"
        } else {
            self.pickedFolderTextBlock?.text = "No folder selected."
        }
        
        button.isEnabled = true
    }
    
    // MARK: - Helper Methods
    
    private func findElementByName(_ element: Any?, name: String) -> Any? {
        if let frameworkElement = element as? FrameworkElement {
            if frameworkElement.name == name {
                return frameworkElement
            }
            
            if let panel = element as? Panel {
                for child in panel.children {
                    if let found = findElementByName(child, name: name) {
                        return found
                    }
                }
            }
            
            if let contentControl = element as? ContentControl {
                if let found = findElementByName(contentControl.content, name: name) {
                    return found
                }
            }
            
            if let border = element as? Border {
                if let found = findElementByName(border.child, name: name) {
                    return found
                }
            }
        }
        
        return nil
    }
}
