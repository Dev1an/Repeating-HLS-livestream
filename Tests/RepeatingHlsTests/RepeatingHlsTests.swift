import XCTest
@testable import RepeatingHls

final class RepeatingHlsTests: XCTestCase {
    func testExample() async throws {
        let gen = ManifestGenerator()
        print(gen.dateFormatStyle.format(gen.streamStartDate))
        print(gen.dateFormatStyle.format(Date()))
        print(ManifestGenerator.versionHeader)
        print(gen.generate())
    }
    
    func testResources() async throws {
    }
}
