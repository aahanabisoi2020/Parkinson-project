import SwiftUI

struct TappingTestView: View {

    @EnvironmentObject private var store: ResultsStore

    private let testDuration = 10.0

    @State private var running = false
    @State private var timeLeft = 10
    @State private var tapTimestamps: [Double] = []

    @State private var startTime: Date?
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 16) {

            Text("Finger Tapping Test")
                .font(.title2)
                .fontWeight(.semibold)

            Text(running ? "Tap anywhere on the screen!" : "Press Start, then tap anywhere.")
                .foregroundStyle(.secondary)

            HStack(spacing: 18) {
                statCard(title: "Taps", value: "\(tapTimestamps.count)")
                statCard(title: "Time Left", value: "\(timeLeft)s")
            }

            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(.thinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(running ? .green.opacity(0.6) : .gray.opacity(0.25), lineWidth: 2)
                    )
                    .frame(height: 240)

                VStack(spacing: 10) {
                    Image(systemName: "hand.tap")
                        .font(.system(size: 42))
                    Text(running ? "TAP NOW" : "Ready")
                        .font(.headline)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                guard running, let startTime else { return }
                let t = Date().timeIntervalSince(startTime)
                // Only record taps during window (safety)
                if t >= 0 && t <= testDuration {
                    tapTimestamps.append(t)
                }
            }

            HStack(spacing: 12) {
                Button {
                    start()
                } label: {
                    Label("Start", systemImage: "play.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(running)

                Button {
                    cancel()
                } label: {
                    Label("Cancel", systemImage: "xmark")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(!running)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Test")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func start() {
        cancel()

        running = true
        timeLeft = Int(testDuration)
        tapTimestamps = []
        startTime = Date()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            timeLeft -= 1
            if timeLeft <= 0 {
                t.invalidate()
                finish()
            }
        }
    }

    private func finish() {
        running = false
        timer?.invalidate()
        timer = nil

        let result = TapResult(
            id: UUID(),
            date: Date(),
            durationSeconds: testDuration,
            tapTimestamps: tapTimestamps.sorted()
        )

        store.add(result)

        // Reset UI a bit (optional)
        startTime = nil
    }

    private func cancel() {
        running = false
        timer?.invalidate()
        timer = nil
        startTime = nil
        timeLeft = Int(testDuration)
        tapTimestamps = []
    }

    private func statCard(title: String, value: String) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }
}
