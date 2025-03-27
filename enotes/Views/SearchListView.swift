//
//  notesListView.swift
//  enotes
//
//  Created by Julio Torres on 08/03/25.
//

import SwiftUI

struct SearchListView: View {
    
    @StateObject var viewModel = ViewModel()
    @State private var isExpandedAllSeas: Bool = true
    @State var searchText: String = ""
    @State private var showingSelectFolderSheet = false
    @State private var selectedNoteId: Int = 1
    @State private var dictionary: [Int:[NoteModel]] = [:]
    
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
                                        viewModel.findNotes(title: searchText)
                                    }
                                }.tint(.red)
                            }
                    }.onAppear(){

                    }
                }.onAppear {
                    viewModel.findNotes(title: searchText)
                    dictionary = Dictionary(grouping: viewModel.notes, by: { $0.folderId})
                }
                .sheet(isPresented: $showingSelectFolderSheet, onDismiss: {
                    viewModel.findNotes(title: searchText)
                }) {
                    SelectFolderSheetView(id: selectedNoteId)
                }
        },
        header: {
            Text("Search results")
        })
    }
}

#Preview {
   // NotesListView()
}
