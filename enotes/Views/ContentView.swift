//
//  ContentView.swift
//  enotes
//
//  Created by Julio Torres on 19/02/25.
//

import SwiftUI
@preconcurrency import TabularData
    
struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    @State var descriptionNote: String = ""
    @State private var showFavoritesOnly = false
    @State private var showingNewFolderSheet = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationSplitView {
            if searchText.isEmpty {
                List($viewModel.folders, id: \.id) { $folder in
                    NavigationLink {
                        NotesListView(folder: folder)
                    } label: {
                        FolderRow(folder: folder)
                            .swipeActions(edge: .trailing) {
                                Button("Favorite", systemImage: "star.fill"){
                                    
                                }.tint(.orange)
                                Button("Folder", systemImage: "folder"){

                                }.tint(.blue)

                            }
                            .swipeActions(edge: .leading) {
                                Button("Favorite", systemImage: "trash"){
                                    Task {
                                        do {
                                            let _ = try await viewModel.deleteFolder(id: folder.id)
                                        }
                                        catch {
                                            print("error al borrar nota: \(error)")
                                        }
                                        viewModel.allFolders()
                                    }
                                }.tint(.red)

                            }
                    }
                }
                //.animation(.default, value: filteredLandmarks)
                .navigationTitle("Folders")
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button("Folder", systemImage: "folder.badge.plus") {
                            showingNewFolderSheet.toggle()
                        }.sheet(isPresented: $showingNewFolderSheet, onDismiss: {
                            viewModel.allFolders()
                        }) {
                            NewFolderSheetView()
                        }
                        Spacer()
                        NavigationLink(destination: NoteView(note: NoteModel())){
                            Button(action: { })  {
                                Label("New Note", systemImage: "square.and.pencil")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }.onAppear(){
                    viewModel.allFolders()
                }
            } else {
                SearchListView(searchText: searchText)
            }
        }
        content: {
            Text("Select a Folder")
        }
        detail: {
            Text("Select a Landmark")
        }.searchable(text: $searchText, prompt: "Search Notes").onChange(of: searchText) {
            viewModel.findNotes(title: searchText)
        }
    }
}

#Preview {
    ContentView()
}
