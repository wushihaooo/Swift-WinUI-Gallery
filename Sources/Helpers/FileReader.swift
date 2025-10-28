class FileReader {
    static func readFileFromPath(_ path: String) -> String? {
        do {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            return content
        } catch {
            print("Error reading file at \(path): \(error)")
            return nil
        }
    }
}