import Foundation
import Swifter

public class SwifterServer {
    let server = HttpServer()
    
    public init() async throws {
        let loader = URLSession(configuration: .default)
        var files = [Data]()
        for file in 0..<10 {
            files.append(try await ResourceLoader.loadFile(number: file, loader: loader))
        }
        let backingStore = GenericServer(
            manifest: ManifestGenerator(),
            files: files
        )
        server.middleware.append { request in
            do {
                let response = try backingStore.get(path: request.path)
                return .ok(.data(response, contentType: "application/vnd.apple.mpegurl"))
            } catch {
                print(error)
                return .internalServerError
            }
        }
    }
    
    public func start() throws {
        try server.start()
    }    
}
