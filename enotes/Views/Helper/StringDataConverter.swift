//
//  StringDataConverter.swift
//  enotes
//
//  Created by Julio Torres on 02/03/25.
//

import Foundation

struct StringDataConverter {
    static func convertAttributedStringToArchivedDataBase64(_ attributedString: NSAttributedString) -> String? {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: attributedString, requiringSecureCoding: false).base64EncodedString()
            return data
        } catch {
            print("Failed to archive NSAttributedString: \(error)")
            return nil
        }
    }
    
    static func convertDataBase64ToAttributedString(_ contentBase64: String) -> NSAttributedString? {
        do {
            let encodedText = Data(base64Encoded: contentBase64)!
            let content = try NSAttributedString(data: encodedText, format: .archivedData)
            //return NSAttributedString(string: content.string)
            return content
        } catch {
            print("Failed to decode Data: \(error)")
        }
        return nil
    }
    
   /* static func convertDataBase64ToData(_ contentBase64: String) -> Data? {
        do {
            let encodedText = Data(base64Encoded: contentBase64)!
            return encodedText
        } catch {
            print("Failed to decode Data: \(error)")
        }
        return nil
    }*/

}


