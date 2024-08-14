import Foundation

enum ResourceLoader {
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
