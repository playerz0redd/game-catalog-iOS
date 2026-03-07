//
//  PersistanceManager.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 27.02.26.
//

import Foundation
import SwiftData

protocol IPersistance {
    func save<T: PersistentModel>(object: T) throws(PersistanceError)
    
    func fetch<T: PersistentModel>(
        predicat: Predicate<T>?,
        sortBy: [SortDescriptor<T>]
    ) throws(PersistanceError) -> [T]
    
    func delete<T: PersistentModel>(predicate: Predicate<T>) throws(PersistanceError)
}

@MainActor
final class PersistanceManager: IPersistance {
    
    static let shared = PersistanceManager()
    
    private let container: ModelContainer
    private let context: ModelContext
    
    private init() {
        let schema = Schema([DatabaseGameModel.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        container = try! ModelContainer(for: schema, configurations: config)
        context = container.mainContext
    }
    
    func delete<T: PersistentModel>(predicate: Predicate<T>) throws(PersistanceError) {
        do {
            try context.delete(model: T.self, where: predicate)
            print("deleted")
        } catch let error {
            throw .deleteError(error)
        }
    }
    
    func save<T: PersistentModel>(object: T) throws(PersistanceError) {
        print("saved")
        context.insert(object)
        do {
            try context.save()
        } catch let error {
            throw .saveError(error)
        }
    }
    
    func fetch<T: PersistentModel>(
        predicat: Predicate<T>? = nil,
        sortBy: [SortDescriptor<T>] = []
    ) throws(PersistanceError) -> [T] {
        
        let descriptor: FetchDescriptor<T> = .init(predicate: predicat, sortBy: sortBy)
        do {
            return try context.fetch(descriptor)
        } catch let error {
            throw .fetchError(error)
        }
    }
}
