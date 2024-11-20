//
//  TodoRowView.swift
//  EffectiveTodo
//
//  Created by Максим Шишлов on 15.11.2024.
//

import SwiftUI

struct TodoRowView: View {
    
    let todo: TodoItem
    let todoViewModel: TodoViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            
            /// Todo toggle status button
            Button {
                withAnimation(.snappy) {
                    todoViewModel.toggleStatus(todo)
                }
            } label: {
                Image(systemName: todo.completed ? "checkmark.circle" : "circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(todo.completed ? .accent : .gray)
            }
            
            /// Todo content
            VStack(alignment: .leading, spacing: 6) {
                Text(todo.todo)
                    .font(.title3)
                    .strikethrough(todo.completed ? true : false)
                    .lineLimit(1)
                Text(todo.detail)
                    .font(.caption)
                    .lineLimit(2)
                Text(format(date: todo.dateAdded, format: "d/MM/YY"))
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .foregroundStyle(todo.completed ? .gray : .white)
        }
        .hSpacing(.leading)
        .padding()
        .overlay(alignment: .bottom) {
            Divider()
                .foregroundStyle(.gray)
        }
    }
}
