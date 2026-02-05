import Foundation

struct TapResult: Identifiable, Codable {
    let id: UUID
    let date: Date
    let durationSeconds: Double
    let tapTimestamps: [Double]   // seconds since test start

    var taps: Int { tapTimestamps.count }

    var tapsPerSecond: Double {
        guard durationSeconds > 0 else { return 0 }
        return Double(taps) / durationSeconds
    }

    // Inter-tap intervals (seconds)
    var intervals: [Double] {
        guard tapTimestamps.count >= 2 else { return [] }
        return zip(tapTimestamps.dropFirst(), tapTimestamps).map { $0 - $1 }
    }

    // Coefficient of Variation (CV) of intervals = std/mean.
    // Higher CV => more irregular rhythm (can be relevant in motor control issues).
    var intervalCV: Double {
        let xs = intervals
        guard xs.count >= 2 else { return 0 }
        let mean = xs.reduce(0, +) / Double(xs.count)
        guard mean > 0 else { return 0 }
        let variance = xs.map { ($0 - mean) * ($0 - mean) }.reduce(0, +) / Double(xs.count - 1)
        let std = sqrt(variance)
        return std / mean
    }

    // Simple 0–100 "rhythm score" (heuristic; not medical).
    // Lower CV => higher score.
    var rhythmScore: Int {
        // CV ~0.05 is very steady, CV ~0.30+ is quite irregular.
        let cv = intervalCV
        let normalized = min(max((0.30 - cv) / 0.30, 0), 1) // 0..1
        return Int((normalized * 100).rounded())
    }
}
