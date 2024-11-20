//
//  CoreDataService.swift
//  EffectiveTodo
//
//  Created by Максим Шишлов on 16.11.2024.
//

import Foundation
import CoreData

final class CoreDataService {
    
    static let shared = CoreDataService()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    func saveTodos(_ todos: [TodoItem]) {
        let context = self.context

        for todo in todos {
            let entity = TodoEntity(context: context)
            entity.id = todo.id
            entity.todo = todo.todo
            entity.detail = todo.detail
            entity.dateAdded = todo.dateAdded
            entity.completed = todo.completed
        }

        saveContext()
    }
    
    func fetchTodos() -> [TodoItem] {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        do {
            let entities = try context.fetch(fetchRequest)
            return entities.map { entity in
                TodoItem(
                    id: entity.id ?? UUID(),
                    todo: entity.todo ?? "",
                    detail: entity.detail ?? "",
                    dateAdded: entity.dateAdded ?? Date(),
                    completed: entity.completed
                )
            }
        } catch {
            print("Failed to fetch todos: \(error)")
            return []
        }
    }
    
    func deleteTodoEntity(_ id: UUID) {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let entities = try context.fetch(fetchRequest)
            for entity in entities {
                context.delete(entity)
            }
            saveContext()
        } catch {
            print("Failed to delete todo: \(error)")
        }
    }

    func updateTodoStatus(_ id: UUID, completed: Bool) {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let entities = try context.fetch(fetchRequest)
            if let entity = entities.first {
                entity.completed = completed
                saveContext()
            }
        } catch {
            print("Failed to update todo status: \(error)")
        }
    }

    func updateTodo(_ updatedTodo: TodoItem) {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", updatedTodo.id as CVarArg)
        
        do {
            let entities = try context.fetch(fetchRequest)
            if let entity = entities.first {
                entity.todo = updatedTodo.todo
                entity.detail = updatedTodo.detail
                entity.dateAdded = updatedTodo.dateAdded
                entity.completed = updatedTodo.completed
                saveContext()
            }
        } catch {
            print("Failed to update todo: \(error)")
        }
    }
}
