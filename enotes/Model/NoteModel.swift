//
//  NoteModel.swift
//  enotes
//
//  Created by Julio Torres on 26/02/25.
//

import Foundation

struct NoteModel: Codable {
    var id: Int
    var title: String
    var content: String
    var folderId: Int
    var creationDate: String
    var updateDate: String
    var isFavorite: Bool
    
    init(id: Int = 0, title: String = "", content: String = "", folderId: Int = 0, creationDate: String = "", updateDate: String = "", isFavorite: Bool = false){
        self.id = id
        self.title = title
        self.content = content
        self.folderId = folderId
        self.creationDate = creationDate
        self.updateDate = updateDate
        self.isFavorite = isFavorite
    }
    
}

