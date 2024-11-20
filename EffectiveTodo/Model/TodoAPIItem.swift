//
//  TodoAPIItem.swift
//  EffectiveTodo
//
//  Created by Максим Шишлов on 16.11.2024.
//

import Foundation

struct TodoAPIItem: Codable {
    let todos: [Todo]
    let total, skip, limit: Int
}

struct Todo: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case id, todo, completed
        case userID = "userId"
    }
}
