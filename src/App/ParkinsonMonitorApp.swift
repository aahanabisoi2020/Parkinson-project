import SwiftUI

@main
struct ParkinsonMonitorApp: App {
    @StateObject private var store = ResultsStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
