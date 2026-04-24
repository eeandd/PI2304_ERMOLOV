import SwiftUI

struct TodoRowView: View {
    let item: TodoItem

    private var completedSubtasksCount: Int {
        item.subtasks.filter { $0.isDone }.count
    }

    private var hasTaskNote: Bool {
        !item.note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var dueDateText: String? {
        guard let dueDate = item.dueDate else { return nil }
        if Calendar.current.isDateInToday(dueDate) {
            return "Сегодня"
        }
        if Calendar.current.isDateInTomorrow(dueDate) {
            return "Завтра"
        }
        return dueDate.formatted(date: .abbreviated, time: .omitted)
    }

    private var isOverdue: Bool {
        guard let dueDate = item.dueDate else { return false }
        return dueDate < Date() && !Calendar.current.isDateInToday(dueDate)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(item.isDone ? .green : .secondary)

                Text(item.title)
                    .font(.headline)
                    .strikethrough(item.isDone, color: .secondary)
                    .foregroundStyle(item.isDone ? .secondary : .primary)

                Spacer(minLength: 8)

                Label(item.priority.rawValue, systemImage: item.priority.icon)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(item.priority.color.opacity(0.15), in: Capsule())
                    .foregroundStyle(item.priority.color)
            }

            HStack(spacing: 12) {
                Label(
                    item.subtasks.count > 0 ? "Подзадачи: \(completedSubtasksCount)/\(item.subtasks.count)" : "Подзадач нет",
                    systemImage: "checklist"
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)

                Spacer()

                Label(
                    hasTaskNote ? "Есть заметка" : "Без заметки",
                    systemImage: hasTaskNote ? "note.text" : "note.text.badge.plus"
                )
                .font(.subheadline)
                .foregroundStyle(hasTaskNote ? .secondary : .tertiary)
            }

            if let dueDateText {
                Label(dueDateText, systemImage: isOverdue && !item.isDone ? "exclamationmark.triangle.fill" : "calendar")
                    .font(.subheadline)
                    .foregroundStyle(isOverdue && !item.isDone ? .red : .secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
