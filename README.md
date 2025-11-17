# Swift-WinUI-Gallery

A WinUI tempalte application like Microsoft WinUI-Gallery.

# Build

1. copy projections.json and generate-bindings.ps1 to ./build/checkouts/swift-winui to replace origin file, then run generate-bindings.ps1. tips: You may encounter permission access issues.

2. swift build

3. If you want to use WebView2, make sure the WebView2 Runtime is installed on the local machine, and place the following four files in the build/debug folder: WebView2Loader.dll, WebView2Loader.dll.lib, WebView2LoaderStatic.lib, and Microsoft.Web.WebView2.Core.dll.