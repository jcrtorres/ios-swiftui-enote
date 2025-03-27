//
//  CategoryModel.swift
//  enotes
//
//  Created by Julio Torres on 03/03/25.
//

import Foundation

struct FolderModel: Codable {
    var id: Int
    var name: String
    var creationDate: String
    var updateDate: String
    
    init(id: Int = 0, name: String = "", creationDate: String = "", updateDate: String = "") {
        self.id = id
        self.name = name
        self.creationDate = creationDate
        self.updateDate = updateDate
    }
}
