import SwiftUI

struct AddTodoSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var priority: TodoPriority = .medium
    @State private var hasDueDate = false
    @State private var dueDate = Date()

    let onSave: (TodoItem) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Новая задача") {
                    TextField("Что нужно сделать?", text: $title)

                    Picker("Приоритет", selection: $priority) {
                        ForEach(TodoPriority.allCases) { current in
                            Label(current.rawValue, systemImage: current.icon)
                                .tag(current)
                        }
                    }

                    Toggle("Установить срок", isOn: $hasDueDate)

                    if hasDueDate {
                        DatePicker("Срок", selection: $dueDate, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("Добавить")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        onSave(
                            TodoItem(
                                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                                isDone: false,
                                priority: priority,
                                dueDate: hasDueDate ? dueDate : nil,
                                note: "",
                                subtasks: []
                            )
                        )
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
