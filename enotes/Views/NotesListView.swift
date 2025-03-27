//
//  notesListView.swift
//  enotes
//
//  Created by Julio Torres on 08/03/25.
//

import SwiftUI

struct NotesListView: View {
    
    @StateObject var viewModel = ViewModel()
    @State private var isExpandedAllSeas: Bool = true
    @State private var searchText = ""
    @State private var showingSelectFolderSheet = false
    @State private var selectedNoteId: Int = 1
    
    var folder: FolderModel
    
    var body: some View {
        Section(
            isExpanded: $isExpandedAllSeas,
            content: {
                List($viewModel.notes, id: \.id) { $note in
                    NavigationLink {
                        NoteView(note: note)
                    } label: {
                        NoteRow(note: note)
                            .swipeActions(edge: .trailing) {
                                Button("Favorite", systemImage: "star.fill"){
                                    
                                }.tint(.orange)
                                Button("Category", systemImage: "folder"){
                                    selectedNoteId = note.id
                                    showingSelectFolderSheet.toggle()
                                }.tint(.blue)
                            }
                            .swipeActions(edge: .leading) {
                                Button("Favorite", systemImage: "trash"){
                                    Task {
                                        do {
                                            let _ = try await viewModel.deleteNote(id: note.id)
                                        }
                                        catch {
                                            print("error al borrar nota: \(error)")
                                        }
                                        viewModel.allFolderNotes(folderId: folder.id)
                                    }
                                }.tint(.red)
                            }
                    }.onAppear(){
                        viewModel.allFolderNotes(folderId: folder.id)
                    }
                }.searchable(text: $searchText, prompt: "Search Notes").onChange(of: searchText) {
                    viewModel.findNotes(title: searchText)
                }
                .sheet(isPresented: $showingSelectFolderSheet, onDismiss: {
                    viewModel.allFolderNotes(folderId: folder.id)
                }) {
                    SelectFolderSheetView(id: selectedNoteId)
                }
        },
        header: {
            Text(folder.name)
        })
    }
}

#Preview {
   // NotesListView()
}
