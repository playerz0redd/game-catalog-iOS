//
//  StorageManager.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 2.03.26.
//

import Foundation
import UIKit

protocol IStorageManager {
    func savePhoto(image: UIImage, name: String) throws(DataStorageError)
    func fetchPhoto(name: String) -> UIImage?
    func deletePhoto(name: String) throws(DataStorageError)
}

final class StorageManager: IStorageManager {
    
    private let storage = FileManager.default
    
    private var documentsDirectory: URL {
        storage.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func savePhoto(image: UIImage, name: String) throws(DataStorageError) {
        let data = image.jpegData(compressionQuality: 0.8)
        let fileURL = documentsDirectory.appendingPathComponent(name)
        do {
            try data?.write(to: fileURL)
        } catch let error {
            print("Error saving image \(error.localizedDescription)")
            throw .saveError(error)
        }
    }
    
    func fetchPhoto(name: String) -> UIImage? {
        let fileUrl = documentsDirectory.appendingPathComponent(name).path
        if storage.fileExists(atPath: fileUrl) {
            return UIImage(contentsOfFile: fileUrl)
        }
        return nil
    }
    
    func deletePhoto(name: String) throws(DataStorageError) {
        let fileUrl = documentsDirectory.appendingPathComponent(name)
        do {
            try storage.removeItem(at: fileUrl)
        } catch let error {
            print("Error deleting \(error.localizedDescription)")
            throw .deleteError(error)
        }
    }
    
    
    
}
