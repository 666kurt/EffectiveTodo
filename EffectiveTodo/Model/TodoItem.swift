//
//  TodoItem.swift
//  EffectiveTodo
//
//  Created by Максим Шишлов on 15.11.2024.
//

import Foundation

struct TodoItem: Identifiable, Decodable {
    var id: UUID = .init()
    var todo: String
    var detail: String
    var dateAdded: Date
    var completed: Bool
}

/// Todo from network to TodoItem
extension TodoItem {
    static func fromAPIData(_ apiData: [Todo]) -> [TodoItem] {
        apiData.map { todo in
            TodoItem(
                id: .init(),
                todo: todo.todo,
                detail: "Описание задачи отсутствует, так как она прилетела из сети...",
                dateAdded: Date(),
                completed: todo.completed
            )
        }
    }
}

/// Some sample data
extension TodoItem {
    static let mockData: [TodoItem] = [
        .init(id: .init(),
              todo: "Buy groceries",
              detail: "Milk, Bread, Eggs, Butter",
              dateAdded: Date().addingTimeInterval(-86400 * 3), // 3 дня назад
              completed: false),
        .init(id: .init(),
              todo: "Read a book",
              detail: "Finish reading 'Swift Programming'",
              dateAdded: Date().addingTimeInterval(-86400 * 5), // 5 дней назад
              completed: true),
    ]
}
