import SwiftUI

struct SubtaskRowView: View {
    @Binding var subtask: Subtask
    let onTapNote: () -> Void

    private var hasNote: Bool {
        !subtask.note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        HStack(spacing: 12) {
            Button {
                subtask.isDone.toggle()
            } label: {
                Image(systemName: subtask.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(subtask.isDone ? .green : .secondary)
            }
            .buttonStyle(.plain)

            TextField("Название подзадачи", text: $subtask.title)
                .strikethrough(subtask.isDone, color: .secondary)
                .foregroundStyle(subtask.isDone ? .secondary : .primary)

            Button(action: onTapNote) {
                Image(systemName: hasNote ? "note.text" : "note.text.badge.plus")
                    .foregroundStyle(hasNote ? .blue : .secondary)
            }
            .buttonStyle(.plain)
            .help(hasNote ? "Открыть заметку" : "Добавить заметку")
        }
    }
}
