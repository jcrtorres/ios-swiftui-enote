//
//  CategoryRow.swift
//  enotes
//
//  Created by Julio Torres on 04/03/25.
//

import SwiftUI

struct FolderRow: View {
    
    @StateObject var viewModel = ViewModel()

    var folder: FolderModel
    @State var countNotes: Int = 0
    
    var body: some View {
        
        HStack {
            Text(folder.name)
            Spacer()
            Text(String(countNotes))
        }.task {
            do {
                countNotes = try await viewModel.countNotes(folderId: folder.id)
            } catch {
                
            }
        }
    }
}

#Preview {
    //FolderRow()
}
