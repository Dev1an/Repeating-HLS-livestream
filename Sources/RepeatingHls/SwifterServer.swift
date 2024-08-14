import Foundation
import Swifter

@available(macOS 12.0, *)
public class SwifterServer {
    let server = HttpServer()
    
    public init() async throws {
        let loader = URLSession(configuration: .default)
        var files = [Data]()
        for file in 0..<10 {
            files.append(try await Self.loadFile(number: file, loader: loader))
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
    
    static func loadFile(number: Int, loader: URLSession) async throws -> Data {
        guard let url = Bundle.module.url(forResource: "fileSequence\(number)", withExtension: "ts") else {
            throw ResourceNotFound(number: number)
        }
        return try await loader.data(from: url).0
    }
    
    struct ResourceNotFound: Error {
        let number: Int
    }
}
