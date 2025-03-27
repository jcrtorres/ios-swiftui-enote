//
//  NoteView.swift
//  enotes
//
//  Created by Julio Torres on 25/02/25.
//

import SwiftUI
import RichTextKit

struct NoteView: View {
    
    @StateObject var viewModel = ViewModel()
    @State var text: NSAttributedString = NSMutableAttributedString(string: "")
    @State var title: String = ""
    @State var placeholderText: Bool = false
    @State private var context = RichTextContext()
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool
    
    var note: NoteModel
    var isEditing = false

    init(note: NoteModel) {
        if(note.id != 0){
            self.text = StringDataConverter.convertDataBase64ToAttributedString(note.content)!
            self.title = note.title
            isEditing = true
        }else{
            isEditing = false
        }
        self.note = note
    }
    
    var body: some View {
        VStack{
            TextField("Title", text: $title, axis: .vertical)
                .font(.title2)
                .padding(.leading)
            RichTextEditor(text: $text, context: context)
                .focusedValue(\.richTextContext, context)
                .focused($isFocused)
                .padding(.horizontal)
                .onAppear(){
                    isFocused = true
                }
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            let contentBase64 = StringDataConverter.convertAttributedStringToArchivedDataBase64(text)!
                            Task {
                                do {
                                    if (!isEditing && text.length > 0){
                                        let _ = try await viewModel.createNote(
                                            title: title,
                                            content: contentBase64
                                        )
                                    }else{
                                        let _ = try await viewModel.updateNote(
                                            id: note.id,
                                            title: title,
                                            content: contentBase64,
                                            folderId: note.folderId
                                        )
                                    }
                                    dismiss()
                                }
                                catch {
                                    print("error al crear la nota: \(error)")
                                }
                            }
                        }
                    }
                }
            RichTextKeyboardToolbar(context: context,
                                    leadingButtons: {_ in},
                                    trailingButtons: {_ in},
                                    formatSheet: {$0})
        }

        }
}

#Preview {
    //NoteView().environment(ModelData())
    NoteView(note: NoteModel())
}
