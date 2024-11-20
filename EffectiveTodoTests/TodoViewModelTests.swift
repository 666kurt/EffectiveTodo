//
//  TodoViewModelTests.swift
//  EffectiveTodoTests
//
//  Created by Максим Шишлов on 21.11.2024.
//

import XCTest

@testable import EffectiveTodo
final class TodoViewModelTests: XCTestCase {
    
    var viewModel: TodoViewModel!
    var mockCoreDataService: CoreDataService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockCoreDataService = CoreDataService.shared
        viewModel = TodoViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockCoreDataService = nil
        try super.tearDownWithError()
    }
    
    func testLoadTodosFromCoreData() throws {
        let todo = TodoItem(
            id: UUID(),
            todo: "Test Todo",
            detail: "Test Detail",
            dateAdded: Date(),
            completed: false
        )
        mockCoreDataService.saveTodos([todo])

        viewModel.loadTodos()
        
        XCTAssertEqual(viewModel.todos.count, 1)
        XCTAssertEqual(viewModel.todos.first?.todo, "Test Todo")
    }
    
    func testAddTodo() throws {
        viewModel.addTodo("New Todo", "Detail", Date())
        
        XCTAssertEqual(viewModel.todos.count, 1)
        XCTAssertEqual(viewModel.todos.first?.todo, "New Todo")
    }
    
    func testToggleStatus() throws {
        let todo = TodoItem(
            id: UUID(),
            todo: "Test Todo",
            detail: "Test Detail",
            dateAdded: Date(),
            completed: false
        )
        viewModel.addTodo(todo.todo, todo.detail, todo.dateAdded)
        
        guard let addedTodo = viewModel.todos.first else {
            XCTFail("Todo not added")
            return
        }
        
        viewModel.toggleStatus(addedTodo)
        
        XCTAssertEqual(viewModel.todos.first?.completed, true)
    }
}
