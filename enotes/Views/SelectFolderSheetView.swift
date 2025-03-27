//
//  NewFolderSheetView.swift
//  enotes
//
//  Created by Julio Torres on 24/02/25.
//

import SwiftUI

struct SelectFolderSheetView: View {
    
    @StateObject var viewModel = ViewModel()
    @Environment(\.dismiss) private var dismiss
    var id: Int
    
    var body: some View {
        NavigationStack {
            List($viewModel.folders, id: \.id) { $folder in
                Button(action: {
                    Task {
                        do {
                            let _ = try await viewModel.updateFolderNote(id: id, folderId: folder.id)
                            print (folder.name)
                        }catch {
                            print(error)
                        }
                    }
                    dismiss()
                }) {
                    Text(folder.name)
                }
            }.onAppear() {
                viewModel.allFolders()
            }.navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Select Folder")
        }
    }
}

#Preview {
    //SelectFolderSheetView()
}
