import Foundation
import SwiftUI

enum TodoPriority: String, CaseIterable, Identifiable, Codable {
    case low = "Низкий"
    case medium = "Средний"
    case high = "Высокий"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .low: .green
        case .medium: .orange
        case .high: .red
        }
    }

    var icon: String {
        switch self {
        case .low: "arrow.down.circle.fill"
        case .medium: "equal.circle.fill"
        case .high: "arrow.up.circle.fill"
        }
    }

    var rank: Int {
        switch self {
        case .low: 1
        case .medium: 2
        case .high: 3
        }
    }
}

struct Subtask: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var isDone: Bool
    var note: String

    init(id: UUID = UUID(), title: String, isDone: Bool, note: String) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.note = note
    }
}

struct TodoItem: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var isDone: Bool
    var priority: TodoPriority
    var dueDate: Date?
    var note: String
    var subtasks: [Subtask]

    init(
        id: UUID = UUID(),
        title: String,
        isDone: Bool,
        priority: TodoPriority,
        dueDate: Date?,
        note: String,
        subtasks: [Subtask]
    ) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.priority = priority
        self.dueDate = dueDate
        self.note = note
        self.subtasks = subtasks
    }
}

enum StatusFilter: String, CaseIterable, Identifiable {
    case all = "Все"
    case active = "Активные"
    case today = "Сегодня"
    case overdue = "Просроченные"
    case done = "Выполненные"

    var id: String { rawValue }
}

enum PriorityFilter: String, CaseIterable, Identifiable {
    case all = "Любой приоритет"
    case high = "Только высокий"
    case medium = "Только средний"
    case low = "Только низкий"

    var id: String { rawValue }

    func matches(_ priority: TodoPriority) -> Bool {
        switch self {
        case .all: true
        case .high: priority == .high
        case .medium: priority == .medium
        case .low: priority == .low
        }
    }
}

enum SortOption: String, CaseIterable, Identifiable {
    case focus = "По фокусу"
    case dueDate = "По сроку"
    case priority = "По приоритету"
    case title = "По названию"

    var id: String { rawValue }
}

enum TodoPersistence {
    private static let storageKey = "todo_items_v1"

    static func loadItems() -> [TodoItem]? {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return nil
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode([TodoItem].self, from: data)
    }

    static func saveItems(_ items: [TodoItem]) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        guard let data = try? encoder.encode(items) else {
            return
        }

        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
