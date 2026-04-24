import SwiftUI

struct AddSubtaskSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""

    let onSave: (String) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Новая подзадача") {
                    TextField("Что нужно сделать?", text: $title)
                }
            }
            .navigationTitle("Подзадача")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        onSave(cleanTitle)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
