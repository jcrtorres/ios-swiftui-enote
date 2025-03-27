//
//  LandmarkRow.swift
//  Landmarks
//
//  Created by Julio Torres on 13/02/25.
//

import SwiftUI

struct NoteRow: View {
    
    var note: NoteModel
    
    var body: some View {
        HStack {
            Text(note.title)
            Spacer()
            if note.isFavorite {
                Image(systemName: "key.fill")
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview("Salmon") {
    /*NoteRow(note: NoteModel(
        id: UUID().uuidString,
        title: "Salmon",
        content: "Salmon",
        category: "General",
        isFavorite: true))*/
}

/*#Preview("Group") {
    //let landmarks = Modelx().landmarks
    //Group {
   //     LandmarkRow(landmark: landmarks[0])
   //     LandmarkRow(landmark: landmarks[1])
   // }
}*/
