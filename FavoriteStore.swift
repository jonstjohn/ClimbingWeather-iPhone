//
//  FavoriteStore.swift
//  climbingweather
//

import Foundation

/// A singleton that persists the favorites list via UserDefaults.
final class FavoriteStore {
    static let shared = FavoriteStore()

    private static let key = "com.climbingweather.favorites"

    private struct Entry: Codable {
        let id: Int
        let name: String
    }

    private init() {}

    private func load() -> [Entry] {
        guard let data = UserDefaults.standard.data(forKey: FavoriteStore.key),
              let entries = try? JSONDecoder().decode([Entry].self, from: data) else {
            return []
        }
        return entries
    }

    private func save(_ entries: [Entry]) {
        UserDefaults.standard.set(try! JSONEncoder().encode(entries), forKey: FavoriteStore.key)
    }

    // MARK: - Read

    /// Returns all favorited areas as (id, name) tuples.
    func all() -> [(id: Int, name: String)] {
        load().map { ($0.id, $0.name) }
    }

    /// Returns whether a given area ID is in the favorites list.
    func contains(_ areaId: Int) -> Bool {
        load().contains { $0.id == areaId }
    }

    // MARK: - Write

    /// Adds an area to favorites. Does nothing if it already exists.
    func add(areaId: Int, name: String) {
        var entries = load()
        guard !entries.contains(where: { $0.id == areaId }) else { return }
        entries.append(Entry(id: areaId, name: name))
        save(entries)
    }

    /// Removes an area from favorites. Does nothing if it doesn't exist.
    func remove(areaId: Int) {
        var entries = load()
        entries.removeAll { $0.id == areaId }
        save(entries)
    }
}
