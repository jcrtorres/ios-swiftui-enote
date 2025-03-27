//
//  NewFolderSheetView.swift
//  enotes
//
//  Created by Julio Torres on 24/02/25.
//

import SwiftUI

struct NewFolderSheetView: View {
    
    @StateObject var viewModel = ViewModel()
    @State var folderName: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            TextField("", text: $folderName)
                .keyboardType(.default)
                .disableAutocorrection(true)
                .padding(8)
                .font(.headline)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(6)
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            print("Cancel tapped!")
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            if(!folderName.isEmpty){
                                print("Done tapped!")
                                Task {
                                    do {
                                        let _ = try await viewModel.createFolder(
                                            name: folderName
                                        )
                                    }catch {
                                        
                                    }
                                }
                                dismiss()
                            }
                        }
                    }

                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("New Folder")
            Spacer()
        }
    }
}

#Preview {
    NewFolderSheetView()
}
