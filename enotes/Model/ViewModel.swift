//
//  NoteViewModel.swift
//  enotes
//
//  Created by Julio Torres on 26/02/25.
//

import Foundation
import SwiftUI
import DuckDB
import TabularData
import GameplayKit

final class ViewModel: ObservableObject {
    @Published var notes: [NoteModel] = []
    @Published var folders: [FolderModel] = []
    
    init() {
        allNotes()
    }

    func connect() throws -> (database: Database, connection: Connection){
        var database: Database!
        var connection: Connection!
        
        do{
            let directory = URL.documentsDirectory
            print("directory: \(directory.path())")
            let fileUrl = directory.appendingPathComponent("enotes.db")
            print("fileUrl: \(fileUrl)")
            database = try Database(store: .file(at: fileUrl))
            connection = try database.connect()
                      
            let _ = try connection.query("CREATE SEQUENCE IF NOT EXISTS id_notes START 1;")
            let _ = try connection.query("CREATE SEQUENCE IF NOT EXISTS id_folders START 2;")
            
            let _ = try connection.query(
               """
               CREATE TABLE IF NOT EXISTS notes (
               id INTEGER PRIMARY KEY,
               title VARCHAR,
               content VARCHAR,
               folderId INTEGER,
               creationDate VARCHAR,
               updateDate VARCHAR,
               isFavorite BOOLEAN,
               );
               """
            )
            
            let creationDate = "26-02-2025"
            let updateDate = "26-02-2025"
            
            let _ = try connection.query(
               """
               CREATE TABLE IF NOT EXISTS folders (
               id INTEGER PRIMARY KEY,
               name VARCHAR,
               creationDate VARCHAR,
               updateDate VARCHAR,
               );
               """
            )
            
            let _ = try connection.query("INSERT OR IGNORE INTO folders VALUES (1, 'Notes', '\(creationDate)', '\(updateDate)');")
            
            let _ = try connection.query("PRAGMA add_parquet_key('notes_key', '01234567891123450123456789112345')")
            
            let _ = try connection.query("COPY notes TO 'notes.parquet' (ENCRYPTION_CONFIG {footer_key: 'notes_key'});")
            
        }catch{
            print("Error: \(error)")
        }
        return (database, connection)
    }
       
    func createNote(title: String, content: String) async throws -> Bool {
        do{
            let (_, connection) = try connect()
            let creationDate = "26-02-2025"
            let updateDate = "26-02-2025"
            let isFavorite = false
            let res = try connection.query("INSERT INTO notes VALUES (nextval('id_notes'), '\(title)', '\(content)', '1', '\(creationDate)', '\(updateDate)', '\(isFavorite)');")
            if (!res.isEmpty){
                return true
            }
        }catch {
            print(error)
        }
        return false
    }
    
    func updateNote(id: Int ,title: String, content: String, folderId: Int) async throws -> Bool {
        do{
            let (_, connection) = try connect()
            let updateDate = "26-02-2025"
            let res = try connection.query("UPDATE notes SET (title, content, folderId, updateDate) = ('\(title)', '\(content)', '\(folderId)', '\(updateDate)') WHERE id = '\(id)';")
            if (!res.isEmpty){
                return true
            }
        }catch {
            print(error)
        }
        return false
    }
    
    func deleteNote(id: Int) async throws -> Bool {
        do{
            let (_, connection) = try connect()
            let res = try connection.query("DELETE FROM notes WHERE id = '\(id)';")
            if (!res.isEmpty){
                return true
            }
        }catch {
            print(error)
        }
        return false
    }
    
    func readNote(id: Int) async throws -> NoteModel {
        do{
            let (_, connection) = try connect()
            let result = try connection.query("SELECT * FROM notes WHERE id = '\(id)';")
            let id = result[0].cast(to: Int.self)
            let title = result[1].cast(to: String.self)
            let content = result[2].cast(to: String.self)
            let folderId = result[3].cast(to: Int.self)
            let creationDate = result[4].cast(to: String.self)
            let updateDate = result[5].cast(to: String.self)
            let isFavorite = result[6].cast(to: Bool.self)

            let zipped = zip(zip(zip(zip(zip(zip(id, title), content), folderId), creationDate), updateDate), isFavorite)

            for ((((((id, title), content), folderId), creationDate), updateDate), isFavorite) in zipped {
                return NoteModel(id: id ?? 0, title: title ?? "", content: content ?? "", folderId: folderId ?? 0, creationDate: creationDate ?? "", updateDate: updateDate ?? "", isFavorite: isFavorite ?? false)
            }
        }catch {
            print(error)
        }
        return NoteModel()
    }
    
    func allNotes() {
        do{
            let (_, connection) = try connect()
            let result = try connection.query("SELECT * FROM notes ORDER BY updateDate DESC;")
            let id = result[0].cast(to: Int.self)
            let title = result[1].cast(to: String.self)
            let content = result[2].cast(to: String.self)
            let folderId = result[3].cast(to: Int.self)
            let creationDate = result[4].cast(to: String.self)
            let updateDate = result[5].cast(to: String.self)
            let isFavorite = result[6].cast(to: Bool.self)

            let zipped = zip(zip(zip(zip(zip(zip(id, title), content), folderId), creationDate), updateDate), isFavorite)
            
            notes = []
            
            for ((((((id, title), content), folderId), creationDate), updateDate), isFavorite) in zipped {
                notes.append(NoteModel(id: id ?? 0, title: title ?? "", content: content ?? "", folderId: folderId ?? 0, creationDate: creationDate ?? "", updateDate: updateDate ?? "", isFavorite: isFavorite ?? false))
            }
            
        }catch {
            print(error)
        }
    }
    
    func allFolderNotes(folderId: Int) {
        do{
            let (_, connection) = try connect()
            let result = try connection.query("SELECT * FROM notes WHERE folderId = '\(folderId)' ORDER BY updateDate DESC;")
            let id = result[0].cast(to: Int.self)
            let title = result[1].cast(to: String.self)
            let content = result[2].cast(to: String.self)
            let folderId = result[3].cast(to: Int.self)
            let creationDate = result[4].cast(to: String.self)
            let updateDate = result[5].cast(to: String.self)
            let isFavorite = result[6].cast(to: Bool.self)

            let zipped = zip(zip(zip(zip(zip(zip(id, title), content), folderId), creationDate), updateDate), isFavorite)
            
            notes = []
            
            for ((((((id, title), content), folderId), creationDate), updateDate), isFavorite) in zipped {
                notes.append(NoteModel(id: id ?? 0, title: title ?? "", content: content ?? "", folderId: folderId ?? 0, creationDate: creationDate ?? "", updateDate: updateDate ?? "", isFavorite: isFavorite ?? false))
            }
            
        }catch {
            print(error)
        }
    }
    
    func findNotes(title: String) {
        do{
            notes = []
            
            let (_, connection) = try connect()
            let result = try connection.query("SELECT * FROM notes WHERE LOWER(title) LIKE LOWER('%\(title)%') ORDER BY title ASC;")
            let id = result[0].cast(to: Int.self)
            let title = result[1].cast(to: String.self)
            let content = result[2].cast(to: String.self)
            let folderId = result[3].cast(to: Int.self)
            let creationDate = result[4].cast(to: String.self)
            let updateDate = result[5].cast(to: String.self)
            let isFavorite = result[6].cast(to: Bool.self)

            let zipped = zip(zip(zip(zip(zip(zip(id, title), content), folderId), creationDate), updateDate), isFavorite)
            
            for ((((((id, title), content), folderId), creationDate), updateDate), isFavorite) in zipped {
                notes.append(NoteModel(id: id ?? 0, title: title ?? "", content: content ?? "", folderId: folderId ?? 0, creationDate: creationDate ?? "", updateDate: updateDate ?? "", isFavorite: isFavorite ?? false))
            }

        }catch {
            print(error)
        }
    }
    
    func updateFolderNote(id: Int, folderId: Int) async throws -> Bool{
        do{
            let (_, connection) = try connect()
            let res = try connection.query("UPDATE notes SET (folderId) = ('\(folderId)') WHERE id = '\(id)';")
            if (!res.isEmpty){
                return true
            }
        }catch {
            print(error)
        }
        return false
    }
    
    func countNotes(folderId: Int) async throws -> Int {
        do{
            let (_, connection) = try connect()
            let result = try connection.query("SELECT COUNT(folderId) AS Count FROM notes WHERE folderId = '\(folderId)';")
            let notesCount = result[0].cast(to: Int.self)[0]
            return notesCount ?? 0
        }catch {
            print(error)
        }
        return 0
    }
       
    func createFolder(name: String) async throws -> Bool {
        do{
            let (_, connection) = try connect()
            let creationDate = "26-02-2025"
            let updateDate = "26-02-2025"
            let res = try connection.query("INSERT INTO folders VALUES (nextval('id_folders'), '\(name)', '\(creationDate)', '\(updateDate)');")
            if (!res.isEmpty){
                return true
            }
        }catch {
            print(error)
        }
        return false
    }
    
    func updateFolder(id: Int ,name: String) async throws -> Bool {
        do{
            let (_, connection) = try connect()
            let updateDate = "26-02-2025"
            let res = try connection.query("UPDATE folders SET (name, updateDate) = ('\(name)', '\(updateDate)') WHERE id = '\(id)';")
            if (!res.isEmpty){
                return true
            }
        }catch {
            print(error)
        }
        return false
    }
    
    func deleteFolder(id: Int) async throws -> Bool {
        do{
            let (_, connection) = try connect()
            let res = try connection.query("DELETE FROM folders WHERE id = '\(id)';")
            if (!res.isEmpty){
                return true
            }
        }catch {
            print(error)
        }
        return false
    }
    
    func allFolders() {
        do{
            let (_, connection) = try connect()
            let result = try connection.query("SELECT * FROM folders ORDER BY name ASC;")
            let id = result[0].cast(to: Int.self)
            let name = result[1].cast(to: String.self)
            let creationDate = result[2].cast(to: String.self)
            let updateDate = result[3].cast(to: String.self)

            let zipped = zip(zip(zip(id, name), creationDate), updateDate)
            
            folders = []
            
            for (((id, name), creationDate), updateDate) in zipped {
                folders.append(FolderModel(id: id ?? 0, name: name ?? "", creationDate: creationDate ?? "", updateDate: updateDate ?? ""))
            }
            
        }catch {
            print(error)
        }
    }
    
}
