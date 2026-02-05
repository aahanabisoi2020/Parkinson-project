import Foundation

final class ResultsStore: ObservableObject {

    @Published private(set) var results: [TapResult] = []

    private let filename = "tap_results.json"

    init() {
        load()
    }

    func add(_ result: TapResult) {
        results.insert(result, at: 0)
        save()
    }

    func delete(at offsets: IndexSet) {
        results.remove(atOffsets: offsets)
        save()
    }

    func clearAll() {
        results.removeAll()
        save()
    }

    // MARK: - Persistence

    private func fileURL() -> URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return dir.appendingPathComponent(filename)
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(results)
            try data.write(to: fileURL(), options: [.atomic])
        } catch {
            // For CS50 MVP: silently ignore.
            // Later: show an alert, or log.
        }
    }

    private func load() {
        let url = fileURL()
        guard FileManager.default.fileExists(atPath: url.path) else {
            results = []
            return
        }

        do {
            let data = try Data(contentsOf: url)
            results = try JSONDecoder().decode([TapResult].self, from: data)
        } catch {
            results = []
        }
    }
}
