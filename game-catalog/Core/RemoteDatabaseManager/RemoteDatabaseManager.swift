//
//  RemoteDatabaseManager.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 14.03.26.
//

import Foundation
import FirebaseFirestore

protocol IRemoteDataProvider {
    func save<T: Encodable & Identifiable>(object: T, path: String) throws(RemoteDatabaseError)
    func fetchAll<T: Decodable>(path: String) async throws(RemoteDatabaseError) -> [T]
    func delete(path: String, id: String) async throws(RemoteDatabaseError)
}

final class FirestoreManager: IRemoteDataProvider {
    
    private let db = Firestore.firestore()
    
    func save<T: Encodable & Identifiable>(object: T, path: String) throws(RemoteDatabaseError) {
        let doc = db.collection(path).document("\(object.id)")
        do {
            try doc.setData(from: object)
            print("saved---------")
        } catch let error {
            throw .saveError(error)
        }
    }
    
    func fetchAll<T: Decodable>(path: String) async throws(RemoteDatabaseError) -> [T] {
        do {
            let snapshot = try await db.collection(path).getDocuments()
            print("fetched")
            let ass = snapshot.documents.compactMap({ try? $0.data(as: T.self)})
            print("----\(ass)----")
            return ass
        } catch let error {
            throw .fetchError(error)
        }
    }
    
    func delete(path: String, id: String) async throws(RemoteDatabaseError) {
        let doc = db.collection(path).document(id)
        do {
            try await doc.delete()
            print("DELETED---------")
        } catch let error {
            throw .deleteError(error)
        }
    }
    
    
}
