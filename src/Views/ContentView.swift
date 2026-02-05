import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                Text("Parkinson Monitor")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Finger Tapping Test (MVP)")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                VStack(spacing: 12) {
                    NavigationLink {
                        TappingTestView()
                    } label: {
                        Label("Start Tapping Test", systemImage: "hand.tap")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)

                    NavigationLink {
                        HistoryView()
                    } label: {
                        Label("View History", systemImage: "clock.arrow.circlepath")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top, 12)

                Spacer()

                Text("Note: This is not a medical diagnosis tool.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
        }
    }
}
