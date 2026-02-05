import SwiftUI

struct HistoryView: View {

    @EnvironmentObject private var store: ResultsStore

    var body: some View {
        List {
            if store.results.isEmpty {
                Text("No results yet. Run a test first.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(store.results) { r in
                    NavigationLink {
                        ResultDetailView(result: r)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(r.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.headline)

                            HStack(spacing: 12) {
                                pill("Taps: \(r.taps)")
                                pill(String(format: "TPS: %.2f", r.tapsPerSecond))
                                pill("Rhythm: \(r.rhythmScore)/100")
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete(perform: store.delete)
            }
        }
        .navigationTitle("History")
        .toolbar {
            EditButton()
        }
    }

    private func pill(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(.thinMaterial, in: Capsule())
    }
}

private struct ResultDetailView: View {
    let result: TapResult

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            Text(result.date.formatted(date: .long, time: .shortened))
                .font(.headline)
                .foregroundStyle(.secondary)

            metricRow("Duration", "\(Int(result.durationSeconds))s")
            metricRow("Total taps", "\(result.taps)")
            metricRow("Taps/sec", String(format: "%.2f", result.tapsPerSecond))
            metricRow("Rhythm score", "\(result.rhythmScore)/100")
            metricRow("Interval CV", String(format: "%.3f", result.intervalCV))

            Divider().padding(.vertical, 6)

            Text("Interpretation (non-medical)")
                .font(.headline)

            Text("Higher taps/sec suggests faster repetitive movement. Lower rhythm score (higher interval variability) suggests less consistent timing. Many factors can affect this: fatigue, screen size, stress, posture, etc. This is not a diagnosis.")
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle("Result")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func metricRow(_ k: String, _ v: String) -> some View {
        HStack {
            Text(k)
            Spacer()
            Text(v).fontWeight(.semibold)
        }
        .font(.body)
    }
}
