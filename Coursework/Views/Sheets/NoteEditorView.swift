import SwiftUI

struct NoteEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var note: String
    let title: String

    var body: some View {
        NavigationStack {
            Form {
                Section(title) {
                    TextEditor(text: $note)
                        .frame(minHeight: 180)
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово") {
                        dismiss()
                    }
                }
            }
        }
    }
}
