import SwiftUI

struct TodoDetailView: View {
    @Binding var item: TodoItem

    @State private var activeSheet: DetailSheet?

    private enum DetailSheet: Identifiable {
        case taskNote
        case subtaskNote(UUID)
        case addSubtask

        var id: String {
            switch self {
            case .taskNote: "task-note"
            case .subtaskNote(let id): "subtask-note-\(id.uuidString)"
            case .addSubtask: "add-subtask"
            }
        }
    }

    private var hasDueDateBinding: Binding<Bool> {
        Binding(
            get: { item.dueDate != nil },
            set: { hasDate in
                if hasDate {
                    if item.dueDate == nil {
                        item.dueDate = Date()
                    }
                } else {
                    item.dueDate = nil
                }
            }
        )
    }

    private var dueDateBinding: Binding<Date> {
        Binding(
            get: { item.dueDate ?? Date() },
            set: { newValue in item.dueDate = newValue }
        )
    }

    var body: some View {
        Form {
            Section("Задача") {
                TextField("Название", text: $item.title)
                Toggle("Выполнено", isOn: $item.isDone)

                Picker("Приоритет", selection: $item.priority) {
                    ForEach(TodoPriority.allCases) { priority in
                        Label(priority.rawValue, systemImage: priority.icon)
                            .tag(priority)
                    }
                }

                Toggle("Установить срок", isOn: hasDueDateBinding)

                if item.dueDate != nil {
                    DatePicker("Срок", selection: dueDateBinding, displayedComponents: .date)
                }
            }

            Section("Заметка к задаче") {
                Button {
                    activeSheet = .taskNote
                } label: {
                    Label(
                        item.note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        ? "Добавить заметку"
                        : "Открыть заметку",
                        systemImage: item.note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        ? "note.text.badge.plus"
                        : "note.text"
                    )
                }

                if !item.note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text(item.note)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }

            Section("Подзадачи") {
                ForEach($item.subtasks) { $subtask in
                    SubtaskRowView(subtask: $subtask) {
                        activeSheet = .subtaskNote(subtask.id)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            subtask.isDone.toggle()
                        } label: {
                            Label(
                                subtask.isDone ? "Вернуть" : "Выполнено",
                                systemImage: subtask.isDone ? "arrow.uturn.backward.circle" : "checkmark.circle"
                            )
                        }
                        .tint(subtask.isDone ? .orange : .green)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            deleteSubtask(withID: subtask.id)
                        } label: {
                            Label("Удалить", systemImage: "trash")
                        }
                    }
                }
                .onDelete(perform: deleteSubtasks)

                Button {
                    activeSheet = .addSubtask
                } label: {
                    Label("Добавить подзадачу", systemImage: "plus.circle")
                }
            }
        }
        .navigationTitle("Детали")
        .sheet(item: $activeSheet) { destination in
            switch destination {
            case .taskNote:
                NoteEditorView(note: $item.note, title: "Заметка задачи")
            case .subtaskNote(let subtaskID):
                NoteEditorView(note: noteBinding(for: subtaskID), title: "Заметка подзадачи")
            case .addSubtask:
                AddSubtaskSheet { title in
                    item.subtasks.append(
                        Subtask(
                            title: title,
                            isDone: false,
                            note: ""
                        )
                    )
                }
            }
        }
    }

    private func deleteSubtasks(at offsets: IndexSet) {
        item.subtasks.remove(atOffsets: offsets)
    }

    private func deleteSubtask(withID id: UUID) {
        item.subtasks.removeAll { $0.id == id }
    }

    private func noteBinding(for subtaskID: UUID) -> Binding<String> {
        Binding(
            get: {
                item.subtasks.first(where: { $0.id == subtaskID })?.note ?? ""
            },
            set: { newValue in
                guard let index = item.subtasks.firstIndex(where: { $0.id == subtaskID }) else {
                    return
                }
                item.subtasks[index].note = newValue
            }
        )
    }
}
