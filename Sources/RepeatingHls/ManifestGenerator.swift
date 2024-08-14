import Foundation

@available(macOS 12.0, *)
class ManifestGenerator {
    static let versionHeader = """
        #EXTM3U
        #EXT-X-VERSION:4
        ## Repeating HLS generator
        """
    
    let startupTime: Date
    let dateFormatStyle = Date.ISO8601FormatStyle(includingFractionalSeconds: true)
    let segmentDuration = 2
    let segmentInPastCount = 6
    
    init() {
        let offset = TimeInterval(segmentDuration * (segmentInPastCount+1))
        startupTime = Date().addingTimeInterval(-offset)
    }
    
    func generate() -> String {
        let now = Date().addingTimeInterval(-TimeInterval(segmentDuration * segmentInPastCount))
        let timeSinceStartup = now.timeIntervalSince(startupTime)
        let startSegmentIndex = Int(timeSinceStartup / TimeInterval(segmentDuration))
        let elapsedIntervalSinceStartup = TimeInterval(startSegmentIndex * segmentDuration)
        let startDate = startupTime.addingTimeInterval(elapsedIntervalSinceStartup)
        let header = """
        #EXT-X-MEDIA-SEQUENCE:\(startSegmentIndex)
        #EXT-X-INDEPENDENT-SEGMENTS
        #EXT-X-TARGETDURATION:\(segmentDuration)
        #EXT-X-PROGRAM-DATE-TIME:\(dateFormatStyle.format(startDate))
        """
        let segmentHeader = "#EXTINF:\(segmentDuration), no desc"
        let segments = (0..<15).map { index in
            """
            \(segmentHeader)
            fileSequence\((startSegmentIndex + index) % 10).ts?seg=\(startSegmentIndex + index)
            """
        }
        return Self.versionHeader + "\n" + header + "\n" + segments.joined(separator: "\n")
    }
}
