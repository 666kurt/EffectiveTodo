//
//  TodoViewModel.swift
//  EffectiveTodo
//
//  Created by Максим Шишлов on 15.11.2024.
//

import Foundation

final class TodoViewModel: ObservableObject {
    
    @Published var todos = [TodoItem]()
    @Published var errorMessage: String?
    
    private let networkService = NetworkService.shared
    
    init() {
        loadTodos()
    }
    
    /// Load todos from CoreData or network
    func loadTodos() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let coreDataTodos = CoreDataService.shared.fetchTodos()
            DispatchQueue.main.async {
                if !coreDataTodos.isEmpty {
                    self?.todos = coreDataTodos
                } else {
                    self?.fetchTodosFromNetwork()
                }
            }
        }
    }
    
    /// Fetch todos from network
    private func fetchTodosFromNetwork() {
        networkService.fetchTodos { [weak self] result in
            DispatchQueue.global(qos: .background).async {
                switch result {
                case .success(let apiTodos):
                    let fetchedTodos = TodoItem.fromAPIData(apiTodos)
                    
                    CoreDataService.shared.saveTodos(fetchedTodos)
                    
                    DispatchQueue.main.async {
                        self?.todos = fetchedTodos
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
    
    /// Toggle status func
    func toggleStatus(_ todo: TodoItem) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let index = self?.todos.firstIndex(where: { $0.id == todo.id }) {
                let newStatus = !(self?.todos[index].completed ?? todo.completed)
                CoreDataService.shared.updateTodoStatus(todo.id, completed: newStatus)

                DispatchQueue.main.async {
                    self?.todos[index].completed = newStatus
                }
            }
        }
    }
    
    /// Add new todo func
    func addTodo(_ todo: String, _ detail: String, _ dateAdded: Date) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let newTodo = TodoItem(
                id: UUID(),
                todo: todo,
                detail: detail,
                dateAdded: dateAdded,
                completed: false
            )
            
            CoreDataService.shared.saveTodos([newTodo])
            
            DispatchQueue.main.async {
                self?.todos.append(newTodo)
            }
        }
    }
    
    /// Edit todo func
    func editTodo(_ updatedTodo: TodoItem) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let index = self?.todos.firstIndex(where: { $0.id == updatedTodo.id }) {
                CoreDataService.shared.updateTodo(updatedTodo)

                DispatchQueue.main.async {
                    self?.todos[index] = updatedTodo
                }
            }
        }
    }
    
    /// Delete todo func
    func deleteTodo(_ todo: TodoItem) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            CoreDataService.shared.deleteTodoEntity(todo.id)

            DispatchQueue.main.async {
                self?.todos.removeAll { $0.id == todo.id }
            }
        }
    }
}

