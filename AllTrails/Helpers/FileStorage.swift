//
//  FileStorage.swift
//  FileStorage
//
//  Created by Arun Kumar on 9/13/21.
//

import Foundation
import os.log

let fileStoreBaseDir = "filestore"

/// Custom file store as persistence choice
final class CodableFileStore {
    //MARK: - Read File
    static func read<T: Decodable>(fileName: String) throws -> T? {
        guard let fileUrl = url(fileName: fileName) else {
            return nil
        }
        
        return try read(url: fileUrl)
    }
    
    static func read<T: Decodable>(url: URL) throws -> T {
        let data = try Data.init(contentsOf: url, options: .alwaysMapped)
        let decoder = JSONDecoder()
        let jsonObject = try decoder.decode(T.self, from: data)
        return jsonObject
    }
    
    //MARK: - Write File
    static func persist<T>(encodableObject: T, fileName: String) where T : Encodable {
        guard let fileUrl = url(fileName: fileName) else {
            return
        }
        
        write(encodableObject: encodableObject, fileUrl: fileUrl)
    }
    
    private static func write<T>(encodableObject: T, fileUrl: URL) where T : Encodable {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(encodableObject)
            write(data: data, fileUrl: fileUrl)
        } catch {
            os_log("Error Coding JSON object")
        }
    }
    
    private static func write(data: Data, fileUrl: URL) {
        createIntermediates(filePath: fileUrl)
        do {
            try data.write(to: fileUrl)
        } catch {
            os_log("Error")
        }
    }
    
    private static func createIntermediates(filePath: URL) {
        let dir = filePath.deletingLastPathComponent()
        let fileManager = FileManager()
        if fileManager.fileExists(atPath: dir.absoluteString) == false {
            do {
                try fileManager.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                os_log("Error Failed to create directory")
                return
            }
        }
    }
    
    //MARK: - Directory management
    private static func url(fileName: String) -> URL? {
        guard let base = fileStoreBase() else {
            return nil
        }
        let url = base.appendingPathComponent(fileName)
        
        return url
    }
    
    private static func fileStoreBase() -> URL? {
        guard let documents = documentsDirectory() else {
            return nil
        }
        let base = documents.appendingPathComponent(fileStoreBaseDir)
        
        return base
    }
    
    private static func documentsDirectory() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard paths.count > 0 else {
            return nil
        }
        let documentsDirectory = paths[0]
        
        return documentsDirectory
    }
    
}
