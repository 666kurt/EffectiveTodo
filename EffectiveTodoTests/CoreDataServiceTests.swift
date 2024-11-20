//
//  CoreDataServiceTests.swift
//  EffectiveTodoTests
//
//  Created by Максим Шишлов on 21.11.2024.
//

import XCTest
import CoreData

@testable import EffectiveTodo
final class CoreDataServiceTests: XCTestCase {
    
    var coreDataService: CoreDataService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        coreDataService = CoreDataService.shared
        coreDataService.persistentContainer = {
            let container = NSPersistentContainer(name: "TodoModel")
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Failed to load in-memory store: \(error)")
                }
            }
            return container
        }()
    }
    
    override func tearDownWithError() throws {
        coreDataService = nil
        try super.tearDownWithError()
    }
    
    func testSaveAndFetchTodos() throws {
        let todo = TodoItem(
            id: UUID(),
            todo: "Test Todo",
            detail: "Test Detail",
            dateAdded: Date(),
            completed: false
        )
        
        coreDataService.saveTodos([todo])
        
        let fetchedTodos = coreDataService.fetchTodos()
        XCTAssertEqual(fetchedTodos.count, 1)
        XCTAssertEqual(fetchedTodos.first?.todo, "Test Todo")
    }
    
    func testDeleteTodo() throws {
        let todo = TodoItem(
            id: UUID(),
            todo: "Test Todo",
            detail: "Test Detail",
            dateAdded: Date(),
            completed: false
        )
        
        coreDataService.saveTodos([todo])
        coreDataService.deleteTodoEntity(todo.id)
        
        let fetchedTodos = coreDataService.fetchTodos()
        XCTAssertTrue(fetchedTodos.isEmpty)
    }
}
