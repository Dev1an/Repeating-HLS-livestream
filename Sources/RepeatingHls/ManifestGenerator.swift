import Foundation

class ManifestGenerator {
    static let versionHeader = """
        #EXTM3U
        #EXT-X-VERSION:4
        ## Repeating HLS generator
        """
    
    let streamStartDate: Date
    let dateFormatStyle = Date.ISO8601FormatStyle(includingFractionalSeconds: true)
    let segmentDuration = TimeInterval(2)
    let segmentInPastCount = 6
    let segmentInFutureCount = 1
    let segmentHeader: String

    var lastGeneratedMarker = Date(timeIntervalSince1970: 0)
    
    init() {
        let offset = segmentDuration * TimeInterval(segmentInPastCount+1)
        streamStartDate = Date().addingTimeInterval(-offset)
        segmentHeader = "#EXTINF:\(segmentDuration),"
    }
    
    func generate() -> String {
        let now = Date()
        let streamTimeUntilNow = now.timeIntervalSince(streamStartDate)
        let runningSegmentIndex = Int(streamTimeUntilNow / TimeInterval(segmentDuration))
        
        let windowStartSegmentIndex = runningSegmentIndex - segmentInPastCount
        let windowEndSegmentIndex = runningSegmentIndex + segmentInFutureCount
        
        let segmentInfo = (windowStartSegmentIndex ..< windowEndSegmentIndex).map { index in
            let startTime = segmentDuration * TimeInterval(index)
            return SegmentInfo(
                index: index,
                startTime: startTime,
                startDate: streamStartDate.addingTimeInterval(startTime)
            )
        }
        
        let segments = segmentInfo.map { segment in
            let relativeIndex = segment.index % 10
            let string: String
            if relativeIndex == 5 {
                string = """
                #EXT-X-DATERANGE:ID="\(segment.index)",START-DATE="\(dateFormatStyle.format(segment.startDate))"\n
                """
            } else { string = "" }
            return string + """
            #EXT-X-PROGRAM-DATE-TIME:\(dateFormatStyle.format(segment.startDate))
            \(segmentHeader)
            fileSequence\(relativeIndex).ts?seg=\(segment.index)
            """
        }
        
        return """
        \(Self.versionHeader)
        #EXT-X-MEDIA-SEQUENCE:\(windowStartSegmentIndex)
        #EXT-X-INDEPENDENT-SEGMENTS
        #EXT-X-TARGETDURATION:\( Int(ceil(segmentDuration)) )
        \(segments.joined(separator: "\n"))
        """
    }
    
    func dateRange(id: String, start: Date) -> String {
        #"#EXT-X-DATERANGE:ID="\#(id)",START-DATE="\#(dateFormatStyle.format(start))""#
    }
    
    struct SegmentInfo {
        let index: Int
        let startTime: TimeInterval
        let startDate: Date
    }
}
